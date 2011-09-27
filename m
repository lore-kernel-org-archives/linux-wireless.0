Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1I0IIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 04:08:12 -0400
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com> (sfid-20110927_100337_790207_D4828C34)
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	 <1317109617.4082.0.camel@jlt3.sipsolutions.net>
	 <CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com>
	 (sfid-20110927_100337_790207_D4828C34)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 10:08:04 +0200
Message-ID: <1317110884.4082.5.camel@jlt3.sipsolutions.net> (sfid-20110927_100817_138962_F2E73263)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 12:03 +0400, Andrew V. Stepanov wrote:
> On Tue, Sep 27, 2011 at 11:46 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2011-09-27 at 14:33 +0400, Andrew V. Stepanov wrote:
> >> From: Andriy Stepanov <stanv@altlinux.ru>
> >>
> >> Use as:
> >> modprobe rfkill unblocked=1
> >> or
> >> /etc/modprobe.d/options
> >> options rfkill unblocked=1
> >
> > Apart from the obvious style problems in this patch (tons of extra
> > braces) I'm not convinced this is a good idea.
> >
> > What problem does it solve? Why can that problem not be solved
> > differently with existing mechanisms (e.g. urfkilld configured to do
> > nothing)?

> 2. urfkilld  can't be used to ignore Hard blocked buttons.

Oh that's a good point -- so NACK on the patch.

You *can't* ignore hard block buttons. All you can ignore is events from
them, which is definitely not useful.

johannes


