Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2JJIIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 04:08:15 -0400
Message-ID: <1349856525.4683.28.camel@jlt4.sipsolutions.net> (sfid-20121010_100820_273297_A6AC9234)
Subject: Re: [PATCH] mac80211: call drv_get_tsf() in sleepable context
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
Date: Wed, 10 Oct 2012 10:08:45 +0200
In-Reply-To: <1349485060-8643-2-git-send-email-thomas@cozybit.com> (sfid-20121006_025748_824596_57F12720)
References: <1349485060-8643-1-git-send-email-thomas@cozybit.com>
	 <1349485060-8643-2-git-send-email-thomas@cozybit.com>
	 (sfid-20121006_025748_824596_57F12720)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-05 at 17:57 -0700, Thomas Pedersen wrote:
> The call to drv_get/set_tsf() was put on the workqueue to perform tsf
> adjustments since that function might sleep. However it ended up inside
> a spinlock, whose critical section must be atomic. Do tsf adjustment
> outside the spinlock instead, and get rid of a warning.

Applied, thanks.

johannes

