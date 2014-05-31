Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:54199 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaEaO53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 10:57:29 -0400
Received: by mail-we0-f175.google.com with SMTP id p10so3229317wes.20
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 07:57:28 -0700 (PDT)
Message-ID: <5389EDD4.9050808@gmail.com> (sfid-20140531_165733_089994_F725666F)
Date: Sat, 31 May 2014 15:57:24 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, kbuild@01.org,
	linux-wireless@vger.kernel.org
Subject: Re: [kbuild] [PATCH] staging: vt6656: Fix vnt_rf_table_download __builtin_memcpy()
 addr* too small (3 vs 64).
References: <1401541767-2940-1-git-send-email-tvboxspy@gmail.com> <20140531133839.GJ17724@mwanda> <20140531141115.GK17724@mwanda>
In-Reply-To: <20140531141115.GK17724@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31/05/14 15:11, Dan Carpenter wrote:
> On Sat, May 31, 2014 at 04:42:02PM +0300, Dan Carpenter wrote:
>> On Sat, May 31, 2014 at 02:09:27PM +0100, Malcolm Priestley wrote:
>>> Fix following errors
>>> drivers/staging/vt6656/rf.c:1060 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
>>> drivers/staging/vt6656/rf.c:1078 vnt_rf_table_download() error: __builtin_memcpy() 'addr3' too small (3 vs 64)
>>> drivers/staging/vt6656/rf.c:1094 vnt_rf_table_download() error: __builtin_memcpy() 'addr1' too small (3 vs 48)
>>> drivers/staging/vt6656/rf.c:1108 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
>>>
>>
>
> Btw, the 3 here is a bug in Smatch...  I will fix that.  You shouldn't
> have to work around that like this.  I'm sorry for the confusion.  My
> only question when I reported the Smatch warning was about where we got
> the 64.
>
64 is the maximum that can be sent out at any one time so it must be 
from length.

array could be reduced to 64.

3 is the element size of the tables, so the pointer should really point 
to the whole table.

Regards


Malcolm






