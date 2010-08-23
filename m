Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63944 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0HWJiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 05:38:19 -0400
Received: by qwh6 with SMTP id 6so4913876qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 02:38:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100822223718.431624390@rtp-net.org>
References: <20100822223710.865969746@rtp-net.org>
	<20100822223718.431624390@rtp-net.org>
Date: Mon, 23 Aug 2010 11:38:16 +0200
Message-ID: <AANLkTi==U5TUXZ2KrofWFcVhqohqDuC0UBYLnKu5Z7bD@mail.gmail.com>
Subject: Re: [patch 1/1] rt2x00: fix "buffer size not provably correct" build warning
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 23, 2010 at 12:37 AM, Arnaud Patard
<arnaud.patard@rtp-net.org> wrote:
> rt2x00 debugfs interface doesn't check the size of the data coming
> from userspace, leading to a build warning. Fix That.
>
> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
>
> Index: rt2x00/drivers/net/wireless/rt2x00/rt2x00debug.c
> ===================================================================
> --- rt2x00.orig/drivers/net/wireless/rt2x00/rt2x00debug.c       2010-08-23 00:21:42.637941244 +0200
> +++ rt2x00/drivers/net/wireless/rt2x00/rt2x00debug.c    2010-08-23 00:33:41.237941022 +0200
> @@ -480,6 +480,8 @@ static ssize_t rt2x00debug_write_##__nam
>        if (index >= debug->__name.word_count)                  \
>                return -EINVAL;                                 \
>                                                                \
> +       if (length > sizeof(line))                              \
> +               length = sizeof(line);                          \
>        if (copy_from_user(line, buf, length))                  \
>                return -EFAULT;                                 \
>                                                                \

I think it should actually return -EINVAL to clearly indicate that the
input is invalid,
rather then alter the value. rt2x00debug_write_* alters registers, so
we should not
assume anything when writing into it.

Ivo
