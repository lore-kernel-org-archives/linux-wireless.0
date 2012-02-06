Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54289 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2BFQmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:42:52 -0500
Received: by qcqw6 with SMTP id w6so3483168qcq.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 08:42:52 -0800 (PST)
Message-ID: <4F3002FB.1030308@gmail.com> (sfid-20120206_174255_871798_B1A54E66)
Date: Mon, 06 Feb 2012 11:42:35 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] add missing =y to CONFIG_RT2X00_LIB_DEBUGFS
References: <1328542936-20963-1-git-send-email-sidhayn@gmail.com> <20120206161652.GB21048@tuxdriver.com>
In-Reply-To: <20120206161652.GB21048@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/12 11:16, John W. Linville wrote:
> On Mon, Feb 06, 2012 at 10:42:16AM -0500, Rick Farina wrote:
>> When editing config.mk with a sed script the missing =y on this line
>> causes issue. Since this line is commented out by default this means no
>> changes to the default behavior and sed scripts will be able to edit the
>> config.mk file much more easily.
>>
>> Signed-of-By: Rick Farina <sidhayn@gmail.com>
>> ---
>>  config.mk |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/config.mk b/config.mk
>> index 9433ce9..a9d189e 100644
>> --- a/config.mk
>> +++ b/config.mk
>> @@ -639,7 +639,7 @@ CONFIG_RT2X00_LIB_LEDS=y
>>  endif #CONFIG_LEDS_CLASS
>>  endif #CONFIG_COMPAT_KERNEL_2_6_25
>>  # CONFIG_RT2X00_DEBUG=y
>> -# CONFIG_RT2X00_LIB_DEBUGFS
>> +# CONFIG_RT2X00_LIB_DEBUGFS=y
>>  endif
>>  
>>  # p54
> Isn't it more common to say "is not set" for Kconfig stuff that is commented out?
>
You are completely correct, however in this case that is not used on any
of the other lines.  This change makes the style consistent across
compat-wireless not across the kernel.

Thanks,
Rick
