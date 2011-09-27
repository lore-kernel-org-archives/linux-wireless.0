Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1I0MAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 08:00:21 -0400
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAN8FffrnCt6TL-dWBJtnOpk=oELRXhnU0ksHntFWfbPo5mgWaA@mail.gmail.com> (sfid-20110927_135107_890107_00098EE0)
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	 <1317109617.4082.0.camel@jlt3.sipsolutions.net>
	 <CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com>
	 <1317110884.4082.5.camel@jlt3.sipsolutions.net>
	 <CAN8FffqjeurgAvVHtMExgeAyBHRWznYBz2c043jcZgOmqw6TVg@mail.gmail.com>
	 <1317113699.4082.7.camel@jlt3.sipsolutions.net>
	 <CAN8FffrZuGu63oL7ZL8EjjdNqBaPDU6KHuatwrbNB0SjffvaTg@mail.gmail.com>
	 <1317121681.4082.8.camel@jlt3.sipsolutions.net>
	 <CAN8FffrnCt6TL-dWBJtnOpk=oELRXhnU0ksHntFWfbPo5mgWaA@mail.gmail.com>
	 (sfid-20110927_135107_890107_00098EE0)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 14:00:13 +0200
Message-ID: <1317124813.4082.29.camel@jlt3.sipsolutions.net> (sfid-20110927_140024_010708_86658157)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 15:50 +0400, Andrew V. Stepanov wrote:

> 1.
> 
> Lenovo ThinkPad x201i has two rfkill buttons.
> One soft: Fn-F5.
> Second hard: small switch on left case side.
> 
> With RFKILL_CONFIG == "is not set" this two buttons became inactive.
> They do not has any influence to adapter\drivers state.

Then the hard one isn't actually a hard button. The typical hard button
is a switch that is wired directly to the mini-pcie slot and
enables/disables the card via a GPIO line on the card. This is reported
as a hard even *through the wifi card*. Nothing you can do about it in
those cases.

> This patch give ability disable rfkill sub-system by means to pass
> special module parameter.

Because the platform driver is doing the wrong thing.

> Example from real life. Some company want to make inactive rfkill
> SW+HW buttons on some company notebooks.
> For this, you advise to recompile kernel.

No, you need to fix the thinkpad driver.

> 2.
> 
> One more thing, why this patch is necessary. You advise to use
> urfkilld. But this is doesn't help in case of external USB WIFI
> devices.
> 
> Turn on(off) HW button will be effect on all WIFI devices, even
> external. rfkill kernel subsystem will bring all cfg80211 devices to
> software lock. See: net/wireless/core.c for rfkill. I do not think,
> that urfkilld will help.

No, it will not. It doesn't work that way. A hard switch in one wifi
device doesn't impact any other devices unless you use urfkilld or
RFKILL_INPUT.

johannes

