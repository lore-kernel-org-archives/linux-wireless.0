Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45686 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab3D1TVA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 15:21:00 -0400
Message-ID: <517D769A.80205@openwrt.org> (sfid-20130428_212104_311382_906CC7B6)
Date: Sun, 28 Apr 2013 21:20:58 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <517D1B45.9020302@openwrt.org> <517D2E77.8000104@rempel-privat.de> <517D3A5F.6020205@rempel-privat.de> <517D7626.6030109@rempel-privat.de>
In-Reply-To: <517D7626.6030109@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-28 9:19 PM, Oleksij Rempel wrote:
> Am 28.04.2013 17:03, schrieb Oleksij Rempel:
>> Am 28.04.2013 16:13, schrieb Oleksij Rempel:
>>> Am 28.04.2013 14:51, schrieb Felix Fietkau:
>>>> On 2013-04-27 5:25 PM, Oleksij Rempel wrote:
>>>>> Collect statistics about recived duplicate and STBC packets.
>>>>> This information should help see if STBC is actually working.
>>>>>
>>>>> Tested on ar9285;
>>>>>
>>>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>>>> I thought about this patch some more, and I'm wondering what's the point
>>>> in doing this? These statistics are going to be completely useless for
>>>> most people and they'll waste some memory/cpu cycles, especially on
>>>> small-cache devices. I think it's much more useful to simply pass the
>>>> information to mac80211 via rx flags and get them added to the radiotap
>>>> header.
>>>
>>> Sure.
> 
> Now i need some help.
> Why there is no traces of  radiotap in ath9k. Some other drivers have 
> them? Do it communicate in some different way or there is just no 
> radiotap support in ath9k?
radiotap is generated in mac80211, so there's no need for the driver to
do it.

- Felix

