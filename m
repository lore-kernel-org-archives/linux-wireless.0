Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6337 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbcCHJbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 04:31:15 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Oh, Peter" <poh@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: parse Rx MAC timestamp in mgmt frame for FW 10.4
Date: Tue, 8 Mar 2016 09:31:11 +0000
Message-ID: <87a8m9s4dk.fsf@kamboji.qca.qualcomm.com> (sfid-20160308_103134_317913_0685D454)
References: <1456513531-14528-1-git-send-email-poh@qca.qualcomm.com>
In-Reply-To: <1456513531-14528-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Fri, 26 Feb 2016 11:05:31 -0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Check and parse Rx MAC timestamp when firmware sets its flag
> to status variable.
> 10.4 firmware adds it in Rx beacon frame only at this moment.
> Drivers and mac80211 may utilize it to detect such clockdrift
> or beacon collision and use the result for beacon collision
> avoidance.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Like kbuild noticed this fails to build:

drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_10_4_op_pull_mgmt_rx_ev':
drivers/net/wireless/ath/ath10k/wmi.c:2236:40: error: 'WMI_RX_STATUS_EXT_INFO' undeclared (first use in this function)
drivers/net/wireless/ath/ath10k/wmi.c:2236:40: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/wireless/ath/ath10k/wmi.c:2239:24: error: 'struct wmi_mgmt_rx_ev_arg' has no member named 'ext_info'
drivers/net/wireless/ath/ath10k/wmi.c:2239:53: error: invalid application of 'sizeof' to incomplete type 'struct wmi_mgmt_rx_ext_info' 

Please resend.

-- 
Kalle Valo