Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51860 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1I0SfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 14:35:09 -0400
Received: by ywb5 with SMTP id 5so5635403ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 11:35:09 -0700 (PDT)
Message-ID: <4E82175A.7020504@lwfinger.net> (sfid-20110927_203514_056669_D63E14F1)
Date: Tue, 27 Sep 2011 13:35:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 24/26] staging: brcm80211: declared global vars in
 softmac phy as const
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com> <1317145530-18839-25-git-send-email-frankyl@broadcom.com>
In-Reply-To: <1317145530-18839-25-git-send-email-frankyl@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 12:45 PM, Franky Lin wrote:
> From: Roland Vossen<rvossen@broadcom.com>
>
> Global variables are undesirable unless they are read only.
>
> Reported-by: Johannes Berg<johannes@sipsolutions.net>
> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
> Reviewed-by: Arend van Spriel<arend@broadcom.com>
> Signed-off-by: Franky Lin<frankyl@broadcom.com>
> ---
>   drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   16 +-----
>   drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   23 --------
>   drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |    6 +-
>   drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   60 ++++++++++----------
>   .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    2 +-
>   5 files changed, 36 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
> index f9702c0..5b81480 100644
> --- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
> +++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
> @@ -52,7 +52,7 @@ struct chan_info_basic {
>   	u16 freq;
>   };
>
> -static struct chan_info_basic chan_info_all[] = {
> +static const struct chan_info_basic chan_info_all[] = {
>   	{1, 2412},
>   	{2, 2417},
>   	{3, 2422},

What are you doing?  You make this change here in patch 24, then undo it in #25, 
and redo it in #26! Are you guys actually thinking about what you are doing?

This needs to be fixed. In addition, the next time you submit this patch bomb, 
change from V2 to V3. That is the standard way to handle resubmissions that are 
addressing comments, not by increasing some extra counter in the 00/XX cover 
patch. The VX notation helps the maintainer keep track of the patches as he 
knows to drop all the V2 ones when V3 arrives. Maintainers are precious and must 
be treated very carefully.

Larry
