Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44988 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbbGBH1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 03:27:18 -0400
Message-ID: <1435822032.2285.2.camel@sipsolutions.net> (sfid-20150702_092722_997599_0FF54812)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>
Date: Thu, 02 Jul 2015 09:27:12 +0200
In-Reply-To: <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com> (sfid-20150627_234919_920334_D8F4F928)
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
	 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
	 <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
	 <1435082418.2777.11.camel@ipeer-box>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
	 <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
	 (sfid-20150627_234919_920334_D8F4F928)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-06-27 at 23:49 +0200, Janusz Dziedzic wrote:
> 
> I just check the mac80211/cfg80211 code, and I am not sure this 
> direct probe could work correctly.
> 
> Function ieee80211_rx_mgmt_probe_resp() is interesting.
> Seems we call
> ieee80211_rx_bss_info() -> ieee80211_bss_info_update ->
> cfg80211_inform_bss_width_frame() -> cfg80211_bss_update() -> this
> could set bss->proberesp_ies
> and after that check:
> 
>         if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies 
> &&
>             ether_addr_equal(mgmt->bssid, ifmgd->auth_data->bss
> ->bssid)) {
>                 /* got probe response, continue with auth */
>                 sdata_info(sdata, "direct probe responded\n");
> 
> So, ifmgd->auth_data->bss->proberesp_ies could be set before check?
> 
> BTW, During my tests (no matter which card used) I never saw this 
> msg:
> sdata_info(sdata, "direct probe responded\n");
> And always saw 3 failed direct probes.
> 
> @Johannes: Is that possible or I miss something.
> 

I agree that this looks like a bug, but I'm not sure it's really all
that relevant?

After all, ieee80211_probe_auth() takes ->proberesp_ies as its only
condition, so even if it doesn't get triggered immediately by the
"direct probe responded", it should send an auth frame the next round,
just the rounds counter wouldn't restart at 0 again.

Perhaps though the changes in cfg80211's BSS management broke this
whole logic? Then again, that's quite a while ago.

The issue above can probably easily fixed by doing the BSS update after
the "direct probe responded" though, no? Like this: 
https://p.sipsolutions.net/67f9212f0f9f3642.txt

johannes
