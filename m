Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46216 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619Ab2GROqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 10:46:10 -0400
Received: by lbom4 with SMTP id m4so2323817lbo.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 07:46:06 -0700 (PDT)
Message-ID: <1342622762.5363.41.camel@cumari.coelho.fi> (sfid-20120718_164614_413634_C6E66CBE)
Subject: Re: [PATCH] cfg80211: Fix mutex locking in
 reg_last_request_cell_base
From: Luciano Coelho <coelho@ti.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Date: Wed, 18 Jul 2012 17:46:02 +0300
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
> ---

Tested-by: Luciano Coelho <coelho@ti.com>

This actually also fixes a similar circular lock dependency bug when
starting AP mode with hostapd (which is the case I tested this patch
on): http://pastebin.com/AVczE1Ej

--
Luca.

