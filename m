Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:54436 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYIMTSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 15:18:43 -0400
Received: by gxk9 with SMTP id 9so21694484gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 13 Sep 2008 12:18:41 -0700 (PDT)
Message-ID: <43e72e890809131218x12aaa38bif3a2e6f3041537b6@mail.gmail.com> (sfid-20080913_211848_543864_9B124B1D)
Date: Sat, 13 Sep 2008 12:18:41 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ingeideas@yahoo.com
Subject: Re:
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <657598.13074.qm@web34808.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <657598.13074.qm@web34808.mail.mud.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 13, 2008 at 9:10 AM, Edgar Velasco <ingeideas@yahoo.com> wrote:
> I'm reporting a bug.
> Went I make, this is what I get:
>
> compat-wireless-2.6-old # make
> /root/compat-wireless-2.6-old/config.mk:30: *** "ERROR: There is a bug with compat-wireless on 2.6.22. Remove me if you want to fix me".  Stop.
>
> How can I fix it?

The error happens because config.mk checks for your kernel release and
if it detects its you are using a kernel release <= 2.6.22 it'll stop
and error out with that message. The problem is there is an oops
(kernel crash) that will occur if you enable the compile to go through
and use it. The error indicates to you that if you want to try to fix
the issue you can remove the force check on config.mk.

I used to support 2.6.22 but distributions have newer kernels so I
rather focus attention on newer kernels as we move forward. This gives
the opportunity for those developers interested in using 2.6.22 to go
ahead and fix it if they wish.

If you are a user I'd recommend to upgrade to at least 2.6.26.

  Luis
