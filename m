Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34172 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965133AbbLHPrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 10:47:39 -0500
Received: by qgeb1 with SMTP id b1so21864170qge.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2015 07:47:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449589374.4154.11.camel@sipsolutions.net>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
 <1449583479-26658-7-git-send-email-emmanuel.grumbach@intel.com>
 <CABPxzYK=RdZo0WB7Tt4PO19n23+9rgAypj=OEDZE8GJ6cV_gXw@mail.gmail.com> <1449589374.4154.11.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 8 Dec 2015 21:17:19 +0530
Message-ID: <CABPxzYJd+9kq8w9zz549F1EEHhWgKhCsDeRUR1MzZ=LbizMJbw@mail.gmail.com> (sfid-20151208_164742_676173_C3C6052B)
Subject: Re: [PATCH 6/9] mac80211: handle width changes from opmode
 notification IE in beacon
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2015 at 9:12 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-12-08 at 21:08 +0530, Krishna Chaitanya wrote:
>>
>> >  void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data
>> > *sdata,
>> >                                  struct sta_info *sta, u8 opmode,
>> > -                                enum ieee80211_band band, bool
>> > nss_only)
>> > +                                enum ieee80211_band band)
>> >  {
>> >         struct ieee80211_local *local = sdata->local;
>> >         struct ieee80211_supported_band *sband = local->hw.wiphy-
>> > >bands[band];
>> >
>> > -       u32 changed = __ieee80211_vht_handle_opmode(sdata, sta,
>> > opmode,
>> > -                                                   band,
>> > nss_only);
>> > +       u32 changed = __ieee80211_vht_handle_opmode(sdata, sta,
>> > opmode, band);
>> >
>> >         if (changed > 0)
>> >                 rate_control_rate_update(local, sband, sta,
>> > changed);
>>
>> Not related to current change.
>>
>> I was looking at this code a while ago and found that
>> rate_control_rate_update
>> doesn't update the rates from rx_nss, rather it updates from HT/VHT
>> capabilities.
>>
>> So how does the NSS update from OP MODE IE work?
>>
>
> Huh? You just quoted the code that does this?
MLME is updating the rx_nss.

> If the rate control algorithm doesn't look at sta->sta.rx_nss then
> that's their bug.

Yes, it looks like it. Only BW is handled, not the NSS change, and
without this patch OP MODE IE in beacon updates neither NSS nor BW.

For Action frame OP MODE IE, NSS will be updated.
