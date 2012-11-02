Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64362 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2KBKts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 06:49:48 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so2301777qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2012 03:49:48 -0700 (PDT)
Date: Fri, 2 Nov 2012 11:49:35 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121102104935.GA12843@eleaks.org> (sfid-20121102_115001_243727_279E514E)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Oct 26, 2012 at 09:23:15AM -0500, Seth Forshee wrote:
> I've been looking into the issues with brcmsmac performance reported at
> [0] and [1]. I started out looking into the tx queueing based on the "No
> where to go" messages in the logs. This code has a number of
> shortcomings:
> 
>  - The amount of bufferring is excessive. The tx queue will buffer up to
>    228 packets, and each of the tx DMA rings will queue up to 256 more.
> 
>  - There's no flow control. If the queue fills up packets begin to get
>    dropped, as evidenced by the "No where to go" messages.
> 
>  - Without flow control the tx queue probably helps avoid dropping
>    packets for short bursts due to the sheer number of packets that will
>    be buffered, but if flow control is added the only remaining benefit
>    that I can see is that it accumulates packets for aggregation. The tx
>    queue is far more complex than needed for supporting aggergation,
>    however.
> 
> As a result I worked up the following patches to add flow control remove
> the tx queue.
> 
> These patches change the tx handler to directly hand off packets to the
> DMA code. The convoluted priority->precedence->fifo mapping is converted
> to a simple one-to-one mapping of the mac80211 queues to fifos. Non-
> aggregate frames are immediately inserted into the DMA ring.
> 
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
It is strange that you would get one frame after stopping the queues.
Apart from the iface up/down code which I did not look at, it seems the tx 
codepaths for queues stop/wake are all properly protected by spin_lock_bhs.
You mention a possible race in your code comments .. are you referring to 
mac80211 or the driver itself ?
 
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
Stopping the queues instead of dropping the skb, the TCP tx throughput should
improve.

 
Karl
