Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965617AbeFNOga (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 10:36:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>,
        Colin King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: make array prop static, shrinks object size
References: <20180611171537.14597-1-colin.king@canonical.com>
        <7f508dccf95cff7fb8e083666b8939c58f65f894.camel@perches.com>
        <20180611204506.GA21542@kroah.com>
Date: Thu, 14 Jun 2018 17:36:23 +0300
In-Reply-To: <20180611204506.GA21542@kroah.com> (Greg Kroah-Hartman's message
        of "Mon, 11 Jun 2018 22:45:06 +0200")
Message-ID: <878t7h8mfs.fsf@kamboji.qca.qualcomm.com> (sfid-20180614_163812_983639_E44C163B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Mon, Jun 11, 2018 at 12:40:55PM -0700, Joe Perches wrote:
>> (adding Greg KH)
>> 
>> Now what is happening is that prop is being reloaded
>> each invocation with the constant addresses of the strings.
>> 
>> It seems the prototype and function for kobject_uevent_env
>> should change as well to avoid this.
>> 
>> Perhaps this should become:
>> ---
>>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
>>  include/linux/kobject.h                         | 2 +-
>>  lib/kobject_uevent.c                            | 2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
>> index 7229991ae70d..6668a8aad22e 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
>> @@ -1946,7 +1946,7 @@ static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
>>  	struct iwl_trans_pcie_removal *removal =
>>  		container_of(wk, struct iwl_trans_pcie_removal, work);
>>  	struct pci_dev *pdev = removal->pdev;
>> -	char *prop[] = {"EVENT=INACCESSIBLE", NULL};
>> +	static const char * const prop[] = {"EVENT=INACCESSIBLE", NULL};
>>  
>>  	dev_err(&pdev->dev, "Device gone - attempting removal\n");
>>  	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, prop);
>> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
>> index 7f6f93c3df9c..9f5cf553dd1e 100644
>> --- a/include/linux/kobject.h
>> +++ b/include/linux/kobject.h
>> @@ -217,7 +217,7 @@ extern struct kobject *firmware_kobj;
>>  
>>  int kobject_uevent(struct kobject *kobj, enum kobject_action action);
>>  int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>> -			char *envp[]);
>> +			const char * const envp[]);
>>  int kobject_synth_uevent(struct kobject *kobj, const char *buf, size_t count);
>>  
>>  __printf(2, 3)
>> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
>> index 63d0816ab23b..9107989a0cc8 100644
>> --- a/lib/kobject_uevent.c
>> +++ b/lib/kobject_uevent.c
>> @@ -452,7 +452,7 @@ static void zap_modalias_env(struct kobj_uevent_env *env)
>>   * corresponding error when it fails.
>>   */
>>  int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>> -		       char *envp_ext[])
>> +		       const char * const envp_ext[])
>>  {
>>  	struct kobj_uevent_env *env;
>>  	const char *action_string = kobject_actions[action];
>
> No objection from me, care to make it a real patch so that I can apply
> it after 4.18-rc1 is out?

For the wireless part:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
