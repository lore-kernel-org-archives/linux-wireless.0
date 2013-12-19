Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3LSMf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 07:35:28 -0500
Message-ID: <1387456523.4298.8.camel@jlt4.sipsolutions.net> (sfid-20131219_133535_420198_B2B8142C)
Subject: Re: [PATCH] mac80211: remove unnecessary iflist_mtx locking
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sw@simonwunderlich.de
Date: Thu, 19 Dec 2013 13:35:23 +0100
In-Reply-To: <1387393315-15671-1-git-send-email-johannes@sipsolutions.net> (sfid-20131218_200202_219087_C4056ED1)
References: <1387393315-15671-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131218_200202_219087_C4056ED1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-18 at 20:01 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The radar detection code changed a few times, and due to
> the changes some iflist_mtx locking stayed in that isn't
> actually necessary - remove it.
> 
> One version of the code needed it because an AP interface's
> VLAN list was changed to use this, but then we moved the
> list handling outside of the chanctx handling and thus the
> locking was no longer needed.

Applied.

johannes

