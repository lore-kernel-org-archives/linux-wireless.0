Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34208 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbaCROK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:10:59 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so7051414obc.29
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:10:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394717621-5608-4-git-send-email-luciano.coelho@intel.com>
References: <1394717621-5608-1-git-send-email-luciano.coelho@intel.com>
	<1394717621-5608-4-git-send-email-luciano.coelho@intel.com>
Date: Tue, 18 Mar 2014 15:10:58 +0100
Message-ID: <CA+BoTQkpjC+LeWfNvaNXTwTsHgWAg7-umDnq4CjWk1oBvvo+9g@mail.gmail.com> (sfid-20140318_151104_083303_ED83C6F3)
Subject: Re: [PATCH v9 3/4] mac80211: implement chanctx reservation
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 March 2014 14:33, Luciano Coelho <luciano.coelho@intel.com> wrote:

[...]

> +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> +       if (old_ctx->refcount == 0)
> +               ieee80211_free_chanctx(local, old_ctx);
> +       if (ret) {
> +               /* if assign fails refcount stays the same */
> +               if (ctx->refcount == 0)
> +                       ieee80211_free_chanctx(local, ctx);
> +               goto out;
> +       }
> +
> +       __ieee80211_vif_copy_chanctx_to_vlans(sdata, false);

I'm sorry I didn't notice that this earlier :-( but this should be
guarded by if (sdata->vif.type == NL80211_IFTYPE_AP). Otherwise you
hit WARN_ON for non-AP (e.g. STA) chanctx reservation.

Same goes for 4/4 (since you re-indent the code there).


Michał
