Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:2908 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYGRIxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 04:53:08 -0400
Received: by wa-out-1112.google.com with SMTP id j37so129371waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 01:53:06 -0700 (PDT)
Message-ID: <1ba2fa240807180153hcb27158qb79e1af893fd2a46@mail.gmail.com> (sfid-20080718_105311_631149_F640A1F8)
Date: Fri, 18 Jul 2008 11:53:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/13] iwlwifi: use dtim_period from association, and set listen_interval
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1216369409.27738.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
	 <1216369409.27738.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2008 at 11:23 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
>> @@ -828,6 +828,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
>>               hw->ampdu_queues = priv->cfg->mod_params->num_of_ampdu_queues;
>>
>>       hw->conf.beacon_int = 100;
>> +     hw->conf.listen_interval = IWL_CONN_LISTEN_INTERVAL;
>>
>
> No way. How did those get in there? mac80211 is supposed to control the
> config, and you're supposed to use them. That was the whole point of the
> discussion we had. Please remove the beacon_int line as well and use the
> setting you get instead.

Mistake in sync with Yi, please ignore this patch. I'll post the correct one.
Tomas

> johannes
>
