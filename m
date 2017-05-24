Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38449 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757877AbdEXHfD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 03:35:03 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E526B20B0A
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 03:35:02 -0400 (EDT)
Received: from localhost (124-169-117-216.dyn.iinet.net.au [124.169.117.216])
        by mail.messagingengine.com (Postfix) with ESMTPA id 330AF2478C
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 03:35:01 -0400 (EDT)
Date: Wed, 24 May 2017 17:34:59 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: linux-wireless@vger.kernel.org
Subject: Re: WPA and WPA2
Message-ID: <20170524073459.GJ8158@eros> (sfid-20170524_093516_255266_45BAFBC3)
References: <20170524072750.GI8158@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170524072750.GI8158@eros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 24, 2017 at 05:27:50PM +1000, Tobin C. Harding wrote:
> Hi,
> 
> I am attempting to rewrite the ks7010 WEXT driver (drivers/staging/ks7010)
> to use the CFG80211 API.
> 
> I am reading 802.11 Wireless Networks - Matthew S. Gast for reference.
> 
> I have some confusion regarding WEP/WPA/WPA2/RSN, ciphers, keys and
> ie's?
> 
> As I understand, first there was WEP. Next we got a marketing term WPA
> which referred to 802.11i (which specified the protocols TKIP and
> CCMP, and also RSN).
> 
> WEP vs WPA
> ----------
> 
> To add to my confusion the ks7010 code seemingly mixes up the use of
> WEP keys and WPA keys, to set both the WEP and the WPA keys the driver
> uses the same MIB requests? Yet throughout the code WEP keys and WPA
> keys are stored in separate structures (and treated differently).

Oh, I just got why there is only one MIB request type - there are only
one set of keys used by the target

	DOT11_WEP_DEFAULT_KEY_VALUE1	= 0x13020101,
	DOT11_WEP_DEFAULT_KEY_VALUE2	= 0x13020102,
	DOT11_WEP_DEFAULT_KEY_VALUE3	= 0x13020103,
	DOT11_WEP_DEFAULT_KEY_VALUE4	= 0x13020104,

removing 'WEP' from the defines removes the confusion here :)

> If WPA is enabled are not WEP keys superfluous?
> 
> WPA vs WPA2
> -----------
> 
> Were WPA version 1 and WPA version 2 marketing terms or do they differ?
> 
> ieee80211.h does not seem to mention WPA2 (and cfg80211.h mentions it
> once only in some comments) however, from cfg80211.h;
> 
>  * struct cfg80211_crypto_settings - Crypto settings
>  * @wpa_versions: indicates which, if any, WPA versions are enabled
>  *	(from enum nl80211_wpa_versions)
> 
> When using the CFG80211 API we do not need to worry about the WPA/WPA2
> distinction? Can I drop all the WPA version 1 code from the driver?
> 
> A little more information:
> 
> The WEXT driver defines ciphers, from looking at ieee80211.h it seems
> that it uses WLAN_CIPHER_SUITE_XXX for WPA2 and for WPA it uses
> 
> #define CIPHER_ID_WPA_NONE    "\x00\x50\xf2\x00"
> #define CIPHER_ID_WPA_WEP40   "\x00\x50\xf2\x01"
> #define CIPHER_ID_WPA_TKIP    "\x00\x50\xf2\x02"
> #define CIPHER_ID_WPA_CCMP    "\x00\x50\xf2\x04"
> #define CIPHER_ID_WPA_WEP104  "\x00\x50\xf2\x05"
> 
> FYI ieee80211.h has
> 
> #define WLAN_OUI_MICROSOFT	       0x0050f2
> 
> Thanks for taking the time to read this mail, any suggestions most
> appreciated.
> 
> thanks,
> Tobin.
