Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaATKZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:25:30 -0500
Message-ID: <1390213525.4335.2.camel@jlt4.sipsolutions.net> (sfid-20140120_112534_246364_7BB7F738)
Subject: Re: [PATCH] mac80211: add check on hw->max_signal value on
 ieee80211_register_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: andrea merello <andrea.merello@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Larry.Finger@lwfinger.net
Date: Mon, 20 Jan 2014 11:25:25 +0100
In-Reply-To: <1390166509-3992-1-git-send-email-andrea.merello@gmail.com> (sfid-20140119_222350_487679_17C01C40)
References: <1390166509-3992-1-git-send-email-andrea.merello@gmail.com>
	 (sfid-20140119_222350_487679_17C01C40)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-01-19 at 22:21 +0100, andrea merello wrote:
> When IEEE80211_HW_SIGNAL_UNSPEC is set, mac80211 will perform a
> division by max_signal in ieee80211_bss_info_update. If max_signal
> is not properly set by the driver (for example it is zero) this
> leads to a divide error and crash.
> Thanks to Larry Finger, who pointed me to this.
> This patch adds in ieee80211_register_hw one more check to detect
> this condition and eventually returns -EINVAL, as already done for
> other checks already performed there.

Applied.

johannes

