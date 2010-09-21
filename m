Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48368 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0IUVKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 17:10:10 -0400
Message-ID: <4C991F25.1000102@candelatech.com>
Date: Tue, 21 Sep 2010 14:09:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to get iw building on Fedora 8
References: <4C98DFB6.10902@candelatech.com> <m2wrqej2qk.fsf@igel.home>
In-Reply-To: <m2wrqej2qk.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 12:49 PM, Andreas Schwab wrote:
> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  writes:
>
>> I need this in order to get iw to build on Fedora 8.
>>
>> [greearb@fs2 iw]$ git diff
>> diff --git a/bitrate.c b/bitrate.c
>> index 8de8839..9b6defc 100644
>> --- a/bitrate.c
>> +++ b/bitrate.c
>> @@ -1,4 +1,6 @@
>>   #include<errno.h>
>> +#define  __USE_ISOC99
>
> This is wrong.  You must never define internal glibc macros.

How about this then?

diff --git a/bitrate.c b/bitrate.c
index 8de8839..f0d513f 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -70,7 +70,7 @@ static int handle_bitrates(struct nl80211_state *state,
  #endif
                 else switch (parser_state) {
                 case S_LEGACY:
-                       tmpf = strtof(argv[i], &end);
+                       tmpf = strtod(argv[i], &end);
                         if (*end != '\0')
                                 return 1;
                         if (tmpf < 1 || tmpf > 255 * 2)

Seems you don't have to do anything clever to get strtod to work,
and I assume it should cast just fine.

Thanks,
Ben

>
> Andreas.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

