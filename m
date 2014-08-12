Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29630 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaHLJH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 05:07:58 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()
Date: Tue, 12 Aug 2014 02:07:51 -0700
Message-ID: <1510813.tvyqjS7Sdn@lx-wigig-72> (sfid-20140812_110807_049591_5275E594)
In-Reply-To: <53E9CF20.8030500@broadcom.com>
References: <1407752997-12382-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1407769025.9844.0.camel@jlt4.sipsolutions.net> <53E9CF20.8030500@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, August 12, 2014 10:24:00 AM Arend van Spriel wrote:
> the cfg80211_rx_mgmt() call could be done with GFP_KERNEL flag in 
> brcmfmac.
No, you can't. In the cfg80211_rx_mgmt(), @gfp used for memory allocation under
spinlock. So, it is done while in_atomic() is true. One can't use waiting GFP_KERNEL
in this case. Quote from cfg80211_rx_mgmt() (see net/wireless/mlme.c):

	spin_lock_bh(&wdev->mgmt_registrations_lock);
<skip>
	list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
		/* Indicate the received Action frame to user space */
		if (nl80211_send_mgmt(rdev, wdev, reg->nlportid,
				      freq, sig_mbm,
				      buf, len, flags, gfp))
			continue;

		result = true;
		break;
	}

	spin_unlock_bh(&wdev->mgmt_registrations_lock);

