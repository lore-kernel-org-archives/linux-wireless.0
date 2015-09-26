Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39145 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbbIZRxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 13:53:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH] mwifiex: control WLAN and bluetooth coexistence modes
References: <1439546371-3218-1-git-send-email-akarwar@marvell.com>
Date: Sat, 26 Sep 2015 20:53:11 +0300
In-Reply-To: <1439546371-3218-1-git-send-email-akarwar@marvell.com> (Amitkumar
	Karwar's message of "Fri, 14 Aug 2015 02:59:31 -0700")
Message-ID: <8737y1dq48.fsf@kamboji.qca.qualcomm.com> (sfid-20150926_195322_774761_F66B7201)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> By default our chip will be in spatial coexistence mode.
> This patch adds a provision to change it to timeshare mode
> via sysfs command.
>
> Enable timeshare coexistence mode
>    echo 1 > /sys/class/net/mlan0/timeshare_coex
>
> Go back to spacial coexistence mode
>    echo 0 > /sys/class/net/mlan0/timeshare_coex
>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>

Is sysfs acceptable for this? Don't other drivers use debugfs to control
coexist?

But IMHO we really need an nl80211 command to do this, this has been a
recurring issue for years :)

-- 
Kalle Valo
