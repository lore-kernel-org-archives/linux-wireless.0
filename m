Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63109 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1AXVRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:17:04 -0500
Received: by qyk12 with SMTP id 12so5036954qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 13:17:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295894723-28346-1-git-send-email-padovan@profusion.mobi>
References: <1295894723-28346-1-git-send-email-padovan@profusion.mobi>
Date: Mon, 24 Jan 2011 22:17:04 +0100
Message-ID: <AANLkTi=GqWNd6yu0CeWAzt9ZRgCDkFRgwMExZiqEUr3Z@mail.gmail.com>
Subject: Re: [PATCH] brcm80211: fix error report string
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: brudley@broadcom.com, henryp@broadcom.com, dowan@broadcom.com,
	vossen@broadcom.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/24 Gustavo F. Padovan <padovan@profusion.mobi>:
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> ---
>  drivers/staging/brcm80211/sys/wlc_mac80211.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
> index 5eb41d6..ee1bcc5 100644
> --- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
> +++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
> @@ -6910,7 +6910,7 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
>                preamble = 0;
>                if (IS_CCK(rspec)) {
>                        if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
> -                               WL_ERROR("Short CCK\n");
> +                               WL_ERROR("%s: Short CCK\n, __func__");

I have no idea how WL_ERROR works, but are you sure of that?

You wrote:
"%s: Short CCK\n, __func__"

Didn't you mean:
"%s: Short CCK\n", __func__
?

-- 
Rafał
