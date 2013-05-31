Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1816 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab3EaT2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 15:28:48 -0400
Message-ID: <51A8F56E.4090704@broadcom.com> (sfid-20130531_212853_196226_D21DF229)
Date: Fri, 31 May 2013 21:09:34 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Ben Greear" <greearb@candelatech.com>,
	"Felix Fietkau" <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: Another try at getting pktgen to work with wifi.
References: <51A79E4A.7000609@candelatech.com>
 <51A7B049.9090201@openwrt.org> <51A7BA63.4080403@candelatech.com>
 <51A857BF.7070008@openwrt.org> <51A8DC1C.1040908@candelatech.com> (
 sfid-20130531_192143_291284_FB196B0A)
 <1370021846.14117.13.camel@jlt4.sipsolutions.net>
 <51A8E53E.8030101@candelatech.com>
 <1370025698.14117.15.camel@jlt4.sipsolutions.net>
 <51A8F141.5050804@candelatech.com>
 <1370027655.14117.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1370027655.14117.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2013 09:14 PM, Johannes Berg wrote:
> On Fri, 2013-05-31 at 11:51 -0700, Ben Greear wrote:
>
>>> What I'm saying though is that I don't see where skb->priority is even
>>> _used_ in the wifi stack. I can see it getting set, but not used.
>>
>> ieee80211_downgrade_queue
>> wme_downgrade_ac // sort of
>> ieee80211_select_queue_80211 // sort of...seems twiddling skb->priority is more of a by-product here.
>>
>> cfg80211_classify8021d
>
> None of this actually matters, it's all within the select_queue() call
> so doesn't need to store it in the skb.
>
> I found it though -- the only thing that ever looks at it is
> ieee80211_set_qos_hdr() to set the QoS header TID, and presumably that's
> what ath9k complains about (hwsim is happy to just push packets.)

Sorry to chime in. The brcmfmac uses cfg80211_classify8021d() as well 
(only when skb->priority equals zero) and puts the return value in 
skb->priority. But also there it is not needed as a few lines below it 
uses it to determine the WWM-AC fifo.

Regards,
Arend

