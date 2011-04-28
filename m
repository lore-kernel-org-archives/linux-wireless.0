Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hhlx01.vscom.de ([62.145.30.242]:53831 "EHLO
	mail.visionsystems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1D1JZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:25:31 -0400
Message-ID: <4DB93282.7060509@visionsystems.de> (sfid-20110428_112534_926316_DD1C11CB)
Date: Thu, 28 Apr 2011 11:25:22 +0200
From: Yegor Yefremov <yegor_sub1@visionsystems.de>
Reply-To: yegor_sub1@visionsystems.de
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: add libnl-3.0 support
References: <4DB91BB9.2080405@visionsystems.de> <BANLkTimJmSA4BheDCN+0V8=AbDoN3M=-Bg@mail.gmail.com>
In-Reply-To: <BANLkTimJmSA4BheDCN+0V8=AbDoN3M=-Bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Extend Makefile to find and use libnl-3.0
>>
>> Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
>> ---
>>  Makefile |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> Index: b/Makefile
>> ===================================================================
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -24,6 +24,7 @@
>>
>>  NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
>>  NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
>> +NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
>>
>>  ifeq ($(NL1FOUND),Y)
>>  NLLIBNAME = libnl-1
>> @@ -35,6 +36,12 @@
>>  NLLIBNAME = libnl-2.0
>>  endif
>>
>> +ifeq ($(NL3FOUND),Y)
>> +CFLAGS += -DCONFIG_LIBNL20
>> +LIBS += -lnl-genl
>> +NLLIBNAME = libnl-3.0
>> +endif
>> +
> Is this intended -DCONFIG_LIBNL**2**0 and NLLIBNAME = libnl-**3**.0?
>
> - Sedat -

There is no such config option as CONFIG_LIBNL30. AFAIK the interface has not been changed since 2.0, so it compiles without errors and I haven't encountered any problems while running iw with libnl-3.0.

Best regards,
Yegor


