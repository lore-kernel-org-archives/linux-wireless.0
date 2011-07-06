Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62793 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab1GFJZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 05:25:08 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so5868009pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 02:25:07 -0700 (PDT)
Date: Wed, 6 Jul 2011 12:24:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 07/31] staging: brcm80211: removed asserts from dhd_cdc.c
 and dhd_common.c
Message-ID: <20110706092401.GH18655@shale.localdomain> (sfid-20110706_112513_110523_920CB1CF)
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
 <1309903378-29021-8-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1309903378-29021-8-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 06, 2011 at 12:02:34AM +0200, Arend van Spriel wrote:
> @@ -317,14 +312,16 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
>  
>  	BRCMF_TRACE(("%s: Enter\n", __func__));
>  
> -	ASSERT(name);
> -	ASSERT(len >= 0);
> +	if (name == NULL || len <= 0)
> +		return -EINVAL;
>  

In the original code len == 0 was OK but now we return -EINVAL.

regards,
dan carpenter

