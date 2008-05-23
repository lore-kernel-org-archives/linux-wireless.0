Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:21012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbYEWF7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 01:59:32 -0400
Received: by wa-out-1112.google.com with SMTP id j37so460188waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 22:59:31 -0700 (PDT)
Message-ID: <1ba2fa240805222259le148912ub540ebf4077dc145@mail.gmail.com> (sfid-20080523_075949_132349_A2DE70AD)
Date: Fri, 23 May 2008 08:59:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH] iwlwifi: impelemnt 5000 tx response path
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1211521497.6888.24.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-44-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-46-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-47-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-48-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-49-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-50-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-51-git-send-email-yi.zhu@intel.com>
	 <1211521497.6888.24.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 23, 2008 at 8:44 AM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Fri, 2008-05-23 at 10:09 +0800, Zhu Yi wrote:
>> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>>
>> This patch implements 5000 HW tx response path
>>
>> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>> ---
>>  drivers/net/wireless/iwlwifi/iwl-5000.c |  235 +++++++++++++++++++++++++++++++
>>  net/mac80211/mlme.c                     |   10 +-
>>  2 files changed, 240 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
>> index 685a84e..5d6a28c 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
>> @@ -972,6 +972,240 @@ static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
>>       iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
>>  }
>>
>> +
>> +static inline u32 iwl5000_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
>> +{
>> +     __le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
>> +                             tx_resp->frame_count);
>> +     return le32_to_cpu(*scd_ssn) & MAX_SN;
>
> How about:
>
>        return le32_to_cpup((__le32 *)&tx_resp->status + tx_resp->frame_count);
>
> Cheers,
>
> Harvey
>

Thanks
Will apply on top of it
    return le32_to_cpup((__le32 *)&tx_resp->status +
tx_resp->frame_count) & MAX_SN;

Thank
Tomas
