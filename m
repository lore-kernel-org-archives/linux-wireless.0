Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44979 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab1EZPVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 11:21:20 -0400
Received: by bwz15 with SMTP id 15so516605bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 08:21:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306421442.14995.325.camel@wwguy-huron>
References: <20110526151422.GA2382@redhat.com> <1306421442.14995.325.camel@wwguy-huron>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Thu, 26 May 2011 08:20:58 -0700
Message-ID: <BANLkTimoDkE0Cad4cYm2n2B83RxU3GC5zQ@mail.gmail.com> (sfid-20110526_172123_739735_AFA0A843)
Subject: Re: [PATCH v2] iwlagn: use cts-to-self protection on 5000 adapters series
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 7:50 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> On Thu, 2011-05-26 at 08:14 -0700, Stanislaw Gruszka wrote:
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
>> index b12c72d..23fa93d 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
>> @@ -163,17 +163,9 @@ static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
>>                                    __le16 fc, __le32 *tx_flags)
>>  {
>>       if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS ||
>> -         info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
>> +         info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT ||
>> +         info->flags & IEEE80211_TX_CTL_AMPDU)
>>               *tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
>> -             return;
>> -     }
>> -
>> -     if (priv->cfg->ht_params &&
>> -         priv->cfg->ht_params->use_rts_for_aggregation &&
>> -         info->flags & IEEE80211_TX_CTL_AMPDU) {
>> -             *tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
>> -             return;
>> -     }
>>  }

Shouldn't there be a new "use_cts_for_aggregation" flag and one that
dominates (looks like use_rts in your setup), rather than this? I'm
still a bit confused as to why CTS-to-self should help (as opposed to
masking some other bug).

Dan
