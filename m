Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:10698 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYKHTLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 14:11:40 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1880551wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2008 11:11:39 -0800 (PST)
Message-ID: <1ba2fa240811081111q72eee389p6afb090cb5c070f5@mail.gmail.com> (sfid-20081108_201145_452206_BBB0A5D3)
Date: Sat, 8 Nov 2008 21:11:39 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 10/13] iwlwifi: move iwl_print_hex_dump to iwl-debug.h
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1226081039.11596.20.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
	 <1226081039.11596.20.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 7, 2008 at 8:03 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Fri, 2008-11-07 at 09:58 -0800, Reinette Chatre wrote:
>> From: Winkler, Tomas <tomas.winkler@intel.com>
>>
>> This patch moves iwl_print_hex_dump to iwl-debug.h
>> where it belongs
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  drivers/net/wireless/iwlwifi/iwl-debug.h |   10 ++++++++++
>>  drivers/net/wireless/iwlwifi/iwl-dev.h   |   17 -----------------
>>  2 files changed, 10 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
>> index 84b7772..0e79a6a 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-debug.h
>> +++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
>> @@ -40,6 +40,13 @@ do { if ((priv->debug_level & (level)) && net_ratelimit()) \
>>    dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
>>        in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
>>
>> +#define iwl_print_hex_dump(priv, level, p, len)                      \
>> +do {                                                                 \
>> +     if (priv->debug_level & level)                                  \
>> +             print_hex_dump(KERN_DEBUG, "iwl data: ",                \
>> +                            DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);   \
>> +} while (0)
>
> static inline please.

Won't work in this case priv is not defined in this context, need to
solve this in another round.
>
>> +
>>  #ifdef CONFIG_IWLWIFI_DEBUGFS
>>  struct iwl_debugfs {
>>       const char *name;
>> @@ -70,6 +77,9 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
>>  #else
>>  #define IWL_DEBUG(level, fmt, args...)
>>  #define IWL_DEBUG_LIMIT(level, fmt, args...)
>> +static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
>> +                                   void *p, u32 len)
>> +{}
>>  #endif                               /* CONFIG_IWLWIFI_DEBUG */
>
> To keep it in sync with this.

This one can be changed.
Tomas
