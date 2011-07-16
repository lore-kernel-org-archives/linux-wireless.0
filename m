Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GPAIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 20:08:17 -0400
Received: by pzk3 with SMTP id 3so2115461pzk.5
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 17:08:17 -0700 (PDT)
Date: Sat, 16 Jul 2011 03:06:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 22/35] staging: brcm80211: fix for checkpatch 'avoid
 externs in c file' warning
Message-ID: <20110716000626.GI18655@shale.localdomain> (sfid-20110716_020824_830497_677F7526)
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
 <1310678971-28952-23-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310678971-28952-23-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> @@ -3552,8 +3552,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
>  		if (wlc->shortslot)
>  			cfg->current_bss->capability |=
>  					WLAN_CAPABILITY_SHORT_SLOT_TIME;
> -	END_FOREACH_BSS
> -
> +	END_FOREACH_BSS /* this comment fixes a checkpatch warning */

I don't have strong feelings about this, but another way to do that
would be to write it like:

	FOR_EACH(blah, blah) {
		frob();
		frob();
		frob();
	} END_FOREACH_BSS();

Or if you know perl, you could look into why checkpatch is printing
the wrong warning here...

regards,
dan carpenter
