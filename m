Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:53465 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3KOQHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 11:07:54 -0500
Received: by mail-la0-f43.google.com with SMTP id n7so2966049lam.30
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 08:07:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <528645F9.9030708@rempel-privat.de>
References: <39E4555519E9C54593B1BE31E24CB79A39B12884@nasanexd02a.na.qualcomm.com>
 <20131115134752.GQ9795@pogo> <52862D32.3010601@rempel-privat.de>
 <CAB=NE6VNZDT4JLRM=iqzkaKezXaoaXcXuyTHq62=H-axxGVNZg@mail.gmail.com>
 <52863154.50105@rempel-privat.de> <CAB=NE6U50eTLcUugBBBKz3fxa8yYcm+LCqgAtARzEnLpYqWg1g@mail.gmail.com>
 <528645F9.9030708@rempel-privat.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 15 Nov 2013 17:07:31 +0100
Message-ID: <CAB=NE6UHO8PO3g0kugAVddOOAEbiCBet7mLsRPfWd2yVOh56yg@mail.gmail.com> (sfid-20131115_170757_503682_5925E42E)
Subject: Re: ath9k_htc: Target is unresponsive
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "Proffit, Jerome" <jproffit@qca.qualcomm.com>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Biard, David" <dbiard@qca.qualcomm.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 5:04 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 15.11.2013 16:33, schrieb Luis R. Rodriguez:
>> On Fri, Nov 15, 2013 at 3:36 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>>> Am 15.11.2013 15:29, schrieb Luis R. Rodriguez:
>>>> On Fri, Nov 15, 2013 at 3:18 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>>>>> I do not know which backport include patch for usb interrupt transfer.
>>>>
>>>> Which patch are you referring to? The backports project releases match
>>>> the Linux kernel releases, so the backports-3.12 release is based on
>>>> linux v3.12, we can check what kernel the patch you are describing got
>>>> merged into Linux by doing:
>>>>
>>>> git describe --contains gitsum
>>>
>>> i mean:
>>>
>>> commit 2f5e3ecfc155449987d64028ff6b73f29cd1ef8b
>>> Author: Oleksij Rempel <linux@rempel-privat.de>
>>> Date:   Tue Aug 13 09:29:34 2013 +0200
>>>
>>>     ath9k_htc: do not use bulk on EP3 and EP4
>>
>> OK that is upstream commit ID 2b721118b7
>>
>> mcgrof@frijol ~/linux-stable (git::master)$ git describe --contains
>> 2b721118b7821107757eb1d37af4b60e877b27e7
>> v3.12-rc1~132^2~84^2^2~88
>>
>> This means that patch got merged into v3.12-rc1 which means the
>> backports release based on v3.12 will have it.
>>
>>> If it is already included, then try to revert.
>>
>> What do you mean? Are you saying to try to revert that patch in case
>> v3.12 backports release causes issues with the card?
>
> yes
>
>> It seems the user
>> of this card had issues with the v3.10 release of backports which
>> would not have this patch merged.
>
> Ok. Thank you.

So to be clear -- you would recommend testing the new v3.12 release
that *has* the patch then?

  Luis
