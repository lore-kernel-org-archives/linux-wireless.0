Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:51702 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbYJIQyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 12:54:14 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
Date: Thu, 9 Oct 2008 18:58:17 +0200
Cc: Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48EE20FB.4060700@lwfinger.net>
In-Reply-To: <48EE20FB.4060700@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810091858.17451.chunkeey@web.de> (sfid-20081009_185417_693022_24BF969A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 October 2008 17:19:23 Larry Finger wrote:
> This patch is meant for testing on big-endian hardware. Every indication
> is that the data in the bootrec structure is little endian. This patch fixes
> a usage of the u32 data array as a string of u8's.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing/drivers/net/wireless/p54/p54common.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/p54/p54common.h
> +++ wireless-testing/drivers/net/wireless/p54/p54common.h
> @@ -18,7 +18,10 @@
>  struct bootrec {
>  	__le32 code;
>  	__le32 len;
> -	u32 data[10];
> +	union {
> +		u32 data[10];
> +		u8 data_char[40];
> +	} __attribute__((packed));
>  	__le16 rx_mtu;
>  } __attribute__((packed));
> 
? how did rx_mtu end up there? it should be a part of bootrec_desc
(which is a few lines down in p54common.h)
struct bootrec_desc {
        __le16 modes;
        __le16 flags;
        __le32 rx_start;
        __le32 rx_end;
        u8 headroom;
        u8 tailroom;
        u8 unimportant[6];
        u8 rates[16];
+	__le16 rx_mtu;
} __attribute__((packed));

This structure is equivalent to struct s_lm_descr from "lmac_longbow.h", which
can be found on wireless.kernel.org's resource page.

Regards,
	Chr
