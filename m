Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52433 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0HWQDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 12:03:22 -0400
Received: by pzk26 with SMTP id 26so2333665pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 09:03:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Aug 2010 12:03:21 -0400
Message-ID: <AANLkTin=gfXmomRa2UnMfn1WaG_2PJc53m1mi8Q-6vpJ@mail.gmail.com>
Subject: getting back QUALITY
From: Christopher Piggott <cpiggott@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I notice that through wpa_supplicant I can see noise, quality, and
signal strength ... but in my own app I can only see signal strength
in my netlink application.  This is in response to a request for scan
results.  I am able to retrieve the station's SSID out of the
NL80211_BSS_INFORMATION_ELEMENTS attribute, and I get a DBM signal
that makes sense.



    nlattr *dbm_ptr = bss[NL80211_BSS_SIGNAL_MBM];
    if (dbm_ptr == NULL) {
        cout << "NO RSSI" << endl;
    } else {
        int dbm = nla_get_u32(dbm_ptr);
        cout << "DBM: " << dbm << endl;
    }

    nlattr *quality_ptr = bss[NL80211_BSS_SIGNAL_UNSPEC];
    if (quality_ptr == NULL) {
        cerr << "NO QUALITY" << endl;
    } else {
        int quality = (int) nla_get_u8(quality_ptr);
        cout << "QUALITY: " << (quality/100.0f) << endl;
    }

I get "NO QUALITY" out of the above, yet wpa_supplicant tells me
"Quality=29/70" (or similar).

Is this actually a calculated parameter, and BSS_SIGNAL_UNSPEC isn't
really reported by the driver?

--Chris
