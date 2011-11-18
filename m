Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36472 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1KRVNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 16:13:12 -0500
Received: by yenq3 with SMTP id q3so2936238yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 13:13:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321650012.10266.78.camel@jlt3.sipsolutions.net>
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com> <1321650012.10266.78.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Fri, 18 Nov 2011 13:12:51 -0800
Message-ID: <CAB=NE6Urei3NSQ05d_4MOUEoBb=tAvy9WE+_5zyc1-j_S+VnDg@mail.gmail.com> (sfid-20111118_221315_826218_992A1874)
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
To: Johannes Berg <johannes@sipsolutions.net>,
	Julia Lawall <julia@diku.dk>,
	Jesper Andersen <jespera@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 1:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-11-18 at 15:54 -0500, John W. Linville wrote:
>> The way the compat-* header files are included causes the default
>> pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
>> Files that define pr_fmt then generate a lot of build SPAM about
>> pr_fmt being redefined.
>>
>> Eliminate the build noise by preemptively undefining pr_fmt in those
>> files that define it.  This is accomplished by adding a patch to the
>> patches directory.
>
> This patch is going to be relatively painful when files move etc -- is
> that really worth it? I for one will just drop it in our compat version
> if it goes in since I don't even have all the files it patches :-)

This may be a good use case for spatch magic?

  Luis
