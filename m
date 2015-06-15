Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34631 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbFOLiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 07:38:16 -0400
Received: by wicnd19 with SMTP id nd19so21733903wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 04:38:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21886.43539.833126.629494@gargle.gargle.HOWL>
References: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>
	<21886.43539.833126.629494@gargle.gargle.HOWL>
Date: Mon, 15 Jun 2015 13:38:14 +0200
Message-ID: <CALhHN=pUKuXAEb3JEEVTHATEHhvoLe52QDh-pixiS9oUo=6j6Q@mail.gmail.com> (sfid-20150615_133821_432095_50B5B5CD)
Subject: Re: [RFC] ath9k: advertise p2p dev support when chanctx
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 June 2015 at 12:33, Sujith Manoharan <sujith@msujith.org> wrote:
> Janusz Dziedzic wrote:
>> Add p2p dev support when ath9k loaded with
>> use_chanctx=1. This will fix problem, when first
>> interface is an AP and next we would like to run
>> p2p_find. Before p2p scan failed.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>> @Felix, Sujith please review. I am not sure if didn't miss some
>> case for NL80211_IFTYPE_P2P_DEVICE (special handling required?).
>
> At least the callbacks for adding/removing interfaces need
> to be handled ?
>
Strange, but I didn't hit any problem yet with my simple patch.

> But, can you describe the sequence of commands used that
> resulted in this issue ?
>
1. load ath9k with use_chanctx=1
2. run wpa_supplicant using wlan0
3. connect wlan0 to AP
4. when we are connected, run p2p_find form wpa_cli
5. scan will failed with Operation not supported (even I will
force-ap-scan, while chanctx version using hw_scan callback ...)
6. p2p_find will fail

BR
Janusz
