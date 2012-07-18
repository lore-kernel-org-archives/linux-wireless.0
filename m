Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2GRPE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 11:04:27 -0400
Message-ID: <1342623865.5310.9.camel@jlt3.sipsolutions.net> (sfid-20120718_170430_371940_92F3D1F1)
Subject: Re: [PATCH] cfg80211: Fix mutex locking in
 reg_last_request_cell_base
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Date: Wed, 18 Jul 2012 17:04:25 +0200
In-Reply-To: <1342615289-3088-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1342615289-3088-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-18 at 18:11 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> should fix the following issue
> 
> 	[ 3229.815012] [ BUG: lock held when returning to user space! ]
> 	[ 3229.815016] 3.5.0-rc7-wl #28 Tainted: G        W  O
> 	[ 3229.815017]
> 	------------------------------------------------
> 	[ 3229.815019] wpa_supplicant/5783 is leaving the kernel with locks still held!
> 	[ 3229.815022] 1 lock held by wpa_supplicant/5783:
> 	[ 3229.815023]  #0: (reg_mutex){+.+.+.}, at: [<fa65834d>]
> 	reg_last_request_cell_base+0x1d/0x60 [cfg80211]
> 
> Cc: Luis Rodriguez <mcgrof@gmail.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Applied, thanks

johannes

