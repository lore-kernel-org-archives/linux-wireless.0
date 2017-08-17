Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34631 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbdHQDjA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 23:39:00 -0400
Received: by mail-oi0-f53.google.com with SMTP id x3so55110201oia.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2017 20:39:00 -0700 (PDT)
MIME-Version: 1.0
From: Rock Chen <rockchen.tw@gmail.com>
Date: Thu, 17 Aug 2017 11:38:59 +0800
Message-ID: <CAH7FnHSWG2yrG2rYP7GTa4Tv0dQxR67DD0bpZ8QB0AzDR1JYDQ@mail.gmail.com> (sfid-20170817_053916_355774_F0F566EF)
Subject: [mac80211] Mesh Remove VHT Capability IE and Remove OFDM in Supported
 Rates IE Question
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sirs,

In mesh, beacon IE contents are generated in mac80211.
If hardware reports VHT capable, then it seems there's no way to
disable VHT Capability IE in some cases, for example vht_disable=1 in
wpa_supplicant.
On the other hand, if ht_disable=1 in wpa_supplicant, then both HT
Capability and VHT Capability IE would be removed.
I think it should be NO VHT Capability IE in cases of VHT is NOT
allowed/desired.

mesh_add_vht_cap_ie() {

        if (!sband->vht_cap.vht_supported ||
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
            sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
                 return 0;
}

Another question is about Supported Rates IE in mesh mode.
Japan regulatory requires that only 802.11b should be used in 2.4G channel 14.
Again, if hardware reports CCK+OFDM capable, then Supported Rates IE
contains both CCK+OFDM.
But wpa_supplicant would set Supported Rates IE as CCK only in mesh
peering action frame.
I think it should be NO OFDM declaration in this case.

ieee80211_add_srates_ie() {
        for (i = 0; i < rates; i++) {
                u8 basic = 0;
                if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
                        continue;

                if (need_basic && basic_rates & BIT(i))
                        basic = 0x80;
                rate = sband->bitrates[i].bitrate;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
                                                   5 * (1 << shift));
                *pos++ = basic | (u8) rate;
         }
}

>From IEEE802.11-2012, Supported Rates contains the meaning of operation.

8.4.2.3 Supported Rates element
The Supported Rates element specifies up to eight rates in the
OperationalRateSet parameter, as described in the MLME-JOIN.request
and MLME-START.request primitives, and zero or more BSS membership
selectors.
The Information field is encoded as 1 to 8 octets, where each octet
describes a single Supported Rate or BSS membership selector.

6.3.4.2.2 Semantics of the service primitive
Description of OperationalRateSet:
The set of data rates that the STA desires to use for communication
within the BSS. The STA shall be able to receive at each of the data
rates listed in the set.
This set is a superset of the rates contained in the BSSBasicRateSet parameter.

Are these abnormal behaviors?

Regards,
Rock
