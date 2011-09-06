Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46469 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1IFHQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 03:16:40 -0400
Message-ID: <4E65C8D4.8030405@qca.qualcomm.com> (sfid-20110906_091643_874010_7C130B2B)
Date: Tue, 6 Sep 2011 10:16:36 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath6kl: Allow enabling of P2P support
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com> <1315233527-6234-5-git-send-email-jouni@qca.qualcomm.com> <4E65C49B.2000201@qca.qualcomm.com>
In-Reply-To: <4E65C49B.2000201@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2011 09:58 AM, Kalle Valo wrote:
> On 09/05/2011 05:38 PM, Jouni Malinen wrote:
>> +	if (ar->p2p) {
>> +		ret = ath6kl_wmi_info_req_cmd(ar->wmi,
>> +					      P2P_FLAG_CAPABILITIES_REQ |
>> +					      P2P_FLAG_MACADDR_REQ |
>> +					      P2P_FLAG_HMODEL_REQ);
>> +		if (ret) {
>> +			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to request P2P "
>> +				   "capabilities (%d) - assuming P2P not "
>> +				   "supported\n", ret);
>> +			ar->p2p = 0;
>> +		}
>> +	}
>> +
>> +	if (ar->p2p) {
> 
> Can we combine this if block with the first one?

Forget this comment. I was blind and didn't see 'ar->p2p = 0'.

Kalle
