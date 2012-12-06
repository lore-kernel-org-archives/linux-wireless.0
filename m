Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36992 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2LFXnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 18:43:22 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so9947lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 15:43:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-2-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-2-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 15:43:00 -0800
Message-ID: <CAB=NE6VCgdMtj_v07BBZ36pOEP_qzVPR_YOe--C3iXw=_KMVgw@mail.gmail.com> (sfid-20121207_004326_204218_9F7B1A94)
Subject: Re: [PATCH 01/24] regulatory: don't write past array when
 intersecting rules
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When intersecting rules, we count first to know how many
> rules need to be allocated, and then do the intersection
> into the allocated array. However, the code doing this
> writes past the end of the array because it attempts to
> do all intersections. Make it stop when the right number
> of rules has been reached.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

A comment below though.

> ---
>  net/wireless/reg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index b6c7ea6..4197359 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -648,9 +648,9 @@ static struct ieee80211_regdomain *regdom_intersect(
>         if (!rd)
>                 return NULL;
>
> -       for (x = 0; x < rd1->n_reg_rules; x++) {
> +       for (x = 0; x < rd1->n_reg_rules && rule_idx < num_rules; x++) {
>                 rule1 = &rd1->reg_rules[x];
> -               for (y = 0; y < rd2->n_reg_rules; y++) {
> +               for (y = 0; y < rd2->n_reg_rules && rule_idx < num_rules; y++) {
>                         rule2 = &rd2->reg_rules[y];
>                         /*

Does rule_idx ever become > num_rules though? The check that builds
num_rules are the same as we traverse and increment rule_idx.

  Luis
