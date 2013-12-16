Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3LPURY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 15:17:24 -0500
Message-ID: <1387225035.2057.34.camel@jlt4.sipsolutions.net> (sfid-20131216_211728_758553_B98247C8)
Subject: Re: [PATCH v2] mac80211_hwsim: Fix NULL pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	danicamps81@yahoo.com
Date: Mon, 16 Dec 2013 21:17:15 +0100
In-Reply-To: <1387216867-26146-1-git-send-email-jlopex@cozybit.com> (sfid-20131216_190120_882745_86DB9122)
References: <1387216867-26146-1-git-send-email-jlopex@cozybit.com>
	 (sfid-20131216_190120_882745_86DB9122)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 10:01 -0800, Javier Lopez wrote:
> mac80211_hwsim was crashing when receiving tx information from user
> space. Crash happens because txi->rate_driver_data[0] is pointing to a
> non valid memory address.
> 
> This code path is only used by wmediumd and wmediumd doesn't provide
> multiple channel support, so we can pass the channel struct
> (data2->channel) directly to mac80211_hwsim_monitor_ack function.

Applied.

johannes

