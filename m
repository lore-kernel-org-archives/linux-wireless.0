Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:58462 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbbIJCIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 22:08:05 -0400
Subject: Re: [PATCH 3/4] staging: wilc1000: delete wilc_oswrapper.h and
 wilc_platform.h
To: Greg KH <gregkh@linuxfoundation.org>
References: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
 <1441782493-11338-3-git-send-email-tony.cho@atmel.com>
 <20150909181912.GA30669@kroah.com>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <55F0E619.5000808@atmel.com> (sfid-20150910_040828_971951_BF8308ED)
Date: Thu, 10 Sep 2015 11:08:25 +0900
MIME-Version: 1.0
In-Reply-To: <20150909181912.GA30669@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

I want to make sure one thing before moving further. Are you saying the errorsupport.h file as the os wrapper remaining in the oswrapper.h file?
If not, can you let me know what you point out as remaining os wrapper in the oswrapper.h file?
If yes, I have been already replacing all of error values defined in the errorsupport.h file so that I send you the next patch when done.

Thanks,
Tony.

On 2015년 09월 10일 03:19, Greg KH wrote:
> On Wed, Sep 09, 2015 at 04:08:12PM +0900, Tony Cho wrote:
>> From: Glen Lee <glen.lee@atmel.com>
>>
>> wilc1000 driver runs on Linux. No need to have oswrapper or platform
>> dependent files.
>> Before delete two header files, move two structures in wilc_platform.h to
>> wilc_msgqueue.h where it is used. Include linux header files where is needs
>> since wilc_platform is deleted.
>> Finally, remove wilc_oswrapper.h and wilc_platform.h.
> That's a lot of different things to be doing all in one patch.  Please
> break this up into individual patches.
>
> And you can't just delete the oswrapper.h file, you still have things in
> it, don't move it for no reason, get rid of those wrapper functions
> properly first, making the file empty, and then you can delete it.
> Moving them to a different .h file just hides the fact that this work
> still needs to be done.
>
> thanks,
>
> greg k-h

