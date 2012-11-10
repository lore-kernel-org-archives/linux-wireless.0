Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34156 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2KJImh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2012 03:42:37 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so3283717pad.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2012 00:42:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20638.4969.882578.804342@gargle.gargle.HOWL> (sfid-20121110_094314_950443_6D17A3D2)
Date: Sat, 10 Nov 2012 14:12:17 +0530
To: Bernhard Urban <lewurm@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, linville@tuxdriver.com, markus@indoo.rs
Subject: [PATCH] ath9k_htc: update RSSI values only when the device is associated
In-Reply-To: <1352480966-17462-1-git-send-email-lewurm@gmail.com>
References: <1352480966-17462-1-git-send-email-lewurm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bernhard Urban wrote:
> add an if-guard, otherwise iw(8) reports weird signal strengths.
> 
> The behaviour was fine before this commit:
> 7c277349ecbd66e19fad3d949fa6ef6c131a3b62
> This patch is therefore a partially revert of it.
> 
> Tested with "TP-Link TL-WN722N"

Looks good, but a cleaner fix would be to update the RSSI only for
beacons that are destined for the station.

Sujith
