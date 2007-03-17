Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43541 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbXCQWJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 18:09:45 -0400
Message-ID: <45FC6727.3090008@warmcat.com>
Date: Sat, 17 Mar 2007 22:09:43 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070317105800.659633351@warmcat.com> <20070317110751.352850972@warmcat.com> <200703171730.33349.flamingice@sourmilk.net> <200703171751.50898.flamingice@sourmilk.net>
In-Reply-To: <200703171751.50898.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Saturday 17 March 2007 17:30, Michael Wu wrote:
>>> +		/* process and remove the injection radiotap header */
>>> +
>>> +	if(control->flags & IEEE80211_TXCTL_INJECTED_PACKET) {
>> dev points to the virtual interface that the frame originally came in on.
>> You can get sdata from that and figure out if the interface was a monitor
>> interface.
>>
> Of course, this depends on ifindex being set properly.
> 
> You added:
> 	pkt_data->ifindex =  local->mdev->ifindex;
> 
> but in that same function, this is used instead:
> 	pkt_data->ifindex = sdata->dev->ifindex;
> 
> Which allows the master device to figure out which virtual interface the skb 
> came from.

Yeah naturally it was my first move to use what was there, but the 
result was a panic that went away when I moved the skb to belong to the 
"master" interface's index and separately persistently tagged the packet 
as being injected.

Is it safe against race problems on interface removal to consider to 
look up against the interface index at actual send time?

-Andy

