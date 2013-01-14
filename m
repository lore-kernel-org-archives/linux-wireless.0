Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37879 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab3ANHTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 02:19:00 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Eugene <wifi.mailing.list@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Custom commands for cfg80211 based driver (like iwpriv)
References: <CAMvjH0A69ZBCZc5qjm_cUYj3bDzSmneaz1u9CsPcJEm2T0Q1iw@mail.gmail.com>
Date: Mon, 14 Jan 2013 09:18:59 +0200
In-Reply-To: <CAMvjH0A69ZBCZc5qjm_cUYj3bDzSmneaz1u9CsPcJEm2T0Q1iw@mail.gmail.com>
	(Eugene's message of "Fri, 11 Jan 2013 13:32:05 +0200")
Message-ID: <87txqkz0yk.fsf@purkki.adurom.net> (sfid-20130114_081904_757229_F6C436AF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eugene <wifi.mailing.list@gmail.com> writes:

> How to add custom configuration command for cfg80211 based driver.
>
> For WEXT was private IOCtls (iwpriv).
>
> What the recommended way for nl80211/cfg80211?

Luckily private commands are now banned, it was such a mess. Now you add
a new generic command to nl80211/cfg80211 so that all drivers can use
it. The benefit is that the driver can be changed without any
modifications to user space.

Only exceptions are NL80211_CMD_TESTMODE for low level factory/RF tests
and debugfs for developer debugging purposes.

-- 
Kalle Valo
