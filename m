Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:58568 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965425AbaLMGnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2014 01:43:05 -0500
Message-ID: <1418452981.29082.7.camel@perches.com> (sfid-20141213_074341_187708_60F248F8)
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
From: Joe Perches <joe@perches.com>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Fri, 12 Dec 2014 22:43:01 -0800
In-Reply-To: <1418425137-13339-1-git-send-email-kris@konagma.com>
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
	 <1418425137-13339-1-git-send-email-kris@konagma.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-12-12 at 23:58 +0100, Krzysztof Konopko wrote:
> This patch changes the types of the struct fields involved to be
> little-endian which is what is received over the air and consistent with
> relevant structs in include/linux/ieee80211.h.
[]
> diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
[]
> @@ -28,7 +28,7 @@
>  struct AC_param {
>  	unsigned char		ACI_AIFSN;
>  	unsigned char		CW;
> -	unsigned short	TXOP_limit;
> +	__le16			TXOP_limit;
>  }  __packed;
>  
>  struct WMM_para_element {
> @@ -39,9 +39,9 @@ struct WMM_para_element {
>  
>  struct ADDBA_request {
>  	unsigned char		dialog_token;
> -	unsigned short	BA_para_set;
> -	unsigned short	BA_timeout_value;
> -	unsigned short	BA_starting_seqctrl;
> +	__le16		BA_para_set;
> +	__le16		BA_timeout_value;
> +	__le16		BA_starting_seqctrl;
>  }  __packed;

If I did this, I would also change the
unsigned char uses to u8 at the same time.



