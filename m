Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39545 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1AUKWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 05:22:48 -0500
Received: by iyj18 with SMTP id 18so1518707iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 02:22:48 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19769.24127.113716.558660@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 15:51:51 +0530
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] ath9k_htc: fix race conditions when stop device
In-Reply-To: <20110121061204.GA3041@redhat.com>
References: <20110121061204.GA3041@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka wrote:
> Similar fix I already posted for ath9k. When stopping device, disable
> interrupts, kill tasklets and then works, in correct order. Patch drop
> mutex in them middle of a function, which I don't like and can possibly
> not be correct. Perhaps this can be arranged differently. Also
> there is no synchronize_irq, which IMHO should be added somewhere in
> htc/wmi stop.

It should be okay if the work instances are canceled first before the mutex
is acquired. And I don't think synchronize_irq() is required since this is a USB driver.

But when the driver is loaded and unloaded without bringing the interface up,
stop() wouldn't be called at all, but I guess it's alright since no tasklet would
have been scheduled. So just moving the tasklet_kill() functions to stop() would
be fine. I tested with ath9k_htc and saw no issues.

Sujith
