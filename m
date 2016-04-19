Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbcDSSYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 14:24:42 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jakub Sitnicki <jsitnicki@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: hide unused tables
References: <1461016782-2640046-1-git-send-email-arnd@arndb.de>
	<wrfjzisp64d7.fsf@redhat.com> <87mvopy4dy.fsf@purkki.adurom.net>
Date: Tue, 19 Apr 2016 14:24:40 -0400
In-Reply-To: <87mvopy4dy.fsf@purkki.adurom.net> (Kalle Valo's message of "Tue,
	19 Apr 2016 19:01:13 +0300")
Message-ID: <wrfjmvop5udz.fsf@redhat.com> (sfid-20160419_202516_457194_20038ABC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>> Arnd Bergmann <arnd@arndb.de> writes:
>>> The references to some arrays in the rtl8xxxu driver were moved inside
>>> of an #ifdef, but the symbols remain outside, resulting in build warnings:
>>>
>>> rtl8xxxu/rtl8xxxu.c:1506:33: error:
>>> 'rtl8188ru_radioa_1t_highpa_table' defined but not used
>>> rtl8xxxu/rtl8xxxu.c:1431:33: error:
>>> 'rtl8192cu_radioa_1t_init_table' defined but not used
>>> rtl8xxxu/rtl8xxxu.c:1407:33: error:
>>> 'rtl8192cu_radiob_2t_init_table' defined but not used
>>> rtl8xxxu/rtl8xxxu.c:1332:33: error:
>>> 'rtl8192cu_radioa_2t_init_table' defined but not used
>>> rtl8xxxu/rtl8xxxu.c:239:35: error: 'rtl8192c_power_base' defined but not used
>>> rtl8xxxu/rtl8xxxu.c:217:35: error: 'rtl8188r_power_base' defined but not used
>>>
>>> This adds an extra #ifdef around them to shut up the warnings.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>> Fixes: 2fc0b8e5a17d ("rtl8xxxu: Add TX power base values for gen1 parts")
>>> Fixes: 4062b8ffec36 ("rtl8xxxu: Move PHY RF init into device
>>> specific functions")
>>> ---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>
>> I'll apply it to my tree!
>
> Actually I would prefer to apply this directly to wireless-drivers-next
> so that the warnings are quickly fixed.

Thats fine with me, I already applied it here before I started doing any
of the refactoring work, so we should be in sync.

Cheers,
Jes
