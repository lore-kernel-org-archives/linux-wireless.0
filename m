Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45475 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYDPXBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:39 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JmGdF-0001wI-6D
	for linux-wireless@vger.kernel.org; Wed, 16 Apr 2008 23:01:37 +0000
Received: from 84-203-37-37.mysmart.ie ([84.203.37.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 23:01:37 +0000
Received: from furlongm by 84-203-37-37.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 23:01:37 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: RE: iwl3945 problem with 2.6.25-rc9
Date: Thu, 17 Apr 2008 00:01:20 +0100
Message-ID: <fu60g5$1h0$1@ger.gmane.org> (sfid-20080417_000147_281975_9CF32A05)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 22:22 in
<D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>,
Chatre, Reinette wrote:

> On Wednesday, April 16, 2008 1:05 PM, Dan Williams  wrote:
> 
>> On Wed, 2008-04-16 at 20:48 +0100, Marcus Furlong wrote:
>>> On Wednesday 16 April 2008 20:01 in
>> <fu5iel$c45$1@ger.gmane.org>, Marcus
>>> Furlong wrote:
>>> 
>>>> On Wednesday 16 April 2008 19:28 in
>>>> 
>>> 
>>
<D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.in
> tel.com>,
>>>> Chatre, Reinette wrote:
>>>> 
>>>>> Looks like the device is being brought up and down a lot ... are
>>>>> you perhaps running wpa_supplicant or some other user application
>>>>> that is doing this? Could you please give more information about
>>>>> what you were doing when these errors started to appear?
>>>> 
>>>> Yes, wpa_supplicant is running as part of the boot process. Should
>>>> I use some other application? (Do wireless-tools support WPA?) Or
>>>> should I just load the module on it's own and give the dmesg output
>>>> from that?
>>> 
>>> Here is the output from the module loading without wpa_supplicant,
>>> then me reloading it with debug flags, and running ifconfig wlan0
>>> and iwlist scanning. Still some Microcode SW and FW errors in there,
>>> but there's a lot less noise.
>>> 
>>> 
>> https://www.cs.tcd.ie/~furlongm/iwlwifi/iwl3945-output-no-wpasu
>> pplicant.bz2
>> 
>> Interesting; can you run wpa_supplicant again but dump it's detailed
>> output using "-dddt" for us so we can see what it's doing and if it's
>> causing the restarts?
> 
> The driver itself is responsible for many of the restarts because of the
> firmware errors. A wpa_supplicant log will still be useful.

Ok got one now:

https://www.cs.tcd.ie/~furlongm/iwlwifi/minicom-wpa_supplicant-output

Reloaded the module halfway through to see if that made any difference.
Sometimes it sees some of the access points after rmmod-ing and
modprobe-ing it (never sees as many as the ipw driver though), but this
time it didn't make any difference.

Marcus.

