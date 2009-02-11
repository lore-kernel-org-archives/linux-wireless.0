Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:47395
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZBKWen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 17:34:43 -0500
Message-ID: <4993527D.9070700@erley.org> (sfid-20090211_233445_363569_131F63EB)
Date: Wed, 11 Feb 2009 17:34:37 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Bob Copeland <bcopeland@gmail.com>
CC: =?ISO-8859-1?Q?Norman_Rie=DF?= <norman@smash-net.org>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
References: <49931D52.90904@smash-net.org> <b6c5339f0902111304u430bce4dl3304f171ae8fbd45@mail.gmail.com>
In-Reply-To: <b6c5339f0902111304u430bce4dl3304f171ae8fbd45@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Wed, Feb 11, 2009 at 1:47 PM, Norman Rie=DF <norman@smash-net.org>=
 wrote:
>> Hello,
>>
>> i pulled wireless-testing kernel today and installed hostapd-0.6.7, =
 but
>> it still does not work.
>>
>>
>> iwconfig wlan0 mode master
>> Error for wireless request "Set Mode" (8B06) :
>>    SET failed on device wlan0 ; Invalid argument.
>=20
> Did you apply this patch from upthread?
>=20

I can confirm Norman's wireless card's behavior (and have an associate =
with
the same problem).  This is with the upthread patch applied to compat-w=
ireless
pulled from git.

ath5k 0000:0a:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath5k 0000:0a:05.0: registered as 'phy5'
phy5: Selected rate control algorithm 'pid'
ath5k phy5: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy5: RF5112B multiband radio found (0x36)

If I remove the entry from hostapd.conf to set the channel, and force a=
 channel
with iwconfig, hostapd will start, but nothing can associate, and netst=
umbler
on an XP machine with an atheros card in it does not detect the SSID as=
 being=20
an access point.

Pat Erley


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
