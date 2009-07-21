Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40624 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZGUJKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 05:10:21 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, luciano.coelho@nokia.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wireless: wl12xx, fix lock imbalance
References: <1247603833-10862-1-git-send-email-jirislaby@gmail.com>
	<87eish56zj.fsf@litku.valot.fi> <4A64E199.70501@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 21 Jul 2009 12:10:14 +0300
In-Reply-To: <4A64E199.70501@gmail.com> (Jiri Slaby's message of "Mon\, 20 Jul 2009 23\:28\:57 +0200")
Message-ID: <877hy2qu4p.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby <jirislaby@gmail.com> writes:

> But currently I'm confused by wl1251_plt_start and wl1251_plt_stop.
> They take a lock but doesn't unlock it at all. Neither their callies.
> Is it hidden somewhere deeper?

I guess that's a bug which creeped in when I ported the patches from our
internal tree. I'll just remove plt start/stop functions altogether,
they need to ported to the new nl80211 test mode interface anyway.

Oh damn, I just noticed that I added wl1251_netlink.c accidentally to
wireless-testing tree. It should definitely not be there, instead we
need to use nl80211 test command interface. I'll send a patch to remove
the private netlink stuff soon. John, sorry about this.

-- 
Kalle Valo
