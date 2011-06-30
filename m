Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34609 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab1F3Hur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 03:50:47 -0400
Received: by eyx24 with SMTP id 24so671881eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 00:50:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309411961-3267-1-git-send-email-coelho@ti.com>
References: <1309411961-3267-1-git-send-email-coelho@ti.com>
Date: Thu, 30 Jun 2011 08:50:46 +0100
Message-ID: <BANLkTi=ovDF4t9AkpyzKoiSnrdZoypA6gw@mail.gmail.com> (sfid-20110630_095110_214840_AEE3C372)
Subject: Re: [PATCH 3.0] cfg80211: fix deadlock with rfkill/sched_scan by
 adding new mutex
From: Duane Griffin <duaneg@dghda.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 June 2011 06:32, Luciano Coelho <coelho@ti.com> wrote:
> There was a deadlock when rfkill-blocking a wireless interface,
> because we were locking the rdev mutex on NETDEV_GOING_DOWN to stop
> sched_scans that were eventually running.  The rfkill block code was
> already holding a mutex under rdev:

It has survived several software and hardware rfkills here, so looks
good to me, thanks!

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
