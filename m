Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47094 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1IXJwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 05:52:53 -0400
Received: by bkbzt4 with SMTP id zt4so4200418bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Sep 2011 02:52:52 -0700 (PDT)
Date: Sat, 24 Sep 2011 11:52:47 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 16/20] staging: brcm80211: declared global vars in
 softmac phy as const
Message-ID: <20110924095247.GA4156@jak-linux.org> (sfid-20110924_115303_891593_8ED1C44B)
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
 <1316830148-28661-17-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1316830148-28661-17-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 23, 2011 at 07:09:04PM -0700, Franky Lin wrote:
> From: Roland Vossen <rvossen@broadcom.com>
> 
> Global variables are undesirable unless they are read only.
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> ---
> diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
> index 15c5ffc..1b11b2f 100644
> --- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
> +++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
> @@ -1611,7 +1611,7 @@ const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
>  	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
>  	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
>  
> -static const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
> +const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
>  	sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
>  	sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);

That seems like an anomaly. In a commit that is supposed
to declare variables as const, the linkage of a variable
changed. Likewise, the removal of extern global variable
declarations in phy_int.h also does not seem to belong
here.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
