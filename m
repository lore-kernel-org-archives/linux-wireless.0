Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56942 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1LHP4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 10:56:37 -0500
Received: by iakc1 with SMTP id c1so2745667iak.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 07:56:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323343608-32561-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1323343608-32561-1-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 8 Dec 2011 07:56:17 -0800
Message-ID: <CAB=NE6VRA=GMcD+BsrTLcPtXJCYr3bd2rxWE+AxwWHjVcbDvyw@mail.gmail.com> (sfid-20111208_165640_985336_8BDF407A)
Subject: Re: [PATCH] cfg80211: notify core hints that helps to restore regd settings
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 8, 2011 at 3:26 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> Regulatory updates set by CORE are ignored for custom regulatory cards.
> Let us notify the changes to the driver, as some drivers uses core hint
> to restore its orig_* reg domain setting.
>
> Cc: Paul Stewart <pstew@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/wireless/reg.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index db958ba..c45c8b7 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1175,9 +1175,21 @@ void regulatory_update(struct wiphy *wiphy,
>  static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
>  {
>        struct cfg80211_registered_device *rdev;
> +       struct wiphy *wiphy;
>
> -       list_for_each_entry(rdev, &cfg80211_rdev_list, list)
> -               wiphy_update_regulatory(&rdev->wiphy, initiator);
> +       list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +               wiphy = &rdev->wiphy;
> +               wiphy_update_regulatory(wiphy, initiator);
> +               /*
> +                * Regulatory updates set by CORE are ignored for custom
> +                * regulatory cards. Let us notify the changes to the driver,
> +                * as some drivers used this to restore its orig_* reg domain.
> +                */
> +               if (initiator == NL80211_REGDOM_SET_BY_CORE &&
> +                   wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
> +                   wiphy->reg_notifier)
> +                       wiphy->reg_notifier(wiphy, last_request);
> +       }

This looks ugly but for now its fine as the alternative is to add
another callback for restoring regulatory settings. I'll take this
into consideration in the regulatory simulator where I'm rewriting all
this.

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis
