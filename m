Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56812 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898Ab3LIOaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 09:30:10 -0500
Received: by mail-ie0-f170.google.com with SMTP id qd12so6225731ieb.29
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 06:30:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A5CDA5.7000601@rempel-privat.de>
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
	<52A5CDA5.7000601@rempel-privat.de>
Date: Mon, 9 Dec 2013 15:30:09 +0100
Message-ID: <CANq1E4RorA7J3WKv1iV2oxi2gZ5wN157Fk1yahEuALyGATqEqg@mail.gmail.com> (sfid-20131209_153017_106251_FF86B050)
Subject: Re: [BUG] P2P setup timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Dec 9, 2013 at 3:03 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 06.12.2013 11:18, schrieb David Herrmann:
>> Hi
>>
>> I am currently working on user-space helpers for P2P setup as part of
>> an Open-Source Miracast implementation (openwfd). I can set up a
>> P2P-group with my Android test-device just fine, however, it only
>> works if initiated by the GNU/Linux host. Once I initiate the
>> p2p-connect from the Android device, it creates a group and sends me a
>> p2p-invitation which I am unable to accept.
>>
>> I am running wpa_supplicant-git from today (but also tried older
>> versions), ath9k-htc from linus-git (3.13-rc2) and the relevant log
>> files are appended.
>>
>> My wpa-config is:
>>   ctrl_interface=/var/run/wpa_supplicant
>>   update_config=1
>>   p2p_go_ht40=1
>>
>> And I do nothing else than open wpa_cli and run:
>>   p2p_find
>>   p2p_connect <peer> pbc
>>
>> This works perfectly well if I don't touch the Android device before
>> issuing the p2p_connect. However, if I initiate the first connect on
>> the Android device, my linux host gets a p2p-invitation:
>>   <3>P2P-INVITATION-RECEIVED sa=12:68:3f:4e:39:f2
>> go_dev_addr=12:68:3f:4e:39:f2 bssid=12:68:3f:4e:b9:f2 unknown-network
>>
>> I tried accepting this invitation via p2p_connect, but just nothing
>> happens. I also tried any combination of arguments
>> (auth/join/persistent, pbc/pin/PIN#, playing with go_intent=), didn't
>> help..
>>
>> Looking at the wpa-log, I see a timeout firing repeatedly:
>>   P2P: GO Negotiation Request TX callback: success=1
>>   P2P: State CONNECT -> CONNECT
>>   P2P: Set timeout (state=CONNECT): 0.500000 sec
>>   P2P: Timeout (state=CONNECT)
>> Below you can see the whole sequence of wpa-messages that repeat over
>> and over again until I cancel the connection-request.
>>
>> For WFD I need to initiate the connect from the Android device,
>> otherwise their WFD stack won't recognize the connection. So if anyone
>> has hints what might be wrong here, I'd gladly try out any patches or
>> configurations.
>> I cannot test whether this happens with other drivers, too, as I
>> couldn't get my hands on a device other than ath9k-htc which supports
>> p2p on linux.
>>
>> If anyone is interested, I'll be presenting OpenWFD at FOSDEM in the
>> graphics-devroom. It would be awesome if I can get my Nexus-4 as a
>> working demo until then. Otherwise, it'll be just linux<->linux demos
>> (non-android), which is already working fine.
>
> Is it related to your "Atheros AR9280: NULL-deref during P2P setup"
> issue? Or it is not reproducible any more?

The NULL-deref happens very sporadically. I wasn't able to figure out
how to trigger it reliably. This timeout happens *all* the time. So I
think the NULL deref is not directly related. Btw., I added some debug
statements to the ath9k sources in case the NULL deref happens again.
However, I haven't seen it yet so I kinda get the feeling it's a
timing/locking issue.

Thanks
David
