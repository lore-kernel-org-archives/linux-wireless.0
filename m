Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56408 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbdBOIOB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 03:14:01 -0500
Message-ID: <1487146439.4026.10.camel@sipsolutions.net> (sfid-20170215_091404_540837_BCEB45CC)
Subject: Re: [PATCH 1/2] mac80211: use DECLARE_EWMA for mesh_fail_avg
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Wed, 15 Feb 2017 09:13:59 +0100
In-Reply-To: <1487104037-24941-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1487104037-24941-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 12:27 -0800, Rajkumar Manoharan wrote:
> As moving average is not considering fractional part, it
> will stuck at the same level after certain state. For example
> with current values, moving average stuck at 96 and it will
> not move forward. Fortunately current threshold is matching
> against 95%. If thresold is increased more than 96, mesh path
> never be deactivated under worst case. Fix failure average
> movement by using EWMA helpers.

Thanks, applied.

> +DECLARE_EWMA(mesh_fail_avg, 64, 8)

Since we only feed in small values (0-100), I picked a much larger
factor (1<<20) to give more precision here.

johannes
