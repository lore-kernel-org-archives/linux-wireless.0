Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:34918 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZFRVSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 17:18:05 -0400
Message-ID: <4A3AAF0A.9020707@tuffmail.co.uk>
Date: Thu, 18 Jun 2009 22:18:02 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Bob Copeland <me@bobcopeland.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pm@lists.linux-foundation.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net, linux-pci@vger.kernel.org
Subject: Re: [ath5k-devel] [linux-pm] PCI hotplug v.s. suspend
References: <Pine.LNX.4.44L0.0906181437090.3129-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906181437090.3129-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern wrote:
> On Thu, 18 Jun 2009, Alan Jenkins wrote:
>
>   
>> Unfortunately this makes it worse.  My eeepc-laptop hacks are now in
>> wireless-testing.  If I apply the above patch to wireless-testing and
>> "remove" the device while suspended, I get a soft hang on resume. 
>>     
>
> Is this different from the behavior without the patch?  (I don't see 
> how it could be.)
>   

Ow.  No, the free_irq patch doesn't cause this bug.  I missed testing
this case after adding a workaround for an even more obscure issue :-(.

I have a good idea how eeepc-laptop could cause a double-free error.  I
suspect we originally got away with trying to call pci_remove_device()
twice, but it's not actually legal, and my workaround caused two
attempts to happen much closer together.

I'll fix it tomorrow and re-test.  With _both_ of my nasty scenarios
this time (and the normal ones) - I should really make a checklist :-).

>> Suspending without removal works fine.
>>
>> I can see a BUG if I boot with no_console_suspend
>>
>> Unable to handle kernel NULL pointer dereference
>> IP: klist_put
>> Tainted: G W
>> Process s2disk
>>
>> Call trace:
>> ? klist_del
>> ? device_del
>> ? device_unregister
>> ? pci_stop_dev
>> ? pci_stop_bus
>> ? pci_remove_device
>> ? eeepc_rfkill_hotplug [eeepc_laptop]
>> ? eeepc_hotk_resume [eeepc_laptop]
>> ? acpi_device_resume
>> ? device_resume
>> ? hibernation_snapshot
>>     
>
> This should be doing more or less the same thing as if you removed the 
> device while the system was running.  Or is it not hot-unpluggable?
>
> Alan Stern
>   

Outside of suspend, I can hot-unplug the device alright.  I'm blaming my
hotplug driver resume handler.

Thanks
Alan
