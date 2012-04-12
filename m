Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47013 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2DLG4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 02:56:35 -0400
Message-ID: <4F867C9D.9070603@qca.qualcomm.com> (sfid-20120412_085706_022693_7A816DCC)
Date: Thu, 12 Apr 2012 09:56:29 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] ath6kl: handle concurrent AP-STA channel switches
References: <1333744548-18028-1-git-send-email-c_tpeder@qca.qualcomm.com> <1333744548-18028-2-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1333744548-18028-2-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/2012 11:35 PM, Thomas Pedersen wrote:
> If an ath6kl AP vif is beaconing on one channel, and a STA vif
> associates on a different channel, a WMI_DISCONNECT event will be sent
> to the AP vif. Make the AP vif follow the STA interface, and notify
> userspace.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied. But there was a sparse warning:

drivers/net/wireless/ath/ath6kl/main.c:599:24: warning: incorrect type
in assignment (different base types)
drivers/net/wireless/ath/ath6kl/main.c:599:24:    expected unsigned
short [unsigned] [usertype] next_chan
drivers/net/wireless/ath/ath6kl/main.c:599:24:    got restricted __le16
[usertype] <noident>

I fixed it like this:

	vif->next_chan = channel;
	vif->profile.ch = cpu_to_le16(channel);

Please check my changes.

Kalle
