Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36834 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbLSBQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 20:16:14 -0500
Received: by mail-qg0-f41.google.com with SMTP id c96so46896649qgd.3
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 17:16:14 -0800 (PST)
Subject: Re: [PATCH 1/1] staging: Fix bitshifts by wrong offsets in
 wilc1000/host_interface.c
To: Greg KH <gregkh@linuxfoundation.org>
References: <1449024595-20290-1-git-send-email-mrugiero@gmail.com>
 <20151218225035.GA26842@kroah.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com
From: "Mario J. Rugiero" <mrugiero@gmail.com>
Message-ID: <5674AFD7.9010604@gmail.com> (sfid-20151219_021618_330330_B2FFBB10)
Date: Fri, 18 Dec 2015 22:16:07 -0300
MIME-Version: 1.0
In-Reply-To: <20151218225035.GA26842@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 18/12/15 a las 19:50, Greg KH escribió:
> On Tue, Dec 01, 2015 at 11:49:55PM -0300, Mario J. Rugiero wrote:
>> struct set_multicast uses (implicitly) sizeof(bool) to determine how many bytes to copy in
>> Handle_SetMulticastFilter. Since that is implementation defined, it triggered sparse to
>> rightfully complain about shifting a bigger value than supported.
>> Since it was used as if assuming it was 32 bits, I replaced the bool member by a u32.
>> Also, time_out and buf_size members of ba_session_info are u16, but while copying their
>> bytes into ptr in Handle_AddBASession shift 16 bits for the second byte instead of 8 bits.
>> This patch fixes those two issues.
>>
>> Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
>> ---
>>   drivers/staging/wilc1000/host_interface.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> How did you test this is correct?
>
> Doesn't apply to my tree :(
>
> thanks,
>
> greg k-h
>

Because I lack the hardware, I only tested it built with allmodconfig 
and tried to be very careful about my reasoning. I know I *should* be 
testing it, and am sorry about it.
Should I try and update the patch? Maybe it conflicts with a different 
one. I made the changes on top of staging-testing.
In retrospect, I believe the issues should be handled in different 
patches anyway, so I would like to do a second version anyway.

Regards,
Mario.
