Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2403 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaHLJQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 05:16:05 -0400
Message-ID: <53E9DB52.7040008@broadcom.com> (sfid-20140812_111610_264828_EBFE1F29)
Date: Tue, 12 Aug 2014 11:16:02 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()
References: <1407752997-12382-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1407769025.9844.0.camel@jlt4.sipsolutions.net> <53E9CF20.8030500@broadcom.com> <1510813.tvyqjS7Sdn@lx-wigig-72>
In-Reply-To: <1510813.tvyqjS7Sdn@lx-wigig-72>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2014 11:07 AM, Vladimir Kondratiev wrote:
> On Tuesday, August 12, 2014 10:24:00 AM Arend van Spriel wrote:
>> the cfg80211_rx_mgmt() call could be done with GFP_KERNEL flag in
>> brcmfmac.
> No, you can't. In the cfg80211_rx_mgmt(), @gfp used for memory allocation under
> spinlock. So, it is done while in_atomic() is true. One can't use waiting GFP_KERNEL
> in this case. Quote from cfg80211_rx_mgmt() (see net/wireless/mlme.c):
>
> 	spin_lock_bh(&wdev->mgmt_registrations_lock);
> <skip>
> 	list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
> 		/* Indicate the received Action frame to user space */
> 		if (nl80211_send_mgmt(rdev, wdev, reg->nlportid,
> 				      freq, sig_mbm,
> 				      buf, len, flags, gfp))
> 			continue;
>
> 		result = true;
> 		break;
> 	}
>
> 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
>

Those spinlock calls did not show in your patch so I missed that. Thanks 
for clarifying.

Regards,
Arend
