Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:45054 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbeCMGXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 02:23:36 -0400
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
To: Stephen Hemminger <stephen@networkplumber.org>
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
 <a7a21b04-025f-19e1-ec09-69cc355b9215@gmail.com>
 <20180312160103.1a043936@xeon-e3>
Cc: =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <30949d84-862f-3685-7884-750edf4e9cf4@gmail.com> (sfid-20180313_072343_860147_592DC464)
Date: Tue, 13 Mar 2018 07:23:31 +0100
MIME-Version: 1.0
In-Reply-To: <20180312160103.1a043936@xeon-e3>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2018 12:01 AM, Stephen Hemminger wrote:
> On Mon, 12 Mar 2018 23:42:48 +0100
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> 2) Blame bridge + mcast-to-ucast + hairpin for 802.11f incompatibility
>>
>> If we agree that 802.11f support in FullMAC firmware is acceptable, then
>> we have to make sure Linux's bridge doesn't break it by passing 802.11f
>> (broadcast) frames back to the source interface. That would require a
>> check like in below diff + proper code for handling such packets. I'm
>> afraid I'm not familiar with bridge code enough to complete that.
>>
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> index edae702..9e5d6ea 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -126,6 +126,27 @@ static void br_do_proxy_arp(struct sk_buff *skb, struct net_bridge *br,
>>   	}
>>   }
>>
>> +static bool br_skb_is_iapp_add_packet(struct sk_buff *skb)
>> +{
>> +	const u8 iapp_add_packet[6] __aligned(2) = {
>> +		0x00, 0x01, 0xaf, 0x81, 0x01, 0x00,
>> +	};
>> +#if !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>> +	const u16 *a = (const u16 *)skb->data;
>> +	const u16 *b = (const u16 *)iapp_add_packet;
>> +#endif
>> +
>> +	if (skb->len != 6)
>> +		return false;
>> +
>> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>> +	return !(((*(const u32 *)skb->data) ^ (*(const u32 *)iapp_add_packet)) |
>> +	         ((*(const u16 *)(skb->data + 4)) ^ (*(const u16 *)(iapp_add_packet + 4))));
>> +#else
>> +	return !((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2]));
>> +#endif
>> +}
>> +
>>   /* note: already called with rcu_read_lock */
>>   int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
>>   {
>> @@ -155,6 +176,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>   	if (is_multicast_ether_addr(dest)) {
>>   		/* by definition the broadcast is also a multicast address */
>>   		if (is_broadcast_ether_addr(dest)) {
>> +			if (br_skb_is_iapp_add_packet(skb))
>> +				pr_warn("This packet should not be passed back to the source interface!\n");
>>   			pkt_type = BR_PKT_BROADCAST;
>>   			local_rcv = true;
>>   		} else {
>
>
> Don't like bridge doing special case code for magic received values directly in input path.
> Really needs to be generic which is why I suggested ebtables.

We need in-bridge solution only if we decide to support FullMAC
firmwares with 802.11f implementation.

In that case is this possible to use ebtables as a workaround at all?
Can I really use ebtables to set switch to don't pass 802.11f ADD frames
back to the original interface?
