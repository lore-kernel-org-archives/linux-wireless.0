Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63528 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1HKViP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 17:38:15 -0400
Received: by gya6 with SMTP id 6so1610712gya.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 14:38:14 -0700 (PDT)
Message-ID: <4E444BC2.40204@lwfinger.net> (sfid-20110811_233818_631531_F8CB49C6)
Date: Thu, 11 Aug 2011 16:38:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, jouni@qca.qualcomm.com
Subject: Re: [PATCH] cfg80211: fix a crash in nl80211_send_station
References: <1313024433-35053-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1313024433-35053-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2011 08:00 PM, Felix Fietkau wrote:
> mac80211 leaves sinfo->assoc_req_ies uninitialized, causing a random
> pointer memory access in nl80211_send_station.
> Instead of checking if the pointer is null, use sinfo->filled, like
> the rest of the fields.
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>

John,

I hope this patch will be added to wireless-testing soon. It is particularly 
insidious as it leads to kernel panics or spontaneous reboots. Note: the problem 
occurs even when the NIC is not being used as an AP.

Thanks,

Larry
