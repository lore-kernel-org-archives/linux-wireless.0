Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39853 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1KRT7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:59:34 -0500
Received: by fagn18 with SMTP id n18so4730719fag.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 11:59:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321645446-22527-3-git-send-email-hauke@hauke-m.de>
References: <1321645446-22527-1-git-send-email-hauke@hauke-m.de> <1321645446-22527-3-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 18 Nov 2011 11:59:12 -0800
Message-ID: <CAB=NE6Va3Hj++skXUVzvXWCRAoDuqs7rj3i+Ype6918CLyf8sQ@mail.gmail.com> (sfid-20111118_205937_154462_404E622F)
Subject: Re: [PATCH 3/3] compat-wireless: fetch crc8.c and cordic.c from kernel
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 11:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> crc8.c and cordic.c are not provided by compat any more, now the
> generation script will fetch them from the kernel image.
> They are used in the build process only when there is not version of
> this library already in the kernel.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

This has the benefit of allowing us to pull the code but that also
means less code dumped into compat. As I see it I want it to be the
other way around, more stuff moved to compat.git given that this means
others can make more use of a general compatibility framework. If
compat-wireless itself becomes more of a compat-kernel, which I'm
happy to do but I think we'd need more subsystem developers willing to
do this, then I see the benefit of sucking in the code but for now I
see more gains the other way around. But perhaps there are some
benefits I may be missing?

  Luis
