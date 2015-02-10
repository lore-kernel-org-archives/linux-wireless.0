Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbbBJNxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 08:53:42 -0500
Message-ID: <54DA0D17.7070403@canonical.com> (sfid-20150210_145402_585108_F00DE65E)
Date: Tue, 10 Feb 2015 13:52:23 +0000
From: Colin Ian King <colin.king@canonical.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>,
	Eric Dumazet <eric.dumazet@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: ratelimit skb allocation failure message
References: <1423558471-27278-1-git-send-email-colin.king@canonical.com>	<1423574228.28434.22.camel@edumazet-glaptop2.roam.corp.google.com> <87a90lop1x.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a90lop1x.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/15 13:48, Kalle Valo wrote:
> Eric Dumazet <eric.dumazet@gmail.com> writes:
> 
>> On Tue, 2015-02-10 at 08:54 +0000, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> when running low on memory I noticed rtlwifi was producing a large
>>> quantity of repeated skb allocation failures messages.  This should
>>> be ratelimited to reduce the noise.
>>>
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>  drivers/net/wireless/rtlwifi/pci.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
>>> index c70efb9..ca0fd50 100644
>>> --- a/drivers/net/wireless/rtlwifi/pci.c
>>> +++ b/drivers/net/wireless/rtlwifi/pci.c
>>> @@ -817,7 +817,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>>>  		/* get a new skb - if fail, old one will be reused */
>>>  		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
>>>  		if (unlikely(!new_skb)) {
>>> -			pr_err("Allocation of new skb failed in %s\n",
>>> +			pr_err_ratelimited("Allocation of new skb failed in %s\n",
>>>  			       __func__);
>>
>> Or even better, remove the message.
> 
> There's actually a pending patch for that, I'll send it to Dave ASAP:
> 
> https://patchwork.kernel.org/patch/5671121/
> 
Thanks!
