Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2774 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab0DJI57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 04:57:59 -0400
Message-ID: <4BC03D95.8060801@gmail.com>
Date: Sat, 10 Apr 2010 10:57:57 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 4/9] rt2x00: Remove rt2800 version	constants.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>	<1270763437-29526-5-git-send-email-gwingerde@gmail.com> <201004090032.53842.IvDoorn@gmail.com> <4BBFA1BD.70900@free.fr>
In-Reply-To: <4BBFA1BD.70900@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/10 23:53, Benoit PAPILLAULT wrote:
> Ivo van Doorn a écrit :
>> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>>  
>>> The rt2800 version constants are inconsistent, and the version number
>>> don't
>>> mean a lot of things anyway. Use the literal values in the code
>>> instead of
>>> some sort of fabricated version name macro.
>>>
>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>>     
>>
>> Perhaps a more elegant way of using and defining needs to be found.
>> But at least the defined show what the purpose for the values is
>> rather then having magical values spread around the code.
>>
>> Ivo
>>
>>   
> Agreed, it's a lot better to avoid hardcoded value. #define adds a
> meaning to the numeric value and if such define needs to be changed,
> there's only one place to change, avoiding bugs by duplicating hardcoded
> values and only changing one instance.
> 
> Even, #define MCS_0 0 is useful :-)
> 

To be honest, I don't think that constants with meaningless names are better
or useful.

If a constant is used it should have a meaningful name, otherwise it is just
as bad as using a magical value. The only change is that it now is a magical
name. IMHO that actually worsens the situation as code readers will start
thinking about what that name actually means.

However, I think I found some sort of scheme that can be used for the version
numbers. See my other email to the mailing list.

---
Gertjan.
