Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:33594 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbZFKM4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 08:56:38 -0400
Received: by ewy6 with SMTP id 6so1992037ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 05:56:39 -0700 (PDT)
Message-ID: <4A30FF03.9000500@tuffmail.co.uk>
Date: Thu, 11 Jun 2009 13:56:35 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243929706.20064.7.camel@johannes.local>	 <1243930703.3192.59.camel@localhost.localdomain>	 <20090603040315.GA10464@khazad-dum.debian.net>	 <1244008652.4145.7.camel@localhost.localdomain>	 <20090603213340.GB22809@khazad-dum.debian.net>	 <1244088806.4145.24.camel@localhost.localdomain>	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>	 <1244389617.23850.102.camel@localhost.localdomain>	 <4A2BE520.6080207@tuffmail.co.uk>	 <1244392536.23850.109.camel@localhost.localdomain>	 <20090610020522.GD593@khazad-dum.debian.net>	 <1244618037.3068.29.camel@localhost.localdomain>	 <4A2F779F.8070003@tuffmail.co.uk> <1244721689.27363.15.camel@violet>
In-Reply-To: <1244721689.27363.15.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann wrote:
> Hi Alan,
>
>   
>>>>>> I don't think we should expect userspace to know whether or not a device
>>>>>> has a persistent state.  Yes, it _could_ maintain whitelists, but why
>>>>>> should it have to if the driver already knows?
>>>>>>         
>>>>>>             
>>>>> If you want that, then the best approach seems an extra sysfs attribute
>>>>> for this. It is not intrusive on the event API and lets udev etc. have
>>>>> these information, too.
>>>>>       
>>>>>           
>>>> I have no problems with either approach.  As long as the information of
>>>> which devices have restored their initial state from NVS is available to
>>>> userspace, it is enough.
>>>>     
>>>>         
>>> just to get the semantic right here. We are not telling userspace if a
>>> state has been restored or not. We are telling userspace that this
>>> specific RFKILL switch is capable of storing something in a persistent
>>> state over boot. There is a difference here.
>>>
>>> If a RFKILL driver claims it is capable of persistent storage then it
>>> better work or it should not claims it. Either it does it all the time
>>> or doesn't do it at all. Otherwise we end up in policy again and that is
>>> not the job of the kernel.
>>>
>>>   
>>>       
>>>> Do note that this information also needs to be available for resume (state
>>>> should be checkpointed to NVS on sleep, and restored from NVS on resume.  I
>>>> believe tpacpi does this, but if it doesn't, I will fix it eventually).
>>>>     
>>>>         
>>> Correct. That is the job of the driver. If it is broken, that needs
>>> fixing.
>>>   
>>>       
>> The core needs fixing too, currently it restores state for all devices
>> on resume.
>>
>> This is my fault again, for coming up with scenarios you probably don't
>> care about :-).  The problem is that suspend to disk provides a
>> possibility that the state will change for _any_ driver.  It's more
>> obvious with rfkill-input and NVS, if the wireless toggle key is pressed
>> when the disk image is being written out.  But you can also contrive it
>> with no NVS and rfkilld, if rfkilld gets started in the initramfs of the
>> resume kernel.  We took the easy way out, rather than adding resume
>> handlers to all drivers, or trying to work out what the real design
>> problem was :-).
>>
>> I hope that explains the issue.  I agree with your logic, I just want to
>> be clear that it needs more work on the rfkill core.  Drivers with NVS
>> should have a resume handler to call rfkill_set_sw_state(), but for this
>> to work the core will need to stop restoring their state (for NVS
>> drivers only).  As a detail, I think this behaviour difference with NVS
>> means it should be flagged with a more explicit API, e.g.
>> rfkill_init_persistent_sw_state().
>>     
>
> I don't see any problem here. If the driver needs extra help from the
> RFKILL subsystem to express its states, that is just fine with me.
>
>   
>> rfkill-input would like another (even more intrusive) hack here to set
>> the global state on resume.  But I for one can live without it for the
>> transition.  I think NVS state change over suspend is much more of a
>> corner case.  At least on eeepc-laptop it only seems to happen if the
>> user does something relatively odd.  And the worst that will happen is
>> they have to press the wireless-toggle key a second time before it
>> starts working.
>>     
>
> So one think is NVS states and the other are the HW switches. For the
> NVS ones we need extra support for suspend/resume details, but that is
> as mentioned above just fine. Also please keep in mind that NVS states
> are per device and not global. If a system wants to treat them as global
> that is userspace policy and not our concern from the kernel side.
>
> For the HW states, I think they gonna store its state pretty obvious and
> if we need a resume callback to poll its current state, then that seems
> logical to me too.
>   

Ok.  I will work on this and post a few more patches.  I guess it's
still easiest if I post this as running code, and try to justify it to
you guys.


1/3:  The original patch removing set_global_sw_state() - this hasn't
been applied yet.

2/3:  Remove the core restore-on-resume code.  Devices with NVS will
maintain their state, and _must_ check NVS on resume.  Other devices are
expected to restore their own state.

I think this should work, because it's how the rfkill rewrite was
designed to start with.  It may take me a while to figure out _why_ it
works though.  I'm not sure about the ordering - whether my
acpi/platform driver resume callback will run before the rfkill class
resume handler, and if so then how does it work?  I don't want to submit
code unless I understand it :-).

3/3: Export the "persistent" flag in sysfs - now we have hopefully
settled what it means.


Thanks
Alan
