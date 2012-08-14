Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50905 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2HNREa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 13:04:30 -0400
Received: by ggdk6 with SMTP id k6so687013ggd.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2012 10:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344961225-28231-1-git-send-email-ozancag@gmail.com>
References: <1344961225-28231-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 14 Aug 2012 10:04:09 -0700
Message-ID: <CAB=NE6WQ7SGy=jXFH9-2m9bq2oDcUHesMG6MKXbGTThGRie7dA@mail.gmail.com> (sfid-20120814_190434_880065_8DCAE099)
Subject: Re: [PATCH] compat: Backport __wake_up_all_locked()
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2012 at 9:20 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> This backports:
>
> commit 63b2001169e75cd71e917ec953fdab572e3f944a
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Dec 1 00:04:00 2011 +0100
>
>         sched/wait: Add __wake_up_all_locked() API
>
> $ git describe --contains 63b2001169e75cd71e917ec953fdab572e3f944a
> v3.4-rc1~3^2~24
>
> This is used by the 3.6-rcX radeon DRM driver (radeon_sa.c) and will
> probably be used by other drivers in the near future.
>
> __wake_up_all_locked() is a preprocessor macro around __wake_up_locked()
> which gained a 3rd parameter in 3.4.
>
> That's why I backported the new __wake_up_locked() as
> compat_wake_up_locked() to avoid name conflicts.
>
> This new function uses the internal __wake_up_common() function
> which needed a backport too. I backported it as
> compat_wake_up_common() as __wake_up_common() was made available
> in kernels between 2.6.28 <= x <= 2.6.30 through wait.h and
> dropped after 2.6.30. Renaming fixes build problems of compat
> for those kernels.
>
> Trying kernel 3.5.0-030500-generic [OK]
> Trying kernel 3.4.4-030404-generic [OK]
> Trying kernel 3.3.7-030307-generic [OK]
> Trying kernel 3.2.2-030202-generic [OK]
> Trying kernel 3.1.10-030110-generic [OK]
> Trying kernel 3.0.18-030018-generic [OK]
> Trying kernel 2.6.39-02063904-generic [OK]
> Trying kernel 2.6.38-02063808-generic [OK]
> Trying kernel 2.6.37-02063706-generic [OK]
> Trying kernel 2.6.36-02063604-generic [OK]
> Trying kernel 2.6.35-02063512-generic [OK]
> Trying kernel 2.6.34-02063410-generic [OK]
> Trying kernel 2.6.33-02063305-generic [OK]
> Trying kernel 2.6.32-02063255-generic [OK]
> Trying kernel 2.6.31-02063113-generic [OK]
> Trying kernel 2.6.30-02063010-generic [OK]
> Trying kernel 2.6.29-02062906-generic [OK]
> Trying kernel 2.6.28-02062810-generic [OK]
> Trying kernel 2.6.27-020627-generic [OK]
> Trying kernel 2.6.26-020626-generic [OK]
> Trying kernel 2.6.25-020625-generic [OK]
> Trying kernel 2.6.24-020624-generic [OK]
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed, thanks!

  Luis
