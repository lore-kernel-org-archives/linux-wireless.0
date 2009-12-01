Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42088 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbZLAIZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 03:25:16 -0500
Received: by bwz27 with SMTP id 27so3212520bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 00:25:22 -0800 (PST)
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: Fix dynamic power save for scanning.
References: <1259580053-19699-1-git-send-email-vnatarajan@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 10:25:20 +0200
In-Reply-To: <1259580053-19699-1-git-send-email-vnatarajan@atheros.com> (Vivek Natarajan's message of "Mon\, 30 Nov 2009 16\:50\:53 +0530")
Message-ID: <87ljhn6qz3.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vnatarajan@atheros.com> writes:

> Not only ps_sdata but also IEEE80211_CONF_PS is to be considered
> before restoring PS in scan_ps_disable(). For instance, when ps_sdata
> is set but CONF_PS is not set just because the dynamic timer is still
> running, a sw scan leads to setting of CONF_PS in scan_ps_disable
> instead of restarting the dynamic PS timer.
> Also for the above case, a null data frame is to be sent after
> returning to operating channel which was not happening with the
> current implementation. This patch fixes this too.

Thanks, looks good now. 

> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

Unfortunately I didn't have time to test this.

-- 
Kalle Valo
