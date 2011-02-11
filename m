Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58423 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1BKLEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 06:04:00 -0500
Received: by qyj19 with SMTP id 19so3210935qyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Feb 2011 03:03:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110114182345.GB11920@vmraj-lnx.users.atheros.com>
References: <loom.20110113T233025-142@post.gmane.org>
	<20110114182345.GB11920@vmraj-lnx.users.atheros.com>
Date: Fri, 11 Feb 2011 12:03:59 +0100
Message-ID: <AANLkTik7gXdwK-qHUhJ35Y+6jSjJec+WA=3NEdCQQLZv@mail.gmail.com>
Subject: Re: ath9k - cannot reconnect few meters from the antenna
From: Tomek <dot@poczta.fm>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok,
I think I know what is happening.
If there are no stations connected the AP wireless card goes in some
kind of low power mode - I think low transmission power
If I am trying to connect if I am close enough the client associates
but the power indicator shows the signal is weak. I After a few
second(5-6 seconds) I can see that the transmission power is increased
and then I could go further from AP and connection stays stable, if I
go away before the transmission power grows the wireless connection
goes down
If I am too far It seems that the windows client terminates connection
before the AP raises the transmission power.
Any idea - anything that could help me ?
Regards
Tomasz

2011/1/14 Rajkumar Manoharan <rmanoharan@atheros.com>:
> On Fri, Jan 14, 2011 at 04:16:37AM +0530, Tomasz wrote:
>> Hi All
>> I've spend a lot of time on this issue and I cannot fix it, thus I am asking for
>> help
>> It looks like that:
>>
>> I am running wireless access point based on:
>> Ubuntu 10.04  vmlinuz-2.6.32-27-generic
>> compat-wireless-2010-12-26
>> hostapd 0.7.3 (wpa/wpa2)
>> Dnsmasq version 2.52
>> Zotac Ion board
>> Minipcie card: ieee80211 phy0: Atheros AR9285 Rev:2
>> ath9k driver
>> Single antenna (but the behaviour with two antenna is similar)
>>
>> Everything works perfectly fine when I am within the few meters from the antenna.
>> So the clients are connecting and I get 25 mbps data rates.
>> But if more then 10 meters from the antenna strange things are happening.
>> - If I am connected to the network and will walk away everything works perfect.
>> - But if i disconnect (disassociate) when I am away I cannot connect back. -
>> this also means I cannot connect when turning the notebook on :)
>> - if I go closer to antenna I am able to connect and while walking away the
>> connection seems perfectly stable ...
> Hi Tomasz,
>
> Do you have any interference with the oper channel? Please enable debug option
> CONFIG_ATH_DEBUG=y in config.mk and modprobe ath9k debug=0x701 and
> post dmesg/kern.log
>
> --
> Rajkumar
>
