Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49730 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbcCHRcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 12:32:16 -0500
From: "Oh, Peter" <poh@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: parse Rx MAC timestamp in mgmt frame for FW 10.4
Date: Tue, 8 Mar 2016 17:32:12 +0000
Message-ID: <56DF0C05.8050806@qca.qualcomm.com> (sfid-20160308_183220_236146_6645FE4C)
References: <1456513531-14528-1-git-send-email-poh@qca.qualcomm.com>
 <87a8m9s4dk.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a8m9s4dk.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 03/08/2016 01:31 AM, Valo, Kalle wrote:
> Peter Oh <poh@qca.qualcomm.com> writes:
>
>> Check and parse Rx MAC timestamp when firmware sets its flag
>> to status variable.
>> 10.4 firmware adds it in Rx beacon frame only at this moment.
>> Drivers and mac80211 may utilize it to detect such clockdrift
>> or beacon collision and use the result for beacon collision
>> avoidance.
>>
>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
> Like kbuild noticed this fails to build:
>
> drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_10_4_op_pull_mgmt_rx_ev':
> drivers/net/wireless/ath/ath10k/wmi.c:2236:40: error: 'WMI_RX_STATUS_EXT_INFO' undeclared (first use in this function)
> drivers/net/wireless/ath/ath10k/wmi.c:2236:40: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/wireless/ath/ath10k/wmi.c:2239:24: error: 'struct wmi_mgmt_rx_ev_arg' has no member named 'ext_info'
> drivers/net/wireless/ath/ath10k/wmi.c:2239:53: error: invalid application of 'sizeof' to incomplete type 'struct wmi_mgmt_rx_ext_info'
>
> Please resend.
Because it has dependency on " ath10k: set MAC timestamp in management 
Rx frame", but I didn't set its dependency.
Let me re-send this patch once after the parent commit is merged.

Thanks,
Peter