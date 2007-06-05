Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37717 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776AbXFEMke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 08:40:34 -0400
Message-ID: <466559C0.30900@lwfinger.net>
Date: Tue, 05 Jun 2007 07:40:32 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net> <46644D8F.2010400@linux.intel.com> <46645478.20002@linux.intel.com>
In-Reply-To: <46645478.20002@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:
> James Ketrenos wrote:
>> Larry Finger wrote:
>>> The initial rate for STA's using rc80211_simple is set to the last
>>> rate in the rate table. This is too fast for the bcm43xx-mac80211
>>> driver.
>>> To correct this situation without affecting any other driver,
>>> an initial_rate parameter is added to the rc80211_simple module. This
>>> parameter is set to 10 times the desired initial rate. If the parameter
>>> is zero or not set, the original behavior is kept. If the parameter
>>> does not match a valid rate, the first rate in the table will be set.
>>
>> Initial rate selection should be based on the RSSI of the last 
>> frame(s) received from the target network.  One way to do that would 
>> be for the driver to map a minimum RSSI value to each rate.  If the 
>> RSSI for the target network is greater than the value listed, that 
>> rate could be used for initial selection.  The ieee80211_rate with the 
>> highest 'rate', which is in the supported rates mask and with a 
>> min_rssi <= the AP's reported RSSI, is selected.
>>
>> The mechanism by which the magic values for min_rssi are determined 
>> for each rate is more observational than scientific--and is vendor 
>> specific.  You can pick a set of values, but different hardware and 
>> environments will yield different levels of success / failure.  Some 
>> hardware can be very lenient if it has automatic hardware retry.  
>> Other hardware will need to be very conservative (since, as you point 
>> out, the first few frames Tx/Rx'd are important)
> 
> I didn't state it above -- doing what is described requires adding one 
> unsigned char (min_rssi) to ieee80211_rate in mac80211.h and then 
> modifying rc80211_simple to take advantage of that information (so if 
> you're grepping for min_rssi and can't find it, that's why...)

I agree that the initial rate selection should be based on the RSSI of the last frame(s), but that 
will take a long time to develop - both to get the necessary code into mac80211 and the driver 
support for min_rssi. I'm not sure we who work with bcm43xx have that time. Although the mac80211 
version of our driver is not yet in mainline, it has been included in FC7, which changes the nature 
and the skills of the users. For many users, me included, the driver cannot associate and 
authenticate with the "out of the box" version of mac80211. I posted a private patch on the bcm43xx 
mailing list that set the initial rate to 1 Mbs, which allowed my system to connect. A number of 
others reported back that this change also allowed them to connect much more reliably. I considered 
submitting that patch, but decided that the new module parameter would be better for at least two 
reasons: (1) any driver that has no difficulty connecting with the current scheme would not be 
affected, and (2) it is a lot easier for users to edit /etc/modprobe.conf.local and add the line 
"options rc80211_simple initial_rate=10" than it would be to download the kernel sources, patch them 
for the equivalent change, and build the revised kernel.

I'm still waiting for one of the mac80211 developers to comment on whether starting at 1 Mbs would 
place an undue speed penalty on a device that is capable of operating at 54 Mbs.

Larry


