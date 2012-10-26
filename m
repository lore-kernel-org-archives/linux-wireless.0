Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35127 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985Ab2JZQFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 12:05:03 -0400
Date: Fri, 26 Oct 2012 11:04:57 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121026160457.GB22016@thinkpad-t410> (sfid-20121026_180509_215983_33D18604)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <508AAE2A.8070400@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <508AAE2A.8070400@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2012 at 05:37:14PM +0200, Arend van Spriel wrote:
> On 10/26/2012 04:23 PM, Seth Forshee wrote:
> >I've been looking into the issues with brcmsmac performance reported at
> >[0] and [1]. I started out looking into the tx queueing based on the "No
> >where to go" messages in the logs. This code has a number of
> >shortcomings:
> >
> >  - The amount of bufferring is excessive. The tx queue will buffer up to
> >    228 packets, and each of the tx DMA rings will queue up to 256 more.
> >
> >  - There's no flow control. If the queue fills up packets begin to get
> >    dropped, as evidenced by the "No where to go" messages.
> >
> >  - Without flow control the tx queue probably helps avoid dropping
> >    packets for short bursts due to the sheer number of packets that will
> >    be buffered, but if flow control is added the only remaining benefit
> >    that I can see is that it accumulates packets for aggregation. The tx
> >    queue is far more complex than needed for supporting aggergation,
> >    however.
> 
> Thanks, Seth
> 
> Nice series that rolled out of your sleeve ;-) We seem to have been
> working in parallel here, which is a bit of a pity. One of the
> things that we noticed was indeed missing flow control. We did not
> start adding that so not work wasted there.

Hopefully there wasn't too much overlap. I had actually planned to send
these a couple of weeks ago, but I just kept finding little things I
wanted to improve before sending :-)

> >As a result I worked up the following patches to add flow control remove
> >the tx queue.
> >
> >These patches change the tx handler to directly hand off packets to the
> >DMA code. The convoluted priority->precedence->fifo mapping is converted
> >to a simple one-to-one mapping of the mac80211 queues to fifos. Non-
> >aggregate frames are immediately inserted into the DMA ring.
> 
> We considered this during mainlining brcmsmac. So retries are also
> queued back on the DMA fifo?

Yes. I've rearranged the stack of tx function calls so that
brcms_c_txfifo() handles flow control and handing off to the DMA code,
and this is what gets called for retransmitting. But the retries are
actually something that I was curious about, so maybe you can answer
some questions for me while we're in Barcelona.

> >Handling of aggregate frames is not as simple, as some of the tx header
> >fixups can only happen once we have all the frames for an AMPDU.  To
> >support this without resyncing buffers after they've been added to the
> >DMA ring I've added the concept of AMPDU sessions. An AMPDU session
> >simply queues up the frames for a single AMPDU until we are ready to
> >insert them into the tx ring. There is one session per DMA ring, and
> >descriptors are reserved in the corresponding ring for all frames queued
> >in the AMPDU session. This also has the benefit of allowing non-
> >aggregate frames to be sent without affecting aggregation and without
> >mapping these frames to a different fifo.
> >
> >The patches also add flow control to stop incoming tx packets when the
> >DMA ring is full. In practice I found that we will sometimes receive a
> >single frame from mac80211 after stopping the queues, so some headroom
> >is reserved when stopping the queues. I also reduced the number of tx
> >descriptors per ring to 64 and fixed a bug that prevented having
> >differing non-zero numbers of tx and rx descriptors for a given ring.
> >
> >When workig on this I made extensive use of ftrace for debug and
> >verification. I'm including patches I wrote which expand the trace
> >support and introduce debug macros which can log messages both to dmesg
> >and the trace buffer. iwlwifi has similar trace support which we've
> >enabled in Ubuntu, making it easier to collect debug information from
> >users experiencing wireless problems.
> >
> >With these changes I'm no longer seeing dropped frames when the tx
> >queues are full. Anecdotally I'd also say that my testing with iperf
> >using TCP seems to show more consistent data rates, resulting in a
> >higher average data rate (sometimes significantly so), but I don't have
> >sufficient amounts of data to be sure this is the case.
> >
> >I'm still observing a few problems when testing with iperf, however. The
> >first is "Pkt tx suppressed, illegal channel" messages. There are also
> 
> This is tx status feedback coming in directly from ucode. Not found
> any clues there yet.

This is what I'm probably going to look into next. I think the
interaction with mac80211 and brcmsmac wrt scanning might be going bad
somehow, i.e. not all the frames get transmitted before the channel
change occurs, but I really don't understand yet exactly how the
interaction here is supposed to work. I have found that when this
happens the channel in the txh->XtraFrameTypes doesn't match the current
channel.

I probably won't get to that until after wireless mini-summit though, as
I've got two weeks solid of conferences coming up.

> >large drops in the data rate reported when using TCP, sometimes even
> >resulting in iperf reporting that no data was transferred for several
> >seconds. Finally, when using iperf with UDP the number of dropped frames
> >periodically spikes to high levels. I'm not sure yet, but it looks like
> >the second and third problems may coincide with scanning.

Just to note, I'm also wondering if this might be to some degree related
to the illegal channel problems. If the channel is getting changed with
frames still queued for tx then the nullfunc frame to enable powersave
may not be getting transmitted to the AP. The problem with this theory
is that the illegal channel message doesn't always coincide with the
poor performance and dropped frames.

> >I also continue to see flush timeouts, but the frequency seems to be
> >reduced with these changes. Likely this is related to the much smaller
> >number of packets that will be queued internally for tx.
> 
> Last week we have been making progress on the flush timeout so a
> patch is queued up for that.

Excellent. Have you published that publicly yet or is it just queued
internally?

> Again, thanks for putting a bit of love into brcmsmac. Hope you did
> not curse too much in that process ;-) I will publish it internally
> on our review server so we can provide our comments.
> 
> See you in Barcelona ;-)

Looking forward to meeting up in person!

Seth

