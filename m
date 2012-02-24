Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42914 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2BXE7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 23:59:05 -0500
Received: by qcqw6 with SMTP id w6so270431qcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 20:59:04 -0800 (PST)
Message-ID: <4F4718EF.3010300@gmail.com> (sfid-20120224_055908_929938_ADF0B46C)
Date: Thu, 23 Feb 2012 23:58:23 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [compat-wireless] replace modprobe -l with functional
 equivilent
References: <1329667396-20357-1-git-send-email-sidhayn@gmail.com> <CAB=NE6VSR8_uhsoDkgh2SmjgDerSX2CXztt2cVxYTEQSgTaYwg@mail.gmail.com>
In-Reply-To: <CAB=NE6VSR8_uhsoDkgh2SmjgDerSX2CXztt2cVxYTEQSgTaYwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/12 20:39, Luis R. Rodriguez wrote:
> On Sun, Feb 19, 2012 at 8:03 AM, Rick Farina <sidhayn@gmail.com> wrote:
>> modprobe -l is either deprecated or removed, so let's replace it
>>
>> Signed-off-by: Rick Farina <sidhayn@gmail.com>
> Did you test this when one of those modules is present?
ozzie compat-wireless # $(modinfo compat > /dev/null 2>&1) && echo yes
yes
ozzie compat-wireless #


The logic is sound, I use the same test in another script and it works
great.  It's a bit unusual I realize, but it works and it's all I could
think of.  It tests the exit value of modinfo which is true when the
module exists and false when it doesn't.  Simple as I could manage.

-Rick

>
>   Luis
>

