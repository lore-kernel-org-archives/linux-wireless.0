Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from be2.wartburg.edu ([216.159.168.186]:33185 "EHLO
	WARTBURG-EVS-01.wartburg.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935635AbYD1QBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 12:01:18 -0400
Message-ID: <4815F4CB.1060508@wartburg.edu> (sfid-20080428_180127_299722_AF715A47)
Date: Mon, 28 Apr 2008 11:01:15 -0500
From: Charles Figura <charles.figura@wartburg.edu>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [Fwd: Re: Problems loading from compat-wireless-2008-04-24]
References: <48148E6F.3080703@wartburg.edu> <43e72e890804271418ted6360bm88f1b1f29aec6790@mail.gmail.com>
In-Reply-To: <43e72e890804271418ted6360bm88f1b1f29aec6790@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, Luis, that seems to do the trick.  The new module installed
and loaded with no errors, and appears to be working correctly!

Thanks again!

-CF

Luis R. Rodriguez wrote:
> On Sun, Apr 27, 2008 at 7:32 AM, Charles Figura
> <charles.figura@wartburg.edu> wrote:
>> I'm running Ubuntu Hardy with the 2.6.24-16-generic kernel.
>>  I've followed the log approach laid out by Luis Rodriguez below,
>>  and attached the corresponding dmesg output.
>>
>>  As you see, the modprobe FAILS due to lots of unknown symbols.
>>
>>  Oh, one other note that I hadn't mentioned before.  I've found
>>  that a 'sudo make uninstall' doesn't get rid of the module - at
>>  least, it doesn't reset the module list.  If I follow a 'sudo make
>>  uninstall' by 'sudo modprobe iwl3945', it tries to insert the same
>>  (faulty) module.  Only by rebooting is the original restored.
>>  How do I update the module list after doing a make uninstall?
>>
>>  Thanks - hope this helps!
>>
>>
>>
>>
>>  -------- Original Message --------
>>  Subject: Re: Problems loading from compat-wireless-2008-04-24
>>  Date: Sat, 26 Apr 2008 11:14:20 -0700
>>  From: Luis R. Rodriguez <mcgrof@gmail.com>
>>  To: Charles Figura <charles.figura@wartburg.edu>
>>  References: <4810F9BC.7030104@wartburg.edu>
>> <43e72e890804252146y600b6b40x738e0826bc492b0@mail.gmail.com>
>> <4813700F.5050108@wartburg.edu>
>>
>>  On Sat, Apr 26, 2008 at 11:10 AM, Charles Figura
>>  <charles.figura@wartburg.edu> wrote:
>>
>>> Luis -
>>>
>>>  Thanks for the response.  I did, actually, do a 'make unload' before
>>>  loading the new module.  And the error I sent you was actually from
>>>  loading the single module I need - the iwl3945 module.
>>>
>>>  So I'm still back where I started, I think.
>>>
>>  Please reply to the list explaining this, Intel reads linux-wireless
>>  so they can help if its their driver.
>>
>>  Do this:
>>
>>  Reboot.
>>
>>  sudo dmesg -c > log1
>>  less log1 # review it to make sure there are no oops
>>  sudo make unload
>>  sudo dmesg -c
>>  sudo modprobe iwl4965
>>  # Try to connect or whatever to try to replicate your oops
>>  sudo dmesg -c > oops.txt
>>
>>  copy and paste the oops.txt into your e-mail, that will give a cleaner
>>  log. Also be sure to mention your kernel you are using.
>>
>>   Luis
>>
>>
>>
>>  --
>>  Charles Figura                      charles.figura@wartburg.edu
>>
>>  Associate Professor of Physics    http://mcsp.wartburg.edu/figura
>>  Director, Wartburg Platte Observatory    (319) 352-8373
>>                                          (319) 352-8606 (fax)
>>
>> [  219.046669] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_register
>>  [  219.046681] iwlwifi_mac80211: Unknown symbol wiphy_register
>>  [  219.046742] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_new
>>  [  219.046747] iwlwifi_mac80211: Unknown symbol wiphy_new
>>  [  219.047765] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_unregister
>>  [  219.047771] iwlwifi_mac80211: Unknown symbol wiphy_unregister
>>  [  219.049060] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_free
>>  [  219.049066] iwlwifi_mac80211: Unknown symbol wiphy_free
> 
> You have iwlwifi's mac8011 making the calls here. Please do after make
> install and after make uninstall:
> 
> sudo modprobe -l iwl4965
> sudo modprobe -l mac80211
> sudo modprobe -l iwlwifi_mac80211
> 
> Also inspect your /lib/modules/ directory and /lib/modules/$(uname -r)/
> 
>   Luis
> 
> 

-- 
Charles Figura                      charles.figura@wartburg.edu
Associate Professor of Physics    http://mcsp.wartburg.edu/figura
Director, Wartburg Platte Observatory    (319) 352-8373
                                          (319) 352-8606 (fax)
