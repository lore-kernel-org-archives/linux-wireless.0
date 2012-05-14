Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4074 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab2ENSJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 14:09:36 -0400
Message-ID: <4FB14A4D.1030002@qca.qualcomm.com> (sfid-20120514_200942_684389_F030AA80)
Date: Mon, 14 May 2012 21:09:17 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
CC: Joe Perches <joe@perches.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: enable enhanced bmiss detection
References: <1337017652-3962-1-git-send-email-c_tpeder@qca.qualcomm.com> <1337018219.29436.24.camel@joe2Laptop> <20120514180339.GA4030@pista>
In-Reply-To: <20120514180339.GA4030@pista>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2012 09:03 PM, Pedersen, Thomas wrote:
> On Mon, May 14, 2012 at 10:56:59AM -0700, Joe Perches wrote:
>
>> Why 2 messages when 1 message might do?
>>
>> 	err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
>> 					       vif->fw_vif_idx, enable);
>> 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
>> 		   "%s enhanced fw bmiss detection: %s\n",
>> 		   enable ? "enable" : "disable",
>> 		   err ? "OK" : "failed");
> 
> OK that seems nicer. Should we still print the error code, or maybe it
> doesn't really matter?

I missed this in the original review, but it's actually better to not
use ath6kl_dbg() for error messages. They are more difficult to notice
that way.

Or did you have a specific reason for using ath6kl_dbg()?

Kalle
