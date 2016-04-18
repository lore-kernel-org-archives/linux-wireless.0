Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36090 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbcDRSMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 14:12:42 -0400
Received: by mail-yw0-f174.google.com with SMTP id o66so212029471ywc.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 11:12:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgV_W6uJF5DR43XdqvHPgBha1AfALYXcX4Lj=4jkO8TftQ@mail.gmail.com>
References: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
	<CAGRGNgV_W6uJF5DR43XdqvHPgBha1AfALYXcX4Lj=4jkO8TftQ@mail.gmail.com>
Date: Mon, 18 Apr 2016 11:12:41 -0700
Message-ID: <CALupW3CsuSGy=xBw-Wj5FfD+ALKBGi9xvi=Z8+YTdL9mGku5HQ@mail.gmail.com> (sfid-20160418_201245_613885_7D153DFE)
Subject: Re: [PATCH] ath6kl: Add ability to set debug uart baud rate
From: Steve deRosier <derosier@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thanks for looking at the patch.

On Sun, Apr 17, 2016 at 5:07 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Steve,
>
> This looks like it's using standard serial rates. Does it accept
> non-standard rates? If not, should this be checked before being passed
> to the hardware?
>

It should use standard serial rates, and obviously I defaulted it to a
sensible one. However, there's nothing that prevents you from using
odd and arbitrary rates in the firmware and it should just suck it in
and use it. In other words, the firmware will happily try to set 9507
baud if you tell it to.

This is specifically for debugging and working with the firmware and
IMHO, if you are using this feature and feel a need to set it to
something weird, I think the user should be allowed to. If you know
enough to be able to shoot yourself in the foot with this, then you
should know enough of what you should or shouldn't do and should be
allowed to. It's a debugging tool only and I don't see any reason to
waste lines in the driver to validate this input.

That's my perspective on the issue, but I recognize other opinions may
differ. Or you may know of a specific chip where it does matter (the
6003s and 6004s I'm using don't seem to care). If you or Kalle insist
on it, I'll be happy to add in some value checking for this parameter.
It just doesn't seem worth-while to me.

- Steve
