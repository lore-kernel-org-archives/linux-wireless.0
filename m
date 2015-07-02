Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37728 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbbGBJoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 05:44:08 -0400
Received: by wicgi11 with SMTP id gi11so68294668wic.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 02:44:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435822032.2285.2.camel@sipsolutions.net>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
	<CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
	<CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
	<1435082418.2777.11.camel@ipeer-box>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
	<CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
	<1435822032.2285.2.camel@sipsolutions.net>
Date: Thu, 2 Jul 2015 11:44:06 +0200
Message-ID: <CALhHN=ojLBA1AFGz=atjJhv+fJAr-Rkhd0cgYpma_4Rx+HYOaw@mail.gmail.com> (sfid-20150702_114417_225355_CC0CD8CC)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 July 2015 at 09:27, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2015-06-27 at 23:49 +0200, Janusz Dziedzic wrote:
>>
>> I just check the mac80211/cfg80211 code, and I am not sure this
>> direct probe could work correctly.
>>
>> Function ieee80211_rx_mgmt_probe_resp() is interesting.
>> Seems we call
>> ieee80211_rx_bss_info() -> ieee80211_bss_info_update ->
>> cfg80211_inform_bss_width_frame() -> cfg80211_bss_update() -> this
>> could set bss->proberesp_ies
>> and after that check:
>>
>>         if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies
>> &&
>>             ether_addr_equal(mgmt->bssid, ifmgd->auth_data->bss
>> ->bssid)) {
>>                 /* got probe response, continue with auth */
>>                 sdata_info(sdata, "direct probe responded\n");
>>
>> So, ifmgd->auth_data->bss->proberesp_ies could be set before check?
>>
>> BTW, During my tests (no matter which card used) I never saw this
>> msg:
>> sdata_info(sdata, "direct probe responded\n");
>> And always saw 3 failed direct probes.
>>
>> @Johannes: Is that possible or I miss something.
>>
>
> I agree that this looks like a bug, but I'm not sure it's really all
> that relevant?
>
> After all, ieee80211_probe_auth() takes ->proberesp_ies as its only
> condition, so even if it doesn't get triggered immediately by the
> "direct probe responded", it should send an auth frame the next round,
> just the rounds counter wouldn't restart at 0 again.
>
> Perhaps though the changes in cfg80211's BSS management broke this
> whole logic? Then again, that's quite a while ago.
>
> The issue above can probably easily fixed by doing the BSS update after
> the "direct probe responded" though, no? Like this:
> https://p.sipsolutions.net/67f9212f0f9f3642.txt
>
This was my first idea, but in such case I suspect we will send
another direct probe while  bss->proberesp_ies will be not set and
ieee80211_probe_auth() will send second probe_req?

BR
Janusz
