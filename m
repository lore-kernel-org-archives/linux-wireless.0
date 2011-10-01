Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62530 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1JAQBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 12:01:12 -0400
Received: by ywb5 with SMTP id 5so2327164ywb.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 09:01:11 -0700 (PDT)
Message-ID: <4E873944.70104@lwfinger.net> (sfid-20111001_180121_461520_6AA18BB4)
Date: Sat, 01 Oct 2011 11:01:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ian Jeffray <ian@emobix.co.uk>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <4E81F8C8.4010909@lwfinger.net> <4E860CDB.9040207@emobix.co.uk> <201109302106.12028.chunkeey@googlemail.com>
In-Reply-To: <201109302106.12028.chunkeey@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------030007060405000608070101"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030007060405000608070101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ian,

Most of the skb assignments in r8712u are aligned OK and most aligned on 
512-byte boundaries, but there was one that had the minimal offset of 14 bytes. 
The attached patch should fix it. Does it help?

Larry


--------------030007060405000608070101
Content-Type: text/plain;
 name="r8712u_align_skb_data"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="r8712u_align_skb_data"

Index: wireless-testing-new/drivers/staging/rtl8712/rtl8712_recv.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/rtl8712_recv.c
+++ wireless-testing-new/drivers/staging/rtl8712/rtl8712_recv.c
@@ -372,8 +372,8 @@ static int amsdu_to_msdu(struct _adapter
 		pdata += ETH_HLEN;
 		a_len -= ETH_HLEN;
 		/* Allocate new skb for releasing to upper layer */
-		sub_skb = dev_alloc_skb(nSubframe_Length + 12);
-		skb_reserve(sub_skb, 12);
+		sub_skb = dev_alloc_skb(nSubframe_Length + 16);
+		skb_reserve(sub_skb, 16);
 		data_ptr = (u8 *)skb_put(sub_skb, nSubframe_Length);
 		memcpy(data_ptr, pdata, nSubframe_Length);
 		subframes[nr_subframes++] = sub_skb;

--------------030007060405000608070101--
