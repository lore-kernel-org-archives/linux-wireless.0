Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:61023 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYFSU00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 16:26:26 -0400
Received: by py-out-1112.google.com with SMTP id p76so415290pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 13:26:26 -0700 (PDT)
Message-ID: <1ba2fa240806191326q1b0fb6f4w7e164a0acd12157d@mail.gmail.com> (sfid-20080619_222629_999312_FC21286D)
Date: Thu, 19 Jun 2008 23:26:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 2/2] mac80211: workaround for resetting the tx power
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Assaf Krauss" <assaf.krauss@intel.com>
In-Reply-To: <1213902248.8967.79.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
	 <1213900512-21565-2-git-send-email-tomas.winkler@intel.com>
	 <1213902248.8967.79.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 10:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-19 at 21:35 +0300, Tomas Winkler wrote:
>> From: Assaf Krauss <assaf.krauss@intel.com>
>>
>> This patch is a workaround for the unreliable disassociation
>> flow. The resetting of the tx power is now performed upon
>> association/reassociation.
>>
>> Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  net/mac80211/mlme.c |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 313b02a..378ccd5 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -2148,6 +2148,19 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
>>       /* AssocResp and ReassocResp have identical structure, so process both
>>        * of them in this function. */
>>
>> +     /***********************************************************
>> +      * Workaround - Until disassociation flow is trustworthy...
>> +      ***********************************************************/
>> +     /* Reset power level. Get the tx power from the current channel/user.*/
>> +     if (ifsta->country_max_pwr || local->hw.conf.tpc_pwr_limit) {
>> +             ifsta->country_max_pwr = 0;
>> +             local->hw.conf.tpc_pwr_limit = 0;
>> +             ieee80211_hw_config(local);
>> +     }
>> +     /***********************************************************
>> +      * End of Workaround
>> +      ***********************************************************/
>
> Umm, can you explain/fix the problem instead of adding ugly comments
> like that?

This patch goes separately with hope it will be not used.
Disconnection is not really captured correctly by mac and old  data
are not cleaned.
Tomas
