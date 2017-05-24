Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40293 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751871AbdEXH1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 03:27:54 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 51DF220719
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 03:27:53 -0400 (EDT)
Received: from localhost (124-169-117-216.dyn.iinet.net.au [124.169.117.216])
        by mail.messagingengine.com (Postfix) with ESMTPA id 99277241E0
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 03:27:52 -0400 (EDT)
Date: Wed, 24 May 2017 17:27:50 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: linux-wireless@vger.kernel.org
Subject: WPA and WPA2
Message-ID: <20170524072750.GI8158@eros> (sfid-20170524_092758_235291_603981F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am attempting to rewrite the ks7010 WEXT driver (drivers/staging/ks7010)
to use the CFG80211 API.

I am reading 802.11 Wireless Networks - Matthew S. Gast for reference.

I have some confusion regarding WEP/WPA/WPA2/RSN, ciphers, keys and
ie's?

As I understand, first there was WEP. Next we got a marketing term WPA
which referred to 802.11i (which specified the protocols TKIP and
CCMP, and also RSN).

WEP vs WPA
----------

To add to my confusion the ks7010 code seemingly mixes up the use of
WEP keys and WPA keys, to set both the WEP and the WPA keys the driver
uses the same MIB requests? Yet throughout the code WEP keys and WPA
keys are stored in separate structures (and treated differently).

If WPA is enabled are not WEP keys superfluous?

WPA vs WPA2
-----------

Were WPA version 1 and WPA version 2 marketing terms or do they differ?

ieee80211.h does not seem to mention WPA2 (and cfg80211.h mentions it
once only in some comments) however, from cfg80211.h;

 * struct cfg80211_crypto_settings - Crypto settings
 * @wpa_versions: indicates which, if any, WPA versions are enabled
 *	(from enum nl80211_wpa_versions)

When using the CFG80211 API we do not need to worry about the WPA/WPA2
distinction? Can I drop all the WPA version 1 code from the driver?

A little more information:

The WEXT driver defines ciphers, from looking at ieee80211.h it seems
that it uses WLAN_CIPHER_SUITE_XXX for WPA2 and for WPA it uses

#define CIPHER_ID_WPA_NONE    "\x00\x50\xf2\x00"
#define CIPHER_ID_WPA_WEP40   "\x00\x50\xf2\x01"
#define CIPHER_ID_WPA_TKIP    "\x00\x50\xf2\x02"
#define CIPHER_ID_WPA_CCMP    "\x00\x50\xf2\x04"
#define CIPHER_ID_WPA_WEP104  "\x00\x50\xf2\x05"

FYI ieee80211.h has

#define WLAN_OUI_MICROSOFT	       0x0050f2

Thanks for taking the time to read this mail, any suggestions most
appreciated.

thanks,
Tobin.
