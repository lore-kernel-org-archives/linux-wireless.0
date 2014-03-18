Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39404 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaCRQRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 12:17:24 -0400
Received: by mail-ie0-f182.google.com with SMTP id y20so7461164ier.27
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 09:17:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395150804-24090-4-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-4-git-send-email-michal.kazior@tieto.com>
Date: Tue, 18 Mar 2014 18:17:23 +0200
Message-ID: <CAB3XZEcRwJ0H_rRSq0kaw8mWLJh2i2msZUmBRBFXZonZSua4kQ@mail.gmail.com> (sfid-20140318_171734_910008_16A0DC80)
Subject: Re: [RFC 03/21] mac80211: add max channel calculation utility function
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> The utility function has no uses yet. It is aimed
> at future chanctx reservation management and
> channel switching.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> +int ieee80211_max_num_channels(struct ieee80211_local *local)
> +{
> +       struct ieee80211_sub_if_data *sdata;
> +       int num[NUM_NL80211_IFTYPES] = {};
> +       struct ieee80211_chanctx *ctx;
> +       int num_different_channels = 0;
> +       u8 radar_detect = 0;
> +       u32 max_num_different_channels = 1;
> +       int err;
> +
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       list_for_each_entry(ctx, &local->chanctx_list, list) {
> +               num_different_channels++;
> +
this doesn't seem correct - i think we can have multiple channel
contexts with the same channel (e.g. due to exclusive mode)?

Eliad.
