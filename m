Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42679 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0IWN0K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 09:26:10 -0400
Message-ID: <4C9B5567.4080306@openwrt.org>
Date: Thu, 23 Sep 2010 15:25:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: greearb@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [mac80211] ath5k:  Support virtual interfaces.
References: <1285213229-19138-1-git-send-email-greearb@candelatech.com> <4C9B2444.9030608@openwrt.org> <4C9B517C.9050204@candelatech.com>
In-Reply-To: <4C9B517C.9050204@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-23 3:09 PM, Ben Greear wrote:
> On 09/23/2010 02:56 AM, Felix Fietkau wrote:
>> On 2010-09-23 5:40 AM, greearb@gmail.com wrote:
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> This allows ath5k to support virtual STA and AP interfaces.
>>>
>>> This patch is ported forward from a patch that Patrick McHardy
>>> did for me against 2.6.31.
>>>
>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>> ---
>>> :100644 100644 504c6d6... 49f10ea... M	drivers/net/wireless/ath/ath5k/base.c
>>> :100644 100644 7f9d0d3... ec5c3c0... M	drivers/net/wireless/ath/ath5k/base.h
>>> :100644 100644 58912cd... 5b179d0... M	drivers/net/wireless/ath/ath5k/reset.c
>>>   drivers/net/wireless/ath/ath5k/base.c  |  249 +++++++++++++++++++++++++++-----
>>>   drivers/net/wireless/ath/ath5k/base.h  |   27 +++-
>>>   drivers/net/wireless/ath/ath5k/reset.c |    4 +-
>>>   3 files changed, 236 insertions(+), 44 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>>> index 504c6d6..49f10ea 100644
>>> --- a/drivers/net/wireless/ath/ath5k/base.c
>>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>>> @@ -509,6 +509,29 @@ ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
>>>   	}
>>>   }
>>>
>>> +static void ath5k_update_bssid_mask(struct ath5k_softc *sc)
>>> +{
>>> +	struct ath5k_vif *avf;
>>> +	unsigned int i, j;
>>> +
>>> +	/*
>>> +	 * This doesn't include the address of the default STA device in case
>>> +	 * it is reconfigured since for some reason it is not created through
>>> +	 * ->add_interface().
>>> +	 */
>>> +	memset(sc->bssidmask, 0xff, ETH_ALEN);
>>> +	for (i = 0; i<  ATH5K_VIF_MAX; i++) {
>>> +		if (sc->vifs[i] == NULL)
>>> +			continue;
>>> +		avf = (void *)sc->vifs[i]->drv_priv;
>>> +		for (j = 0; j<  ETH_ALEN; j++) {
>>> +			sc->bssidmask[j]&= ~(sc->lladdr[j] ^ avf->lladdr[j]);
>>> +			sc->bssidmask[j]&= ~(sc->lladdr[j] ^ avf->bssid[j]);
>> avf->bssid seems to be duplicated. I think you can remove that field
>> entirely. And even if it were to contain the BSSID (in the STA case),
>> you should not use it to calculate the bssidmask.
> 
> I'll check on this..  Might could make it more like ath9k's anyway.
> 
>>
>>
>>> @@ -2671,30 +2764,70 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
>>>   {
>>>   	struct ath5k_softc *sc = hw->priv;
>>>   	int ret;
>>> +	struct ath5k_hw *ah = sc->ah;
>>> +	struct ath5k_vif *avf = (void *)vif->drv_priv;
>>> +	unsigned int i;
>>>
>>>   	mutex_lock(&sc->lock);
>>> -	if (sc->vif) {
>>> -		ret = 0;
>>> +
>>> +	if (sc->nvifs>  1&&  !modparam_nohwcrypt) {
>>> +		pr_err("ath5k: can not add multiple virtual interfaces with hardware encryption\n");
>> Why not? Other drivers can do this just fine.
> 
> ath9k and ath5k, at least, cannot do multiple STA with hardware encryption,
> as far as I know.
I think that can be fixed in software by switching over to using address
based key lookup. In either case, this should not restrict the use of
multiple AP interfaces...

>>> diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
>>> index 7f9d0d3..ec5c3c0 100644
>>> --- a/drivers/net/wireless/ath/ath5k/base.h
>>> +++ b/drivers/net/wireless/ath/ath5k/base.h
>>> @@ -58,8 +58,8 @@
>>>
>>>   #define	ATH_RXBUF	40		/* number of RX buffers */
>>>   #define	ATH_TXBUF	200		/* number of TX buffers */
>>> -#define ATH_BCBUF	1		/* number of beacon buffers */
>>> -
>>> +#define ATH_BCBUF	16		/* number of beacon buffers */
>> A value of 16 here seems a bit much for staggered beacons. IMHO that
>> will increase the likelihood of stuck beacon issues in the long run.
>> I think 4 would be a better value to start with for now.
>> In the future we should probably make the SWBA timing more dynamic based
>> on the actual number of AP mode interfaces.
> 
> We ran tests before with at least 8 VAPs and it seemed to work fine.  Maybe
> we can compromise to 8?
Did you test it under very heavy load? My suggestion for supporting more
interfaces would be to keep 4 SWBA slots, and after the fourth interface
is added, assign the extra interfaces to the existing slots.
Then when transmitting beacons, link together all DMA descriptors
assigned to the current slot. That way you have less issues with
imprecise timers, IRQ delays and similar things, which are more likely
to show up on embedded hardware than on regular PCs. This also has the
advantage of using less power, as it generates less useless wakeups per
second.

- Felix

