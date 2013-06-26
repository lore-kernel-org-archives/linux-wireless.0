Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.msg.oleane.net ([62.161.4.3]:52751 "EHLO
	smtp03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3FZJgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 05:36:17 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <1372174262-13526-1-git-send-email-cedric.voncken@acksys.fr>	 (sfid-20130625_205307_645728_289E3D48) <1372232028.8157.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1372232028.8157.1.camel@jlt4.sipsolutions.net>
Subject: RE: [PATCH] wireless: vlan priority handling in WMM
Date: Wed, 26 Jun 2013 11:36:13 +0200
Message-ID: <059a01ce7250$9980fa80$cc82ef80$@acksys.fr> (sfid-20130626_113620_627997_FE6531B8)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>On Tue, 2013-06-25 at 17:31 +0200, cedric.voncken@acksys.fr wrote:
>> From: Cedric Voncken <cedric.voncken@acksys.fr>
>> 
>> If the VLAN priority is set in skb->vlan_tci use it to determine the WMM priority.

>What's the VLAN priority? How are you even running 802.1q on top of wifi? heh.
I used the wireless as bridge (The wireless vif client is bridged with my eth0). The VLAN tag is already present in frame when I received it from eth0. The eth0 driver set the skb->vlan_tci. 

>> @@ -694,6 +695,10 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
>>  	if (skb->priority >= 256 && skb->priority <= 263)
>>  		return skb->priority - 256;
>>  
>> +	vlan_priority = (skb->vlan_tci >> 13) & 0x07;

>Are there no symbolic constants for this?
Fix in V2

>> +		if (vlan_priority > 0)
>> +			return vlan_priority;

>I think you got indentation a bit confused :-)
Sorry, it will fix in V2.

Cedric


