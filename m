Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55611 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbcCSJ5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 05:57:07 -0400
Message-ID: <1458381422.12902.1.camel@sipsolutions.net> (sfid-20160319_105712_394809_F0DF6BBE)
Subject: Re: [PATCH 2/5] mac80211: add an option to not disconnect on beacon
 loss
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Date: Sat, 19 Mar 2016 10:57:02 +0100
In-Reply-To: <1458222099-30301-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1458222099-30301-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-17 at 15:41 +0200, Emmanuel Grumbach wrote:

>  	ifmgd->probe_send_count = 0;
> +	sdata->u.mgd.flags &= ~IEEE80211_STA_BEACON_LOSS_REPORTED;

This is very racy, concurrent RX will corrupt the flags value since
this requires a read-modify-write and cannot be done with locking.

I can't apply this.

johannes
