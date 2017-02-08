Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41196 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752142AbdBHIah (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 03:30:37 -0500
Message-ID: <1486542634.4603.9.camel@sipsolutions.net> (sfid-20170208_093157_173239_83B1175A)
Subject: Re: [PATCH v2 1/3] mac80211: fix mesh moving average stuck
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Wed, 08 Feb 2017 09:30:34 +0100
In-Reply-To: <1485893272-6893-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1485893272-6893-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-31 at 12:07 -0800, Rajkumar Manoharan wrote:
> As moving average is not considering fractional part after
> certain ratio, it will stuck at the same state. For example
> with current values, moving average stuck at 96 and it will
> not move forward. Fortunately current threshold is matching
> against 95%. If thresold is increased more than 96, mesh path
> never be deactivated under worst case. Fix failure average
> movement by bumping up average at stuck state.

This is ... really strange to me.

Can't we just actually take into account fractional parts instead?

I think you should instead convert this to the EMWA helpers (see
include/linux/average.h).

johannes
