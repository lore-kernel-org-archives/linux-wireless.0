Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35825 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbcDFP4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 11:56:17 -0400
Received: by mail-vk0-f65.google.com with SMTP id e185so7889204vkb.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 08:56:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5704C751.3060201@broadcom.com>
References: <1459886507-26249-1-git-send-email-per.forlin@gmail.com>
	<5704C751.3060201@broadcom.com>
Date: Wed, 6 Apr 2016 17:56:01 +0200
Message-ID: <CAC0pXTKtAPmK74E1ue1YUhS9YgFb0_NWC3veNQXrwvoPhyG=sw@mail.gmail.com> (sfid-20160406_175638_890504_5EB6B3D8)
Subject: Re: [PATCH v2] brcmfmac: Don't increase 8021x_cnt for dropped packets
From: =?UTF-8?Q?Per_F=C3=B6rlin?= <per.forlin@gmail.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for getting back to me,

* Chip: chip 43340 rev 2 pmurev 20
* I'm running kernel 4.1 (backports) for the wireless parts
* I have not to setup my environment for the latest kernel yet.
  It's on my todo list.

Looking at the code you pointed out I realize my fix i misplaced.
It's strange that I don't end up with a negative count since
the counter would be decreased twice, with my patch in place.
I took a closer look at the execution flow and made the following
observation:

The eh->h_proto has changed when reaching the txfinalize() function.
This only happens in case of packet drop.

Simplified execution flow.

brcmf_fws_process_skb():
  # At this point ntohs(eh->h_proto) == 0x888E (ETH_P_PAE)
  rc = brcmf_proto_txdata() ->
    brcmf_proto_bcdc_txdata() ->
      brcmf_sdio_bus_txdata()
  # At this point it has changed to: ntohs(eh->h_proto) == 0x8939 (?)
  if (rc < 0)
    # When executing this function the cnt will not be decreased due to
    # eh->h_proto being changed.
    brcmf_txfinalize()

I need to continue my investigation to find out why the h_proto got changed.
I assume this is not an expected behavior?

BR
Per


2016-04-06 10:22 GMT+02:00 Arend Van Spriel <arend.vanspriel@broadcom.com>:
> On 5-4-2016 22:01, per.forlin@gmail.com wrote:
>> From: Per Forlin <per.forlin@gmail.com>
>>
>> The pend_8021x_cnt gets into a state where it's not being decreased.
>> When the brcmf_netdev_wait_pend8021x is called it will timeout
>> because there are no pending packets to be consumed. There is no
>> easy way of getting out of this state once it has happened.
>> Preventing the counter from being increased in case of dropped
>> packets seem like a reasonable solution.
>>
>> Log showing overflow txq and increased cnt:
>>
>> // Extra debug prints
>> brcmfmac: [brcmf_netdev_wait_pend8021x] pend_8021x_cnt == 0
>> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 1
>> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 2
>>
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
>>
>> // Extra debug prints
>> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 3
>> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 4
>> brcmfmac: [brcmf_netdev_wait_pend8021x] pend_8021x_cnt == 4
>>
>> WARNING: at .../brcmfmac/core.c:1289 brcmf_netdev_wait_pend8021x
>>   (warn_slowpath_common)
>>   (warn_slowpath_null)
>>   (brcmf_netdev_wait_pend8021x [brcmfmac])
>>   (send_key_to_dongle [brcmfmac])
>>   (brcmf_cfg80211_del_key [brcmfmac])
>>   (nl80211_del_key [cfg80211])
>>   (genl_rcv_msg)
>>   (netlink_rcv_skb)
>>   (genl_rcv)
>>   (netlink_unicast)
>>   (netlink_sendmsg)
>>   (sock_sendmsg)
>>   (___sys_sendmsg)
>>   (__sys_sendmsg)
>>   (SyS_sendmsg)
>>
>> Signed-off-by: Per Forlin <per.forlin@gmail.com>
>> ---
>> I came across this bug in an older kernel but it seems relevant
>> for the latest kernel as well. I'm not familiar with the code
>> but I can reproduce the issue and verify a fix for it.
>> With this patch I no longer get stuck with a pend8021_cnt > 0.
>>
>> Change log:
>>  v2 - Add variable to know whether the counter is increased or not
>
> Sorry for the late response. Can you elaborate where you are seeing this.
>
> What kind of chipset are you using?
> What kernel version are you running?
>
> The function brcmf_fws_process_skb() should call brcmf_txfinalize() in
> case of an error and it does in latest kernel. There the count is
> decreased. We had an issue mapping to the right ifp as reported by
> Rafał, but that has also been fixed recently. So main question here:
>
> Do you see the issue in the latest kernel?
>
> Regards,
> Arend
>
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> index ed9998b..de80ad8 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> @@ -196,6 +196,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>>       struct brcmf_if *ifp = netdev_priv(ndev);
>>       struct brcmf_pub *drvr = ifp->drvr;
>>       struct ethhdr *eh = (struct ethhdr *)(skb->data);
>> +     bool pend_8021x_cnt_increased = false;
>>
>>       brcmf_dbg(DATA, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
>>
>> @@ -233,14 +234,18 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>>               goto done;
>>       }
>>
>> -     if (eh->h_proto == htons(ETH_P_PAE))
>> +     if (eh->h_proto == htons(ETH_P_PAE)) {
>>               atomic_inc(&ifp->pend_8021x_cnt);
>> +             pend_8021x_cnt_increased = true;
>> +     }
>>
>>       ret = brcmf_fws_process_skb(ifp, skb);
>>
>>  done:
>>       if (ret) {
>>               ifp->stats.tx_dropped++;
>> +             if (pend_8021x_cnt_increased)
>> +                     atomic_dec(&ifp->pend_8021x_cnt);
>>       } else {
>>               ifp->stats.tx_packets++;
>>               ifp->stats.tx_bytes += skb->len;
>>
