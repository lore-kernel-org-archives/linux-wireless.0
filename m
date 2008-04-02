Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:41269 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753026AbYDBPff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 11:35:35 -0400
Message-ID: <47F3A7BB.1050501@yahoo.com> (sfid-20080402_163538_341566_89114B58)
Date: Wed, 02 Apr 2008 11:35:23 -0400
From: Andres Bertens <abertensu@yahoo.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: FW: [ipw3945-devel] iwl3945: disassociation from AP (reason=4)
 andtimeout, a solution
References: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com>	 <1206999696.20744.2.camel@localhost.localdomain>	 <1207051434.5143.58.camel@johannes.berg>  <47F23C6B.6060205@yahoo.com>	 (sfid-20080401_144755_080818_247DF100) <1207068153.5143.137.camel@johannes.berg>
In-Reply-To: <1207068153.5143.137.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
>> Reason=4 is in fact "Inactivity timer expired and station was 
>> disassociated". According to my router log:
>> "Tuesday April 01, 2008 09:08:54 Disassociated: 00-19-D2-4F-22-4D 
>> because idle 300 seconds"
>>
>> Indeed, the default behaviour goes for a reassocation 
> 
> Right, I just checked, we try to reassociate after one second.
> 
>> but my hw/sw 
>> combination (intel3945/dlink/wep) fails with a status=17 (AP unable to 
>> handle new status).
> 
> 17 actually is WLAN_REASON_IE_DIFFERENT, i.e. the WPA/RSN IE we send is
> no longer appropriate, something for wpa_supplicant to handle then. Are
> you using encryption?
> 
>> After 3 tries, it dies with an AP association 
>> timeout. From there is no recovery till I set the interface down and up.
>>
>> That's why I solved it (perhaps not in the best way) ignoring the 
>> disassociation. Now it works.
> 
> Your AP is broken. After it disassociates you and you ignore this
> status, it complains that it deauthenticated (!) you and then
> deauthenticates you again (with reason=6 meaning that you weren't
> authenticated.) 
> 
> The thing is, it's disassociating you and thinks it actually
> deauthenticated you since when you ignore the disassociation and
> continue sending it frames it starts complaining that you weren't
> authenticated (reason=6.)
> 
> Your fix is obviously wrong, and only fixes the problem for you because
> it works around your broken AP that needs a re-authentication after it
> disassociated you.
> 
> I'm not sure what we can do about that. Assuming we're deauthenticated
> seems completely wrong, and I fear that if we assume deauthentication if
> the association times out then we may easily end up in a loop there.
> 
> johannes

Sorry to hear my AP is broken.

It works ok with other 2 computers with different cards (intel2200bg and 
dlink w/texas acx100) under Linux (ipw2200/acx100) or Windows. No 
problem at all. It worked flawlessly with my notebook (intel3945) using 
ipw3945 with any pre-2.6.24.x kernel.

A couple of months ago I tried kernel 2.6.24 with iwlwifi and moved back 
due to this problem. A week ago, I tried again but this time getting 
into the code and I'm still using kernel 2.6.24.4 with this fix which is 
obviously wrong.

I guess you will hear more often about this problem when more people 
moves to kernel 2.6.24.x.

Regards,
Andres
