Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:43311 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3ICHjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 03:39:37 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, kaber@trash.net, jiri@resnulli.us,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	libertas-dev@lists.infradead.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, forest@alittletooquiet.net,
	stephen@networkplumber.org, dan.carpenter@oracle.com
Subject: Re: [PATCH v2 net-next 0/9] set addr_assign_type when inheriting a dev_addr
References: <1377878932-26881-1-git-send-email-bjorn@mork.no>
	<20130831.225057.1874268263797742541.davem@davemloft.net>
Date: Tue, 03 Sep 2013 09:38:10 +0200
In-Reply-To: <20130831.225057.1874268263797742541.davem@davemloft.net> (David
	Miller's message of "Sat, 31 Aug 2013 22:50:57 -0400 (EDT)")
Message-ID: <87mwnuqrrx.fsf@nemi.mork.no> (sfid-20130903_093944_717058_8AB3570B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Bjørn Mork <bjorn@mork.no>
> Date: Fri, 30 Aug 2013 18:08:43 +0200
>
>> Copying the dev_addr from a parent device is an operation
>> common to a number of drivers. The addr_assign_type should
>> be updated accordingly, either by reusing the value from
>> the source device or explicitly indicating that the address
>> is stolen by setting addr_assign_type to NET_ADDR_STOLEN.
>> 
>> This patch set adds a helper copying both the dev_addr and
>> the addr_assign_type, and use this helper in drivers which
>> don't currently set the addr_assign_type. Using NET_ADDR_STOLEN
>> might be more appropriate in some of these cases.  Please
>> let me know, and I'll update the patch accordingly.
>> 
>> Changes in v2:
>>  - assuming addr_len == ETH_ALEN to allow optimized memcpy
>>  - dropped the vt6656 patch due to addr_len being unset in that driver
>
> Looks good, series applied, thanks.

Thanks.  But it doesn't look like it ended up in net-next?  Or am I
missing something (again)?


Bjørn
