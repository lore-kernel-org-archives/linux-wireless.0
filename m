Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3840 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3FCRGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:06:38 -0400
Message-ID: <51ACCD0E.10407@broadcom.com> (sfid-20130603_190641_371118_6697401C)
Date: Mon, 3 Jun 2013 19:06:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John Greene" <jogreene@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Reduce log spam in heavy tx, make err
 print in debug
References: <1370267259-19712-1-git-send-email-jogreene@redhat.com>
 <1370278476.2025.41.camel@joe-AO722>
In-Reply-To: <1370278476.2025.41.camel@joe-AO722>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2013 06:54 PM, Joe Perches wrote:
> On Mon, 2013-06-03 at 09:47 -0400, John Greene wrote:
>> Move message to debug mode to reduce log spam under heavy tx (iperf) load.
> []
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> []
>> @@ -900,7 +900,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
>>   		if (supr_status) {
>>   			update_rate = false;
>>   			if (supr_status == TX_STATUS_SUPR_BADCH) {
>> -				brcms_err(wlc->hw->d11core,
>> +				brcms_dbg_ht(wlc->hw->d11core,
>>   					  "%s: Pkt tx suppressed, illegal channel possibly %d\n",
>>   					  __func__, CHSPEC_CHANNEL(
>>   					  wlc->default_bss->chanspec));
>
> net_ratelimited instead?

Yes and only when driver debug level is set.

Regards,
Arend


