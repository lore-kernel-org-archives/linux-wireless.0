Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49643 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbbLHQnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 11:43:50 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/9] mac80211: limit the A-MSDU Tx based on peer's
 capabilities
Date: Tue, 8 Dec 2015 16:43:45 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E912BEA@hasmsx107.ger.corp.intel.com> (sfid-20151208_174353_268334_A625A658)
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
 <1449583479-26658-3-git-send-email-emmanuel.grumbach@intel.com>
 <CABPxzYJB9M5FtxdjXeB5t-ygqv8OQ9LpVqsMvGTJa_r=nOb4Bw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E912959@hasmsx107.ger.corp.intel.com>
 <CABPxzYKp-97mNgtZZubiQ3Ew2VjOh-hFRPRwLY5WLvac9kU32g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/08/2015 06:35 PM, Krishna Chaitanya wrote:
>
>
> On Dec 8, 2015 10:01 PM, "Grumbach, Emmanuel"
> <emmanuel.grumbach@intel.com <mailto:emmanuel.grumbach@intel.com>> wrote:
> >
> >
> >
> > On 12/08/2015 06:03 PM, Krishna Chaitanya wrote:
> > > On Tue, Dec 8, 2015 at 7:34 PM, Emmanuel Grumbach
> > > <emmanuel.grumbach@intel.com <mailto:emmanuel.grumbach@intel.com>>
> wrote:
> > >> index 7a76ce6..f4a5287 100644
> > >> --- a/net/mac80211/ht.c
> > >> +++ b/net/mac80211/ht.c
> > >> @@ -230,6 +230,11 @@ bool
> ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
> > >>         /* set Rx highest rate */
> > >>         ht_cap.mcs.rx_highest = ht_cap_ie->mcs.rx_highest;
> > >>
> > >> +       if (ht_cap.cap & IEEE80211_HT_CAP_MAX_AMSDU)
> > >> +               sta->sta.max_amsdu_len =
> IEEE80211_MAX_MPDU_LEN_HT_7935;
> > >> +       else
> > >> +               sta->sta.max_amsdu_len =
> IEEE80211_MAX_MPDU_LEN_HT_3839;
> > >> +
> > >>   apply:
> > >>         changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
> > >>
> > >> diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
> > >> index 92c9843..d2f2ff6 100644
> > >> --- a/net/mac80211/vht.c
> > >> +++ b/net/mac80211/vht.c
> > >> @@ -281,6 +281,24 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct
> ieee80211_sub_if_data *sdata,
> > >>         }
> > >>
> > >>         sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
> > >> +
> > >> +       /* If HT IE reported 3839 bytes only, stay with that size. */
> > >> +       if (sta->sta.max_amsdu_len == IEEE80211_MAX_MPDU_LEN_HT_3839)
> > >> +               return;
> > >> +
> > >> +       switch (vht_cap->cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK) {
> > >> +       case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
> > >> +               sta->sta.max_amsdu_len =
> IEEE80211_MAX_MPDU_LEN_VHT_11454;
> > >> +               break;
> > >> +       case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991:
> > >> +               sta->sta.max_amsdu_len =
> IEEE80211_MAX_MPDU_LEN_VHT_7991;
> > >> +               break;
> > >> +       case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895:
> > >> +       default:
> > >> +               sta->sta.max_amsdu_len =
> IEEE80211_MAX_MPDU_LEN_VHT_3895;
> > >> +               break;
> > >> +       }
> > > Ideally speaking shouldn't we use different variables for HT and VHT
> > > and depending on
> > > rate HT/VHT we should aggregate accordingly? of course that will be
> > > tricky as we dont
> > > have the rate control info at the time of aggregation. Standard is
> > > clear about usage of
> > > independent lengths depending on whether its an VHT/HT PPDU.
> >
> > Yes - but since it is tricky, I preferred to be on the safe side and
> > limit VHT amsdus for the very peculiar AP that would decide to have
> > large A-MSDUs in VHT and small ones in HT (?!).
> Yes but wouldn't it be safer to just use min(ht , vht)? For a good AP
> it shouldn't matter and bad AP it will still work.
>
This is the de-facto what this code does I think.
If the HT limit is 4K, then don't even take the VHT limit into account
and the VHT limit can't be smaller than the HT one in that case.
If the HT limit is 8K, then we can limit it further to 4K in case VHT
has a limit of 4K (which is another weird case), but we can also make it
larger for VHT frames?

So I don't really see the bug here, am I missing something?

> > > If we use the same variable to arrive at max_amsdu_len for both VHT
> > > and HT, we might
> > > end up sending 11454 sized MSDU in a HT rate.
> > >
> > And since that can't be handled at the time of the A-MSDU building,
> > leave that to another entity :)
>

