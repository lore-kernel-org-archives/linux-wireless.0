Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35802 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0CLGhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 01:37:39 -0500
Received: by bwz1 with SMTP id 1so763695bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 22:37:37 -0800 (PST)
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] wl1251: fix potential crash
References: <1268322326-16721-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 12 Mar 2010 08:37:34 +0200
In-Reply-To: <1268322326-16721-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\, 11 Mar 2010 17\:45\:26 +0200")
Message-ID: <87mxyecafl.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> In case debugfs does not init for some reason (or is disabled
> on older kernels) driver does not allocate stats.fw_stats
> structure, but tries to clear it later and trips on a NULL
> pointer:
>
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000000
> PC is at __memzero+0x24/0x80
> Backtrace:
> [<bf0ddb88>] (wl1251_debugfs_reset+0x0/0x30 [wl1251])
> [<bf0d6a2c>] (wl1251_op_stop+0x0/0x12c [wl1251])
> [<bf0bc228>] (ieee80211_stop_device+0x0/0x74 [mac80211])
> [<bf0b0d10>] (ieee80211_stop+0x0/0x4ac [mac80211])
> [<c02deeac>] (dev_close+0x0/0xb4)
> [<c02deac0>] (dev_change_flags+0x0/0x184)
> [<c031f478>] (devinet_ioctl+0x0/0x704)
> [<c0320720>] (inet_ioctl+0x0/0x100)
>
> Add a NULL pointer check to fix this.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kalle.valo@iki.fi>

Thank you for all the patches.

-- 
Kalle Valo
