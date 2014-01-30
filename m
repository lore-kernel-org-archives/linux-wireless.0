Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:52735 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaA3UDi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 15:03:38 -0500
Date: Thu, 30 Jan 2014 20:39:06 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Tuomas =?iso-8859-1?Q?R=E4s=E4nen?= <tuomasjjrasanen@opinsys.fi>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	tuomasjjrasanen@tjjr.fi, Veli-Matti Lintu <vmlintu@opinsys.fi>
Subject: Re: PROBLEM: skb_push called from rt2x00 panics occasionally
Message-ID: <20140130193906.GA2977@localhost.localdomain> (sfid-20140130_210342_143915_CA303713)
References: <2018379362.52866.1391084425810.JavaMail.zimbra@opinsys.fi>
 <879434908.52885.1391085222657.JavaMail.zimbra@opinsys.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <879434908.52885.1391085222657.JavaMail.zimbra@opinsys.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 30, 2014 at 12:33:42PM +0000, Tuomas Räsänen wrote:
> =================================================
>  skb_push called from rt2x00 panics occasionally
> =================================================
> 
> We have been experiencing occasional skb_push panics with rt2x00 driver
> throughout the stable v3.10 -series. Problems occur with hosts acting as
> accesspoints, managed by hostapd 2.0. Some hosts panic reportedly
> several times per week, some almost never. All hosts have identical
> kernels and WiFi adapters.
> 
> We have not been able to reproduce panics in a controlled manner.
> 
> I'd be very happy to get some advice how to proceed in debugging and fixing
> this problem and even better, to understand the whole issue
> thoroughly. Unfortunately, all I know now is that the skb headroom is
> not big enough for the frame the AP is trying to transmit, right?
> Hopefully someone can shed some light on this problem.

Yes, is possible that we have no headroom for frame retransmitted
several times, but I do not see bug in code for that so far. 
We remove and add again l2 pad for retransmit frame, that should
not utilize more headroom than for first frame transmission (as long
mac80211 does not increase header length, but that seems to be not
possible and sensible).

For know you can try to increase headroom like on below patch or use
module with nohwcrypt=1. Please check if any of that stops panics or 
just make it less reproducible.

You can also configure kdump to dump memory to see how skb looks when
kernel crashes.

Stanislaw

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e4ba2ce..50fc3e7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -115,7 +115,7 @@
  * Constants for extra TX headroom for alignment purposes.
  */
 #define RT2X00_ALIGN_SIZE	4 /* Only whole frame needs alignment */
-#define RT2X00_L2PAD_SIZE	8 /* Both header & payload need alignment */
+#define RT2X00_L2PAD_SIZE	12 /* Both header & payload need alignment */
 
 /*
  * Standard timing and size defines.
