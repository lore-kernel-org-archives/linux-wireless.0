Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:40112 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbeGCTlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 15:41:12 -0400
Received: by mail-oi0-f67.google.com with SMTP id w126-v6so6171009oie.7
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2018 12:41:12 -0700 (PDT)
Subject: Re: [PATCH] nl80211/mac80211: Fix cfg80211_rx_control_port
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
References: <20180703182626.26782-1-denkenz@gmail.com>
 <5B3BCC08.3030800@broadcom.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <b7dba32d-174b-91b6-7342-7b045a79d507@gmail.com> (sfid-20180703_214116_188297_A8BB8E36)
Date: Tue, 3 Jul 2018 14:41:04 -0500
MIME-Version: 1.0
In-Reply-To: <5B3BCC08.3030800@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 07/03/2018 02:18 PM, Arend van Spriel wrote:
> Hi Denis,
> 
> I prefer the subject summarizes the issue, eg. "allow non-linear skb 
> data passed to cfg80211_rx_control_port".

Right, I'll fix this in the next version.

> 
> On 7/3/2018 8:26 PM, Denis Kenzior wrote:
>> The current implementation of cfg80211_rx_control_port assumed that the
>> caller could provide a contiguous region of memory for the control port
>> frame to be sent up to userspace.  Unfortunately, many drivers produce
>> non-linear skbs, especially for data frames.  This resulted in userspace
>> getting notified of control port frames with correct metadata (from
>> address, port, etc) yet garbage / nonsense contents, resulting in bad
>> handshakes, disconnections, etc.
> 
> [snip]
> 
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 9ba1f289c439..94842c2a2f73 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -5937,10 +5937,10 @@ void cfg80211_mgmt_tx_status(struct 
>> wireless_dev *wdev, u64 cookie,
>>   /**
>>    * cfg80211_rx_control_port - notification about a received control 
>> port frame
>>    * @dev: The device the frame matched to
>> - * @buf: control port frame
>> - * @len: length of the frame data
>> - * @addr: The peer from which the frame was received
>> - * @proto: frame protocol, typically PAE or Pre-authentication
>> + * @skb: The skbuf with the control port frame.  It is assumed that 
>> the skbuf
>> + * is 802.3 formatted (with 802.3 header).  The skb can be 
>> non-linear.  This
>> + * function does not take ownership of the skb, so the caller is 
>> responsible
>> + * for any cleanup.
>>    * @unencrypted: Whether the frame was received unencrypted
>>    *
>>    * This function is used to inform userspace about a received 
>> control port
>> @@ -5953,8 +5953,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev 
>> *wdev, u64 cookie,
>>    * Return: %true if the frame was passed to userspace
>>    */
>>   bool cfg80211_rx_control_port(struct net_device *dev,
>> -                  const u8 *buf, size_t len,
>> -                  const u8 *addr, u16 proto, bool unencrypted);
>> +                  struct sk_buff *skb, bool unencrypted);
> 
> If we are changing the signature, could we change the return type to 
> int. I don't see much value in the int-2-bool conversion.

I was mostly following the pattern in other cfg80211_rx_ functions here. 
  They all return bool or void.  I'm fine either way.

> 
>>   /**
>>    * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
> 
> [snip]
> 
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 8db59129c095..b75a0144c0a5 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -15036,20 +15036,24 @@ void cfg80211_mgmt_tx_status(struct 
>> wireless_dev *wdev, u64 cookie,
>>   EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
>>
>>   static int __nl80211_rx_control_port(struct net_device *dev,
>> -                     const u8 *buf, size_t len,
>> -                     const u8 *addr, u16 proto,
>> +                     struct sk_buff *skb,
>>                        bool unencrypted, gfp_t gfp)
>>   {
>>       struct wireless_dev *wdev = dev->ieee80211_ptr;
>>       struct cfg80211_registered_device *rdev = 
>> wiphy_to_rdev(wdev->wiphy);
>> +    struct ethhdr *ehdr = eth_hdr(skb);
>> +    const u8 *addr = ehdr->h_source;
>> +    u16 proto = be16_to_cpu(skb->protocol);
> 
> So this means skb->protocol has to be set by driver (using 
> eth_type_trans() helper). Guess mac80211 does it for sure, but better 
> make it a clear requirement for cfg80211-based drivers.
>

Right, mac80211 uses skb->protocol to do the filtering, so this is 
already done.  We could make protocol and addr explicit arguments, but 
it seemed strange to not extract these from the skb.

I guess we could also extract the proto from the eth_hdr or call 
eth_type_trans inside nl80211.  I have no strong feelings here.  It 
would be great if another driver or two tried to implement this and gave 
us feedback as to which works better...
>>       struct sk_buff *msg;
>>       void *hdr;
>> +    struct nlattr *frame;
>> +
>>       u32 nlportid = READ_ONCE(wdev->conn_owner_nlportid);
>>
>>       if (!nlportid)
>>           return -ENOENT;
>>
>> -    msg = nlmsg_new(100 + len, gfp);
>> +    msg = nlmsg_new(100 + skb->len, gfp);
>>       if (!msg)
>>           return -ENOMEM;
>>
>> @@ -15063,13 +15067,17 @@ static int __nl80211_rx_control_port(struct 
>> net_device *dev,
>>           nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
>>           nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
>>                     NL80211_ATTR_PAD) ||
>> -        nla_put(msg, NL80211_ATTR_FRAME, len, buf) ||
>>           nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr) ||
>>           nla_put_u16(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE, proto) ||
>>           (unencrypted && nla_put_flag(msg,
>>                        NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT)))
>>           goto nla_put_failure;
>>
>> +    frame = nla_reserve(msg, NL80211_ATTR_FRAME, skb->len);
>> +    if (!frame)
>> +        goto nla_put_failure;
>> +
>> +    skb_copy_bits(skb, 0, nla_data(frame), skb->len);
>>       genlmsg_end(msg, hdr);
>>
>>       return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);
>> @@ -15080,14 +15088,12 @@ static int __nl80211_rx_control_port(struct 
>> net_device *dev,
>>   }
>>
>>   bool cfg80211_rx_control_port(struct net_device *dev,
>> -                  const u8 *buf, size_t len,
>> -                  const u8 *addr, u16 proto, bool unencrypted)
>> +                  struct sk_buff *skb, bool unencrypted)
>>   {
>>       int ret;
>>
>> -    trace_cfg80211_rx_control_port(dev, buf, len, addr, proto, 
>> unencrypted);
>> -    ret = __nl80211_rx_control_port(dev, buf, len, addr, proto,
>> -                    unencrypted, GFP_ATOMIC);
>> +    trace_cfg80211_rx_control_port(dev, skb, unencrypted);
>> +    ret = __nl80211_rx_control_port(dev, skb, unencrypted, GFP_ATOMIC);
>>       trace_cfg80211_return_bool(ret == 0);
>>       return ret == 0;
>>   }
>> diff --git a/net/wireless/trace.h b/net/wireless/trace.h
>> index 2b417a2fe63f..e18a8b0176e2 100644
>> --- a/net/wireless/trace.h
>> +++ b/net/wireless/trace.h
>> @@ -2627,24 +2627,32 @@ TRACE_EVENT(cfg80211_mgmt_tx_status,
>>   );
>>
>>   TRACE_EVENT(cfg80211_rx_control_port,
>> -    TP_PROTO(struct net_device *netdev, const u8 *buf, size_t len,
>> -         const u8 *addr, u16 proto, bool unencrypted),
>> -    TP_ARGS(netdev, buf, len, addr, proto, unencrypted),
>> +    TP_PROTO(struct net_device *netdev, struct sk_buff *skb,
>> +         bool unencrypted),
>> +    TP_ARGS(netdev, skb, unencrypted),
>>       TP_STRUCT__entry(
>>           NETDEV_ENTRY
>> -        MAC_ENTRY(addr)
>> +        __field(const void *, skbaddr)
>> +        __field(int, len)
> 
> any particular reason for adding these? It is not very informational and 
> if it can be dropped you could consider following:

The length is actually somewhat useful to figure out which frame is 
being passed along, since handshake 1_4 tends to be much smaller than 
3_4 for example.  Not sure why I thought skbaddr was useful.  I'll drop 
it in v2.

> 
>      TRACE_EVENT(cfg80211_rx_control_port,
>          TP_PROTO(struct net_device *ndev, struct ethhdr *ehdr,
>               u16 proto, bool unencrypted),
> 
> so you can....
> 
>> +        MAC_ENTRY(from)
>>           __field(u16, proto)
>>           __field(bool, unencrypted)
>>       ),
>>       TP_fast_assign(
>>           NETDEV_ASSIGN;
>> -        MAC_ASSIGN(addr, addr);
>> -        __entry->proto = proto;
>> +        __entry->skbaddr = skb;
>> +        __entry->len = skb->len;
>> +        do {
>> +            struct ethhdr *ehdr = eth_hdr(skb);
>> +            memcpy(__entry->from, ehdr->h_source, ETH_ALEN);
>> +        } while (0);
>> +        __entry->proto = be16_to_cpu(skb->protocol);
> 
> ... drop the do {} while (0) and use proto param as is. Actually you 
> could just pass eth_hdr(skb)->h_source in memcpy().

Right, your approach is much more elegant.  I ended up doing:

+               MAC_ASSIGN(from, eth_hdr(skb)->h_source);

Thanks for the review!

Regards,
-Denis
