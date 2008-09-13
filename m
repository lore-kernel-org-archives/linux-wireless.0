Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:3066 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYIMTgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 15:36:49 -0400
Received: by wr-out-0506.google.com with SMTP id 69so791919wri.5
        for <linux-wireless@vger.kernel.org>; Sat, 13 Sep 2008 12:36:45 -0700 (PDT)
Message-ID: <43e72e890809131236v6b5893c1q16a11231c6131741@mail.gmail.com> (sfid-20080913_213654_024183_D3134CF9)
Date: Sat, 13 Sep 2008 12:36:45 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ingeideas@yahoo.com
Subject: Re: Bug report compat-wireless-2.6-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201197.56850.qm@web34804.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <201197.56850.qm@web34804.mail.mud.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 13, 2008 at 9:12 AM, Edgar Velasco <ingeideas@yahoo.com> wrote:
> I'm reporting a bug.
> Went I make, this is what I get:
>
> compat-wireless-2.6-old # make
> /root/compat-wireless-2.6-old/config.mk:30: *** "ERROR: There is a bug with compat-wireless on 2.6.22. Remove me if you want to fix me".  Stop.
>
> How can I fix it?
> Edgar Velasco

(keeping the subject now)

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
