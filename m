Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59978 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2APX4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 18:56:50 -0500
Received: by wibhm6 with SMTP id hm6so990655wib.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 15:56:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <86wr8rfbpf.fsf@sumi.keithp.com>
References: <86wr8rfbpf.fsf@sumi.keithp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 15:56:26 -0800
Message-ID: <CA+55aFwdHKhLXF+Utbk0A2jcshSeQmQ91YxBzvqSa3wXCKh8BA@mail.gmail.com> (sfid-20120117_005654_110173_E8113AEA)
Subject: Re: MBA resume wedge due to wireless fixed yet?
To: Keith Packard <keithp@keithp.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2012 at 3:51 PM, Keith Packard <keithp@keithp.com> wrote:
>
> I've been vaguely following the thread on netdev@ about the brcmsmac
> driver's adventures; am I missing something, or is this still supposed
> to break suspend/resume?

I have patches, but haven't committed them because I was kind of
expecting them to go through the wireless tree.

I *will* commit them before releasing -rc1 (either my own, or
hopefully a pull request from davem), and I can send you temporary
ones for now if you want to play around.

Actually, you're probably better off just picking them up from the
kernel mailing list, see for example

  http://www.spinics.net/lists/netdev/msg185722.html

(that's 1/5, and that is the one that fixes the actual bug that makes
things really not work - patches 2-5 are my fixes to not do insane
things, but I think #1 on its own is already sufficient for the
"doesn't resume" issue).

                       Linus
