Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38488 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbZFHLKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 07:10:11 -0400
Received: by bwz9 with SMTP id 9so2956050bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 04:10:11 -0700 (PDT)
Message-ID: <4A2CF18D.4080305@tuffmail.co.uk>
Date: Mon, 08 Jun 2009 12:10:05 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] rfkill: remove set_global_sw_state()
References: <1243885494.3015.29.camel@localhost.localdomain>	 <4A24559D.7010201@tuffmail.co.uk>	 <1243928308.3192.38.camel@localhost.localdomain>	 <1243929706.20064.7.camel@johannes.local>	 <1243930703.3192.59.camel@localhost.localdomain>	 <20090603040315.GA10464@khazad-dum.debian.net>	 <1244008652.4145.7.camel@localhost.localdomain>	 <20090603213340.GB22809@khazad-dum.debian.net>	 <1244088806.4145.24.camel@localhost.localdomain>	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>	 <20090607125715.GC3340@khazad-dum.debian.net>	 <1244394963.12956.1.camel@johannes.local> <4A2BF833.1050906@tuffmail.co.uk>	 <4A2CE4A2.2090308@tuffmail.co.uk> <1244457159.18863.7.camel@johannes.local>
In-Reply-To: <1244457159.18863.7.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-06-08 at 11:14 +0100, Alan Jenkins wrote:
>   
>> rfkill_set_global_sw_state() (previously rfkill_set_default()) will no
>> longer be exported by the rewritten rfkill core.
>>
>> Instead, platform drivers which can provide persistent soft-rfkill state
>> across power-down/reboot should indicate their initial state by calling
>> rfkill_set_sw_state() before registration.  Otherwise, they will be
>> initialized to a default value during registration by a set_block call.
>>
>> We remove existing calls to rfkill_set_sw_state() which happen before
>> registration, since these had no effect in the old model.  If these
>> drivers do have persistent state, the calls can be put back (subject
>> to testing :-).  This affects hp-wmi and acer-wmi.
>>     
>
> Cool.
>
>   
>> Drivers with persistent state will affect the global state only if
>> rfkill-input is enabled.  This is required, otherwise booting with
>> wireless soft-blocked and pressing the wireless-toggle key once would
>> have no apparent effect.  This special case will be removed in future
>> along with rfkill-input, in favour of a more flexible userspace daemon
>> (see Documentation/feature-removal-schedule.txt).
>>     
>
> How does that work?
>
>   
>> --- a/drivers/platform/x86/acer-wmi.c
>> +++ b/drivers/platform/x86/acer-wmi.c
>>     
>
>   
>> @@ -996,8 +995,6 @@ static struct rfkill *acer_rfkill_register(struct device *dev,
>>  				  (void *)(unsigned long)cap);
>>  	if (!rfkill_dev)
>>  		return ERR_PTR(-ENOMEM);
>> -	get_u32(&state, cap);
>> -	rfkill_set_sw_state(rfkill_dev, !state);
>>     
>
> That does seem persistent, I'd think? get_u32 here hits ACPI iirc.
>
>   
>> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
>> index 8d93114..16fffe4 100644
>> --- a/drivers/platform/x86/hp-wmi.c
>> +++ b/drivers/platform/x86/hp-wmi.c
>> @@ -422,7 +422,6 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
>>  					   RFKILL_TYPE_WLAN,
>>  					   &hp_wmi_rfkill_ops,
>>  					   (void *) 0);
>> -		rfkill_set_sw_state(wifi_rfkill, hp_wmi_wifi_state());
>>  		err = rfkill_register(wifi_rfkill);
>>  		if (err)
>>  			goto register_wifi_error;
>> @@ -433,8 +432,6 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
>>  						RFKILL_TYPE_BLUETOOTH,
>>  						&hp_wmi_rfkill_ops,
>>  						(void *) 1);
>> -		rfkill_set_sw_state(bluetooth_rfkill,
>> -				    hp_wmi_bluetooth_state());
>>  		err = rfkill_register(bluetooth_rfkill);
>>  		if (err)
>>  			goto register_bluetooth_error;
>> @@ -445,7 +442,6 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
>>  					   RFKILL_TYPE_WWAN,
>>  					   &hp_wmi_rfkill_ops,
>>  					   (void *) 2);
>> -		rfkill_set_sw_state(wwan_rfkill, hp_wmi_wwan_state());
>>  		err = rfkill_register(wwan_rfkill);
>>  		if (err)
>>  			goto register_wwan_err;
>>     
>
> Hmm. Anyone know anything about HP? That kinda looks persistent too.
>   

Quite possibly.  I just don't know, and it's never been treated that way
before.  The old core, when I first read it, you were supposed to report
the initial state so that it knew whether it differed from the default
state.  So the core could "optimise away" the initialization if the
current state was the same.  Then rfkill_set_default() was added, but it
was only used in tp-acpi and then eeepc-laptop.

The counter is the sony-laptop case.  That driver also hits ACPI to
query it's current state.  But apparently it doesn't always power up in
a useful state, because there's a specific git commit which forces the
radios to unblock at load time.


I think this patch should preserve the existing behaviour.  But the
rfkill rewrite as a whole is a good opportunity to re-check this issue. 
There's only a few maintainers to contact so I don't mind doing it -
unless you were going to check with them about the rewrite anyway?

>> @@ -1200,8 +1185,20 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
>>  	atp_rfk->id = id;
>>  	atp_rfk->ops = tp_rfkops;
>>  
>> -	rfkill_set_states(atp_rfk->rfkill, initial_sw_state,
>> -				tpacpi_rfk_check_hwblock_state());
>> +	initial_sw_status = (tp_rfkops->get_status)();
>> +	if (initial_sw_status < 0) {
>> +		printk(TPACPI_ERR
>> +			"failed to read initial state for %s, error %d; "
>> +			"will turn radio off\n", name, initial_sw_status);
>>     
>
> That message seems wrong now, it would not turn off but impose the
> current default, I think?
>   

Yes, good point.

>>  /**
>> - * rfkill_set_global_sw_state - set global sw block default
>>     
>
> There's a static inline in the !RFKILL case, please remove that too.
>
>   
>> @@ -916,7 +885,17 @@ int __must_check rfkill_register(struct rfkill *rfkill)
>>  	if (rfkill->ops->poll)
>>  		schedule_delayed_work(&rfkill->poll_work,
>>  			round_jiffies_relative(POLL_INTERVAL));
>> -	schedule_work(&rfkill->sync_work);
>> +
>> +	if (!rfkill->persistent || rfkill_epo_lock_active) {
>> +		schedule_work(&rfkill->sync_work);
>> +	} else {
>> +#ifdef CONFIG_RFKILL_INPUT
>> +		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
>> +
>> +		if (!atomic_read(&rfkill_input_disabled))
>> +			__rfkill_switch_all(rfkill->type, soft_blocked);
>> +#endif
>> +	}
>>     
>
> Ah, this is the quirky backward compat code you're talking about. I
> guess we need it, although I don't particularly like it.
>   

I don't like it either.  The patch as a whole only makes sense because
rfkill-input is going away, so the global states will become less
important.  When you use rfkill-input, you really want the individual
states to match the global ones, otherwise your user experience
suffers.  When you don't use rfkill-input, the "global" states will just
be load-time defaults (once suspend is fixed).

> Looks good except for these few comments!
>
> johannes
>   

Great, thanks for the feedback
