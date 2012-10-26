Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1495 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933782Ab2JZPh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 11:37:27 -0400
Message-ID: <508AAE2A.8070400@broadcom.com> (sfid-20121026_173731_667362_006BE19C)
Date: Fri, 26 Oct 2012 17:37:14 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2012 04:23 PM, Seth Forshee wrote:
> I've been looking into the issues with brcmsmac performance reported at
> [0] and [1]. I started out looking into the tx queueing based on the "No
> where to go" messages in the logs. This code has a number of
> shortcomings:
>
>   - The amount of bufferring is excessive. The tx queue will buffer up to
>     228 packets, and each of the tx DMA rings will queue up to 256 more.
>
>   - There's no flow control. If the queue fills up packets begin to get
>     dropped, as evidenced by the "No where to go" messages.
>
>   - Without flow control the tx queue probably helps avoid dropping
>     packets for short bursts due to the sheer number of packets that will
>     be buffered, but if flow control is added the only remaining benefit
>     that I can see is that it accumulates packets for aggregation. The tx
>     queue is far more complex than needed for supporting aggergation,
>     however.

Thanks, Seth

Nice series that rolled out of your sleeve ;-) We seem to have been 
working in parallel here, which is a bit of a pity. One of the things 
that we noticed was indeed missing flow control. We did not start adding 
that so not work wasted there.

> As a result I worked up the following patches to add flow control remove
> the tx queue.
>
> These patches change the tx handler to directly hand off packets to the
> DMA code. The convoluted priority->precedence->fifo mapping is converted
> to a simple one-to-one mapping of the mac80211 queues to fifos. Non-
> aggregate frames are immediately inserted into the DMA ring.

We considered this during mainlining brcmsmac. So retries are also 
queued back on the DMA fifo?

> Handling of aggregate frames is not as simple, as some of the tx header
> fixups can only happen once we have all the frames for an AMPDU.  To
> support this without resyncing buffers after they've been added to the
> DMA ring I've added the concept of AMPDU sessions. An AMPDU session
> simply queues up the frames for a single AMPDU until we are ready to
> insert them into the tx ring. There is one session per DMA ring, and
> descriptors are reserved in the corresponding ring for all frames queued
> in the AMPDU session. This also has the benefit of allowing non-
> aggregate frames to be sent without affecting aggregation and without
> mapping these frames to a different fifo.
>
> The patches also add flow control to stop incoming tx packets when the
> DMA ring is full. In practice I found that we will sometimes receive a
> single frame from mac80211 after stopping the queues, so some headroom
> is reserved when stopping the queues. I also reduced the number of tx
> descriptors per ring to 64 and fixed a bug that prevented having
> differing non-zero numbers of tx and rx descriptors for a given ring.
>
> When workig on this I made extensive use of ftrace for debug and
> verification. I'm including patches I wrote which expand the trace
> support and introduce debug macros which can log messages both to dmesg
> and the trace buffer. iwlwifi has similar trace support which we've
> enabled in Ubuntu, making it easier to collect debug information from
> users experiencing wireless problems.
>
> With these changes I'm no longer seeing dropped frames when the tx
> queues are full. Anecdotally I'd also say that my testing with iperf
> using TCP seems to show more consistent data rates, resulting in a
> higher average data rate (sometimes significantly so), but I don't have
> sufficient amounts of data to be sure this is the case.
>
> I'm still observing a few problems when testing with iperf, however. The
> first is "Pkt tx suppressed, illegal channel" messages. There are also

This is tx status feedback coming in directly from ucode. Not found any 
clues there yet.

> large drops in the data rate reported when using TCP, sometimes even
> resulting in iperf reporting that no data was transferred for several
> seconds. Finally, when using iperf with UDP the number of dropped frames
> periodically spikes to high levels. I'm not sure yet, but it looks like
> the second and third problems may coincide with scanning.
>
> I also continue to see flush timeouts, but the frequency seems to be
> reduced with these changes. Likely this is related to the much smaller
> number of packets that will be queued internally for tx.

Last week we have been making progress on the flush timeout so a patch 
is queued up for that.

Again, thanks for putting a bit of love into brcmsmac. Hope you did not 
curse too much in that process ;-) I will publish it internally on our 
review server so we can provide our comments.

See you in Barcelona ;-)

Regards,
Arend

