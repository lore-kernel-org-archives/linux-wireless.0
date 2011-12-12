Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLJCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:02:30 -0500
Subject: Re: [RFC] mac80211: Prevent possible BUG on suspend.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYgLHP2WmcuMFh6fzih-NKO8Brvpbeeb2uunZQydYYmNLw@mail.gmail.com> (sfid-20111212_003850_667575_028C8B2F)
References: <CAMG6FYgLHP2WmcuMFh6fzih-NKO8Brvpbeeb2uunZQydYYmNLw@mail.gmail.com>
	 (sfid-20111212_003850_667575_028C8B2F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:02:27 +0100
Message-ID: <1323680547.3442.6.camel@jlt3.sipsolutions.net> (sfid-20111212_100235_106629_42576AB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 00:38 +0100, Dmitry Tarnyagin wrote:
> PM code has a watchdog to trigger a BUG when suspend callback
> is not returning in several seconds. Some WLAN hardware has
> longer timeouts for non-interruptible configuration-related
> operations, leading to the watchdog timeout while
> ieee80211_scan_cancel is waiting on a mutex.

Yuck, fix the device?

> The patch checks if interface mutex is already held and rejects
> suspend if there is a possibility of locking.

That's really not a good plan. This will refuse suspend *all the time*.

johannes


