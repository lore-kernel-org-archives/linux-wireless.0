Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48905 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S968872AbdEXKNP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 06:13:15 -0400
Date: Wed, 24 May 2017 20:13:09 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WPA and WPA2
Message-ID: <20170524101309.GA2319@eros> (sfid-20170524_121510_563119_1116637C)
References: <20170524072750.GI8158@eros>
 <1495611651.2665.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1495611651.2665.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 24, 2017 at 09:40:51AM +0200, Johannes Berg wrote:
> On Wed, 2017-05-24 at 17:27 +1000, Tobin C. Harding wrote:
> 
> > I am attempting to rewrite the ks7010 WEXT driver
> > (drivers/staging/ks7010) to use the CFG80211 API.
> 
> Heh, I wasn't even aware of this driver yet.

Thanks for replying. It came into staging a couple of months
ago.

> > As I understand, first there was WEP. 
> 
> Correct.
> 
> > Next we got a marketing term WPA which referred to 802.11i (which
> > specified the protocols TKIP and CCMP, and also RSN).
> 
> No, technically WPA referred to a *draft* version of 802.11i, and
> used (only?) TKIP - where WPA2 is equivalent to RSN, the published
> version of 802.11i (now long rolled into the spec, of course), but
> WPA2 also preferred CCMP and only used TKIP for compatibility, IIRC.

Oh nice, thanks for the clarification.

> > WEP vs WPA
> > ----------
> > 
> > To add to my confusion the ks7010 code seemingly mixes up the use of
> > WEP keys and WPA keys, to set both the WEP and the WPA keys the
> > driver uses the same MIB requests? Yet throughout the code WEP keys
> > and WPA keys are stored in separate structures (and treated
> > differently).
> > 
> > If WPA is enabled are not WEP keys superfluous?
> 
> Well, you can't really have both at the same time, but you can (and
> probably should) support both.
> 
> > WPA vs WPA2
> > -----------
> > 
> > Were WPA version 1 and WPA version 2 marketing terms or do they
> > differ?
> 
> See above. But at the level you're looking at, it's probably not really
> all that relevant. To some extent, WPA1 is TKIP and WPA2 is CCMP, but
> you don't really care since you just get keys with a cipher suite
> identifier attached to them.

For this driver I think it matters. It is not a soft MAC driver, but
it is not a Full MAC either. The firmware was released in 2009, I
don't imagine it is getting any updates. The WEXT driver adds/checks
the TKIP Michael MIC in software.

Perhaps for the initial cfg80211 implementation we could simply
support RSN only (i.e either WPA2 or no security)?

> > ieee80211.h does not seem to mention WPA2 (and cfg80211.h mentions it
> > once only in some comments) however, from cfg80211.h;
> > 
> >  * struct cfg80211_crypto_settings - Crypto settings
> >  * @wpa_versions: indicates which, if any, WPA versions are enabled
> >  *	(from enum nl80211_wpa_versions)
> > 
> > When using the CFG80211 API we do not need to worry about the
> > WPA/WPA2 distinction? 
> 
> This is only relevant for full-MAC devices, I think it's mostly used
> for selecting the BSS?
> 
> > Can I drop all the WPA version 1 code from the driver?
> > 
> > A little more information:
> > 
> > The WEXT driver defines ciphers, from looking at ieee80211.h it seems
> > that it uses WLAN_CIPHER_SUITE_XXX for WPA2 and for WPA it uses
> > 
> > #define CIPHER_ID_WPA_NONE    "\x00\x50\xf2\x00"
> > #define CIPHER_ID_WPA_WEP40   "\x00\x50\xf2\x01"
> > #define CIPHER_ID_WPA_TKIP    "\x00\x50\xf2\x02"
> > #define CIPHER_ID_WPA_CCMP    "\x00\x50\xf2\x04"
> > #define CIPHER_ID_WPA_WEP104  "\x00\x50\xf2\x05"
> 
> That's ... strange. The standard identifiers are
> 
> WLAN_CIPHER_SUITE_*, which are 00-0F-AC:n (with the same values for n
> as above).
> 
> If the firmware wants them with MS OUI, then you'd probably have to
> translate them.
> 
> 
> 
> All this wext code there looks really strange though.
> 
> Does this driver actually work with standard wpa_supplicant?

I'm not sure, I got hardware in the mail a couple of days ago but have
not tested it yet. The current driver may be broken thanks to my
refactoring efforts of late. I believe it was tested and functional
when it was first brought into staging. I do not know to what depth it
was tested.

> johannes

Thanks Johannes,
Tobin.
