Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54331 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaL3LAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 06:00:42 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so25331198wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2014 03:00:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A27BEE.4020603@rempel-privat.de>
References: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<549FFB8F.9010701@rempel-privat.de>
	<CAA2SeNKxDk+sgpP9be=8MUgVOBHO26=oA4r4v+wRHfN1b6fH8w@mail.gmail.com>
	<54A15896.2020008@rempel-privat.de>
	<CAA2SeNKM34-DWGFw5ahKVt2N=yr97OK6zCcf=FNRU5jrDJc6gQ@mail.gmail.com>
	<54A27BEE.4020603@rempel-privat.de>
Date: Tue, 30 Dec 2014 12:00:41 +0100
Message-ID: <CAA2SeNKw_QBaGbEutOscaepiq-Uu7x9Gu1duAkrUdZ7AW2q5dg@mail.gmail.com> (sfid-20141230_120045_819682_BCDEF533)
Subject: Re: [RFC 0/3] add TPC capability for AR9002 based chips
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Am 29.12.2014 um 15:18 schrieb Lorenzo Bianconi:
>>> Am 28.12.2014 um 15:32 schrieb Lorenzo Bianconi:
>>>>> Hi, can you please describe some testcases for you patches.
>>>>>
>>>>
>>>> This patchset adds Transmission Power Control (TPC) for AR9002 based
>>>> chips. IOW it enables the capability of correct TX power on per-packet
>>>> basis. It is preparatory for upcoming Thomas's joint rate and power
>>>> control
>>>>  algorithm.
>>>
>>> Do you mean, right now there is no way to test your patches?
>>>
>>
>> I have just added TPC support to ath9k. In order to exploit that hw
>> feature we have to wait Thomas's algorithm :).
>> However in order to test patches you can set tx_power field of
>> ath_frame_info data structure in setup_frame_info() to a different
>> value (for the moment it is set to MAX_RATE_POWER) and measure the RX
>> power on the other end of the link (this is what I did).
>
> Ok, thank you.
> We will talk with Adrian how to mesure it at home.
>

You can get a raw measure of received signal strenght from radiotap
header of sniffed frames on RX side.

Regards,
Lorenzo

>>
>> Regards,
>> Lorenzo
>>
>>>
>>>> Regards,
>>>> Lorenzo
>>>>
>>>>> Am 27.12.2014 um 15:12 schrieb Lorenzo Bianconi:
>>>>>> This patchset adds TPC capability to ath9k for AR9002 based chips
>>>>>>
>>>>>> *[RFC 1/3]: add TX power per-rate tables to cap TX power in TX descriptor path
>>>>>> *[RFC 2/3]: cap per-packet TX power according to TX power per-rate tables
>>>>>> *[RFC 3/3]: enable per-packet TPC on AR9002 based chips by default
>>>>>>
>>>>>> This pachset is based on Adrian Chadd's hints
>>>>>> (https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html)
>>>>>>
>>>>>> Lorenzo Bianconi (3):
>>>>>>   ath9k: add power per-rate tables for AR9002 chips
>>>>>>   ath9k: add TPC to TX path for AR9002 based chips
>>>>>>   ath9k: enable per-packet TPC on AR9002 based chips
>>>>>>
>>>>>>  drivers/net/wireless/ath/ath9k/ar5008_phy.c  | 80 ++++++++++++++++++++++++++++
>>>>>>  drivers/net/wireless/ath/ath9k/debug.c       |  5 --
>>>>>>  drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 14 +++++
>>>>>>  drivers/net/wireless/ath/ath9k/eeprom_9287.c | 15 ++++++
>>>>>>  drivers/net/wireless/ath/ath9k/eeprom_def.c  | 14 +++++
>>>>>>  drivers/net/wireless/ath/ath9k/hw.c          |  3 +-
>>>>>>  drivers/net/wireless/ath/ath9k/hw.h          |  2 +
>>>>>>  drivers/net/wireless/ath/ath9k/xmit.c        | 66 +++++++++++++++++++----
>>>>>>  8 files changed, 181 insertions(+), 18 deletions(-)
>>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Regards,
>>>>> Oleksij
>>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>> --
>>> Regards,
>>> Oleksij
>>>
>>
>>
>>
>
>
> --
> Regards,
> Oleksij
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
