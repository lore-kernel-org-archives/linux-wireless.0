Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:53185 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3EQJji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 05:39:38 -0400
Message-ID: <5195F5BB.6030306@uni-dortmund.de> (sfid-20130517_113941_300169_FED7A961)
Date: Fri, 17 May 2013 11:17:47 +0200
From: Thomas Klute <thomas2.klute@uni-dortmund.de>
MIME-Version: 1.0
To: Felix Blanke <felixblanke@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: AR9227: Can't set master mode
References: <CAFTPBc+jVwNnAirFCR9ZvHKCjy_AO1ce=ZpnLs3tPZUNGe75aQ@mail.gmail.com>
In-Reply-To: <CAFTPBc+jVwNnAirFCR9ZvHKCjy_AO1ce=ZpnLs3tPZUNGe75aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 17.05.2013 10:54, schrieb Felix Blanke:
> Hi,
> 
> first: Please CC me as I'm not subscribed to the list.
> 
> I have the following wireless card: 04:02.0 Network controller:
> Atheros Communications Inc. AR9227 Wireless Network Adapter (rev 01)
> 
> I can't set it to master mode, but this card should support it:
> 
> server ~ # iwconfig wlp4s2
> wlp4s2    IEEE 802.11bgn  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=19 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
> 
> server ~ # iwconfig wlp4s2 mode Master
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlp4s2 ; Invalid argument.

You cannot set any card to master mode this way, you have to use hostapd
to set up the access point interface. The documentation at
http://wireless.kernel.org/en/users/Documentation/hostapd should help. :-)

I'd also recommend using iw instead of iwconfig, see
http://wireless.kernel.org/en/users/Documentation/iw

> My kernel config should be correct:
> 
> server linux # cat .config | grep ATH9K
> CONFIG_ATH9K_HW=y
> CONFIG_ATH9K_COMMON=y
> # CONFIG_ATH9K_BTCOEX_SUPPORT is not set
> CONFIG_ATH9K=y
> CONFIG_ATH9K_PCI=y
> # CONFIG_ATH9K_AHB is not set
> # CONFIG_ATH9K_DEBUGFS is not set
> CONFIG_ATH9K_RATE_CONTROL=y
> # CONFIG_ATH9K_HTC is not set
> 
> server linux # cat .config | grep MAC80211
> CONFIG_MAC80211=y
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> # CONFIG_MAC80211_MESH is not set
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_MESSAGE_TRACING is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> # CONFIG_MAC80211_HWSIM is not set
> 
> 
> I can scan for wireless networks and probably also connect to them
> (never tested because this is not an use case for me).
> 
> Any ideas? Thanks in advance!
> 
> Kind regards,
> Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
