Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3859 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab1I0Hwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 03:52:30 -0400
Message-ID: <4E8180B0.2060202@broadcom.com> (sfid-20110927_095233_963853_272D64F3)
Date: Tue, 27 Sep 2011 09:52:16 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: jak@jak-linux.org
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: [PATCH 16/20] staging: brcm80211: declared global vars
 in softmac phy as const
References: <20110924095247.GA4156@jak-linux.org>
 <4E80B37C.4060106@broadcom.com>
In-Reply-To: <4E80B37C.4060106@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Julian,

>> diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
>> index 15c5ffc..1b11b2f 100644
>> --- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
>> +++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
>> @@ -1611,7 +1611,7 @@ const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
>>   	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
>>   	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
>>
>> -static const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
>> +const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
>>   	sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
>>   	sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);
>
> That seems like an anomaly. In a commit that is supposed
> to declare variables as const, the linkage of a variable
> changed.

The name of this commit could have been better. It should have been 
'fixed sparse warnings on variable usage in softmac phy'. For what it is 
worth: this variable is deleted in a later commit.

> Likewise, the removal of extern global variable
> declarations in phy_int.h also does not seem to belong
> here.

Agree.

The whole patch series will be resent anyway, let me split this commit 
up in two to address your feedback.

Thanks, Roland.

