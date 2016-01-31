Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34815 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbcAaKMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 05:12:08 -0500
Received: by mail-wm0-f66.google.com with SMTP id p63so4621682wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2016 02:12:07 -0800 (PST)
Subject: Re: [PATCH FIX?] brcmfmac: fix possible overflows in flowrings code
 by bumping u8 to u16
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
References: <1454198830-13971-1-git-send-email-zajec5@gmail.com>
 <56ADDA44.90707@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <56ADDDF0.3080302@gmail.com> (sfid-20160131_111214_182268_4AA7D10A)
Date: Sun, 31 Jan 2016 11:12:00 +0100
MIME-Version: 1.0
In-Reply-To: <56ADDA44.90707@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 31-01-16 10:56, Arend van Spriel wrote:
> On 31-01-16 01:07, Rafał Miłecki wrote:
>> Some devices may use more than 255 flowings, below is log from BCM4366:
>> [  194.606245] brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 264
>>
>> At various places we were using u8 which could lead to storing wrong
>> number or infinite loops when indexing incorrectly. Initially this
>> issue was spotted as infinite loop in brcmf_flowring_detach.
> 
> There has already been a patch submitted for this [1]. However, because
> you reported issues with that patch on your device (not sure which one) ...

[let finish this sentence]... the patch never got applied to
wireless-drivers-next.

> Did you test this patch on that particular device.
> 
> I want Hante to review your patch, but indeed this would be 4.5 material
> and probably stable.

So please Cc: stable@vger.kernel.org once reviewed by Hante.

Regards,
Arend

> Regards,
> Arend
> 
> [1]
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/141004/focus=141003
> 
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> I guess it's a good candidate for a fix (4.5 material). Any objections?
>> ---
>>  .../broadcom/brcm80211/brcmfmac/flowring.c         | 24 +++++++++++-----------
>>  .../broadcom/brcm80211/brcmfmac/flowring.h         | 18 ++++++++--------
>>  .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  4 ++--
>>  .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |  2 +-
>>  4 files changed, 24 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
>> index 2ca783f..3d2373b 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
>> @@ -169,7 +169,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
>>  }
>>  
>>  
>> -u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid)
>> +u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u16 flowid)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>>  
>> @@ -179,7 +179,7 @@ u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid)
>>  }
>>  
>>  
>> -static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
>> +static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
>>  				 bool blocked)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>> @@ -228,7 +228,7 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
>>  }
>>  
>>  
>> -void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid)
>> +void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>>  	u8 hash_idx;
>> @@ -253,7 +253,7 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid)
>>  }
>>  
>>  
>> -u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
>> +u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u16 flowid,
>>  			   struct sk_buff *skb)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>> @@ -279,7 +279,7 @@ u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
>>  }
>>  
>>  
>> -struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid)
>> +struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u16 flowid)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>>  	struct sk_buff *skb;
>> @@ -300,7 +300,7 @@ struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid)
>>  }
>>  
>>  
>> -void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u8 flowid,
>> +void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u16 flowid,
>>  			     struct sk_buff *skb)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>> @@ -311,7 +311,7 @@ void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u8 flowid,
>>  }
>>  
>>  
>> -u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u8 flowid)
>> +u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u16 flowid)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>>  
>> @@ -326,7 +326,7 @@ u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u8 flowid)
>>  }
>>  
>>  
>> -void brcmf_flowring_open(struct brcmf_flowring *flow, u8 flowid)
>> +void brcmf_flowring_open(struct brcmf_flowring *flow, u16 flowid)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>>  
>> @@ -340,7 +340,7 @@ void brcmf_flowring_open(struct brcmf_flowring *flow, u8 flowid)
>>  }
>>  
>>  
>> -u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u8 flowid)
>> +u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u16 flowid)
>>  {
>>  	struct brcmf_flowring_ring *ring;
>>  	u8 hash_idx;
>> @@ -384,7 +384,7 @@ void brcmf_flowring_detach(struct brcmf_flowring *flow)
>>  	struct brcmf_pub *drvr = bus_if->drvr;
>>  	struct brcmf_flowring_tdls_entry *search;
>>  	struct brcmf_flowring_tdls_entry *remove;
>> -	u8 flowid;
>> +	u16 flowid;
>>  
>>  	for (flowid = 0; flowid < flow->nrofrings; flowid++) {
>>  		if (flow->rings[flowid])
>> @@ -408,7 +408,7 @@ void brcmf_flowring_configure_addr_mode(struct brcmf_flowring *flow, int ifidx,
>>  	struct brcmf_bus *bus_if = dev_get_drvdata(flow->dev);
>>  	struct brcmf_pub *drvr = bus_if->drvr;
>>  	u32 i;
>> -	u8 flowid;
>> +	u16 flowid;
>>  
>>  	if (flow->addr_mode[ifidx] != addr_mode) {
>>  		for (i = 0; i < ARRAY_SIZE(flow->hash); i++) {
>> @@ -434,7 +434,7 @@ void brcmf_flowring_delete_peer(struct brcmf_flowring *flow, int ifidx,
>>  	struct brcmf_flowring_tdls_entry *prev;
>>  	struct brcmf_flowring_tdls_entry *search;
>>  	u32 i;
>> -	u8 flowid;
>> +	u16 flowid;
>>  	bool sta;
>>  
>>  	sta = (flow->addr_mode[ifidx] == ADDR_INDIRECT);
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
>> index 95fd1c9..c59f684 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
>> @@ -24,7 +24,7 @@ struct brcmf_flowring_hash {
>>  	u8 mac[ETH_ALEN];
>>  	u8 fifo;
>>  	u8 ifidx;
>> -	u8 flowid;
>> +	u16 flowid;
>>  };
>>  
>>  enum ring_status {
>> @@ -61,16 +61,16 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
>>  			  u8 prio, u8 ifidx);
>>  u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
>>  			  u8 prio, u8 ifidx);
>> -void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid);
>> -void brcmf_flowring_open(struct brcmf_flowring *flow, u8 flowid);
>> -u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid);
>> -u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
>> +void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid);
>> +void brcmf_flowring_open(struct brcmf_flowring *flow, u16 flowid);
>> +u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u16 flowid);
>> +u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u16 flowid,
>>  			   struct sk_buff *skb);
>> -struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid);
>> -void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u8 flowid,
>> +struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u16 flowid);
>> +void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u16 flowid,
>>  			     struct sk_buff *skb);
>> -u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u8 flowid);
>> -u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u8 flowid);
>> +u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u16 flowid);
>> +u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u16 flowid);
>>  struct brcmf_flowring *brcmf_flowring_attach(struct device *dev, u16 nrofrings);
>>  void brcmf_flowring_detach(struct brcmf_flowring *flow);
>>  void brcmf_flowring_configure_addr_mode(struct brcmf_flowring *flow, int ifidx,
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
>> index c2bdb91..0b9c2dd 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
>> @@ -677,7 +677,7 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
>>  }
>>  
>>  
>> -static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u8 flowid)
>> +static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
>>  {
>>  	struct brcmf_flowring *flow = msgbuf->flow;
>>  	struct brcmf_commonring *commonring;
>> @@ -1310,7 +1310,7 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
>>  }
>>  
>>  
>> -void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u8 flowid)
>> +void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
>>  {
>>  	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
>>  	struct msgbuf_tx_flowring_delete_req *delete;
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
>> index 3d513e4..ee6906a 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
>> @@ -33,7 +33,7 @@
>>  
>>  
>>  int brcmf_proto_msgbuf_rx_trigger(struct device *dev);
>> -void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u8 flowid);
>> +void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid);
>>  int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr);
>>  void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr);
>>  #else
>>
