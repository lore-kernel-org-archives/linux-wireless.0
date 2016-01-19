Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46210 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354AbcASUL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 15:11:27 -0500
Message-ID: <1453234283.23600.5.camel@sipsolutions.net> (sfid-20160119_211149_760810_DD847120)
Subject: Re: [PATCH 1/8] rfkill: Documentation and style fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, jprvita@endlessm.com,
	linux@endlessm.com
Date: Tue, 19 Jan 2016 21:11:23 +0100
In-Reply-To: <1453218163-31998-2-git-send-email-jprvita@endlessm.com> (sfid-20160119_164405_325639_90B88BB3)
References: <1453218163-31998-1-git-send-email-jprvita@endlessm.com>
	 <1453218163-31998-2-git-send-email-jprvita@endlessm.com>
	 (sfid-20160119_164405_325639_90B88BB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  /**
>   * rfkill_resume_polling(struct rfkill *rfkill)
>   *
> - * Pause polling -- say transmitter is off for other reasons.
> + * Resume polling previously paused with rfkill_pause_polling.
>   * NOTE: not necessary for suspend/resume -- in that case the
> - * core stops polling anyway
> + * core restarts polling anyway, even if was explicitly paused
> + * before suspending.
>   */

If this is true, that's a bug, no? Drivers would call pause/resume when
their status changes, and shouldn't be required to check status at
resume time?

johannes
