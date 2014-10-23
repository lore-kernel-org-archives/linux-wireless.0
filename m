Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29302 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755282AbaJWMlA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 08:41:00 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Belisko Marek <marek.belisko@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 23 Oct 2014 05:40:54 -0700
Subject: RE: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected
 to 5GHz
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951821545AE6@SC-VEXCH1.marvell.com> (sfid-20141023_144105_233539_EBDAB115)
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
	<CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
	<CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com>
	<CAAfyv34ivLF-B0ip+uhCah0PsiRsP1QOD0qW8F73n7KERqgM2w@mail.gmail.com>,<CAAfyv37uyPwED3tzX_4RjeTuf8LXqtL3zH4f-cNOLuRB+w=z6Q@mail.gmail.com>
In-Reply-To: <CAAfyv37uyPwED3tzX_4RjeTuf8LXqtL3zH4f-cNOLuRB+w=z6Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marek,

>> I tried to capture logs but when enable DYNAMIC_DEBUG I cannot
>> reproduce issue (running test > 30 minutes without allocation
>> failure).

Thanks for the testing. Yes. Sometimes timing issues won't get reproduced with debug messages enabled.

>Any update on this? Should I provide some other logs?

What's the size of Rx data packets? Is the Rx data AMSDU aggregated?(You can check if "if (rx_pkt_type == PKT_TYPE_AMSDU)" check is passed in mwifiex code) If so, disable AMSDU option in AP and try to reproduce the issue. 

As you suspected earlier, we might have missed to free skbs allocated for Rx data which leads to SKB allocation failure. There is very less probability for this. But we can try below experiment.  

1) I observed that debug variable "adapter->rx_pending" doesn;t get decremented when packet is submitted to kernel. Add below code change(valid only for AMSDU disabled case. Because multiple packets are submitted to kernel when AMSDU is enabled)

----------
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -218,6 +218,7 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 
        priv->stats.rx_bytes += skb->len;
        priv->stats.rx_packets++;
+       atomic_dec(&priv->adapter->rx_pending);
        if (in_interrupt())
                netif_rx(skb);
----------

2) Add BUG_ON when first time SKB allocation is failed and print "rx_pending". If it's a huge number, we have missed freeing allocated SKB.

3) Also, get rx_pending info when Rx traffic works fine with 40M bandwidth option.

Btw, could you move to the firmware image (14.68.29.p38)
shared recently?

By any means(redirecting the log to serial console etc.), could you please capture and share kernel trace logs when system becomes unresponsive. It may give some clue and help us debug further.

Best Regards,
Amit