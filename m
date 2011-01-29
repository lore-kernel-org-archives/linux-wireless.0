Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50219 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1A2Leg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jan 2011 06:34:36 -0500
Received: by wwi17 with SMTP id 17so1927295wwi.1
        for <linux-wireless@vger.kernel.org>; Sat, 29 Jan 2011 03:34:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D42C27A.70509@t-online.de>
References: <4D42C27A.70509@t-online.de>
Date: Sat, 29 Jan 2011 17:04:30 +0530
Message-ID: <AANLkTi=sRLjQ1gw5yb1ihVKAyp8E5B99KDKedwHTbW+=@mail.gmail.com>
Subject: Re: ath9k: scanning kills unicast
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 6:49 PM, Richard Schütz <r.schtz@t-online.de> wrote:
> When I receive data with the highest possible speed in my 802.11g network
> and simultaneously scan for available networks (NetworkManager does this all
> the time in the background) ath9k enters a strange state: unicast data
> transfer is stalled, but broadcast is still working. This state lasts for a
> while. Then it ends after deauthentication (Reason: 6) and reauthentication.
> ATH_DEBUG_FATAL logs nothing.
>
>
> $ lspci -nn|grep Atheros
> 05:00.0 Network controller [0280]: Atheros Communications Inc. AR9285
> Wireless Network Adapter (PCI-Express) [168c:002b] (rev 01)
>
> $ dmesg|grep -i ath
> ath9k 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ath9k 0000:05:00.0: setting latency timer to 64
> ath: EEPROM regdomain: 0x65
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: 00
> ath: Regpair used: 0x65
> ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
> Registered led device: ath9k-phy0::radio
> Registered led device: ath9k-phy0::assoc
> Registered led device: ath9k-phy0::tx
> Registered led device: ath9k-phy0::rx
> ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc90012260000, irq=16
>
> $ uname -r
> 2.6.37-ARCH

Yes reproducible, if you can get some useful logs(inspite of
DEBUG_FATAL) it will be highly.
At present please disable the NM and run the traffic

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
