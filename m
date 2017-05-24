Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49804 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966711AbdEXHkx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 03:40:53 -0400
Message-ID: <1495611651.2665.9.camel@sipsolutions.net> (sfid-20170524_094058_864437_CC6D436D)
Subject: Re: WPA and WPA2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Tobin C. Harding" <me@tobin.cc>, linux-wireless@vger.kernel.org
Date: Wed, 24 May 2017 09:40:51 +0200
In-Reply-To: <20170524072750.GI8158@eros> (sfid-20170524_092758_235291_603981F2)
References: <20170524072750.GI8158@eros>
         (sfid-20170524_092758_235291_603981F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-24 at 17:27 +1000, Tobin C. Harding wrote:

> I am attempting to rewrite the ks7010 WEXT driver
> (drivers/staging/ks7010) to use the CFG80211 API.

Heh, I wasn't even aware of this driver yet.

> As I understand, first there was WEP. 

Correct.

> Next we got a marketing term WPA which referred to 802.11i (which
> specified the protocols TKIP and CCMP, and also RSN).

No, technically WPA referred to a *draft* version of 802.11i, and used
(only?) TKIP - where WPA2 is equivalent to RSN, the published version
of 802.11i (now long rolled into the spec, of course), but WPA2 also
preferred CCMP and only used TKIP for compatibility, IIRC.

> WEP vs WPA
> ----------
> 
> To add to my confusion the ks7010 code seemingly mixes up the use of
> WEP keys and WPA keys, to set both the WEP and the WPA keys the
> driver uses the same MIB requests? Yet throughout the code WEP keys
> and WPA keys are stored in separate structures (and treated
> differently).
> 
> If WPA is enabled are not WEP keys superfluous?

Well, you can't really have both at the same time, but you can (and
probably should) support both.

> WPA vs WPA2
> -----------
> 
> Were WPA version 1 and WPA version 2 marketing terms or do they
> differ?

See above. But at the level you're looking at, it's probably not really
all that relevant. To some extent, WPA1 is TKIP and WPA2 is CCMP, but
you don't really care since you just get keys with a cipher suite
identifier attached to them.

> ieee80211.h does not seem to mention WPA2 (and cfg80211.h mentions it
> once only in some comments) however, from cfg80211.h;
> 
>  * struct cfg80211_crypto_settings - Crypto settings
>  * @wpa_versions: indicates which, if any, WPA versions are enabled
>  *	(from enum nl80211_wpa_versions)
> 
> When using the CFG80211 API we do not need to worry about the
> WPA/WPA2 distinction? 

This is only relevant for full-MAC devices, I think it's mostly used
for selecting the BSS?

> Can I drop all the WPA version 1 code from the driver?
> 
> A little more information:
> 
> The WEXT driver defines ciphers, from looking at ieee80211.h it seems
> that it uses WLAN_CIPHER_SUITE_XXX for WPA2 and for WPA it uses
> 
> #define CIPHER_ID_WPA_NONE    "\x00\x50\xf2\x00"
> #define CIPHER_ID_WPA_WEP40   "\x00\x50\xf2\x01"
> #define CIPHER_ID_WPA_TKIP    "\x00\x50\xf2\x02"
> #define CIPHER_ID_WPA_CCMP    "\x00\x50\xf2\x04"
> #define CIPHER_ID_WPA_WEP104  "\x00\x50\xf2\x05"

That's ... strange. The standard identifiers are

WLAN_CIPHER_SUITE_*, which are 00-0F-AC:n (with the same values for n
as above).

If the firmware wants them with MS OUI, then you'd probably have to
translate them.



All this wext code there looks really strange though.

Does this driver actually work with standard wpa_supplicant?

johannes
