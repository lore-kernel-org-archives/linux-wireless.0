Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:46430 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaIKJ2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 05:28:12 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so4182016wev.13
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 02:28:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410418181.14130.7.camel@dubbel>
References: <1410418181.14130.7.camel@dubbel>
Date: Thu, 11 Sep 2014 11:28:10 +0200
Message-ID: <CA+BoTQ=dqQz1epo=-odvVQjOx0K-yLNtivufE5BKBK9+QV2wGQ@mail.gmail.com> (sfid-20140911_112820_622054_109C6087)
Subject: Re: CSA broken with !use_chanctx drivers?
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 September 2014 08:49, Luca Coelho <luca@coelho.fi> wrote:
> Hi Michal,
>
> Johannes and I were checking the channel switch code (namely to see if
> implementing the drv_channel_switch op was fine in our case) and we saw
> that CSA with non-chanctx drivers seems to be broken.
>
> In commit 4c3ebc56 (mac80211: use chanctx reservation for STA CSA) we
> lost this piece of code:
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index eccc849..931330b 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -940,52 +940,70 @@ static void ieee80211_chswitch_work(struct work_struct *work)
> [...]
> -       if (!local->use_chanctx) {
> -               local->_oper_chandef = sdata->csa_chandef;
> -               /* Call "hw_config" only if doing sw channel switch.
> -                * Otherwise update the channel directly
> -                */
> -               if (!local->ops->channel_switch)
> -                       ieee80211_hw_config(local, 0);
> -               else
> -                       local->hw.conf.chandef = local->_oper_chandef;
> -       }
> -
>
> It seems that we're not updating the chandef in non-chanctx drivers.  Or
> are we missing something?

Hmm.. ieee80211_hw_config() is called in
ieee80211_chsw_switch_hwconf() now. The special treatment of
drv_channel_switch() drivers is gone though - can that be a big
problem?

>From what I've tested just now it seems iwldvm (3.17-rc2, fw
18.168.6.1) calls ieee80211_chswitch_done() almost immediately most of
the time. This obviously ends up with beacon loss with larger CS
count. With small CS count it works though. This doesn't seem to be
related to the missing hw_confg().

Now that I think it's probably a good idea to make multi-vif CSA
mutually exlusive with drv_channel_switch() based STA CSA..


Michał
