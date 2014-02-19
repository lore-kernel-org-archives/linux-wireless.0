Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:42716 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaBSLs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:48:27 -0500
Received: by mail-bk0-f41.google.com with SMTP id na10so172025bkb.28
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 03:48:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392809283.12095.89.camel@porter.coelho.fi>
References: <1392804045-11258-1-git-send-email-luca@coelho.fi>
	<1392804045-11258-8-git-send-email-luca@coelho.fi>
	<CA+BoTQmFRoS-uEWx-guObucK5dwM8gm=yGt-58hzADQBPxOAtg@mail.gmail.com>
	<1392809283.12095.89.camel@porter.coelho.fi>
Date: Wed, 19 Feb 2014 12:48:25 +0100
Message-ID: <CA+BoTQn3WAuVPM5HSHoaKFAhdDFfp7_qJXNEd+Nc_9B6VCk67g@mail.gmail.com> (sfid-20140219_124830_973503_6298D5DB)
Subject: Re: [PATCH 7/7] cfg80211/mac80211: move combination check to mac80211
 for ibss
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 12:28, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-02-19 at 12:01 +0100, Michal Kazior wrote:
>> On 19 February 2014 11:00, Luciano Coelho <luca@coelho.fi> wrote:
>> > From: Luciano Coelho <luciano.coelho@intel.com>
>> >
>> > Now that mac80211 can check the interface combinations itself, move
>> > the combinations check from cfg80211 to mac80211 when joining an IBSS.
>> >
>> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
>> > ---
>> >  net/mac80211/ibss.c | 28 +++++++++++++++++++++++++---
>> >  net/wireless/ibss.c | 27 ---------------------------
>> >  2 files changed, 25 insertions(+), 30 deletions(-)
>> >
>> > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
>> > index 56b0dce..49a25aa 100644
>> > --- a/net/mac80211/ibss.c
>> > +++ b/net/mac80211/ibss.c
>> > @@ -1646,7 +1646,29 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
>> >         u32 changed = 0;
>> >         u32 rate_flags;
>> >         struct ieee80211_supported_band *sband;
>> > +       enum ieee80211_chanctx_mode chanmode;
>> > +       struct ieee80211_local *local = sdata->local;
>> > +       int radar_detect_width;
>> >         int i;
>> > +       int ret;
>> > +
>> > +       radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
>> > +                                                          &params->chandef,
>> > +                                                          sdata->vif.type);
>> > +       if (radar_detect_width < 0)
>> > +               return radar_detect_width;
>> > +
>> > +       if (radar_detect_width > 0 && !params->userspace_handles_dfs)
>> > +               return -EINVAL;
>> > +
>> > +       chanmode = (params->channel_fixed && !radar_detect_width) ?
>> > +               IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
>> > +
>> > +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
>> > +                                          &params->chandef, chanmode,
>> > +                                          radar_detect_width);
>> > +       if (ret < 0)
>> > +               return ret;
>>
>> Aren't you supposed to be holding chanctx_mtx while calling
>> ieee80211_check_combinations()?
>
> Gulp! You're totally right, I missed the mutex here.  I'll add it and
> send it in v2.
>
> I haven't tested IBSS yet, as I said in my cover letter.  This would
> have been caught with the lockdep_assert_held() in
> ieee80211_check_combinations().
>
>
>> I hope you're aware this can end up with not being able to connect?
>> chanctx isn't claimed until __ieee80211_sta_join_ibss() so you could
>> possibly start other interface and break combinations. Or am I missing
>> something?
>
> This is just an early check.  The actual connection may still fail later
> if someone adds another interface meanwhile.  We check that again in
> ieee80211_vif_use_channel().
>
> This was actually broken before my changes, wasn't it? AFAICT the check
> was only done in __cfg80211_join_ibss() and not later when the channel
> was actually taken into use...

True. Maybe it's pointless to perform the check here at all? It
doesn't guarantee anything..


Michał
