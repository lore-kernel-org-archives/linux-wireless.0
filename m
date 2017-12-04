Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35450 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdLDLU2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 06:20:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 04 Dec 2017 16:50:13 +0530
From: akolli@codeaurora.org
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: mbizon@freebox.fr, linux-wireless-owner@vger.kernel.org,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
In-Reply-To: <87374uxxjy.fsf@kamboji.qca.qualcomm.com>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
 <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
 <1512125137.38490.70.camel@sakura.staff.proxad.net>
 <7792e2fb2c546d8745c65e48945f2535@codeaurora.org>
 <87374uxxjy.fsf@kamboji.qca.qualcomm.com>
Message-ID: <ec75cd163af6a2e989739474a4a190b5@codeaurora.org> (sfid-20171204_122031_902039_356D8AF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
>>>> Parse peer stats from pktlog packets and update the tx rate
>>>> information
>>>> per STA. This way user space can query about transmit rate with iw:
>>> 
>>> everything works ok, ath10k_update_per_peer_tx_stats() is called and
>>> ath10k_sta fields are updated correctly
>>> 
>>> but tx bitrate is still 6 MBit/s in station dump
>>> 
>> Hope CONFIG_MAC80211_DEBUGFS is enabled in your build.
>> Please Run ping traffic and see and 'station dump'
> 
> This feature should not depend on debugfs. Why is it needed? In patch 1
> you already moved pktlog_filter to struct ath10k, does it need 
> something
> else as well?

ATH10K updates tx rate from this callback,
.sta_statistics                 = ath10k_sta_statistics,

This callback is defined under CONFIG_MAC80211_DEBUGFS.

Thanks,
Anil.
