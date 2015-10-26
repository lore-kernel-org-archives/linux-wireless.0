Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19892 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbbJZHsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 03:48:00 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"egrumbach@gmail.com" <egrumbach@gmail.com>
Subject: Re: [PATCH v2] net: tso: add support for IPv6
Date: Mon, 26 Oct 2015 07:47:54 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8B07E2@hasmsx107.ger.corp.intel.com> (sfid-20151026_084808_361232_DF1DF309)
References: <1445803107-18513-1-git-send-email-emmanuel.grumbach@intel.com>
 <1445803371-19778-1-git-send-email-emmanuel.grumbach@intel.com>
 <562DA5FF.6040307@lab.ntt.co.jp>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/26/2015 06:03 AM, Toshiaki Makita wrote:
> On 2015/10/26 5:02, Emmanuel Grumbach wrote:
>> Adding IPv6 for the TSO helper API is trivial:
>> * Don't play with the id (which doesn't exist in IPv6)
>> * Correctly update the payload_len (don't include the
>>   length of the IP header itself)
> ...
>>  	memcpy(hdr, skb->data, hdr_len);
>> -	iph = (struct iphdr *)(hdr + mac_hdr_len);
>> -	iph->id = htons(tso->ip_id);
>> -	iph->tot_len = htons(size + hdr_len - mac_hdr_len);
>> +	if (skb->protocol == htons(ETH_P_IP)) {
> 
> I guess this should be vlan_get_protocol(skb).

I truly don't know. I guess we could have VLANs, but I'd need to check
how the packet would look like after it exits mac80211.
If we need that, I'll likely do this check once in tso_start() and add a
variable to struct tso_t.

> 
>> +		struct iphdr *iph = (void *)(hdr + mac_hdr_len);
>> +
>> +		iph->id = htons(tso->ip_id);
>> +		iph->tot_len = htons(size + hdr_len - mac_hdr_len);
>> +		tso->ip_id++;
>> +	} else if (skb->protocol == htons(ETH_P_IPV6)) {
> 
> Likewise.
> 
> Toshiaki Makita
> 
> 
