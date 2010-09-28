Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40079 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0I1PmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:42:04 -0400
Message-ID: <4CA20CC1.7040305@candelatech.com>
Date: Tue, 28 Sep 2010 08:41:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v4] ath5k: Allow ath5k to support virtual STA and AP interfaces.
References: <1285621588-28184-1-git-send-email-greearb@candelatech.com> <201009281901.07312.br1@einfach.org>
In-Reply-To: <201009281901.07312.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 03:01 AM, Bruno Randolf wrote:
> On Tue September 28 2010 06:06:28 greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Support up to 4 virtual APs and as many virtual STA interfaces
>> as desired.
>>
>> This patch is ported forward from a patch that Patrick McHardy
>> did for me against 2.6.31.
>
> hi ben!
>
> it's great to see this! :) i tested it today, but only using ping, and at it
> seemed to work fine with two WPA and two non-encrypted access points! but
> unfortunately, i have also seen some instablility, and problems like:
>
> hostapd:
> AP-STA-DISCONNECTED 00:0e:8e:25:92:7d
> Station 00:0e:8e:25:92:7d trying to deauthenticate, but it is not
> authenticated.
> handle_auth_cb: STA 00:0e:8e:25:92:7d not found
> handle_assoc_cb: STA 00:0e:8e:25:92:7d not found
>
> and:
>
> Could not set station 00:0e:8e:25:92:7d flags for kernel driver (errno=97).
> handle_auth_cb: STA 00:0e:8e:25:92:7d not found

Thanks for the in-depth review!

We've just started serious testing on this, so likely problems remain.

>> +void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif
>> *vif) +{
>> +	struct ath_common *common = ath5k_hw_common(sc->ah);
>> +	struct ath_vif_iter_data iter_data;
>> +
>> +	/*
>> +	 * Use the hardware MAC address as reference, the hardware uses it
>> +	 * together with the BSSID mask when matching addresses.
>> +	 */
>> +	iter_data.hw_macaddr = common->macaddr;
>> +	memset(&iter_data.mask, 0xff, ETH_ALEN);
>> +	iter_data.found_active = false;
>> +	iter_data.need_set_hw_addr = true;
>> +
>> +	if (vif)
>> +		ath_vif_iter(&iter_data, vif->addr, vif);
>> +
>> +	/* Get list of all active MAC addresses */
>> +	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath_vif_iter,
>> +						&iter_data);
>
> maybe i misunderstand something here, but why call ath_vif_iter()? doesn't
> ieee80211_iterate_active_interfaces_atomic() iterate over it anyways?

When adding an interface, it isn't running yet, so the iterate would skip
it.  I basically copied this code directly out of ath9k virtual.c.

>>   	/* configure operational mode */
>>   	ath5k_hw_set_opmode(ah, sc->opmode);
>> @@ -698,13 +760,13 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct
>> ath5k_buf *bf, flags |= AR5K_TXDESC_RTSENA;
>>   		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
>>   		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
>> -			sc->vif, pktlen, info));
>> +			NULL, pktlen, info));
>
> hmm, this NULL means we don't handle short preamble and erp correctly. i don't
> know if we did before, but it would be better to use the corresponding vif - i
> think it can be found in ieee80211_tx_info *info.

I just copied this from my .31 code, and it may well have been broken there.
I'll see if I can make this better.

>>   	if (WARN_ON(!vif)) {
>> @@ -1757,11 +1823,34 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct
>> ieee80211_vif *vif)
>>
>>   	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
>>
>> -	ath5k_txbuf_free_skb(sc, sc->bbuf);
>> -	sc->bbuf->skb = skb;
>> -	ret = ath5k_beacon_setup(sc, sc->bbuf);
>> +	if (!avf->bbuf) {
>> +		WARN_ON(list_empty(&sc->bcbuf));
>> +		avf->bbuf = list_first_entry(&sc->bcbuf, struct ath5k_buf,
>> +					     list);
>> +		list_del(&avf->bbuf->list);
>> +
>> +		/* Assign the vap to a beacon xmit slot. */
>> +		if (avf->opmode == NL80211_IFTYPE_AP) {
>> +			int slot;
>> +
>> +			avf->bslot = 0;
>> +			for (slot = 0; slot<  ATH_BCBUF; slot++) {
>> +				if (!sc->bslot[slot]) {
>> +					avf->bslot = slot;
>> +					break;
>> +				}
>> +			}
>> +			BUG_ON(sc->bslot[avf->bslot] != NULL);
>> +			sc->bslot[avf->bslot] = vif;
>> +			sc->nbcnvifs++;
>> +		}
>> +	}
>
> hmm, do we really have to do that here? couldn't we assign the beacon slot
> when the interface is added?

Well, it might could be done with the interface is configured UP,
at least.  I'm not too sure why this code was written as it is.

>> +	if (vif)
>> +		avf = (void *)vif->drv_priv;
>> +	else
>> +		return;
>
> i think this is part of what breaks ad-hoc beacons... we also need to assign a
> slot in adhoc mode...

Ok..we never tested ad-hoc.  Patches welcome if you get it working
before I get a chance to try it :)

>> @@ -2056,6 +2175,15 @@ ath5k_intr(int irq, void *dev_id)
>>
>>   	do {
>>   		ath5k_hw_get_isr(ah,&status);		/* NB: clears IRQ too */
>> +		{
>> +			static unsigned int irq_counter;
>> +			if ((++irq_counter % 10000) == 9999) {
>> +				ATH5K_WARN(sc, "status 0x%x/0x%x  dev_id: %p"
>> +					   "  counter: %i  irq_counter: %i\n",
>> +					   status, sc->imask, dev_id, counter,
>> +					   irq_counter);
>> +			}
>> +		}
>
> why did you add this code?
>
> i see these warnings:
> ath5k phy0: status 0x1/0x800814b5  dev_id: c7e30d20  counter: 1000
> irq_counter: 9999
> ath5k phy0: status 0x1/0x800814b5  dev_id: c7e30d20  counter: 1000
> irq_counter: 19999
> ath5k phy0: status 0x1/0x800814b5  dev_id: c7e30d20  counter: 1000
> irq_counter: 29999
> ath5k phy0: status 0x1/0x800814b5  dev_id: c7e30d20  counter: 1000
> irq_counter: 39999

In .31 testing, we saw cases where the system basically live-locked
trying to endlessly handle irqs.  This code was to help detect and debug
this..but it can be removed from the final patch.

>>   	spinlock_t		block;		/* protects beacon */
>>   	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
>> -	struct ath5k_buf	*bbuf;		/* beacon buffer */
>> +	struct list_head	bcbuf;		/* beacon buffer */
>> +	struct ieee80211_vif	*bslot[ATH_BCBUF];
>
> it seems a bit pointless to use a linked list to keep the beacon buffers,
> since they are more or less statically assigned to the slots / vifs anyways.
> couldn't we pre-assign one buffer per slot (skb would be NULL if unused, or we
> keep track of that some other way)?

Sounds reasonable to me...not sure why this was written as it is.

>
> i will continue to test and i will look at the adhoc beacon problem tomorrow.

I'll work on addressing your comments and will post a new version when I
make some progress.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
