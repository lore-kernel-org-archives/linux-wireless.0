Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33677 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab0G1VaZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 17:30:25 -0400
Message-ID: <4C50A170.1070902@openwrt.org>
Date: Wed, 28 Jul 2010 23:30:24 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Jouni Malinen <Jouni.Malinen@atheros.com>
Subject: Re: [PATCH 2/3] ath9k_hw: clean up per-channel calibration data
References: <1280339151-37084-1-git-send-email-nbd@openwrt.org> 	<1280339151-37084-2-git-send-email-nbd@openwrt.org> <AANLkTi=8UX5B9+nLymSdJS2J-gRwMsYT_SVnviHX9Zi3@mail.gmail.com> 	<4C509CE1.90503@openwrt.org> <AANLkTi==nB+Wqe3KcmDf6P=JUYnLzc2PeAuOZQE3v9bn@mail.gmail.com>
In-Reply-To: <AANLkTi==nB+Wqe3KcmDf6P=JUYnLzc2PeAuOZQE3v9bn@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-28 11:21 PM, Luis R. Rodriguez wrote:
> On Wed, Jul 28, 2010 at 2:10 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2010-07-28 10:52 PM, Luis R. Rodriguez wrote:
>>> On Wed, Jul 28, 2010 at 10:45 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>> The noise floor history buffer is currently not kept per channel, which
>>>> can lead to problems when changing channels from a clean channel to a
>>>> noisy one. Also when switching from HT20 to HT40, the noise floor
>>>> history buffer is full of measurements, but none of them contain data
>>>> for the extension channel, which it needs quite a bit of time to recover
>>>> from.
>>>>
>>>> This patch puts all the per-channel calibration data into a single data
>>>> structure, and gives the the driver control over whether that is used
>>>> per-channel or even not used for some channels.
>>>>
>>>> For ath9k_htc, I decided to keep this per-channel in order to avoid
>>>> creating regressions.
>>>>
>>>> For ath9k, the data is kept only for the operating channel, which saves
>>>> some space. ath9k_hw takes care of wiping old data when the operating
>>>> channel or its channel flags change.
>>>>
>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>
>>> But this also means every time we want to get operational on a channel
>>> we have to learn the current noise all over again. This means for WiFi
>>> Direct every channel swap we'd have to learn to walk, which happens
>>> quite often. What do you think? Sorry, I know we discussed this
>>> approach and I seemed fine but this just occurred to me now, and will
>>> become really important later when we support WiFi Direct.
>> When we get to implementing per-vif channel settings with switching
>> being done in mac80211, we can just move the calibration data to ath9k's
>> virtual interface data and thus keep the calibration for multiple
>> operating channels.
> 
> Sounds good. This would currently break the ath9k virtual wiphy's
> calibration stuff :P (not like I care), Jouni?
My current patch should work just fine with virtual wiphy's, since I
store the calibration data in the ath_wiphy struct.

- Felix
