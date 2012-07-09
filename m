Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46782 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2GITnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 15:43:41 -0400
Message-ID: <4FFB3469.4000003@openwrt.org> (sfid-20120709_214345_566532_6D8A2B5B)
Date: Mon, 09 Jul 2012 21:43:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: thomas@net.t-labs.tu-berlin.de, x-alina@gmx.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add transmit power control support (TPC)
References: <4FFB2E78.9090402@gmail.com>
In-Reply-To: <4FFB2E78.9090402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-09 9:18 PM, Xose Vazquez Perez wrote:
> Thomas Huehn wrote:
> 
>> (6) restructure tx-path of all effected drivers
>> Restructure tx-path of all effected drivers to respect new TPC support in
>> mac80211. TPC support is added to mac80211 by restructuring of struct
>> ieee80211_tx_info. Therfore the tx-path of all effected drivers is modified
>> to receive struct sta from the stack and respect the new ieee80211_tx_info
>> struct. List of modified driver:
> 
>> ath9k
>> ath5k
>> iwl3954
>> iwl4965
>> iwl-agn
>> mwl8k
>> carl9170
>> ath9k-htc
>> p54
>> rt2x00
>> rtl8180
>> rtl8087
>> hwsim
>> b43
>> b43legacy
>> brcmsmac
>> zd1211rw
> 
> candidates:
> 
> ath6kl
> brcmfmac
> iwmc3200wifi
> mwifiex
> rndis_wlan
No. (fullmac, thus unaffected by the change)

> libertas_tf
> rtlwifi
> wl1251
> wl12xx
Yes, those indeed look like they need to be added.

- Felix
