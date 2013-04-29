Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:43305 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab3D2GrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 02:47:06 -0400
Message-ID: <517E16FC.2020501@neratec.com> (sfid-20130429_084712_512870_827EC2EA)
Date: Mon, 29 Apr 2013 08:45:16 +0200
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <517D1B45.9020302@openwrt.org> <517D2E77.8000104@rempel-privat.de> <517D3A5F.6020205@rempel-privat.de>
In-Reply-To: <517D3A5F.6020205@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/2013 05:03 PM, Oleksij Rempel wrote:
> Am 28.04.2013 16:13, schrieb Oleksij Rempel:
>> Am 28.04.2013 14:51, schrieb Felix Fietkau:
>>> On 2013-04-27 5:25 PM, Oleksij Rempel wrote:
>>>> Collect statistics about recived duplicate and STBC packets.
>>>> This information should help see if STBC is actually working.
>>>>
>>>> Tested on ar9285;
>>>>
>>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>>> I thought about this patch some more, and I'm wondering what's the 
>>> point
>>> in doing this? These statistics are going to be completely useless for
>>> most people and they'll waste some memory/cpu cycles, especially on
>>> small-cache devices. I think it's much more useful to simply pass the
>>> information to mac80211 via rx flags and get them added to the radiotap
>>> header.
>>
>> Sure.
>>
>
> I see Wojciech Dubowik sanded some patches, for at least one year, to 
> make exactly what Felix suggested. Are there any reason why this 
> patches was not accepted?
> Wojciech if you alive and have some time, can you update them?
Sure. I will try to update them based on suggested radiotap field 
structure for STBC and Ness.

On the other hand as Felix already mentioned it's yet another line of 
code one needs once in a lifetime.
If one is checking whether stbc is working the easiest way is to create 
own debugging namespace
in radiotap and dump all descriptor registers there. It probably doesn't 
go mainline but you could apply
the patches when you need and they mostly rebase cleanly. At least 
that's what I do.

Wojtek
