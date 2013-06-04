Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab3FDOKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 10:10:52 -0400
Message-ID: <51ADF562.7050707@redhat.com> (sfid-20130604_161112_473222_DEABD475)
Date: Tue, 04 Jun 2013 10:10:42 -0400
From: John Greene <jogreene@redhat.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Joe Perches <joe@perches.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Reduce log spam in heavy tx, make err print
 in debug
References: <1370267259-19712-1-git-send-email-jogreene@redhat.com> <1370278476.2025.41.camel@joe-AO722> <51ACCD0E.10407@broadcom.com>
In-Reply-To: <51ACCD0E.10407@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2013 01:06 PM, Arend van Spriel wrote:
> On 06/03/2013 06:54 PM, Joe Perches wrote:
>> On Mon, 2013-06-03 at 09:47 -0400, John Greene wrote:
>>> Move message to debug mode to reduce log spam under heavy tx (iperf)
>>> load.
>> []
>>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>>> b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>> []
>>> @@ -900,7 +900,7 @@ brcms_c_ampdu_dotxstatus_complete(struct
>>> ampdu_info *ampdu, struct scb *scb,
>>>           if (supr_status) {
>>>               update_rate = false;
>>>               if (supr_status == TX_STATUS_SUPR_BADCH) {
>>> -                brcms_err(wlc->hw->d11core,
>>> +                brcms_dbg_ht(wlc->hw->d11core,
>>>                         "%s: Pkt tx suppressed, illegal channel
>>> possibly %d\n",
>>>                         __func__, CHSPEC_CHANNEL(
>>>                         wlc->default_bss->chanspec));
>>
>> net_ratelimited instead?
>
> Yes and only when driver debug level is set.
>
> Regards,
> Arend
>
>
Thanks for the ACK, Arend. And comments..live and learn.

Certainly they would be reasonable also.  Issue (confined to an 
annoyance level, hence the workaround) is why this comes up when the 
channel being flagged is the same as the one the AP I'm connected with 
is on. That is the root of the problem, more work needed on that point 
which probably would render this moot.



-- 
John Greene

