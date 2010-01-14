Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64866 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0ANSHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 13:07:38 -0500
Received: by fxm25 with SMTP id 25so327934fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 10:07:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263492165.31774.13.camel@localhost.localdomain>
References: <1263494975.4643.15.camel@eclipse> <1263492165.31774.13.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Jan 2010 10:07:15 -0800
Message-ID: <43e72e891001141007r3ab8d8dbm581df88a4953dc05@mail.gmail.com>
Subject: Re: ath9k/AR9285 - incompatibility with bluetooth
To: Dan Williams <dcbw@redhat.com>
Cc: =?UTF-8?Q?Alberto_Jos=C3=A9_Rodr=C3=ADguez_Rodr=C3=ADguez?=
	<ajrodriguez@blulabs.es>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/14 Dan Williams <dcbw@redhat.com>:
> On Thu, 2010-01-14 at 18:49 +0000, Alberto José Rodríguez Rodríguez
> wrote:
>> Hellow,
>>       I have a ZOTAC MAG ION and I'm having problems with wireless
>> connections
>>
>> Distribution: Ubuntu 9.10
>> Kernel version: 2.6.31-16
>> Device: 04:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
>> Problem Description:
>>     - Low signal strength
>>     - Cannot connect to wireless networks
>> Using linux-backports-modules-karmic:
>>     - Low signal strength persists
>>     - Can connect to WPA networks but signal strengh is low and unstable, also when using at the same time a Bluetooth USB dongle (continuously inquiring) the wireless connection is lost.
>>     - Cannot connect to WEP networks, although the WEP key is set correctly and the device is associated to the AP
>> Using latest linux-wireless snapshot (20100113):
>>     - Can connect to WEP networks but when I use at the same time a Bluetooth USB dongle (continuously inquiring) the speed of the wireless connection becomes very slow.
>>     - Can connect to WPA networks but when I use at the same time a Bluetooth USB dongle (continuously inquiring) the wireless connection is lost.
>
> This isn't unexpected; Bluetooth and WiFi interfere with each other
> because they both use 2.4GHz.  So don't expect great performance out of
> either BT or WiFi when you're using both at the same time.  Many
> built-in chips have BT co-existence capability, but that only works if
> both the WiFi and BT chips are built into your computer and are wired up
> to talk to each other.  External USB BT or WiFi dongles almost certainly
> will not have working coexistence support.

We have also spoke about writing some generic bluetooth coexistance by
using a frequency broker [1] and submitting for example some commands
to the bluetooth device to not operate on the channel the 802.11 is on
but this would be an enhancement and something which remains to be
implemented.

[1] http://wireless.kernel.org/en/developers/FrequencyBroker

  Luis
