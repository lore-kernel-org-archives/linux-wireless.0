Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gmmr3.centrum.cz ([46.255.225.251]:55772 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2AaU2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 15:28:04 -0500
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: connection interrupted for rt61pci in master mode
Date: Tue, 31 Jan 2012 21:21:36 +0100
From: <trencan@centrum.cz>
Cc: <linux-wireless@vger.kernel.org>
References: <20120128154544.70E060CD@centrum.cz>, <1385650.dcoDil3T5I@helmutmobil.site>, <20120130191820.F4F520E8@centrum.cz> <CAGXE3d_wHuNT7Q+Ubj5qR-DgA78AeYXe7MfnFS4rv+iHjtMJbA@mail.gmail.com>
In-Reply-To: <CAGXE3d_wHuNT7Q+Ubj5qR-DgA78AeYXe7MfnFS4rv+iHjtMJbA@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <20120131212136.652477E0@centrum.cz> (sfid-20120131_212809_472180_5625FC17)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I set CONFIG_RT2X00_LIB_DEBUGFS=y and CONFIG_RT2X00_DEBUG=y in config.mk. Then I saw 3 files in "/sys/kernel/debug/ieee80211/phy0/rt61pci/queue/"
-r--r--r-- 1 root root 0 Jan 31 20:32 crypto
-r-------- 1 root root 0 Jan 31 20:32 dump
-r-------- 1 root root 0 Jan 31 20:32 queue

One of them "dump" was still continuosly growing. I stopped catting after connection interrupted occured. Do you need all them three? Should I send it only to your email? Packed dump file has 820kB. Queue and Crypto are of small sizes.

Thanks.

Michal


______________________________________________________________
> Od: "Helmut Schaa" <helmut.schaa@googlemail.com>
> Komu: <trencan@centrum.cz>
> Datum: 31.01.2012 08:49
> Předmět: Re: connection interrupted for rt61pci in master mode
>
> CC: linux-wireless@vger.kernel.org
>On Mon, Jan 30, 2012 at 7:18 PM,  <trencan@centrum.cz> wrote:
>> I made the test again, got connection interrupted on client, but folder
>> "/sys/kernel/debug/ieee80211/phy0/" was empty on server, no rt2800pci
>> inside. Do I make anything wrongly?
>
>Hmm, rt2x00 needs to be build with debug/debugfs support:
>
>CONFIG_RT2X00_LIB_DEBUGFS
>CONFIG_RT2X00_DEBUG
>
>Helmut
>
