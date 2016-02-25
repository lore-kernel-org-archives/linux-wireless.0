Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40315 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268AbcBYQew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 11:34:52 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Oh, Peter" <poh@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: set MAC timestamp in management Rx frame
Date: Thu, 25 Feb 2016 16:34:45 +0000
Message-ID: <87k2lsd9zv.fsf@kamboji.qca.qualcomm.com> (sfid-20160225_173456_780343_80DCBAA2)
References: <4c705dc7a2c0aa857da4e6eaf6e8ed47c354b9ea.1456351768.git.poh@qca.qualcomm.com>
In-Reply-To: <4c705dc7a2c0aa857da4e6eaf6e8ed47c354b9ea.1456351768.git.poh@qca.qualcomm.com>
	(Peter Oh's message of "Wed, 24 Feb 2016 14:18:51 -0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Check and set Rx MAC timestamp when firmware indicates it.
> Firmware adds it in Rx beacon frame only at this moment.
> Driver and mac80211 may utilize it to detect such clockdrift
> or beacon collision and use the result for beacon collision
> avoidance.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
> ---
>
> v2:
> 	- fix kbuild test robot warning, left shift count >= width of type,
> 	at __le32_to_cpu(arg.ext_info.rx_mac_timestamp_u32) << 32
> v3:
> 	- correct ext_info to start 4-byte aligned
> 	- make struct wmi_mgmt_rx_ext_info 4-byte aligned to comply FW's intention.

I see new warnings:

drivers/net/wireless/ath/ath10k/wmi.c:2199:16: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: cast to restricted __le32
drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted __le32 degrades to integer

-- 
Kalle Valo