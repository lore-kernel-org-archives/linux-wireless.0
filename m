Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:40732 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbbIUFyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 01:54:41 -0400
Subject: Re: [PATCH 08/18] staging: wilc1000: remove declaration of
 WILC_WFI_frame_register
To: Greg KH <gregkh@linuxfoundation.org>,
	Chaehyun Lim <chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-8-git-send-email-chaehyun.lim@gmail.com>
 <20150921020143.GC22262@kroah.com>
CC: <rachel.kim@atmel.com>, <devel@driverdev.osuosl.org>,
	<chris.park@atmel.com>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <leo.kim@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <55FF9B94.9020300@atmel.com> (sfid-20150921_075444_054445_67A882E1)
Date: Mon, 21 Sep 2015 14:54:28 +0900
MIME-Version: 1.0
In-Reply-To: <20150921020143.GC22262@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 09월 21일 11:01, Greg KH wrote:
> On Sun, Sep 20, 2015 at 03:51:15PM +0900, Chaehyun Lim wrote:
>> This patch removes function declaration of WILC_WFI_frame_register in
>> linux_wlan.c file, then adds it in wilc_wfi_cfgoperations.h file.
>>
>> The compilation warning occurs because it is assigned to incorrect
>> pointer type of second parameter of WILC_WFI_frame_register.
>> It is assigned with struct wireless_dev pointer type.
> How was this code ever even working properly if the wrong pointer was
> being passed into it?
>
> Tony, what is going on here, is this code just never called?  If so, can
> we just delete the whole function?
>
> thanks,
>
> greg k-h

This file with linux_wlan.c file is being fully changed, but at this time, the second parameter which passed as
net_device pointer instead of wireless_dev incorrectly is never being used inside the WILC_WFI_frame_register().
That's why no problem is found yet.

As of the patch which Chaehyun Lim made, the second parameter, nic->wilc_netdev should be replaced by nic->wilc_netdev->ieee80211_ptr.
Thanks,
Tony.


