Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50818 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1HXKBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 06:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110823191306.GK12248@shale.localdomain>
References: <20110818133809.GG4786@shale.localdomain>
	<CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com>
	<20110823191306.GK12248@shale.localdomain>
Date: Wed, 24 Aug 2011 12:01:11 +0200
Message-ID: <CACna6rwLrGa4LU2GOQ03w+t5FfrD+c1rdHki_Nu-3oPVninCJg@mail.gmail.com> (sfid-20110824_120117_567024_A47AEA49)
Subject: Re: [patch -next] bcma: signedness bug in bcma_get_next_core()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "open list:BROADCOM SPECIFIC..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 sierpnia 2011 21:13 użytkownik Dan Carpenter
<error27@gmail.com> napisał:
> On Sat, Aug 20, 2011 at 02:23:56PM +0200, Rafał Miłecki wrote:
>> W dniu 18 sierpnia 2011 15:38 użytkownik Dan Carpenter
>> <error27@gmail.com> napisał:
>> > The u32 would never be less than zero so the error handling would
>> > break.  I changed it to int.
>>
>> In declaration we use s32:
>> static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 **eromptr);
>>
>> Doesn't it sound better to use s32 instead of int?
>>
>
> I don't know.  I think I'm going to trust the original author on this
> one.  I'll send you a v2 that uses s32.

Dan, I asked you to use int in both: call and function declaration.
I'm the author of that code, and I don't have anything against
modifying that :)

I think int is used much more often that s32 for errors.

-- 
Rafał
