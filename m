Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from goliath.siemens.de ([192.35.17.28]:24650 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0C2Nl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 09:41:58 -0400
Message-ID: <4BB0ADFA.8010205@siemens.com>
Date: Mon, 29 Mar 2010 15:41:14 +0200
From: Marco Porsch <marco.porsch@siemens.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iw station del broken?
References: <4BB0A16A.7080400@siemens.com>	 <1269867487.4131.28.camel@jlt3.sipsolutions.net>	 <4BB0A5B1.9090003@siemens.com> <1269868155.4131.29.camel@jlt3.sipsolutions.net>
In-Reply-To: <1269868155.4131.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:
> On Mon, 2010-03-29 at 15:05 +0200, Marco Porsch wrote:
>   
>> Johannes Berg schrieb:
>>     
>>> On Mon, 2010-03-29 at 14:47 +0200, Marco Porsch wrote:
>>>   
>>>       
>>>> Hi list,
>>>>
>>>> is it just me or is 'iw dev <devname> station del <MAC address>' broken?
>>>>     
>>>>         
>>> No ... we decided a while ago that station manipulation in mesh was too
>>> hard to support and removed it.
>>>
>>> What's the use case anyway?
>>>
>>> johannes
>>>   
>>>       
>> The use case is that, if I have some mesh points in a single room or one 
>> a small floor, I can simply give them a topology by removing the links 
>> between the STA, I do not wish to be directly connected.
>> Removing the links means 'iw dev <devname> set mesh_param 
>> mesh_auto_open_plinks 0', which blocks building up new peering links, 
>> and then removing some links with 'station del'.
>>     
>
> Can't you just do that before it gets discovered?
>
> I'm not really happy with the mesh API anyway ...
>
> johannes
>
>   
That makes any scripting impossible, because it would mean a fine timing 
between the ifup on the stations. Also I think you can't build complex 
topologies this way.
The alternative iw dev <devname> mpath set <destination MAC address> 
next_hop <next hop MAC address> is not useful (if it is still included 
though ^^) because it sets paths hard. Means that these paths are not 
changed, even if they are broken.

Well, you're the maintainer. Your choice.

By the way: which was the last version with 'station del' in mesh 
intact? Which codeparts would have to be exchanged if i'd like to use 
this further? Only iw and nl80211?
