Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51685 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2COSx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:53:56 -0400
Received: by yenl12 with SMTP id l12so3376588yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 11:53:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331836777.3432.31.camel@jlt3.sipsolutions.net>
References: <4F6236D0.40505@candelatech.com>
	<1331836777.3432.31.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Mar 2012 20:53:55 +0200
Message-ID: <CAB3XZEeDtJKpSbYB8sMM35rRT7KH5dVuKOWntDBhDp+unRkWGA@mail.gmail.com> (sfid-20120315_195400_146132_B767C0DD)
Subject: Re: compiler warning in wireless-testing.
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 8:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-03-15 at 11:37 -0700, Ben Greear wrote:
>> Looks like this is the compiler's fault to me..but might be
>> worth explicitly initializing the sta variable just to make
>> it quiet.
>
> I disagree, doing that will only hide legitimate warnings if somebody
> changes the code. Initializing for compiler happiness is almost always
> the worst thing you can do.
>
what about

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6cb5361..96fc201 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3094,7 +3094,6 @@ static int ieee80211_prep_connection(struct
ieee80211_sub_if_data *sdata,
        struct ieee80211_local *local = sdata->local;
        struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
        struct ieee80211_bss *bss = (void *)cbss->priv;
-       struct sta_info *sta;
        bool have_sta = false;
        int err;

@@ -3107,12 +3106,6 @@ static int ieee80211_prep_connection(struct
ieee80211_sub_if_data *sdata,
                rcu_read_unlock();
        }

-       if (!have_sta) {
-               sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
-               if (!sta)
-                       return -ENOMEM;
-       }
-
        mutex_lock(&local->mtx);
        ieee80211_recalc_idle(sdata->local);
        mutex_unlock(&local->mtx);
@@ -3123,10 +3116,15 @@ static int ieee80211_prep_connection(struct
ieee80211_sub_if_data *sdata,

        if (!have_sta) {
                struct ieee80211_supported_band *sband;
+               struct sta_info *sta;
                u32 rates = 0, basic_rates = 0;
                bool have_higher_than_11mbit;
                int min_rate = INT_MAX, min_rate_index = -1;

+               sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
+               if (!sta)
+                       return -ENOMEM;
+
                sband = sdata->local->hw.wiphy->bands[cbss->channel->band];

                ieee80211_get_rates(sband, bss->supp_rates,


it also makes the code more clear, imho.

Eliad.
