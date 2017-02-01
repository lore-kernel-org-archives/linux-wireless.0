Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50538 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752860AbdBAR3M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 12:29:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 01 Feb 2017 22:59:09 +0530
From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 2/2] mac80211: store tx power value from user to
 station
In-Reply-To: <eff562d4-7dd8-4b5a-812c-58f4f690cde3@candelatech.com>
References: <1485888101-23454-1-git-send-email-arnagara@qti.qualcomm.com>
 <1485888101-23454-2-git-send-email-arnagara@qti.qualcomm.com>
 <eff562d4-7dd8-4b5a-812c-58f4f690cde3@candelatech.com>
Message-ID: <7584a5235b49b7799a2c15f91fb03794@codeaurora.org> (sfid-20170201_182918_962556_009F1374)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-01 00:30, Ben Greear wrote:
> On 01/31/2017 10:41 AM, Ashok Raj Nagarajan wrote:
>> This patch introduce a new driver callback drv_sta_set_txpwr. This API 
>> will
>> copy the transmit power value passed from user space and call the 
>> driver
>> callback to set the tx power for the station.
>> 
>> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
>> ---
>>  include/net/mac80211.h    |  6 ++++++
>>  net/mac80211/cfg.c        |  7 +++++++
>>  net/mac80211/driver-ops.c | 21 +++++++++++++++++++++
>>  net/mac80211/driver-ops.h |  5 +++++
>>  net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
>>  5 files changed, 66 insertions(+)
>> 
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 5345d35..e059d5a 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -1777,6 +1777,8 @@ struct ieee80211_sta_rates {
>>   *	This is defined by the spec (IEEE 802.11-2012 section 8.3.2.2 NOTE 
>> 2).
>>   * @support_p2p_ps: indicates whether the STA supports P2P PS 
>> mechanism or not.
>>   * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by 
>> rate control.
>> + * @txpwr: indicates the tx power, in dBm, to be used when sending 
>> data frames
>> + *	to the STA. Value of 0 means, automatic (default) tx power.
> 
> Atheros NICs use 1/2 dBm increments internally, so maybe pass down mBm
> to the driver so you don't
> loose the granularity?  (Other NICs may potentially have even finer 
> control.)
> 

ath10k firmware expects values to be in dBm and the calculations 
regarding 1/2 dBm is taken care in firmware.

Thanks,
Ashok
> Thanks,
> Ben
