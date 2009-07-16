Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:40785 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071AbZGPTZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 15:25:42 -0400
Received: by yxe14 with SMTP id 14so569632yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 12:25:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247772250.30529.42.camel@johannes.local>
References: <9e4733910907161204x441c21b9n22530800682d363@mail.gmail.com>
	 <1247771344.30529.41.camel@johannes.local>
	 <1247772250.30529.42.camel@johannes.local>
Date: Thu, 16 Jul 2009 15:25:41 -0400
Message-ID: <9e4733910907161225m7322b5dcidf9271cb45c07657@mail.gmail.com>
Subject: Re: Cross compiling crda and SSL word size
From: Jon Smirl <jonsmirl@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 3:24 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-07-16 at 21:09 +0200, Johannes Berg wrote:
>> On Thu, 2009-07-16 at 15:04 -0400, Jon Smirl wrote:
>> > When cross compiling crda the Makefile asks the python system what the
>> > word size is. This gets the word size from the host. Is there a way to
>> > ask the word size using gcc? In my environment the Makefile is
>> > automatically using the correct gcc cross compiler.
>>
>> Can you just use gnutls instead? it has no such issue :)
>>
>> Otherwise you can probably parse it out of "gcc -dumpspecs", but that
>> format doesn't look too nice, especially with multilib gcc...
>
> C99 says this works, I think:
>
> echo -e '#include <limits.h>\n#if ULONG_MAX == 4294967295\n32\n#elif ULONG_MAX == 18446744073709551615U\n64\n#else\n0\n#endif' | gcc -E - | sed 's/^\(#.*\|\)$//;T;d'

The problem test is in key2pub.py

def print_ssl(output, name, val):
    import struct
    if len(struct.pack('@L', 0)) == 8:
        return print_ssl_64(output, name, val)
    else:
        return print_ssl_32(output, name, val)


>
> johannes
>



-- 
Jon Smirl
jonsmirl@gmail.com
