Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36147 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423779AbcFMOsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 10:48:06 -0400
Received: by mail-vk0-f43.google.com with SMTP id u64so70382566vkf.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 07:48:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3475016.uenfZZHUnB@wuerfel>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org> <3475016.uenfZZHUnB@wuerfel>
From: Binoy Jayan <binoy.jayan@linaro.org>
Date: Mon, 13 Jun 2016 20:18:04 +0530
Message-ID: <CAHv-k__2APMhcgD6VoQ1DX9XebO5P=5eaqfACvk8U5Sd-XfvCQ@mail.gmail.com> (sfid-20160613_164827_252978_770F3BFA)
Subject: Re: [PATCH 0/7] *** staging: wilc1000: Replace semaphores with
 mutexes or completions ***
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 June 2016 at 19:59, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday, June 13, 2016 4:07:32 PM CEST Binoy Jayan wrote:
>> Hi,
>>
>> These are a set of patches which removes semaphores from:
>>
>> drivers/staging/wilc1000
>>
>> These are part of a bigger effort to eliminate all semaphores
>> from the linux kernel.
>>
>> They build correctly (individually and as a whole).
>>
>> NB: The changes are untested
>>
>
> Most of these look really good, but I've commented on what I think
> should be done differently, most importantly using a work_queue
> rather than a completion to replace the semaphore in patch 6.
>
> Maybe you can resend the first five patches after addressing
> my comments so we can get those tested and queued already while
> you look into reworking patch 6. Let me know if that one ends up
> being more complicated than I thought so we can come up with
> a different approach.
>
>         Arnd

Thank you for reviewing the patches thoroughly. I overlooked the
problem with using
completion directly. Thank you for pointing that out. As you have
suggested, I'll rework
on the first 5 patches and work on the last one.

Binoy
