Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59543 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbZG2UQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 16:16:03 -0400
Date: Wed, 29 Jul 2009 16:00:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: redefine usage of the mac80211 workqueue
Message-ID: <20090729200036.GA10056@tuxdriver.com>
References: <1248733291-10848-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1248733291-10848-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 03:21:31PM -0700, Luis R. Rodriguez wrote:
> The mac80211 workqueue exists to enable mac80211 and drivers
> to queue their own work on a single threaded workqueue. mac80211
> takes care to flush the workqueue during suspend but we never
> really had requirements on drivers for how they should use
> the workqueue in consideration for suspend.
> 
> We extend mac80211 to document how the mac80211 workqueue should
> be used, how it should not be used and finally move raw access to
> the workqueue to mac80211 only. Drivers and mac80211 use helpers
> to queue work onto the mac80211 workqueue:
> 
>   * ieee80211_queue_work()
>   * ieee80211_queue_delayed_work()
> 
> These helpers will now warn if mac80211 already completed its
> suspend cycle and someone is trying to queue work. mac80211
> flushes the mac80211 workqueue prior to suspend a few times,
> but we haven't taken the care to ensure drivers won't add more
> work after suspend. To help with this we add a warning when
> someone tries to add work and mac80211 already completed the
> suspend cycle.
> 
> Drivers should ensure they cancel any work or delayed work
> in the mac80211 stop() callback.

How are they supposed to do that after you've removed workqueue
from the ieee80211_hw structure?  This breaks the compilation of
at76c50x-usb.c...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
