Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36184 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbaJ2KXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 06:23:11 -0400
From: Junjie Mao <eternal.n08@gmail.com>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: Junjie Mao <eternal.n08@gmail.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: release driver when ieee80211_register_hw fails
References: <1414459907-7509-1-git-send-email-eternal.n08@gmail.com>
	<20141029064501.GB2985@piware.de>
Date: Wed, 29 Oct 2014 18:23:02 +0800
In-Reply-To: <20141029064501.GB2985@piware.de> (Martin Pitt's message of "Wed,
	29 Oct 2014 07:45:01 +0100")
Message-ID: <8638a718ft.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me> (sfid-20141029_112342_294770_37A0CECB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was not familiar with the acquiring/releasing API either, until I met
with this bug...

Perhaps we can use static checkers to avoid these issues as early as
possible. Any suggestions?

Best Regards
Junjie Mao

Martin Pitt <martin.pitt@ubuntu.com> writes:

> Acked-By: Martin Pitt <martin.pitt@ubuntu.com>
>
> Hello Junjie,
>
> Junjie Mao [2014-10-28  9:31 +0800]:
>> The driver is not released when ieee80211_register_hw fails in
>> mac80211_hwsim_create_radio, leading to the access to the unregistered (and
>> possibly freed) device in platform_driver_unregister:
>
> Many thanks for fixing this! Sorry about that, I don't know these bits
> very well.
>
> Martin
