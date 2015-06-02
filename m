Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61921 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbbFBMKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 08:10:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jakub =?utf-8?Q?Kici=C5=84ski?= <moorray3@wp.pl>
CC: Yanbo Li <yanbol@qca.qualcomm.com>, <dreamfly281@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: Debugfs entry to enable/disable WLAN&Blutooth Coexist feature
References: <1432840745-21725-1-git-send-email-yanbol@qca.qualcomm.com>
	<20150602113901.2da3542d@north>
Date: Tue, 2 Jun 2015 15:10:08 +0300
In-Reply-To: <20150602113901.2da3542d@north> ("Jakub =?utf-8?Q?Kici=C5=84s?=
 =?utf-8?Q?ki=22's?= message of
	"Tue, 2 Jun 2015 11:39:01 +0200")
Message-ID: <87bngyux9b.fsf@kamboji.qca.qualcomm.com> (sfid-20150602_141025_822541_12E37088)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kiciński <moorray3@wp.pl> writes:

> On Thu, 28 May 2015 12:19:05 -0700, Yanbo Li wrote:
>> As some radio have no connection with BT modules, enable the WLAN/Bluetooth
>> coexist(BTC) feature will has some side effect if the radio's GPIO connect
>> with any other HW modules. Add the control switcher "btc_feature" at
>> debugfs and set the feature as disable by default to avoid such case.
>>
>> To enable this feature, execute:
>> echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
>> To disable:
>> echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
>> 
>> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
>
> IMHO common API for disabling/enabling btcoex is something we would all
> benefit from and easy enough to implement properly.  Burying it in
> driver-specific debugfs is less than appropriate.
>
> I seem to recall there were plans to discuss btcoex at one of the
> linux-wireless summits.  If the consensus was to leave it in debugfs
> then I apologize for the noise ;)

I agree. I don't recall anymore the discussion in the summit but I think
that adding btcoex support to nl80211 would be the right thing to do.
It's a common setting for many drivers. But before we have that, ath10k
still has to use debugfs.

-- 
Kalle Valo
