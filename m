Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55473 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2DZLqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 07:46:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120425.163926.2209040699696617525.davem@davemloft.net>
References: <20120425191418.GC16900@tuxdriver.com> <20120425.163926.2209040699696617525.davem@davemloft.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 26 Apr 2012 04:46:34 -0700
Message-ID: <CAB=NE6Xqi42GgDRHg-oPuLgofXYGpBrLm-YPa+AfyQ+NhsK3ww@mail.gmail.com> (sfid-20120426_134700_056946_D66CEACA)
Subject: Re: pull request: wireless-next 2012-04-25
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2012 at 1:39 PM, David Miller <davem@davemloft.net> wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 25 Apr 2012 15:14:19 -0400
>
>> This is another batch of updates intended for 3.5...
>  ...
>> Please let me know if there are problems!
>
> There are:
>
> From 792545c7bc5d6b922d3778dc602e557d64c83551 Mon Sep 17 00:00:00 2001
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> Date: Mon, 23 Apr 2012 19:55:48 -0700
> Subject: [PATCH 88/88] libertas: include sched.h on firmware.c
>
> Do not assume we have our subsystem including this for us,
> at least for older kernels this is not true. Lets just be
> explicit about this requirement for the usage of wake_up().
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> This is bogus, wake_up() is defined in linux/wait.h, the whole
> point of the linux/sched.h split up is so that linux/sched.h
> includes could be removed and replaced with actual dependencies.
>
> Also, please don't accept any patches from Luis that add those
> #undef pr_fmt things to the atheros drivers.
>
> He tried to add it an ethernet driver, and I asked him to explain
> exactly why he's doing and that if it's appropriate then it's
> appropriate everywhere not just in a few specific drivers.  He failed
> to respond to me, and therefore failed to explain the situation and
> address my concerned.  And then I saw just today that he's submitting
> the same patch to wireless drivers.  That's not acceptable.

Sorry about that, I missed your reply, will dig it up and reply.

  Luis
