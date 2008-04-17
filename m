Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41793 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbYDQAHF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 20:07:05 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JmHeX-0004p1-Ob
	for linux-wireless@vger.kernel.org; Thu, 17 Apr 2008 00:07:01 +0000
Received: from 84-203-37-37.mysmart.ie ([84.203.37.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 00:07:01 +0000
Received: from furlongm by 84-203-37-37.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 00:07:01 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: RE:  RE: iwl3945 problem with 2.6.25-rc9
Date: Thu, 17 Apr 2008 01:06:48 +0100
Message-ID: <fu64at$cm9$1@ger.gmane.org> (sfid-20080417_010730_429478_F13500B1)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 23:55 in
<D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>,
Chatre, Reinette wrote:

> On , Marcus Furlong  wrote:
> 
>> On Wednesday 16 April 2008 22:22 in
>>
<D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.in
>> tel.com>, Chatre, Reinette wrote:
>> 

[SNIP]

>>> Could you please give more information about what the system is
>>> trying to do here? In the first log you sent most failures appear to
>>> occur when A band channels are configured ... does this match with
>>> what you are trying to do? Can you explain why the BSSID is all
>>> zeroes?
>> 
>> I have no idea why the BSSID is all zeros. This usually
>> happens first thing
>> after boot, even with the ipw driver. I usually use wpa_gui to
>> select the
>> second network in my wpa_supplicant list (which is not
>> actually present at
>> my current location), then reselect the first network (which
>> is present).
> 
> Can you send a copy of your wpa_supplicant configuration file (comment
> out the private parts)?

https://www.cs.tcd.ie/~furlongm/iwlwifi/wpa_supplicant.conf

> 
>> It usually then associates. That's with the ipw driver, so I
>> was seeing if
>> the same trick would work with the iwl driver (in the first
>> log).
> 
> There seems to be a lot going on through initialization scripts of your
> distribution. Could you disable all that and try to get up and running
> with as little variables as possible? It may be that the interface is
> automatically brought up when the module is loaded - this script should
> be among your network init scripts. Can you disable that? You can load
> the driver with debugging and see through the logs if anything is trying
> to use it. The first goal is to load the driver and not have it do any
> work after initial load.

The second log I linked to was made similar to the above scenario. The
module autoloads but I disabled the network script on boot. Then I rmmod-ed
the iwl3945 module and loaded it again with debugging enabled. After no
more kernel messages were being outputted, I ran wpa_supplicant in the
foreground from the command line.

> After this follow the following steps (I am assuming you are not using
> security):
> $ /sbin/ip link set dev wlan0 up
> $ iwlist wlan0 scan
> Search for your AP in the above output - should match with your
> wpa_supplicant conf file.

This works, not always the first time, but eventually it finds my AP.
Sometimes it takes up to ten minutes to find my AP even though it's in the
same room as me.

> $ iwconfig wlan0 channel <channel of your AP> ap <MAC of your AP> essid
> <essid of your AP>
> $ iwconfig
> check above output to see if you are associated
> next use your usual net app to get an IP (dhclient?)
> 
> Can you associate with the above steps? What do the logs look like?

Unfortunately the AP is configured to use WPA-PSK and there are others
connected at the moment so I can't test if it connects without security.
I'll have a go at associating using WPA with the latest version of
wireless-tools.

> 
>> Not sure
>> what "A band channels" means, can you explain that and possibly I can
>> answer..
> 
> A band operates at 5GHz as opposed to B and G that operates in 2.4GHz.
> Do you know what your AP is configured as?

Ok thanks, I know what you mean now. The AP is configured to operate using
band G only.

Marcus.

