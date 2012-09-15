Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43156 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2IOVmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2012 17:42:38 -0400
Received: by oago6 with SMTP id o6so3781228oag.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Sep 2012 14:42:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347626233-21916-2-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
	<1347626233-21916-2-git-send-email-johannes@sipsolutions.net>
Date: Sun, 16 Sep 2012 00:42:37 +0300
Message-ID: <CAB3XZEdAX8=BU5QQaQpS=OF-5XXDH=k3rO7C2z2F+sZpaCNK1Q@mail.gmail.com> (sfid-20120915_234243_262623_76C88C5E)
Subject: Re: [PATCH 01/10] mac80211: introduce channel context skeleton code
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 14, 2012 at 3:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
>
> Channel context are the foundation for multi-channel
> operation. They are are immutable and are re-created
> (or re-used if other interfaces are bound to a certain
> channel and a compatible channel type) on channel
> switching.
>
> This is an initial implementation and more features
> will come in separate patches.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> [some changes including RCU protection]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
> +                             struct ieee80211_channel *channel,
> +                             enum nl80211_channel_type channel_type,
> +                             enum ieee80211_chanctx_mode mode)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_chanctx *ctx;
> +       int ret;
> +
> +       mutex_lock(&local->chanctx_mtx);
> +       __ieee80211_vif_release_channel(sdata);
> +
> +       ctx = ieee80211_find_chanctx(local, channel, channel_type, mode);
since you might use an existing ctx here...

> +       if (!ctx)
> +               ctx = ieee80211_new_chanctx(local, channel, channel_type, mode);
> +       if (IS_ERR(ctx)) {
> +               ret = PTR_ERR(ctx);
> +               goto out;
> +       }
> +
> +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> +       if (ret) {
> +               ieee80211_free_chanctx(local, ctx);
i think you should check ctx->refcount before freeing it.

Eliad.
