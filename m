Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18387 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbZCYMmH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:42:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 05:42:06 -0700
Date: Wed, 25 Mar 2009 18:11:53 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH V3] mac80211: Fix bug in getting rx status for frames
	pending in reorder buffer
Message-ID: <20090325124153.GB29348@vasanth-laptop> (sfid-20090325_134212_040029_32F25232)
References: <1237984249-7177-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1237984249-7177-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 06:00:49PM +0530, Vasanth Thiagarajan wrote:
> Currently rx status for frames which are completed from reorder buffer
> is taken from it's cb area which is not always right, cb is not holding
> the rx status when driver uses mac80211's non-irq rx handler to pass it's
> received frames. This results in dropping almost all frames from reorder
> buffer when security is enabled by doing double decryption (first in hw,
> second in sw because of wrong rx status). This patch copies rx status into
> cb area before the frame is put into reorder buffer. After this patch,
> there is a significant improvement in throughput with ath9k + WPA2(AES).
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Cc: stable@kernel.org
> ---

oops, forgot to add Acked by

vasanth
