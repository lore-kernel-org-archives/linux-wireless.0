Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54863 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1DATWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 15:22:04 -0400
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] wl1251: Prepare for idle mode support
References: <1301576643-29224-1-git-send-email-jhnikula@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 01 Apr 2011 22:22:01 +0300
In-Reply-To: <1301576643-29224-1-git-send-email-jhnikula@gmail.com> (Jarkko Nikula's message of "Thu\, 31 Mar 2011 16\:04\:02 +0300")
Message-ID: <87aag9srom.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jarkko Nikula <jhnikula@gmail.com> writes:

> RFC for WL1251 idle mode support brought a few issues that are worth to
> update before adding the idle mode support.
>

[...]

> Then enum wl1251_cmd_ps_mod in cmd.h is renamed and moved to wl1251.h as it
> is a state rather than chip level command.

But now you are moving a firmware interface value outside cmd.h. I was
thinking that you would touch wl1251_cmd_ps_mod at all, instead just
create a new enum wl1251_station_mode which will be used as the driver
state variable.

That way it's clear which enum is for the firmware interface and which
one is an internal variable.

To make it even more clear we could change the function to this:

int wl1251_cmd_ps_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mod mode);

Otherwise patch looks very good to me.

-- 
Kalle Valo
