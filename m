Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54323 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYDWNWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 09:22:40 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Joevn-0007ag-8O
	for linux-wireless@vger.kernel.org; Wed, 23 Apr 2008 13:22:39 +0000
Received: from 84-203-43-214.mysmart.ie ([84.203.43.214])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2008 13:22:39 +0000
Received: from furlongm by 84-203-43-214.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2008 13:22:39 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: RE: iwl3945 problem with 2.6.25-rc9
Date: Wed, 23 Apr 2008 14:23:03 +0100
Message-ID: <fund6n$v22$1@ger.gmane.org> (sfid-20080423_152320_184250_7883154A)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com> <1208555842.4848.56.camel@johannes.berg> <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com> <BAY109-W5276443C777EAD90F53A43C9E70@phx.gbl> <D936D925018D154694D8A362EEB0892004415152@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 April 2008 00:02 in
<D936D925018D154694D8A362EEB0892004415152@orsmsx416.amr.corp.intel.com>,
Chatre, Reinette wrote:

> On Friday, April 18, 2008 7:33 PM, Marcus Furlong  wrote:
> 
> 
>> Both dmesg logs here:
>> 
>> https://www.cs.tcd.ie/~furlongm/iwlwifi/2.6.25-dmesg-with-patch
>> https://www.cs.tcd.ie/~furlongm/iwlwifi/2.6.25-dmesg-with-patch
>> -disable_hw_scan
> 
> This is very strange. Did anything change in your setup since you sent
> the logs that created the debug file named
> "2.6.25-dmesg-wirelesstools-only"? In the above log
> 2.6.25-dmesg-with-patch hardware scanning is indeed being used ... while
> it was not in the previous test runs. Note the debug message
> "iwl3945_mac_hw_scan enter" and "iwl3945_mac_hw_scan leave". This
> message only appears in this log (2.6.25-dmesg-with-patch) and none of
> the others.
> I find it very hard to believe that this patch caused hw scanning to
> work all of a sudden.

Since the first one, I disabled autoloading of the module during boot and
removed the wireless device from the udev startup scripts and added it to a
udev blacklist,  so that I could load it manually without unloading first.
So maybe there was something in the startup scripts causing this (i.e. the
option with disable_hw_scan somewhere). I just deleted all related files
to "start cleanly" so I didn't keep a backup that I can check. :( Looks
like the dmesg output doesn't show which options the module was loaded
with, maybe this would be handy in future?

Marcus.



