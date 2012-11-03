Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4896 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2KCR46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2012 13:56:58 -0400
Message-ID: <50955ADB.9020703@broadcom.com> (sfid-20121103_185710_775331_B0D94E00)
Date: Sat, 3 Nov 2012 18:56:43 +0100
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
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2012 04:23 PM, Seth Forshee wrote:
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

I mentioned earlier we were still looking at the first patch in this
series and do more testing on it. However, I wanted to provide feedback
on the other patches now. See below.

> Thanks,
> Seth
> 
> [0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1046507
> [1] http://www.spinics.net/lists/linux-wireless/msg96287.html
> 
> 
> Seth Forshee (18):
>   brcmsmac: Rework tx code to avoid internal buffering of packets

under test

>   brcmsmac: Use correct descriptor count when calculating next rx
>     descriptor

nice catch. acked.

>   brcmsmac: Reduce number of entries in tx DMA rings

under test.

>   brcm80211: Allow trace support to be enabled separately from debug

A bit confusing with BRCMDBG selecting BRCMS_TRACING.

>   brcm80211: Add macro for checking if debug log levels are enabled

During mainlining we got rid of such a macro. Strange to put something
similar back in there.

>   brcm80211: Convert log message levels to debug levels

acked.

>   brcmsmac: Add module parameter for setting the debug level

I would prefer doing this through debugfs.

>   brcmsmac: Add support for writing debug messages to the trace buffer

can you name the new files just debug.[ch]

>   brcmsmac: Use debug macros for general error and debug statements

acked.

>   brcmsmac: Add BRCMS_DBG_MAC80211 debug macro
>   brcmsmac: Add RX and TX debug macros
>   brcmsmac: Add INT debug macro
>   brcmsmac: Add DMA debug macro
>   brcmsmac: Add HT debug macro

I would prefer the macros to be in lower case.

>   brcmsmac: Improve tx trace and debug support

acked.

>   brcmsmac: Add tracepoint for macintstatus

useful one. acked.

>   brcmsmac: Add tracepoint for AMPDU session information

acked.

>   brcmsmac: Remove some noisy but uninformative debug messages

acked. I would say: noisy *and* uninformative but that is just semantics ;-)

Regards,
AvS

