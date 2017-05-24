Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967839AbdEXQoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 12:44:03 -0400
Message-ID: <1495644240.12939.3.camel@redhat.com> (sfid-20170524_184417_597726_14DB4F2B)
Subject: Re: WPA and WPA2
From: Dan Williams <dcbw@redhat.com>
To: "Tobin C. Harding" <me@tobin.cc>, linux-wireless@vger.kernel.org
Date: Wed, 24 May 2017 11:44:00 -0500
In-Reply-To: <20170524073459.GJ8158@eros>
References: <20170524072750.GI8158@eros> <20170524073459.GJ8158@eros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-24 at 17:34 +1000, Tobin C. Harding wrote:
> On Wed, May 24, 2017 at 05:27:50PM +1000, Tobin C. Harding wrote:
> > Hi,
> > 
> > I am attempting to rewrite the ks7010 WEXT driver
> > (drivers/staging/ks7010)
> > to use the CFG80211 API.
> > 
> > I am reading 802.11 Wireless Networks - Matthew S. Gast for
> > reference.
> > 
> > I have some confusion regarding WEP/WPA/WPA2/RSN, ciphers, keys and
> > ie's?
> > 
> > As I understand, first there was WEP. Next we got a marketing term
> > WPA
> > which referred to 802.11i (which specified the protocols TKIP and
> > CCMP, and also RSN).
> > 
> > WEP vs WPA
> > ----------
> > 
> > To add to my confusion the ks7010 code seemingly mixes up the use
> > of
> > WEP keys and WPA keys, to set both the WEP and the WPA keys the
> > driver
> > uses the same MIB requests? Yet throughout the code WEP keys and
> > WPA
> > keys are stored in separate structures (and treated differently).
> 
> Oh, I just got why there is only one MIB request type - there are
> only
> one set of keys used by the target
> 
> 	DOT11_WEP_DEFAULT_KEY_VALUE1	= 0x13020101,
> 	DOT11_WEP_DEFAULT_KEY_VALUE2	= 0x13020102,
> 	DOT11_WEP_DEFAULT_KEY_VALUE3	= 0x13020103,
> 	DOT11_WEP_DEFAULT_KEY_VALUE4	= 0x13020104,
> 
> removing 'WEP' from the defines removes the confusion here :)

I could be entirely wrong, but it looks like the driver really just
defines 4 "keys" which can be used for anything.

For WEP, they are the 4 WEP key indexes.

For RSN, they are 1 = PMK, 2 = GMK, 3 = GMK2, 4 seems unused.

Because WEXT is pretty convoluted, I woudn't necessarily try to
translate what eg ks_wlan_set_encode_ext() is doing directly to
cfg80211, but to understand how the firmware interface works and then
just write the cfg80211 code to the firmware interface.

Basically, you have the following modes:

a) open, no encryption
b) WEP encryption (4 possible WEP keys, each either 40 or 104 bits)
c) WPA/RSN (PMK and GMK are computed by wpa_supplicant and supplied to
you, just need to send to firmware)

most of the stuff about IW_ENCODE_ALG_* is useless for cfg80211, you
just take the values that you get from userspace (eg, wpa_supplicant)
for the key and the type of key and just tell the firmware to use
those.

The driver also has odd stuff like SME_WEP_FLAG_REQUEST that really
just maps to DOT11_PRIVACY_INVOKED, so that's going to be a bit
confusing for you too since that's used not just for WEP but also for
WPA/RSN.

So anyway, it's going to be an interesting ride for you, but I think
you'll be pleasantly surprised at how much awful code you can actually
remove.

And to answer Johannes, this firmware looks much more fullmac than
softmac; BSS selection seems left up to the firmware.  You just send it
a "connect with these parameters" command (HIF_INFRA_SET_REQ) including
channels, SSID, BSSID, mode, etc and it does everything.

So Tobin, I think that means this driver should probably implement the
"connect" call like fullmac drivers do.  One existing example of that
is the 'brcmfmac' driver, eg brcmf_cfg80211_connect().

Dan

> > If WPA is enabled are not WEP keys superfluous?
> > 
> > WPA vs WPA2
> > -----------
> > 
> > Were WPA version 1 and WPA version 2 marketing terms or do they
> > differ?
> > 
> > ieee80211.h does not seem to mention WPA2 (and cfg80211.h mentions
> > it
> > once only in some comments) however, from cfg80211.h;
> > 
> >  * struct cfg80211_crypto_settings - Crypto settings
> >  * @wpa_versions: indicates which, if any, WPA versions are enabled
> >  *	(from enum nl80211_wpa_versions)
> > 
> > When using the CFG80211 API we do not need to worry about the
> > WPA/WPA2
> > distinction? Can I drop all the WPA version 1 code from the driver?
> > 
> > A little more information:
> > 
> > The WEXT driver defines ciphers, from looking at ieee80211.h it
> > seems
> > that it uses WLAN_CIPHER_SUITE_XXX for WPA2 and for WPA it uses
> > 
> > #define CIPHER_ID_WPA_NONE    "\x00\x50\xf2\x00"
> > #define CIPHER_ID_WPA_WEP40   "\x00\x50\xf2\x01"
> > #define CIPHER_ID_WPA_TKIP    "\x00\x50\xf2\x02"
> > #define CIPHER_ID_WPA_CCMP    "\x00\x50\xf2\x04"
> > #define CIPHER_ID_WPA_WEP104  "\x00\x50\xf2\x05"
> > 
> > FYI ieee80211.h has
> > 
> > #define WLAN_OUI_MICROSOFT	       0x0050f2
> > 
> > Thanks for taking the time to read this mail, any suggestions most
> > appreciated.
> > 
> > thanks,
> > Tobin.
