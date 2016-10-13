Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54422 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932744AbcJMO0K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 10:26:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 1/3] rsi: Fix memory leak in module unload
References: <1476357946-15460-1-git-send-email-prameela.j04cs@gmail.com>
        <87inswcs1j.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 13 Oct 2016 17:26:04 +0300
In-Reply-To: <87inswcs1j.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Thu, 13 Oct 2016 16:11:36 +0300")
Message-ID: <87bmyo1g1v.fsf@purkki.adurom.net> (sfid-20161013_162628_456575_F240A3DF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:
>
>> Observed crash when module is unloaded if CONFIG_RSI_DEBUGSFS is not set.
>> 	Fix: Debugfs entry removal moved inside CONFIG_RSI_DEBUGSFS flag in
>>              function rsi_mac80211_detach()
>> Memory leak found and fixed for below structures in function rsi_mac80211_detach()
>> 	* channel list for each supported band
>> 	* rsi debugfs info
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> BTW, I don't see patch 2 in patchwork nor in linux-wireless, but I do
> see it on my inbox. Either it's slow or there was a problem with the
> delivery.

It was just slow, I see it now:

https://patchwork.kernel.org/patch/9374987/

-- 
Kalle Valo
