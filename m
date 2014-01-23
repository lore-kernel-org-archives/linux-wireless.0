Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaAWPfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:35:45 -0500
Message-ID: <1390491332.4142.18.camel@jlt4.sipsolutions.net> (sfid-20140123_163549_361748_3A8C8D60)
Subject: Re: [PATCH] mac80211: avoid deadlock revealed by lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 23 Jan 2014 16:35:32 +0100
In-Reply-To: <1390480096-15150-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1390480096-15150-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 14:28 +0200, Emmanuel Grumbach wrote:
> sdata->u.ap.request_smps_work can’t be flushed synchronously
> under wdev_lock(wdev) since ieee80211_request_smps_ap_work
> itself locks the same lock.

Applied.

johannes

