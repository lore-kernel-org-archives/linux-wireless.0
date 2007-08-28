Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:43001 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbXH1RrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 13:47:12 -0400
Message-ID: <46D45F9B.2000000@lwfinger.net>
Date: Tue, 28 Aug 2007 12:47:07 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christoph Hellwig <hch@infradead.org>,
	Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
References: <2713029743177393055@pripojeni.net>	 <20070828171034.GB29343@infradead.org> <1188322410.7837.113.camel@johannes.berg>
In-Reply-To: <1188322410.7837.113.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2007-08-28 at 18:10 +0100, Christoph Hellwig wrote:
>> On Tue, Aug 28, 2007 at 11:58:52AM -0400, Jiri Slaby wrote:
>>> -ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o
>>> +ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o \
>>> +			  ath5k_hw_phy.o ath5k_hw_inivals.o
>> And while I'm at nitpicking :)
>>
>> ath5k_hw_phy.o should probably be ath5k_phy.o by conventions used by
>> most drivers and ath5k_hw_inivals.o mights aswell be something like
>> ath5k_init.o
> 
> While we're at names... I personally much prefer a new directory ath5k
> and then ath5k/hw.c etc. but it seems I'm pretty alone in that. But here
> we already have at least four files now.

I agree with you. If a wireless driver takes more than one .c and one .h file, it belongs in its own 
directory, and the file names stripped of any driver prefix. Not only are the file names simpler, 
but Makefile and Kconfig in wireless benefits.

Larry
