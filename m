Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lorien.comfychair.org ([173.8.144.98]:44960 "EHLO
        lorien.comfychair.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbeHRAdD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 20:33:03 -0400
Date: Fri, 17 Aug 2018 14:21:20 -0700
From: Danek Duvall <duvall@comfychair.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Use of IEEE80211_VHT_CAP_RXSTBC_* in mac80211_hwsim
Message-ID: <20180817212120.GA16270@lorien.comfychair.org> (sfid-20180818_004155_053007_4313902F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211_hwsim driver puts this in its VHT capabilities info field:

    IEEE80211_VHT_CAP_RXSTBC_1 | 
    IEEE80211_VHT_CAP_RXSTBC_2 |
    IEEE80211_VHT_CAP_RXSTBC_3 |
    IEEE80211_VHT_CAP_RXSTBC_4

and I don't understand what that's supposed to mean.  According to
802.11-2016, the three-bit field isn't a series of boolean values, but a
single numerical value in its three bits, where the value is the maximum
number of STBC streams, and the maximum defined value is 4.

But the way that the code treats it, we end up with a value of 7.

There seems to be a similar issue in mac80211/main.c, in the definition of
mac80211_vht_capa_mod_mask.

Is that a bug in the code, or a misunderstanding on my part?  No other
(in-tree) drivers use any of the macros other than _1, so I don't have any
other references for how the other values might be used.

Thanks,
Danek
