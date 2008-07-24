Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:11250 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYGXCJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 22:09:51 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2651358rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 19:09:51 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18567.57982.939459.435411@localhost.localdomain> (sfid-20080724_040956_828962_1CB371D7)
Date: Thu, 24 Jul 2008 07:31:34 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] [PATCH 1/4] Add new Atheros IEEE 802.11n ath9k
	driver
In-Reply-To: <1216842238.13587.31.camel@johannes.berg>
References: <20080720024341.GQ17936@ruslug.rutgers.edu>
	<20080720024500.GR17936@ruslug.rutgers.edu>
	<1216842238.13587.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Thanks for the review, Johannes.
I am addressing a few comments here.

Johannes Berg wrote:
 > Only STA support is currently enabled
 > 
 > Thanks for that. The folks at Intel still haven't gotten the message ;)
 > 

How far along is IBSS ?

 > +#define HAL_TX_BA               0x01
 > +#define HAL_TX_PWRMGMT          0x02
 > +#define HAL_TX_DESC_CFG_ERR     0x04
 > +#define HAL_TX_DATA_UNDERRUN    0x08
 > +#define HAL_TX_DELIM_UNDERRUN   0x10
 > +#define HAL_TX_SW_ABORTED       0x40
 > +#define HAL_TX_SW_FILTERED      0x80
 > 
 > Do you really have to have HAL_ names? :)
 > Kinda reminiscent of the old days... And it makes little
 > sense in a driver that hopefully (I'm not that far yet)
 > doesn't have a HAL. I think those should probably be
 > called ATH9K_ instead.
 > 

There are plenty of structures/enums in the erstwhile HAL that have been named in such a manner.
Will fix this.

 > +#ifndef howmany
 > +#define howmany(x, y)   (((x)+((y)-1))/(y))
 > +#endif
 > 
 > The #ifndef and the name of the macro make little sense.
 > You should change the name and get rid of the ifndef.
 > 

Will do.

 > +#define	HAL_RXERR_CRC		0x01
 > 
 > Ditto about HAL_*
 > 

Will fix.

 > +enum hal_bool {
 > +	AH_FALSE = 0,
 > +	AH_TRUE = 1,
 > +};
 > 
 > Eww. What do you need that for? That's gross.

Heh, legacy cruft. Will clean that.

 > +#define	ds_txstat	ds_us.tx
 > +#define	ds_rxstat	ds_us.rx
 > +#define ds_stat		ds_us.stats
 > 
 > I personally don't like that, but I know the kernel does it in a few places.
 > Is there a specific reason? Usually it's mostly done when fields are moved
 > into structs or so.
 > 

No specific reason. But it was a very common occurrence in the original code.
Cleaned up most of the places, guess this was overlooked.

 > +struct hal_tx_queue_info {
 > +	u_int32_t tqi_ver;
 > 
 > If you didn't say hal_ everywhere it could possible also be much clearer
 > which part is hardware dependent and which part is just for the driver.
 > 

Ok.

 > +enum hal_rx_filter {
 > +	HAL_RX_FILTER_UCAST = 0x00000001,
 > 
 > BIT()?
 > 
 > +enum hal_int {
 > +	HAL_INT_RX = 0x00000001,
 > 
 > Dito.
 > 

Ok.

 > +#define CHANNEL_QUARTER   0x08000
 > +#define CHANNEL_HT20      0x10000
 > +#define CHANNEL_HT40PLUS  0x20000
 > +#define CHANNEL_HT40MINUS 0x40000
 > 
 > 
 > CHANNEL_ seems a bit too generic.

Will change it to something else.

 > 
 > +#define IS_CHAN_A(_c) ((((_c)->channelFlags & CHANNEL_A) == CHANNEL_A) || \
 > +       (((_c)->channelFlags & CHANNEL_A_HT20) == CHANNEL_A_HT20) || \
 > +       (((_c)->channelFlags & CHANNEL_A_HT40PLUS) == CHANNEL_A_HT40PLUS) || \
 > +       (((_c)->channelFlags & CHANNEL_A_HT40MINUS) == CHANNEL_A_HT40MINUS))
 > 
 > Do you really have to build the structs this way? I mean, couldn't you use a
 > separate A/B/G flag in your structs? Or is this shared with hw?
 > 

I'll check and try to make this easier on the eyes.

 > +enum {
 > +	CTRY_DEBUG = 0x1ff,
 > +	CTRY_DEFAULT = 0
 > +};
 > 
 > ??

I don't understand it either. :)

 > 
 > +#define HAL_DBG_MALLOC		0x00400000
 > +#define HAL_DBG_POWER_OVERRIDE	0x01000000
 > +#define HAL_DBG_SPUR_MITIGATE	0x02000000
 > +#define HAL_DBG_UNMASKABLE      0xFFFFFFFF
 > 
 > whitespace mixup tabs and spaces

Will fix.

 > 
 > +#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
 > +#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
 > 
 > Do you really need macros for this? Static inlines that do
 > type-checking are so much nicer.
 > 

Ok.

 > +#define SM(_v, _f)  (((_v) << _f##_S) & _f)
 > +#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
 > +#define OS_REG_RMW(_a, _r, _set, _clr)    \
 > +	REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
 > +#define OS_REG_RMW_FIELD(_a, _r, _f, _v) \
 > +	REG_WRITE(_a, _r, \
 > +	(REG_READ(_a, _r) & ~_f) | (((_v) << _f##_S) & _f))
 > +#define OS_REG_SET_BIT(_a, _r, _f) \
 > +	REG_WRITE(_a, _r, REG_READ(_a, _r) | _f)
 > +#define OS_REG_CLR_BIT(_a, _r, _f) \
 > +	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~_f)
 > +#define OS_REG_ath9k_regd_is_bit_set(_a, _r, _f) \
 > +	((REG_READ(_a, _r) & _f) != 0)
 > 
 > Uh what? OS_?? Did you forget to resolve the os-indep layer from your
 > windows driver completely? :)
 > 

I guess. :)
Will fix.

 > +#define IEEE80211_WEP_IVLEN      3
 > +#define IEEE80211_WEP_KIDLEN     1
 > +#define IEEE80211_WEP_CRCLEN     4
 > +#define IEEE80211_MAX_MPDU_LEN  (3840 + FCS_LEN +		\
 > +				 (IEEE80211_WEP_IVLEN +		\
 > +				  IEEE80211_WEP_KIDLEN +	\
 > +				  IEEE80211_WEP_CRCLEN))
 > +#define IEEE80211_MAX_LEN       (2300 + FCS_LEN +		\
 > +				 (IEEE80211_WEP_IVLEN +		\
 > +				  IEEE80211_WEP_KIDLEN +	\
 > +				  IEEE80211_WEP_CRCLEN))
 > 
 > Those seems like they should be in linux/ieee80211.h already, and if not be
 > added there. or is that hw dependent, in which case it should be renamed?
 > 

I am not sure right now, will check.

 > +enum hal_status {
 > +	HAL_OK = 0,
 > +	HAL_ENXIO,
 > 
 > Ok, so what do you use these for? What's wrong with negative error codes
 > like 99% of the kernel uses, and using pre-defined numbers we already have?
 > 

Luis brought this up a while ago.
Anyway, will clean this up.

 > +enum {
 > +	HAL_SLOT_TIME_6 = 6,
 > +	HAL_SLOT_TIME_9 = 9,
 > +	HAL_SLOT_TIME_20 = 20,
 > +};
 > 
 > That's great, new names for "6", "9" and "20".

Heh.

 > 
 > +enum hal_freq_band {
 > +	HAL_FREQ_BAND_5GHZ = 0,
 > +	HAL_FREQ_BAND_2GHZ = 1,
 > +};
 > 
 > You can remove those.

And use mac80211's band macros ?

 > 
 > +enum {
 > +	HAL_TRUE_CHIP = 1
 > +};
 > 
 > And that one most likely as well.
 > 

Ok.

 > +enum phytype {
 > +	PHY_DS,
 > +	PHY_FH,
 > +	PHY_OFDM,
 > +	PHY_HT,
 > +	PHY_MAX
 > 
 > What's a MAX PHY? And where do you use that constant?
 > 

AFAICS, it is not used anywhere. Will clean this.

 > +struct ath_hal {
 > +	u_int32_t ah_magic;
 > +	u_int16_t ah_devid;
 > +	u_int16_t ah_subvendorid;
 > +	void *ah_sc;
 > 
 > A void * pointer? This isn't a hal where you need to hide stuff behind void
 > * pointers because the users aren't supposed to know what it is...
 > 

Right.

 > +#define HDPRINTF(_ah, _m, _fmt, ...) do {				\
 > +		if (((_ah) == NULL && _m == HAL_DBG_UNMASKABLE) ||	\
 > +		    (((struct ath_hal *)(_ah))->ah_config.ath_hal_debug & _m)) \
 > +			printk(KERN_DEBUG _fmt , ##__VA_ARGS__);	\
 > +	} while (0)
 > 
 > Ugh.
 > 

:)

 > +enum hal_status ath_hal_getcapability(struct ath_hal *ah,
 > +				      enum hal_capability_type type,
 > +				      u_int32_t capability,
 > +				      u_int32_t *result);
 > 
 > HAL or hardware capability?
 > 

Hardware capability.

 > +enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah,
 > +				     enum hal_int ints);
 > 
 > Please use more standard return values.

Ok.

 > 
 > +enum hal_bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 > 
 > And there's a perfectly fine "bool" type. It even comes with "true" and
 > "false" values.

Ok. :)

 > + *  Setup the beacon frame for transmit.
 > + *
 > + *  Associates the beacon frame buffer with a transmit descriptor.  Will set
 > + *  up all required antenna switch parameters, rate codes, and channel flags.
 > + *  Beacons are always sent out at the lowest rate, and are not retried.
 > +*/
 > 
 > Why not use kerneldoc notation?

In due time. :)

 > 
 > +	ath9k_hw_set11n_txdesc(ah, ds
 > +			      , skb->len + FCS_LEN /* frame length */
 > +			      , HAL_PKT_TYPE_BEACON /* Atheros packet type */
 > +			      , avp->av_btxctl.txpower /* txpower XXX */
 > +			      , HAL_TXKEYIX_INVALID /* no encryption */
 > +			      , HAL_KEY_TYPE_CLEAR /* no encryption */
 > +			      , flags /* no ack, veol for beacons */
 > +		);
 > 
 > That's some pretty weird layout.

Will fix.

 > 
 > +	/* XXX: spin_lock_bh should not be used here, but sparse bitches
 > +	 * otherwise. We should fix sparse :) */
 > +	spin_lock_bh(&mcastq->axq_lock);
 > 
 > First and foremost you should write correct code regardless of whether
 > sparse complains about it or not. Then let others review it and possibly
 > submit a bug report to sparse. This is the wrong way around.

Right, any help on locking in the driver is welcome. :)

 > +#define TSF_TO_TU(_h,_l)					\
 > +	((((u_int32_t)(_h)) << 22) | (((u_int32_t)(_l)) >> 10))
 > 
 > You keep defining that in each function. It should probably be in
 > linux/ieee80211.h

Ok.

 > 
 > +static int ath_outdoor = AH_FALSE;		/* enable outdoor use */
 > 
 > How is that useful if it cannot be set?

Will remove this.

 > 
 > + *  This function initializes and fills the rate table in the ATH object based
 > + *  on the operating mode.  The blink rates are also set up here, although
 > + *  they have been superceeded by the ath_led module.
 > +*/
 > 
 > ath_led module? stuff that is superceeded?

The comment refers to an old LED module that was removed prior to submission.
Will clean this.

 > + *  This routine will provide the enumerated WIRELESSS_MODE value based
 > + *  on the settings of the channel flags.  If ho valid set of flags
 > 
 > ho ho ho

:)

 > 
 > +	/* NB: should not get here */
 > +	return WIRELESS_MODE_11b;
 > 
 > WARN instead.

Ok.

 > 
 > +	 *    reset 802.11 state machine
 > +	 *      (sends station deassoc/deauth frames)
 > 
 > what? are you sure you're doing that?

Nope, we are not. Again, cruft from a net80211 specific layer.

 > 
 > + *  Scan End
 > + *
 > + *  This routine is called by the upper layer when the scan is completed.  This
 > + *  will set the filters back to normal operating mode, set the BSSID to the
 > + *  correct value, and restore the power save state.
 > 
 > Uh huh? What upper layer are you talking about?

Heh, see my previous response.

 > 
 > +/*
 > + * Set the current channel
 > + *
 > + * Set/change channels.  If the channel is really being changed, it's done
 > + * by reseting the chip.  To accomplish this we must first cleanup any pending
 > + * DMA, then restart stuff after a la ath_init.
 > +*/
 > 
 > You should indent the */ by one space too, happens in tons of places.

Ok.

 > 
 > +		if (!ath9k_hw_intrpend(ah)) {	/* shared irq, not for us */
 > +			return ATH_ISR_NOTMINE;
 > +		}
 > 
 > Ok, why is this not using irqreturn_t to start with?

I did this. Patch on its way.

 > +	/*
 > +	 * Query the hal about antenna support
 > 
 > There should be no hal.

Right.

 > 
 > +	sc->sc_hasveol = ah->ah_caps.halVEOLSupport;
 > 
 > And stuff like that is particularly ugly. You can test the relevant
 > feature bit wherever necessary, no need to copy feature bits around.
 > 

Ok.

 > +#ifdef CONFIG_SLOW_ANT_DIV
 > 
 > I haven't seen a Kconfig definition for that
 > 

I think Luis cooked up a patch for that.

 > +bad2:
 > +	/* cleanup tx queues */
 > +	for (i = 0; i < HAL_NUM_TX_QUEUES; i++)
 > +		if (ATH_TXQ_SETUP(sc, i))
 > +			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
 > +bad:
 > +	if (ah)
 > +		ath9k_hw_detach(ah);
 > +	return error;
 > 
 > The labels could be named better.

Ok.

 > 
 > +struct ath_node *ath_node_get(struct ath_softc *sc, u8 *addr)
 > 
 > + * Setup driver-specific state for a newly associated node.  This routine
 > + * really only applies if compression or XR are enabled, there is no code
 > + * covering any other cases.
 > 
 > What sort of state do you need? Anything mac80211 could cover?

Aggregation information is maintained on a per-STA basis.
All this node stuff will be cleaned up anyway.

 > +#define KASSERT(exp, msg) do {			\
 > +		if (unlikely(!(exp))) {         \
 > +			printk msg;		\
 > +			BUG();			\
 > +		}				\
 > +	} while (0)
 > 
 > what's wrong with BUG_ON?

Will clean this.

 > 
 > +static inline unsigned long get_timestamp(void)
 > +{
 > +	return ((jiffies / HZ) * 1000) + (jiffies % HZ) * (1000 / HZ);
 > 
 > ??

Me neither. :)

 > 
 > +#define	DPRINTF(sc, _m, _fmt, ...) do {			\
 > +		if (sc->sc_debug & (_m))                \
 > +			printk(_fmt , ##__VA_ARGS__);	\
 > +	} while (0)
 > 
 > We already had that. Are you duplicating things in the driver because that's
 > how the HAL was built? Ahh. HDPRINTF was HAL DPRINTF?

Yep, the original code had separate debug levels for HAL and the layer above.
Will clean this.

 > 
 > +struct ath_buf_state {
 > +	int bfs_nframes;	/* # frames in aggregate */
 > +	u_int16_t bfs_al;	/* length of aggregate */
 > +	u_int16_t bfs_frmlen;	/* length of frame */
 > +	int bfs_seqno;		/* sequence number */
 > +	int bfs_tidno;		/* tid of this frame */
 > +	int bfs_retries;	/* current retries */
 > +	struct ath_rc_series bfs_rcs[4];	/* rate series */
 > +	u8 bfs_isdata:1;	/* is a data frame/aggregate */
 > 
 > bitfields.

Ok.

 > +/* driver-specific node state */
 > +struct ath_node {
 > +	struct list_head	list;
 > +	struct ath_softc    	*an_sc; 		/* back pointer */
 > +	atomic_t		an_refcnt;
 > +	struct ath_chainmask_sel an_chainmask_sel;
 > +	struct ath_node_aggr 	an_aggr; /* A-MPDU aggregation state */
 > +	u_int8_t             	an_smmode; /* SM Power save mode */
 > +	u_int8_t         	an_flags;
 > +	u8	 		an_addr[ETH_ALEN];
 > 
 > What sort of node state do you really need? Why do you need PS state?
 > Can we help you here with mac80211? Get some insight into a part of
 > sta_info and have that passed to the driver to avoid having a list/hash
 > table in the driver etc.

Can sta_info be accessed directly from the driver ?
Don't we need a ieee80211_local ptr to retrieve sta_info ?
And if so, is that ok ?
Or will you be providing a private driver area embedded in sta_info ?

 > 
 > +/********/
 > +/* VAPs */
 > +/********/
 > 
 > Please use "virtual interface" terminology instead of VAP since
 > that matches what mac80211 says. Not just here, of course!

Ok.

 > 
 > +/* driver-specific vap state */
 > +struct ath_vap {
 > +	struct ieee80211_vif            *av_if_data; /* interface(vap)
 > +				instance from 802.11 protocal layer */
 > +	enum hal_opmode                 av_opmode;  /* VAP operational mode */
 > +	struct ath_buf                  *av_bcbuf;  /* beacon buffer */
 > +	struct ath_beacon_offset        av_boff;    /* dynamic update state */
 > +	struct ath_tx_control           av_btxctl;  /* tx control information
 > +							for beacon */
 > +	int                             av_bslot;   /* beacon slot index */
 > +	struct ath_txq                  av_mcastq;  /* multicast
 > +						transmit queue */
 > +	struct ath_vap_config           av_config;  /* vap configuration
 > +					parameters from 802.11 protocol layer*/
 > 
 > You should be embedding this struct in the private part of the vif structure
 > instead of linking the vif structure off of this, and then use container_of
 > or so to get at it.

Ok.

 > 
 > +struct ath_softc {
 > +	struct ieee80211_hw *hw; /* mac80211 instance */
 > +	struct pci_dev		*pdev;	    /* Bus handle */
 > +	void __iomem		*mem;	    /* address of the device */
 > +	struct tasklet_struct   intr_tq;    /* General tasklet */
 > +	struct tasklet_struct   bcon_tasklet; /* Beacon tasklet */
 > 
 > I think this should be embedded in the hw struct private area. Or
 > is hung off the driver data in the pci dev?

It is.

 > 
 > +static inline enum hal_status ath9k_hw_init_macaddr(struct ath_hal *ah)
 > 
 > inline? bit large for that
 > 

Ok, will clean this.

 > +static inline enum hal_bool
 > +ath9k_hw_get_lower_upper_index(u_int8_t target,
 > 
 > ditto.

Ok.

 > 
 > +static inline void ath9k_hw_ani_setup(struct ath_hal *ah)
 > 
 > etc. Why do you think setup functions need to be inlines?

Heh, the entire codebase was on a massive inline abuse trip.
Will clean this.

 > 
 > +++ b/drivers/net/wireless/ath9k/initvals.h
 > 
 > initvals probably should not be in a header file but rather a C file
 > 

Ok.

 > +static int ath_check_chanflags(struct ieee80211_channel *chan,
 > +			       u_int32_t mode,
 > +			       struct ath_softc *sc)
 > 
 > and what exactly does this actually do with flags?
 > 

This was added to somehow deal with the fact that the HAL expects a mode
when doing a hw reset. But yeah, we'll look into this.

 > +static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 > +{
 > +#define ATH_MAX_NUM_KEYS 4
 > 
 > That's one of the most useless defines I've ever seen, keyidx is always
 > 0..3 (or 5 for 11w). And nothing in that is hw specific.
 > 

Ok, will remove this.

 > +/* Until mac80211 includes these fields */
 > 
 > You'll have to tell us why, how, and what for.
 > 

Will do.

 > 
 > +static int ath9k_beacon_update(struct ieee80211_hw *hw,
 > +			       struct sk_buff *skb)
 > +
 > +{
 > +	struct ath_softc *sc = hw->priv;
 > +
 > +	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: Update Beacon\n", __func__);
 > +	return ath9k_tx(hw, skb);
 > 
 > Didn't I just remove beacon_update? Confused.

Bah, I removed this already. Will send out patch soon.

 > 
 > +static int ath9k_add_interface(struct ieee80211_hw *hw,
 > +			       struct ieee80211_if_init_conf *conf)
 > +{
 > +	struct ath_softc *sc = hw->priv;
 > +	int error, ic_opmode = 0;
 > +
 > +	/* Support only vap for now */
 > +
 > +	if (sc->sc_nvaps)
 > +		return -1;
 > +
 > +	switch (conf->type) {
 > +	case IEEE80211_IF_TYPE_STA:
 > +		ic_opmode = HAL_M_STA;
 > +	default:
 > +		break;
 > +	}
 > +
 > +	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Attach a VAP of type: %d\n",
 > +		__func__,
 > +		ic_opmode);
 > +
 > +	error = ath_vap_attach(sc, 0, conf->vif, ic_opmode, ic_opmode, 0);
 > +	if (error) {
 > +		DPRINTF(sc, ATH_DEBUG_FATAL,
 > +			"%s: Unable to attach vap, error: %d\n",
 > +			__func__, error);
 > +		goto bad;
 > 
 > Does that reject the call if ic_opmode is 0? Why is ic_opmode passed twice?

No it doesn't, for some reason IBSS has a value 0 for its opmode.
But if opmode happens to be invalid, -EINVAL is returned.
And yep, it shouldn't be passed twice.

 > 
 > +	switch (vif->type) {
 > +	case IEEE80211_IF_TYPE_STA:
 > +		/* XXX: Handle (conf->changed & IEEE80211_IFCC_SSID) */
 > 
 > You might not need to if you don't care about the SSID (since you have
 > no IBSS yet)

But IBSS is on its way. :)

 > 
 > +	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 > +		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
 > +			ath_scan_start(sc);
 > +		else
 > +			ath_scan_end(sc);
 > 
 > That's extremly wrong. What do you need scan start/end for? Pick up
 > Dan's patch to add callbacks for this.
 > 

Right, will fix this.

 > +u_int32_t ath_chan2flags(struct ieee80211_channel *chan,
 > +				struct ath_softc *sc)
 > +{
 > +	struct ieee80211_hw *hw = sc->hw;
 > +	struct ath_ht_info *ht_info = &sc->sc_ht_info;
 > +
 > +	if (sc->sc_scanning) {
 > +		if (chan->band == IEEE80211_BAND_5GHZ) {
 > +			if (ath_check_chanflags(chan, CHANNEL_A_HT20, sc))
 > +				return CHANNEL_A_HT20;
 > +			else
 > +				return CHANNEL_A;
 > 
 > Why can't you use cfg80211's flags, adding required ones?

Will look into this.

 > 
 > +void ath__update_txpow(struct ath_softc *sc,
 > +		       u_int16_t txpowlimit,
 > +		       u_int16_t txpowlevel)
 > +{
 > +
 > +}
 > 
 > Huh?

I think that was removed already.

 > 
 > +struct sk_buff *ath_get_beacon(struct ath_softc *sc,
 > +			       int if_id,
 > +			       struct ath_beacon_offset *bo,
 > +			       struct ath_tx_control *txctl)
 > +{
 > +	return NULL;
 > +}
 > +
 > +int ath_update_beacon(struct ath_softc *sc,
 > +		      int if_id,
 > +		      struct ath_beacon_offset *bo,
 > +		      struct sk_buff *skb,
 > +		      int mcast)
 > +{
 > +	return 0;
 > +}
 > 
 > Huh?

I have already removed all this. Patch on its way.

 > 
 > +	/* remove FCS before passing up to protocol stack */
 > +	skb_trim(skb, (skb->len - FCS_LEN));
 > 
 > No, please don't, just tell us it's still there.

Ok.

 > 
 > +	if ((wMode >= WIRELESS_MODE_MAX) || (type != NORMAL_RATE))
 > +		return;
 > 
 > What's with all those defines?

Will clean them.

 > 
 > +	for (i = 0; i < maxrates; i++) {
 > +		switch (wMode) {
 > +		case WIRELESS_MODE_11b:
 > +		case WIRELESS_MODE_11g:
 > 
 > and those?
 > 

Will clean them.

 > +	error = ieee80211_register_hw(hw);
 > +	if (error != 0) {
 > +		ath_rate_control_unregister();
 > +		goto bad;
 > +	}
 > +
 > +	/* initialize tx/rx engine */
 > +
 > +	error = ath_tx_init(sc, ATH_TXBUF);
 > +	if (error != 0)
 > +		goto bad1;
 > +
 > +	error = ath_rx_init(sc, ATH_RXBUF);
 > +	if (error != 0)
 > +		goto bad1;
 > 
 > You should probably do that the other way around...
 > 

Ok.

 > 
 > So some more comments.
 > 
 > You need to dissolve the hal layer better; get rid of all the HAL constants.
 > Rename all the ATH_ constants that aren't hw but 802.11 and put them into
 > ieee80211.h. Tell us what sort of node information you need, and let's put
 > it into sta_info and/or have some sort of private sta_info area, instead
 > of implementing a linked station list yourself.
 > 

Will address the comments.
Thanks again for the review !

Sujith
