Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49970 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GOXvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 19:51:17 -0400
Received: by pzk3 with SMTP id 3so2106102pzk.5
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 16:51:16 -0700 (PDT)
Date: Sat, 16 Jul 2011 02:49:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 35/35] staging: brcm80211: replace simple_strtoul usage
 in brcmfmac
Message-ID: <20110715234924.GH18655@shale.localdomain> (sfid-20110716_015120_367756_F01EA414)
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
 <1310678971-28952-36-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310678971-28952-36-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 02:29:31PM -0700, Franky Lin wrote:
> --- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
> +++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
> @@ -827,10 +827,13 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
>  		return -EINVAL;
>  	}
>  	for (i = 0; *src != '\0'; i++) {
> +		unsigned long res;
>  		char num[3];
>  		strncpy(num, src, 2);
>  		num[2] = '\0';
> -		dst[i] = (u8) simple_strtoul(num, NULL, 16);
> +		if (kstrtoul(num, 16, &res))
> +			return -1;
			       ^^
Not a proper error code.

> +		dst[i] = (u8)res;
>  		src += 2;

regards,
dan carpenter
