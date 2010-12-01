Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33660 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0LAX0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 18:26:04 -0500
Received: by qwb7 with SMTP id 7so7667223qwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 15:26:03 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTinUFXCEAXcp6d=riFMtgq4Y-Na6_NJaRiymTOmB@mail.gmail.com>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
	<AANLkTinUFXCEAXcp6d=riFMtgq4Y-Na6_NJaRiymTOmB@mail.gmail.com>
Date: Thu, 2 Dec 2010 00:26:02 +0100
Message-ID: <AANLkTikEanGpBGCMn6M9FQ=QRWU9=qGjQ1XE2kkGAXHV@mail.gmail.com>
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 11:05 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2010/12/1 Sedat Dilek <sedat.dilek@googlemail.com>:
>> Hi,
>>
>> I have built today a linux-next (next-20101201) kernel which includes
>> wireless-next-2.6 up to master-2010-11-30.
>>
>> From tig utility:
>> 2010-11-30 15:33 Stanislaw Gruszka  [wireless-next-2.6] iwlagn: fix
>> microcode error on 4965
>> [main] 61790c5f3c5f158821821a00797d94504531839f - commit 1929 of 226338 (0%)
>>
>> Unfortunately, my wlan network connection is totally unstable.
>>
>> $ dmesg | grep "RX AssocResp" | wc -l
>> 216
>>
>> The block looks like this:
>> [ 4436.504059] ieee80211 phy0: wlan0: No probe response from AP
>> 00:04:0e:e4:00:3d after 500ms, disconnecting.
>> [ 4436.504490] cfg80211: Calling CRDA to update world regulatory domain
>> [ 4440.677020] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
>> [ 4440.679096] wlan0: authenticated
>> [ 4440.679158] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
>> [ 4440.684667] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
>> status=0 aid=1)
>> [ 4440.684673] wlan0: associated
>>
>> My wlan device is an ath5k:
>>
>> $ lspci -nnvv | grep "Ethernet controller" | grep -i ath
>> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
>> 802.11abg NIC [168c:1014] (rev 01)
>>
>> Any idea what's wrong? (Just speculating on the last patch-set from Nick...)
>> How can I help to dig into this problem?
>> Debug-session with wpasupplicant? Which kernel-parameters (debug) to
>> be considered/set?
>>
>> Kind Regards,
>> - Sedat -
>>
>
> That's weird I tested all patches for connectivity + iperf, maybe
> something else also went on the tree that results such behavior...
>
> 1) Are you using NetworkManager ? If so disable it and connect manually.
> 2) Can you disable encryption on your AP and see if it works without it ?
> 3) Try and enable/disable hw encryption with nohwcrypt module parameter.
> 4) What's your signal strength/rate when you connect to the AP ?
>
> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
>

Tested my usual ath5k setup also with a self-debianized wpasupplicant
0.7.3 (build against libnl-2.0):

# dpkg -l | grep wpa | cut -c-80
ii  wpagui                                          0.7.3-1~dileks.1
ii  wpasupplicant                                   0.7.3-1~dileks.1

Same error-messages:

Dec  2 00:24:53 tbox kernel: [10319.504083] ieee80211 phy0: wlan0: No
probe response from AP 00:04:0e:e4:00:3d after 500ms, disconnecting.
Dec  2 00:24:53 tbox kernel: [10319.504946] cfg80211: Calling CRDA to
update world regulatory domain
Dec  2 00:24:58 tbox wpa_supplicant[6955]: Trying to associate with
00:04:0e:e4:00:3d (SSID='myCastle-WLAN WPA (Wireless LAN)' freq=2442
MHz)
Dec  2 00:24:58 tbox kernel: [10323.677183] wlan0: authenticate with
00:04:0e:e4:00:3d (try 1)
Dec  2 00:24:58 tbox kernel: [10323.680850] wlan0: authenticated
Dec  2 00:24:58 tbox kernel: [10323.680907] wlan0: associate with
00:04:0e:e4:00:3d (try 1)
Dec  2 00:24:58 tbox kernel: [10323.687204] wlan0: RX AssocResp from
00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
Dec  2 00:24:58 tbox kernel: [10323.687215] wlan0: associated
Dec  2 00:24:58 tbox wpa_supplicant[6955]: Associated with 00:04:0e:e4:00:3d
Dec  2 00:24:58 tbox wpa_supplicant[6955]: WPA: Key negotiation
completed with 00:04:0e:e4:00:3d [PTK=CCMP GTK=TKIP]
Dec  2 00:24:58 tbox wpa_supplicant[6955]: CTRL-EVENT-CONNECTED -
Connection to 00:04:0e:e4:00:3d completed (reauth) [id=0 id_str=]

- Sedat -
