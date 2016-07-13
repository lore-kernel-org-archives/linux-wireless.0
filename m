Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36085 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcGMLVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 07:21:10 -0400
Received: by mail-pa0-f49.google.com with SMTP id pp5so10364040pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 04:20:50 -0700 (PDT)
Subject: Re: [PATCH v4] brcmfmac: Decrease 8021x_cnt for dropped packets
To: =?UTF-8?Q?Per_F=c3=b6rlin?= <per.forlin@gmail.com>
References: <1460498140-18874-1-git-send-email-per.forlin@gmail.com>
 <CAC0pXTLDeiiVma7AGD1XirQG=SqSDht_BA3arQQnvn=ztTLDug@mail.gmail.com>
 <CAC0pXTJ-hnKgSMwf7KYPwBs7RB2YAgaouOdeJwD2kuLneCGXfA@mail.gmail.com>
 <38869535-4f77-f6d8-d8d0-cb01b3f9c65b@broadcom.com>
 <CAC0pXTKPm=Q2__OuYEp0p4RC_Jum_+tuS3-7R-hBcoa8Ka8==Q@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org, arend@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cdb613ba-d2b1-d9eb-9beb-2934cff96aa6@broadcom.com> (sfid-20160713_132256_090407_1C0147CC)
Date: Wed, 13 Jul 2016 13:20:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAC0pXTKPm=Q2__OuYEp0p4RC_Jum_+tuS3-7R-hBcoa8Ka8==Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-7-2016 12:23, Per Förlin wrote:
> 2016-07-12 11:48 GMT+02:00 Arend Van Spriel <arend.vanspriel@broadcom.com>:
>>
>>
>> On 12-7-2016 10:35, Per Förlin wrote:
>>> 2016-07-06 11:53 GMT+02:00 Per Förlin <per.forlin@gmail.com>:
>>>> I have now verified this patch on backports 4.4.
>>>>
>>>> 2016-04-12 23:55 GMT+02:00  <per.forlin@gmail.com>:
>>>>> From: Per Forlin <per.forlin@gmail.com>
>>>>>
>>>>> This patch resolves an issue where pend_8021x_cnt was not decreased
>>>>> on txfinalize. This caused brcmf_netdev_wait_pend8021x to timeout
>>>>> because the counter indicated pending packets.
>>>>>
>>>>> WARNING: at .../brcmfmac/core.c:1289 brcmf_netdev_wait_pend8021x
>>>>>   (warn_slowpath_common)
>>>>>   (warn_slowpath_null)
>>>>>   (brcmf_netdev_wait_pend8021x [brcmfmac])
>>>>>   (send_key_to_dongle [brcmfmac])
>>>>>   (brcmf_cfg80211_del_key [brcmfmac])
>>>>>   (nl80211_del_key [cfg80211])
>>>>>   (genl_rcv_msg)
>>>>>   (netlink_rcv_skb)
>>>>>   (genl_rcv)
>>>>>   (netlink_unicast)
>>>>>   (netlink_sendmsg)
>>>>>   (sock_sendmsg)
>>>>>   (___sys_sendmsg)
>>>>>   (__sys_sendmsg)
>>>>>   (SyS_sendmsg)
>>>>>
>>>>> The solution is to pull back the header offset in case
>>>>> of an error in txdata(), which may happen in case of
>>> Clarification:
>>>
>>> txdata=brcmf_proto_bcdc_txdata()
>>> brcmf_proto_bcdc_txdata(): Calls brcmf_proto_bcdc_hdrpush()
>>>
>>> The header needs to be pulled back in case of error otherwise
>>> the error handling and cleanup up will fail to decrease the counter
>>> of pending packets.
>>
>> Yes, this part of the patch is clear to me.
>>
> Thanks, I wasn't sure.
> 
>>>>> packet overload in brcmf_sdio_bus_txdata.
>>>>>
>>>>> Overloading an WLAN interface is not an unlikely scenario.
>>
>> So here is where things start to look suspicious and I have mentioned
>> this before. My thought here was "How the hell can you end up with a
>> 2048 packets on the sdio queue", which I mentioned to you before. There
>> is a high watermark on the queue upon which we do a netif_stop_queue()
>> so network layer does not keep pushing tx packets our way. Looking
>> further into this I found that we introduced a bug with commit
>> 9cd18359d31e ("brcmfmac: Make FWS queueing configurable.") so we ended
>> up doing nothing except increasing as statistics debug counter :-(
>>
> Is there a fix available for the high watermark issue or is it
> something you will look into?
> 
> To produce a load on the wlan interface I run
> iperf -c 239.255.1.3 -u -b 10m -f m -i 60 -t 3000
> and this is enough in my case to fill up the 2048 queue.
> 
>>>>> In case of packet overload the error print "out of bus->txq"
>>>>> is very verbose. To reduce SPAM degrade it to a debug print.
>>>>>
>>>>> Signed-off-by: Per Forlin <per.forlin@gmail.com>
>>>>> ---
>>>>> Change log:
>>>>>  v2 - Add variable to know whether the counter is increased or not
>>>>>  v3 - txfinalize should decrease the counter. Adjust skb header offset
>>>>>  v4 - Fix build error
>>>>>
>>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 4 ++++
>>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 4 +++-
>>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     | 2 +-
>>>>>  3 files changed, 8 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>>> index ed9998b..f342f7c 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>>> @@ -541,6 +541,9 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
>>>>>         struct ethhdr *eh;
>>>>>         u16 type;
>>>>>
>>>>> +       if (!ifp)
>>>>> +               goto free;
>>>>> +
>>
>> This may not be needed.
>>
> This is not strictly needed. I can remove it.
> 
>>>>>         eh = (struct ethhdr *)(txp->data);
>>>>>         type = ntohs(eh->h_proto);
>>>>>
>>>>> @@ -553,6 +556,7 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
>>>>>         if (!success)
>>>>>                 ifp->stats.tx_errors++;
>>>>>
>>>>> +free:
>>>>>         brcmu_pkt_buf_free_skb(txp);
>>>>>  }
>>>>>
>>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
>>>>> index f82c9ab..98cb83f 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
>>>>> @@ -1899,8 +1899,10 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
>>>>>
>>>>>         if (fws->avoid_queueing) {
>>>>>                 rc = brcmf_proto_txdata(drvr, ifp->ifidx, 0, skb);
>>>>> -               if (rc < 0)
>>>>> +               if (rc < 0) {
>>>>> +                       (void)brcmf_proto_hdrpull(drvr, false, skb, &ifp);
>>
>> Could it be that the ifp is NULL pointer after brcmf_proto_hdrpull().
>> Can you check. Better use tmp_ifp variable in this call as you have a
>> valid ifp before this call for sure.
>>
> To be on the safe side I can use NULL as in param like you propose,
> and use the available ifp.
> 
>>>>>                         brcmf_txfinalize(ifp, skb, false);
>>>>> +               }
>>>>>                 return rc;
>>>>>         }
>>>>>
>>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> index a14d9d9d..485e2ad 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> @@ -2721,7 +2721,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
>>>>>         *(u16 *)(pkt->cb) = 0;
>>>>>         if (!brcmf_sdio_prec_enq(&bus->txq, pkt, prec)) {
>>>>>                 skb_pull(pkt, bus->tx_hdrlen);
>>>>> -               brcmf_err("out of bus->txq !!!\n");
>>>>> +               brcmf_dbg(INFO, "out of bus->txq !!!\n");
>>
>> Now that I understand the issue I want to keep this as error print as it
>> should be very unlikely.
> I would like to test this patch with the watermark fix to confirm this.

Can you try this?

Regards,
Arend

---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
b/drive
index cd221ab..9f9024a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2469,10 +2469,22 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info
*fws, str
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
 {
        struct brcmf_fws_info *fws = drvr->fws;
+       struct brcmf_if *ifp;
+       int i;

-       fws->bus_flow_blocked = flow_blocked;
-       if (!flow_blocked)
-               brcmf_fws_schedule_deq(fws);
-       else
-               fws->stats.bus_flow_block++;
+       if (fws->avoid_queueing) {
+               for (i = 0; i < BRCMF_MAX_IFS; i++) {
+                       ifp = drvr->iflist[i];
+                       if (!ifp || !ifp->ndev)
+                               continue;
+                       brcmf_txflowblock_if(ifp,
BRCMF_NETIF_STOP_REASON_FLOW,
+                                            flow_blocked);
+               }
+       } else {
+               fws->bus_flow_blocked = flow_blocked;
+               if (!flow_blocked)
+                       brcmf_fws_schedule_deq(fws);
+               else
+                       fws->stats.bus_flow_block++;
+       }
 }

