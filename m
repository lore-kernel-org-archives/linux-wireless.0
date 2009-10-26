Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:52224 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZJZM7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 08:59:45 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Questions about cfg80211's cfg80211_connect_params->crypto settings
Date: Mon, 26 Oct 2009 13:59:13 +0100
Cc: linux-wireless@vger.kernel.org
References: <200910260947.48365.hs4233@mail.mn-solutions.de> <200910261311.47164.hs4233@mail.mn-solutions.de> <1256559734.28230.23.camel@johannes.local>
In-Reply-To: <1256559734.28230.23.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910261359.13658.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > inside .connect() if I check sme->crypto.cipher_suite for
> > 
> >   WLAN_CIPHER_SUITE_WEP40
> >   WLAN_CIPHER_SUITE_WEP104
> >   WLAN_CIPHER_SUITE_TKIP
> >   WLAN_CIPHER_SUITE_CCMP
> >   0  (meaning no encryption/WEP obfuscation)
> 
> But why would you look at that? It sounds like you want 
sme->privacy to
> know whether to select an AP that advertises privacy or not?

Libertas' firmware doesn't have a capability of to "select an AP
that advertises privacy". So in practice it's wpa_supplicant that 
selects this, because pure iw/cfg80211 can't select an AP for 
me.

My connect method does this:

lbs_cfg_connect:
    if (sme->bssid set)  {
        # I need a full cfg80211_bss entry, because I can only
        # associate to a specific bss via CMD_802_11_ASSOCIATE
	# and I need
	#   bss->capability
	#   bss->bssid
	#   bss->get_ie(WLAN_EID_SSID)
	#   bss->channel
	#   bss->rates
        bss = cfg80211_get_bss()
    } else {
        error_out
    }

    clear_local_wep_key_copy
    switch (sme->cryto.cipher_group) {
    case WEP40, WEP104:
        store_key_keyidx_locally
        set_wep_keys
        enable_wep_in_lbs_mac
        disable_rsn
        break;
    case no_encryption:
    case WPA, WPA2:
        remove_wep_keys
        disable_wep_in_lbs_mac
        clear_wpa_wpa2_unicast_multicast_key
        unless no_encryption:
           enable_rsn
    }
    build_and_submit_set_authtype_command_for_the_firmware
    build_and_submit_associate_command_for_the_firmware
        

You see, nowhere do I actually need sme->privacy, all info is in 
sme->crypto.cipher_group.


However, this current setup makes "iw abc connect SSID" 
non-working with libertas. It would work with libertas if I 
would use the .auth/.assoc API, because then net/wireless/sme.c 
would scan for me. But in the .connect API case, it doesn't do 
this.

But information I get in the .connect() call aren't sufficuent 
for the Libertas firmware interface, I need more data, which I 
can get from a cfg80211_bss entry.

One possiblity is that net/wireless/sme.c get's more general and 
does scan in the .connect() case, too.

Or I could substitute the "error_out" with a local scan, and then 
select the "best" AP from the bss list. I fear however that such 
a selection function might already be somewhere inside 
net/wireless/*.c, I'll need to search for that.

-- 
http://www.holgerschurig.de
