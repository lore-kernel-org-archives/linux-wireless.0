Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36948 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3GTVMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 17:12:14 -0400
Received: by mail-ob0-f182.google.com with SMTP id va7so6767393obc.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jul 2013 14:12:12 -0700 (PDT)
Message-ID: <51EAFD2A.6060909@lwfinger.net> (sfid-20130720_231218_259307_2CF6E6DE)
Date: Sat, 20 Jul 2013 16:12:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: thomas@fjellstrom.ca
CC: linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: wil6210 driver compilation failure
References: <6363399.uASIm9rubl@balsa> <51EAE191.90401@lwfinger.net> <1546638.YtIzlZyRv2@balsa>
In-Reply-To: <1546638.YtIzlZyRv2@balsa>
Content-Type: multipart/mixed;
 boundary="------------060904090907020304070109"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060904090907020304070109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/20/2013 02:40 PM, Thomas Fjellstrom wrote:
>
> The warnings have gone away, and the first error, but the second one is still
> there.

Sorry, I missed the second one in your original message. Does this one fix it?

Larry



--------------060904090907020304070109
Content-Type: text/plain; charset=UTF-8;
 name="wil6210_compile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wil6210_compile"

Index: linux-2.6/drivers/net/wireless/ath/wil6210/debugfs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath/wil6210/debugfs.c
+++ linux-2.6/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -145,7 +145,7 @@ static void wil_print_ring(struct seq_fi
 				   le16_to_cpu(hdr.type), hdr.flags);
 			if (len <= MAX_MBOXITEM_SIZE) {
 				int n = 0;
-				unsigned char printbuf[16 * 3 + 2];
+				char printbuf[16 * 3 + 2];
 				unsigned char databuf[MAX_MBOXITEM_SIZE];
 				void __iomem *src = wmi_buffer(wil, d.addr) +
 					sizeof(struct wil6210_mbox_hdr);
@@ -416,7 +416,7 @@ static int wil_txdesc_debugfs_show(struc
 		seq_printf(s, "  SKB = %p\n", skb);
 
 		if (skb) {
-			unsigned char printbuf[16 * 3 + 2];
+			char printbuf[16 * 3 + 2];
 			int i = 0;
 			int len = le16_to_cpu(d->dma.length);
 			void *p = skb->data;

--------------060904090907020304070109--
