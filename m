Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34339 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbbFIKyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 06:54:11 -0400
Message-ID: <5576C574.6050905@broadcom.com> (sfid-20150609_125414_434629_8A02A3E9)
Date: Tue, 9 Jun 2015 12:52:36 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: about .dump_station() callback
References: <5576AFA2.9090004@broadcom.com> <1433842889.1892.9.camel@sipsolutions.net>
In-Reply-To: <1433842889.1892.9.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/15 11:41, Johannes Berg wrote:
> On Tue, 2015-06-09 at 11:19 +0200, Arend van Spriel wrote:
>
>> I am looking in get_station() and consequently dump_station() callback
>> for our brcmfmac driver. The latter is called with index. Can I expect
>> this to be starting at 0 and iterate through or can it be requested in
>> any order.
>
> You can expect that, yes.

Thanks. Guess it is nl80211.c assuring that. I should have checked that 
first. See that I have to return -ENOENT when iteration is done.

> If it would help, we could instead give the driver one or two pointers
> to unsigned long values that start out as 0 and can be controlled
> entirely by the driver?

Not sure if I understand this. What would those pointers represent?

Regards,
Arend
