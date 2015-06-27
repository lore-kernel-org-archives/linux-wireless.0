Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37065 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbbF0WDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 18:03:30 -0400
Received: by wicgi11 with SMTP id gi11so43613529wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2015 15:03:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
	<CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
	<CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
	<1435082418.2777.11.camel@ipeer-box>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
	<CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
Date: Sun, 28 Jun 2015 00:03:29 +0200
Message-ID: <CALhHN=oqhSu5KiBDaAMOkei2qZZ7+_cWkmRNje679BE1aaMimg@mail.gmail.com> (sfid-20150628_000825_174411_A950D404)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 June 2015 at 23:49, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> On 24 June 2015 at 14:20, Peer, Ilan <ilan.peer@intel.com> wrote:
>> Hi Janusz,
>>
>> Any chance you can check if the attached patch fixes the issue you reported?
>>
>> Thanks in advance,
>>
> I just check the mac80211/cfg80211 code, and I am not sure this direct
> probe could work correctly.
>
> Function ieee80211_rx_mgmt_probe_resp() is interesting.
> Seems we call
> ieee80211_rx_bss_info() -> ieee80211_bss_info_update ->
> cfg80211_inform_bss_width_frame() -> cfg80211_bss_update() -> this
> could set bss->proberesp_ies
> and after that check:
>
>         if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies &&
>             ether_addr_equal(mgmt->bssid, ifmgd->auth_data->bss->bssid)) {
>                 /* got probe response, continue with auth */
>                 sdata_info(sdata, "direct probe responded\n");
>
> So, ifmgd->auth_data->bss->proberesp_ies could be set before check?
>
> BTW, During my tests (no matter which card used) I never saw this msg:
> sdata_info(sdata, "direct probe responded\n");
> And always saw 3 failed direct probes.
>
> @Johannes: Is that possible or I miss something.
>

Simplest patch I made:

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e9f36f7..8ceae3d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -371,6 +371,7 @@ struct ieee80211_mgd_auth_data {
        struct cfg80211_bss *bss;
        unsigned long timeout;
        int tries;
+       bool waiting_probe_resp;
        u16 algorithm, expected_transaction;

        u8 key[WLAN_KEY_LEN_WEP104];
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3294666..6f4027e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3212,13 +3212,14 @@ static void
ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
            ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
                ieee80211_reset_ap_probe(sdata);

-       if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies &&
+       if (ifmgd->auth_data && ifmgd->auth_data->waiting_probe_resp &&
            ether_addr_equal(mgmt->bssid, ifmgd->auth_data->bss->bssid)) {
                /* got probe response, continue with auth */
                sdata_info(sdata, "direct probe responded\n");
                ifmgd->auth_data->tries = 0;
                ifmgd->auth_data->timeout = jiffies;
                ifmgd->auth_data->timeout_started = true;
+               ifmgd->auth_data->waiting_probe_resp = false;
                run_again(sdata, ifmgd->auth_data->timeout);
        }
 }
@@ -3727,6 +3728,8 @@ static int ieee80211_probe_auth(struct
ieee80211_sub_if_data *sdata)
                           auth_data->bss->bssid, auth_data->tries,
                           IEEE80211_AUTH_MAX_TRIES);

+               auth_data->waiting_probe_resp = true;
+
                rcu_read_lock();
                ssidie = ieee80211_bss_get_ie(auth_data->bss, WLAN_EID_SSID);
                if (!ssidie) {

BR
Janusz
