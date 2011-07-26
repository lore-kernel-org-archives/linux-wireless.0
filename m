Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37260 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1GZI25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 04:28:57 -0400
Received: by pzk37 with SMTP id 37so467878pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 01:28:56 -0700 (PDT)
Date: Tue, 26 Jul 2011 11:26:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/29] staging: brcm80211: revisited END_FOREACH_BSS macro
Message-ID: <20110726082658.GD3824@shale.localdomain> (sfid-20110726_102902_051801_4E9155B0)
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
 <1311361036-3175-14-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1311361036-3175-14-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2011 at 08:57:00PM +0200, Arend van Spriel wrote:
> @@ -3345,7 +3345,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
>  	FOREACH_BSS(wlc, i, bsscfg)
>  		brcms_c_set_mac(bsscfg);
>  		brcms_c_set_bssid(bsscfg);
> -	END_FOREACH_BSS
> +	END_FOREACH_BSS()

These would look nicer with a semicolon on the end.

	END_FOREACH_BSS();

That looks like c.

I quite liked my way with the extra { } chars.

	FOREACH_BSS(wlc, i, bsscfg) {
		brcms_c_set_mac(bsscfg);
		brcms_c_set_bssid(bsscfg);
	} END_FOREACH_BSS();

Emacs gets the indenting wrong without the braces.  We use that
style of for each loop in the Sparse project.

But I'm fairly sick of this macro so at this point, I'm fine with
whatever.  :P

regards,
dan carpenter

