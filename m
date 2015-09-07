Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:65207 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbbIGQgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 12:36:00 -0400
Message-ID: <55EDBCEE.1040008@broadcom.com> (sfid-20150907_183604_527961_5043FFDE)
Date: Mon, 7 Sep 2015 18:35:58 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: using dev_coredumpv
References: <55ED5D28.8000309@broadcom.com>	 (sfid-20150907_114727_883458_63EE9237) <1441619646.1940.2.camel@sipsolutions.net>
In-Reply-To: <1441619646.1940.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2015 11:54 AM, Johannes Berg wrote:
> On Mon, 2015-09-07 at 11:47 +0200, Arend van Spriel wrote:
>> Hi Johannes,
>>
>> I am looking at devcoredump subsystem and I was wondering about the
>> lifetime of the devcd folder. With dev_coredumpm() the description says:
>> "If a previous one hasn't been read yet, the new coredump is
>> discarded.". I am wondering what "read" means here. For testing I call
>> dev_coredumpv() every second, but when I hexdump the data file it does
>> not create a new devcd folder. That only occurs after 5 minutes. Is that
>> expected?
>
> I suppose "read" should say "discarded by userspace", but I always
> assumed userspace would read the file and then discard the coredump by
> writing (anything iirc) to the file.

Thanks. Went back to devcoredump.c and reading the code found that 
devcd_data_write schedules devcd_del work without any condition. Sorry 
for being lazy.

Gr. AvS

> IOW - yes, this is expected, you should write to the data file which
> makes it (and the folder) disappear and allows creating a new one.
>
> johannes
>

