Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57322 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbbE1NTD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 09:19:03 -0400
Message-ID: <1432819140.2459.6.camel@sipsolutions.net> (sfid-20150528_151906_693235_4011E0EC)
Subject: Re: [PATCH v2 1/2] nl80211: Add support to configure low ack
 threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 May 2015 15:19:00 +0200
In-Reply-To: <1432794355-3639-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1432794355-3639-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-28 at 11:55 +0530, Rajkumar Manoharan wrote:

> @@ -837,6 +839,7 @@ struct station_parameters {
>  	u8 supported_oper_classes_len;
>  	u8 opmode_notif;
>  	bool opmode_notif_used;
> +	u16 low_ack_threshold;

This cannot work, it leaves no way to detect "no change"; you need to
add that, document it and also implement it in the mac80211 patch.

johannes

