Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:15850 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbZDRN3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 09:29:22 -0400
Received: by ey-out-2122.google.com with SMTP id 4so325781eyf.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2009 06:29:20 -0700 (PDT)
Message-ID: <49E9D5AE.50509@tuffmail.co.uk> (sfid-20090418_152927_344238_3CB6642F)
Date: Sat, 18 Apr 2009 14:29:18 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Rfkill rewrite: eeepc-laptop resume
References: <49DCA88E.6060400@tuffmail.co.uk>	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>	 <49E98C86.2040308@tuffmail.co.uk>	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>	 <49E9A0C7.8040602@tuffmail.co.uk> (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
In-Reply-To: <1240057470.4755.7.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-04-18 at 10:43 +0100, Alan Jenkins wrote:
>   
>>
>>
>> 1) I think we need to add a resume method to eeepc-laptop.
>>
>> Without this, funny things happen when I hibernate, disable wireless in
>> the BIOS, and resume:
>>
>>     ath5k phy0: failed to wake up the MAC chip
>>
>> It's an really stupid thing to do, but it can happen.  It's bad from a
>> UI point of view.  E.g. in network-manager, you can see a "wlan0"
>> device, but it doesn't work.
>>
>> The EEE rfkill is unusual in that it hotplugs the PCI device, making
>> eeepc-laptop something like a custom pci hotplug driver.  With your
>> rewrite, eeepc-laptop doesn't notice the state change on resume. 
>> Previously, the rfkill-core would restore the pre-hibernation state,
>> which would sort everything out.  I don't think anything else does this,
>> so we can just add a resume method to eeepc-laptop.  The resume method
>> would re-check the state and do the PCI hotplug dance if necessary.
>>
>> If you agree, I can do the patch for this and send it to you.
>>     
>
> Sounds good to me, yeah.
>
> I could make the rfkill core do that at resume, but I'm not really sure
> it's what we want -- there are too many cases imho:
>  * hard rfkill might have changed
>  * soft rfkill might still be ok in hw
>  * soft rfkill might need reconfiguring
> etc. I think generally it's saner to let the driver sort it out -- it
> can always ask for the current state by using set_hw_state() or so.
>   

API nit:

 * This function tells the rfkill core that the device is capable of
 * remembering soft blocks (which it is notified of via the set_block
 * method) -- this means that the driver may ignore the return value
 * from rfkill_set_hw_state().

Doesn't this conflict with the declaration of rfkill_set_sw_state() as
__must_check?

Ta
Alan

