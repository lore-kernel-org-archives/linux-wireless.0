Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62488 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbFIPWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 11:22:44 -0400
Message-ID: <55770475.7050705@broadcom.com> (sfid-20150609_172249_129479_261F8829)
Date: Tue, 9 Jun 2015 17:21:25 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: about .dump_station() callback
References: <5576AFA2.9090004@broadcom.com>	 <1433842889.1892.9.camel@sipsolutions.net> <5576C574.6050905@broadcom.com> <1433847693.1892.10.camel@sipsolutions.net>
In-Reply-To: <1433847693.1892.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/15 13:01, Johannes Berg wrote:
> On Tue, 2015-06-09 at 12:52 +0200, Arend van Spriel wrote:
>
>> Thanks. Guess it is nl80211.c assuring that. I should have checked that
>> first. See that I have to return -ENOENT when iteration is done.
>
> Right.
>
>>> If it would help, we could instead give the driver one or two pointers
>>> to unsigned long values that start out as 0 and can be controlled
>>> entirely by the driver?
>>
>> Not sure if I understand this. What would those pointers represent?
>
> Well, you could put in there whatever you like :)
>
> Though realistically I wouldn't expect you to put anything other than
> the sta_idx that you currently get.

Well, I obtain (in ap mode) a list of associated clients and keep that 
list until iteration is done (or .dump_station() is called with sta_idx 
== 0). So I am fine with current api.

Regards,
Arend
