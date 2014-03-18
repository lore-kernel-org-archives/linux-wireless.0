Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52494 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbaCRQZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 12:25:30 -0400
Received: by mail-ie0-f181.google.com with SMTP id tp5so6990233ieb.26
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 09:25:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395150804-24090-5-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-5-git-send-email-michal.kazior@tieto.com>
Date: Tue, 18 Mar 2014 18:25:29 +0200
Message-ID: <CAB3XZEcrRZdwfbfX6oBAwZ++ZV7uHcJZ1V=ggzfMhUJ9zo62=Q@mail.gmail.com> (sfid-20140318_172534_188739_07DB39D5)
Subject: Re: [RFC 04/21] mac80211: prevent chanctx overcommit
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Do not allocate more channel contexts than a
> driver is capable for currently matching interface
> combination.
>
> This allows the ieee80211_vif_reserve_chanctx() to
> act as a guard against breaking interface
> combinations.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> +static bool ieee80211_can_create_new_chanctx(struct ieee80211_local *local)
> +{
> +       lockdep_assert_held(&local->chanctx_mtx);
> +       return ieee80211_num_chanctx(local) < ieee80211_max_num_channels(local);
> +}
the same goes here - num_channels and num_chanctx are two different
things (afaiu).
i don't think you can compare them this way.

Eliad.
