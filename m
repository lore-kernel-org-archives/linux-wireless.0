Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33805 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0GWIOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 04:14:36 -0400
Received: by bwz1 with SMTP id 1so1414400bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 01:14:35 -0700 (PDT)
Message-ID: <4C494F50.4050808@adurom.com>
Date: Fri, 23 Jul 2010 10:14:08 +0200
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com> <1279780458.2322.25.camel@powerslave> <4C47F706.4060102@iki.fi> <20100722132150.GB18742@tuxdriver.com>
In-Reply-To: <20100722132150.GB18742@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2010 03:21 PM, John W. Linville wrote:
> On Thu, Jul 22, 2010 at 09:45:10AM +0200, Kalle Valo wrote:
>> On 07/22/2010 08:34 AM, Luciano Coelho wrote:
> 
>>>> @@ -467,7 +467,7 @@ static int wl1251_boot_upload_nvs(struct wl1251 *wl)
>>>>  		val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
>>>>  		       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
>>>>  
>>>> -		val = cpu_to_le32(val);
>>>> +		val = (u32 __force) cpu_to_le32(val);
>>>
>>> This will work, but such casts always make me a bit suspicious.  I think
>>> this is fine for now
>>
>> This line was very suspicious already from beginning, I can't remember
>> why it was added and I don't see why it's needed here.
> 
> It certainly is a bit strange, and rather ugly as well.  I agree that
> the write should probably just take the le32 instead, but I was more
> interested in silencing sparse than in rewriting a driver for which
> I have not hardware. :-)
> 
> I could drop that hunk for the time being?

Yeah, drop that hunk for now.  Better to create a separate patch which
removes that val = cpu_to_le32(val) line altogether.

Kalle
