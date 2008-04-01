Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:38489 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754746AbYDANwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 09:52:06 -0400
Message-ID: <47F23C6B.6060205@yahoo.com> (sfid-20080401_145210_897585_A9C95B1A)
Date: Tue, 01 Apr 2008 09:45:15 -0400
From: Andres Bertens <abertensu@yahoo.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: FW: [ipw3945-devel] iwl3945: disassociation from AP (reason=4)
 andtimeout, a solution
References: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com>	 <1206999696.20744.2.camel@localhost.localdomain> <1207051434.5143.58.camel@johannes.berg>
In-Reply-To: <1207051434.5143.58.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
>>>> After browsing the internet, I found a lot of people with the same
>>>> problem and no solution. So, I dived into the code and found a simple
>>>> solution: ignore disassociation. When a new request arrives to the
>>>> wireless, a reconnection is done automatically.
>> Ignoring the disassociation from the AP is suspect...  wouldn't the AP
>> be releasing resources associated with the station, requiring a
>> reassociate/reauth from the station?  Reason 4 seems to mean "Inactivity
>> timer expired and station was disassociated".
> 
> Indeed.
> 
>> A better solution would be to queue up a reassocation worker if the AP
>> kicked you off for reason 4, maybe?
> 
> It would think so, yes.
> 
> johannes

Reason=4 is in fact "Inactivity timer expired and station was 
disassociated". According to my router log:
"Tuesday April 01, 2008 09:08:54 Disassociated: 00-19-D2-4F-22-4D 
because idle 300 seconds"

Indeed, the default behaviour goes for a reassocation but my hw/sw 
combination (intel3945/dlink/wep) fails with a status=17 (AP unable to 
handle new status). After 3 tries, it dies with an AP association 
timeout. From there is no recovery till I set the interface down and up.

That's why I solved it (perhaps not in the best way) ignoring the 
disassociation. Now it works.

Andres
