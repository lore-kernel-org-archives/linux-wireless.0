Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46149 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbYHAC6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 22:58:16 -0400
Message-ID: <48927BCA.1030805@lwfinger.net> (sfid-20080801_045822_620074_0A13DF4D)
Date: Thu, 31 Jul 2008 21:58:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH V3] rtl8187: Fix lockups due to concurrent access to config
 routine
References: <48925938.27Ki5NWyw4NzKtNf%Larry.Finger@lwfinger.net> <3ace41890807311929w464c41femf30efc5441830d13@mail.gmail.com>
In-Reply-To: <3ace41890807311929w464c41femf30efc5441830d13@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> Thanks for the work. I think we need a few more mutex locks.

I tried two other places: rtl8187_tx() and rtl8187_configure_filter. Both 
generated warnings as mac80211 had already had a lock in place. So far, I 
haven't seen any candidates, but the code surely needs a thorough audit.

> The one-line message/explanation is a bit mis-worded though. There isn't a
> "lockup" though. I would describe the problem as the driver's internal
> state getting garbbaged. It is probably a performance "feature" that
> routines in either the mac80211 layer or the usb layer returns before
> they are done. (i.e. actions are simply
> queued for near-future to act on). Maybe somebody else can explain this better?

The comment in the code that "the card will stop work until next reset" sounds 
as though it locks up. That was why I chose the wording that I did.

Larry

