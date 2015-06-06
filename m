Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35433 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbbFFNnP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 09:43:15 -0400
Message-ID: <1433598191.2467.65.camel@sipsolutions.net> (sfid-20150606_154320_682998_75203DB8)
Subject: Re: [PATCH] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Date: Sat, 06 Jun 2015 15:43:11 +0200
In-Reply-To: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com> (sfid-20150604_065726_449748_FA29E81C)
References: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com>
	 (sfid-20150604_065726_449748_FA29E81C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David, all,

I'm not really in the chain here, but I figured I'd review your driver
nonetheless. I'll want to take a closer look at some things, but for now
here's a bit of a review just of the code.

Can you perhaps explain how the STA/AP firmware separation works? I've
not really managed to figure that out - admittedly with not all that
much effort though.


On Thu, 2015-06-04 at 04:57 +0000, David Lin wrote:

>  drivers/net/wireless/mwlwifi/Kconfig        |   17 +

Does this driver has any relation to mwifiex? Perhaps the same
maintainer team, etc.? Could consider moving all the Marvell drivers
into one directory, but not really necessary I guess.

Out of curiosity - why "mwlwifi" and not just "mwl" or similar? :)

Also - consider adding a MAINTAINERS entry for this driver.

>  drivers/net/wireless/mwlwifi/mwl_debug.c    |  207 ++

The mwl_ prefix doesn't really do much for this driver (especially since
it's used for all files) -- I'd consider removing it.

> @@ -284,5 +284,6 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
>  source "drivers/net/wireless/mwifiex/Kconfig"
>  source "drivers/net/wireless/cw1200/Kconfig"
>  source "drivers/net/wireless/rsi/Kconfig"
> +source "drivers/net/wireless/mwlwifi/Kconfig"

Perhaps, just like with the directory structure, we should also consider
having per-vendor Kconfig structure, like Ethernet drivers have now.

Then again, unless we decide we want to do this for all drivers and all
devices it doesn't really do much.

> +	depends on PCI && MAC80211
> +	select FW_LOADER
> +	select OF

That's interesting, why does a PCI(e) driver need OF?

> +/* CONSTANTS AND MACROS
> +*/

that one-line comment style (also in other places below, and perhaps
other files) is a but strange

> +#define PRT_8BYTES "0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n"

Do you really need the "0x" in here? Otherwise it'd be much nicer to use
%ph instead of macros.

> +void mwl_debug_prt(u32 classlevel, const char *func, const char *format, ...)
> +{

> +	debug_string = kmalloc(1024, GFP_ATOMIC);
> +
> +	if (!debug_string)
> +		return;

That seems a bit questionable - when memory allocations start failing is
one of those places where you really want debug output ...

> +	switch (class) {
> +	case DBG_CLASS_ENTER:
> +		pr_debug("Enter %s() ...\n", func);
> +		break;
> +	case DBG_CLASS_EXIT:
> +		pr_debug("... Exit %s()\n", func);
> +		break;

I think you should not have enter/exit logging at all but use function
tracing instead in the unlikely event this becomes necessary.

> +	if (strlen(debug_string) > 0) {

strlen() > 0 seems pretty expensive - perhaps the compiler can optimise
it, but still.

> +		if (debug_string[strlen(debug_string) - 1] == '\n')
> +			debug_string[strlen(debug_string) - 1] = '\0';
> +			pr_debug("%s(): %s\n", func, debug_string);
> +	}

You should also be able to just pass the original arguments to pr_debug,
perhaps with %pV, and get rid of the allocation entirely.

> +	for (curr_byte = 0; curr_byte < len; curr_byte = curr_byte + 8) {

This really is pretty icky - get rid of it and use %ph in the caller. If
it's longer than what's supported there you probably shouldn't have it
at all and add tracing events to your driver instead.

> +void mwl_debug_dumpdata(const void *data, int len, char *marker)

ditto.

> +#define DBG_LEVEL_0 BIT(0)    /* mwl_main.c     */
> +#define DBG_LEVEL_1 BIT(1)    /* mwl_fwdl.c     */
> +#define DBG_LEVEL_2 BIT(2)    /* mwl_fwcmd.c    */
> +#define DBG_LEVEL_3 BIT(3)    /* mwl_tx.c       */
> +#define DBG_LEVEL_4 BIT(4)    /* mwl_rx.c       */
> +#define DBG_LEVEL_5 BIT(5)    /* mwl_mac80211.c */

This seems very questionable.

> +#define DBG_CLASS_7 BIT(23)

and those are hopefully not used at all - remove them?

Consider adding __printf(x,y) annotation to the functions to check the
validity of the format strings.

> +#define WLDBG_DUMP_DATA(classlevel, data, len)
> +#define WLDBG_ENTER(classlevel)
> +#define WLDBG_ENTER_INFO(classlevel, ...)
> +#define WLDBG_EXIT(classlevel)
> +#define WLDBG_EXIT_INFO(classlevel, ...)
> +#define WLDBG_INFO(classlevel, ...)
> +#define WLDBG_WARNING(classlevel, ...)
> +#define WLDBG_ERROR(classlevel, ...)
> +#define WLDBG_PANIC(classlevel, ...)

Consider still expanding them to some inline that gets the arguments and
also has __printf(x,y) annotation so you get compile-time checking even
when you don't have debug enabled.

> +/* Map to 0x80000000 (Bus control) on BAR0
> +*/

should be single-line comment style - not going to comment on that any
more

> +#define MACREG_A2HRIC_BIT_TX_DONE           0x00000001 /* bit 0 */
> +#define MACREG_A2HRIC_BIT_RX_RDY            0x00000002 /* bit 1 */
> +#define MACREG_A2HRIC_BIT_OPC_DONE          0x00000004 /* bit 2 */
> +#define MACREG_A2HRIC_BIT_MAC_EVENT         0x00000008 /* bit 3 */
> +#define MACREG_A2HRIC_BIT_RX_PROBLEM        0x00000010 /* bit 4 */
> +#define MACREG_A2HRIC_BIT_RADIO_OFF         0x00000020 /* bit 5 */
> +#define MACREG_A2HRIC_BIT_RADIO_ON          0x00000040 /* bit 6 */
> +#define MACREG_A2HRIC_BIT_RADAR_DETECT      0x00000080 /* bit 7 */
> +#define MACREG_A2HRIC_BIT_ICV_ERROR         0x00000100 /* bit 8 */
> +#define MACREG_A2HRIC_BIT_WEAKIV_ERROR      0x00000200 /* bit 9 */

Those comments are clearly useless - just use BIT(N) as below?!

> +#define MACREG_A2HRIC_BIT_QUEUE_EMPTY       BIT(10)

> +#define MACREG_A2HRIC_BIT_CHAN_SWITCH       BIT(12) /* IEEE80211_DH */

What's that supposed to mean?

> +#define MACREG_A2HRIC_BA_WATCHDOG           BIT(14)
> +#define MACREG_A2HRIC_BIT_SSU_DONE          BIT(16)
> +#define MACREG_A2HRIC_CONSEC_TXFAIL         BIT(17) /* 15 taken by ISR_TXACK */

That comment seems misplaced? maybe it should be between 14 and 16?

> +#define ISR_SRC_BITS        ((MACREG_A2HRIC_BIT_RX_RDY) | \
> +			     (MACREG_A2HRIC_BIT_TX_DONE) | \
> +			     (MACREG_A2HRIC_BIT_OPC_DONE) | \

Lots of useless parentheses.

> +#define MACREG_H2ARIC_BIT_PPA_READY         0x00000001 /* bit 0 */

see above

> +#define WL_SEC_SLEEP(num_secs)              mdelay(num_secs * 1000)
> +#define WL_MSEC_SLEEP(num_milli_secs)       mdelay(num_milli_secs)
> +
> +#define ENDIAN_SWAP32(_val)                 (cpu_to_le32(_val))
> +#define ENDIAN_SWAP16(_val)                 (cpu_to_le16(_val))
> +
> +#define DECLARE_LOCK(l)                     spinlock_t l
> +#define SPIN_LOCK_INIT(l)                   spin_lock_init(l)
> +#define SPIN_LOCK(l)                        spin_lock(l)
> +#define SPIN_UNLOCK(l)                      spin_unlock(l)
> +#define SPIN_LOCK_IRQSAVE(l, f)             spin_lock_irqsave(l, f)
> +#define SPIN_UNLOCK_IRQRESTORE(l, f)        spin_unlock_irqrestore(l, f)

Nope, get rid of all these.

> +/* vif and station
> +*/
> +#define MAX_WEP_KEY_LEN              13

Use WLAN_KEY_LEN_WEP104?

> +#define MWL_VIF(_vif)                ((struct mwl_vif *)&((_vif)->drv_priv))
> +#define IEEE80211_KEY_CONF(_u8)      ((struct ieee80211_key_conf *)(_u8))
> +#define MWL_STA(_sta)                ((struct mwl_sta *)&((_sta)->drv_priv))

convert these to static inline functions

> +enum {
> +	IEEE_TYPE_MANAGEMENT = 0,
> +	IEEE_TYPE_CONTROL,
> +	IEEE_TYPE_DATA
> +};

This will be rather confusing since they don't match the spec - get rid
of them and use IEEE80211_FTYPE_* with the correct shift/mask.

> +struct mwl_rate_info {
> +	u32 format:2;        /* 0 = Legacy, 1 = 11n, 2 = 11ac */
> +	u32 stbc:1;
> +	u32 rsvd1:1;
> +	u32 bandwidth:2;     /* 0 = 20 MHz, 1 = 40 MHz, 2 = 80 MHz */
> +	u32 short_gi:1;      /* 0 = standard guard interval, 1 = short */
> +	u32 rsvd2:1;
> +	u32 rate_id_mcs:7;
> +	u32 preamble_type:1; /* Preambletype 0 = Long, 1 = Short; */
> +	u32 power_id:6;
> +	u32 adv_coding:1;    /* ldpc */
> +	u32 bf:1;
> +	u32 ant_select:8;    /* Bitmap to select one of the transmit antenna */
> +} __packed;

This being __packed seems to indicate you want to send it to the
hardware - you should probably put such structures into a separate
header file.

Also, using bitfields in a structure sent to hardware cannot possibly be
endian correct - simply don't do it and use constants/shifts/masks/etc.
instead.

Then again, after seeing the next struct - perhaps this simply shouldn't
be packed, or have a comment as to why it must be?

> +struct mwl_tx_desc {
> +	u8 data_rate;
> +	u8 tx_priority;
> +	u16 qos_ctrl;
> +	u32 pkt_ptr;
> +	u16 pkt_len;
> +	u8 dest_addr[ETH_ALEN];
> +	u32 pphys_next;
> +	u32 sap_pkt_info;
> +	struct mwl_rate_info rate_info;
> +	u8 type;
> +	u8 xmit_control;     /* bit 0: use rateinfo, bit 1: disable ampdu */
> +	u16 reserved;
> +	u32 tcpack_sn;
> +	u32 tcpack_src_dst;
> +	struct sk_buff *psk_buff;
> +	struct mwl_tx_desc *pnext;
> +	u8 reserved1[2];
> +	u8 packet_info;
> +	u8 packet_id;
> +	u16 packet_len_and_retry;
> +	u16 packet_rate_info;
> +	u8 *sta_info;
> +	u32 status;
> +} __packed;

See above - clearly this one cannot be sent to the hardware.

> +struct mwl_hw_rssi_info {
> +	u32 rssi_a:8;
> +	u32 rssi_b:8;
> +	u32 rssi_c:8;
> +	u32 rssi_d:8;
> +} __packed;

Err, what's with the bitfields?!

> +struct mwl_hw_noise_floor_info {
> +	u32 noise_floor_a:8;
> +	u32 noise_floor_b:8;
> +	u32 noise_floor_c:8;
> +	u32 noise_floor_d:8;
> +} __packed;

Ditto.

> +struct mwl_rx_desc {
> +	u16 pkt_len;                 /* total length of received data      */
> +	struct mwl_rxrate_info rate; /* receive rate information           */
> +	u32 pphys_buff_data;         /* physical address of payload data   */
> +	u32 pphys_next;              /* physical address of next RX desc   */
> +	u16 qos_ctrl;                /* received QosCtrl field variable    */
> +	u16 ht_sig2;                 /* like name states                   */
> +	struct mwl_hw_rssi_info hw_rssi_info;
> +	struct mwl_hw_noise_floor_info hw_noise_floor_info;
> +	u8 noise_floor;
> +	u8 reserved[3];
> +	u8 rssi;                     /* received signal strengt indication */
> +	u8 status;                   /* status field containing USED bit   */
> +	u8 channel;                  /* channel this pkt was received on   */
> +	u8 rx_control;               /* the control element of the desc    */
> +	/* above are 32bits aligned and is same as FW, RxControl put at end
> +	 * for sync
> +	 */
> +	struct sk_buff *psk_buff;    /* associated sk_buff for Linux       */
> +	void *pbuff_data;            /* virtual address of payload data    */
> +	struct mwl_rx_desc *pnext;   /* virtual address of next RX desc    */
> +} __packed;

This is really really strange - the first few fields *are* used with the
firmware, and the latter aren't? But how come then they can be "u32"
rather than "__le32"? Very odd.

> +struct mwl_desc_data {
> +	dma_addr_t pphys_tx_ring;          /* ptr to first TX desc (phys.)    */
> +	struct mwl_tx_desc *ptx_ring;      /* ptr to first TX desc (virt.)    */
> +	struct mwl_tx_desc *pnext_tx_desc; /* next TX desc that can be used   */
> +	struct mwl_tx_desc *pstale_tx_desc;/* the staled TX descriptor        */
> +	dma_addr_t pphys_rx_ring;          /* ptr to first RX desc (phys.)    */
> +	struct mwl_rx_desc *prx_ring;      /* ptr to first RX desc (virt.)    */
> +	struct mwl_rx_desc *pnext_rx_desc; /* next RX desc that can be used   */
> +	unsigned int wcb_base;             /* FW base offset for registers    */
> +	unsigned int rx_desc_write;        /* FW descriptor write position    */
> +	unsigned int rx_desc_read;         /* FW descriptor read position     */
> +	unsigned int rx_buf_size;          /* length of the RX buffers        */
> +} __packed;

Clearly shouldn't be packed.

> +struct mwl_locks {
> +	DECLARE_LOCK(xmit_lock);           /* used to protect TX actions      */
> +	DECLARE_LOCK(fwcmd_lock);          /* used to protect FW commands     */
> +	DECLARE_LOCK(stream_lock);         /* used to protect stream          */
> +};

Whaaa?

No no ... first of all, putting locks with the data they protect seems
much better, then the macros, ...

> +struct beacon_info {
> +	bool valid;
> +	u16 cap_info;
> +	u8 b_rate_set[SYSADPT_MAX_DATA_RATES_G];
> +	u8 op_rate_set[SYSADPT_MAX_DATA_RATES_G];
> +	u8 ie_wmm_len;               /* Keep WMM IE */
> +	u8 *ie_wmm_ptr;

I'm not sure why you'd need such a struct with mac80211, but even if you
do it'd be far more efficient to not alternate u8 and u8 * fields since
that basically wastes 7 bytes for alignment each time you do it.

> +	u16 iv16;
> +	u32 iv32;
> +	s8 keyidx;
> +};

Hmm. Are you sure you need an iv16/iv32 in a *vif* struct? That seems
very suspicious.

> +struct mwl_sta {
> +	u8 is_ampdu_allowed;
> +	struct mwl_tx_info tx_stats[MWL_MAX_TID];
> +	u16 iv16;
> +	u32 iv32;
> +};

Here also - you can still have multiple keys, even TKIP.

> +struct mwl_tx_ctrl {
> +	u8 tx_priority;
> +	u16 qos_ctrl;
> +	u8 type;
> +	u8 xmit_control;
> +	u8 *sta_info;
> +	bool ccmp;
> +} __packed;

Again, don't do packed for host structures, it just kills your
performance on many architectures. Instead, reorder the structure so
it's natively packed!

> +/* Genenral error */

typo

> +/* Key type is WEP		*/
> +#define KEY_TYPE_ID_WEP                         0x00
> +/* Key type is TKIP		*/
> +#define KEY_TYPE_ID_TKIP                        0x01
> +/* Key type is AES-CCMP	*/
> +#define KEY_TYPE_ID_AES	                        0x02

Those comments are pretty useless.

> +/* Group key for TX */
> +#define ENCR_KEY_FLAG_TXGROUPKEY                0x00000004
> +/* pairwise */
> +#define ENCR_KEY_FLAG_PAIRWISE                  0x00000008

same here etc...

> +/*      Misc
> +*/
> +#define MWL_SPIN_LOCK(X)     SPIN_LOCK_IRQSAVE(X, flags)
> +#define MWL_SPIN_UNLOCK(X)   SPIN_UNLOCK_IRQRESTORE(X, flags)

Umm, nope.

> +struct hostcmd_header {
> +	u16 cmd;
> +	u16 len;
> +	u8 seq_num;
> +	u8 macid;
> +	u16 result;
> +} __packed;

Now this really looks like a struct you exchange with the device, so it
should probably be using __le16 instead of u16.

> +struct hostcmd_cmd_get_hw_spec {
> +	struct hostcmd_header cmd_hdr;
> +	u8 version;                  /* version of the HW                    */
> +	u8 host_if;                  /* host interface                       */
> +	u16 num_wcb;                 /* Max. number of WCB FW can handle     */
> +	u16 num_mcast_addr;          /* MaxNbr of MC addresses FW can handle */

ditto, and throughout this file.

Unless the firmware can somehow run in "host endian"? Seems rather
unlikely to me since dealing with wifi is much easier in little endian
firmware.

> +	/* Indicates supported AMPDU type
> +	 * (1 = implicit, 0 = explicit (default))
> +	 */
> +	u32 implicit_ampdu_ba:1;
> +	/* indicates mbss features disable in FW */
> +	u32 disablembss:1;
> +	u32 host_form_beacon:1;
> +	u32 host_form_probe_response:1;
> +	u32 host_power_save:1;
> +	u32 host_encr_decr_mgt:1;
> +	u32 host_intra_bss_offload:1;
> +	u32 host_iv_offload:1;
> +	u32 host_encr_decr_frame:1;
> +	u32 reserved: 21;                       /* Reserved */
> +	u32 tx_wcb_num_per_queue;
> +	u32 total_rx_wcb;
> +} __packed;

And here for real - don't use bitfields in data exchanged with the
device.

> +struct hostcmd_cmd_broadcast_ssid_enable {
> +	struct hostcmd_header cmd_hdr;
> +	u32 enable;
> +} __packed;

Maybe, btw, you should consider having the header somehow separate from
the structs since it's always present. No idea how you use it though, so
perhaps not something you want to do.

> +struct rsn_ie {
> +	u8 elem_id;
> +	u8 len;
> +	u8 oui_type[4];              /* 00:50:f2:01 */
> +	u8 ver[2];
> +	u8 grp_key_cipher[4];
> +	u8 pws_key_cnt[2];
> +	u8 pws_key_cipher_list[4];
> +	u8 auth_key_cnt[2];
> +	u8 auth_key_list[4];
> +} __packed;
> +
> +struct rsn48_ie {
> +	u8 elem_id;
> +	u8 len;
> +	u8 ver[2];

I'm getting a feeling that your hardware is too smart for a mac80211
driver ... ;-)

> +struct hostcmd_cmd_update_encryptoin {

typo - encryption

> +static bool mwl_fwcmd_chk_adapter(struct mwl_priv *priv);

Personally, I'd never mix host function declarations with device command
structure declarations in a header file so they're both more clearly
identifiable.

Actually, this is in a C file - you should avoid static forward
declarations anyway, reorder the code instead.

> +void mwl_fwcmd_reset(struct ieee80211_hw *hw)

> +	BUG_ON(!hw);
> +	priv = hw->priv;
> +	BUG_ON(!priv);

Avoid BUG_ON(), it just makes life easier, if only for the poor
developer who happened to pass NULL for some stupid reason ...

Also, if hw is valid then hw->priv really can't be NULL ... think of how
the memory layout is done.

> +	if (mwl_fwcmd_chk_adapter(priv)) {
> +		writel(ISR_RESET,
> +		       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
> +	}

No need for braces.

> +	WLDBG_EXIT(DBG_LEVEL_2);

I think you should get rid of all of these.

And of course this is going to be a theme since all of your functions
are written this way :)

> +	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_GET_HW_SPEC);
> +	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
> +	pcmd->fw_awake_cookie = ENDIAN_SWAP32(priv->pphys_cmd_buf + 2048);

So I really think you need to add the proper __le16 annotations, make
sparse run on your code - add

ccflags-y += -D__CHECK_ENDIAN__

to your Makefile to do that, get rid of the macros and fix all the
sparse warnings by using the proper leXX_to_cpu and cpu_to_leXX in all
places.

> +	while (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_GET_HW_SPEC)) {
> +		WLDBG_PRINT("failed execution");
> +		WL_MSEC_SLEEP(1000);
> +		WLDBG_PRINT("repeat command = %x", (unsigned int)pcmd);
> +	}

An infinite loop doesn't seem like a great idea.

> +	if ((conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
> +	    (conf->chandef.width == NL80211_CHAN_WIDTH_20)) {
> +		width = CH_20_MHZ_WIDTH;
> +		sub_ch = NO_EXT_CHANNEL;
> +
> +	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_40) {

extra blank line

> +	if ((priv->powinited & 1) == 0) {
> +		mwl_fwcmd_get_tx_powers(priv, priv->target_powers,
> +					channel->hw_value, band, width, sub_ch);
> +		priv->powinited |= 1;
> +	}

That "1" should probably be a constant that's defined somewhere?

> +	if ((priv->powinited & 2) == 0) {
> +		mwl_fwcmd_get_tx_powers(priv, priv->max_tx_pow,
> +					channel->hw_value, band, width, sub_ch);
> +
> +		priv->powinited |= 2;
> +	}

Ditto for the "2"?


> +	if ((conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
> +	    (conf->chandef.width == NL80211_CHAN_WIDTH_20)) {
> +		pcmd->chnl_flags.chnl_width = CH_20_MHZ_WIDTH;
> +		pcmd->chnl_flags.act_primary = ACT_PRIMARY_CHAN_0;
> +	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_40) {
> +		pcmd->chnl_flags.chnl_width = CH_40_MHZ_WIDTH;
> +		if (conf->chandef.center_freq1 > channel->center_freq)
> +			pcmd->chnl_flags.act_primary = ACT_PRIMARY_CHAN_0;
> +		else
> +			pcmd->chnl_flags.act_primary = ACT_PRIMARY_CHAN_1;
> +	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_80) {
> +		pcmd->chnl_flags.chnl_width = CH_80_MHZ_WIDTH;
> +		pcmd->chnl_flags.act_primary =
> +			mwl_fwcmd_get_80m_pri_chnl_offset(pcmd->curr_chnl);
> +	}

Btw, might be worth rewriting these as switch statements.

[skipping the rest of this file for this round]

> +/*  Define OpMode for SoftAP/Station mode
> + *
> + *  The following mode signature has to be written to PCI scratch register#0
> + *  right after successfully downloading the last block of firmware and
> + *  before waiting for firmware ready signature
> + */
> +
> +#define HOSTCMD_STA_MODE                0x5A
> +#define HOSTCMD_SOFTAP_MODE             0xA5

This is a bit strange - how are you advertising the capabilities for
this?

Also, no P2P which requires combinations?

> +static void mwl_mac80211_tx(struct ieee80211_hw *hw,
> +			    struct ieee80211_tx_control *control,
> +			    struct sk_buff *skb);

again, try to avoid static forward declarations

> +static irqreturn_t (*mwl_mac80211_isr)(int irq, void *dev_id);
> +
> +static const struct ieee80211_rate mwl_rates_24[] = {
> +	{ .bitrate = 10, .hw_value = 2, },
> +	{ .bitrate = 20, .hw_value = 4, },
> +	{ .bitrate = 55, .hw_value = 11, },
> +	{ .bitrate = 110, .hw_value = 22, },
> +	{ .bitrate = 220, .hw_value = 44, },

Interesting - 22 MBps support is very rare.

> +struct ieee80211_ops *mwl_mac80211_get_ops(void)
> +{
> +	return &mwl_mac80211_ops;
> +}

This looks strange, why should it be necessary rather than simply
exposing the structure in the header file??

> +void mwl_mac80211_set_isr(irqreturn_t (*isr)(int irq, void *dev_id))
> +{
> +	WLDBG_ENTER(DBG_LEVEL_5);
> +
> +	mwl_mac80211_isr = isr;

This doesn't seem right - you should avoid global state, but store state
per device.

> +	index = skb_get_queue_mapping(skb);
> +
> +	mwl_tx_xmit(hw, index, control->sta, skb);

why pass the index and station separately, since they're both in the
skb?

> +	rc = mwl_fwcmd_radio_enable(hw);
> +
> +	if (!rc)
> +		rc = mwl_fwcmd_set_rate_adapt_mode(hw, 0);
> +
> +	if (!rc)
> +		rc = mwl_fwcmd_set_wmm_mode(hw, true);
> +
> +	if (!rc)
> +		rc = mwl_fwcmd_set_dwds_stamode(hw, true);
> +
> +	if (!rc)
> +		rc = mwl_fwcmd_set_fw_flush_timer(hw, 0);

This is pretty non-standard error handling code for the kernel, better
rewrite with goto.

> +	/* Setup driver private area.
> +	*/
> +	mwl_vif = MWL_VIF(vif);
> +	memset(mwl_vif, 0, sizeof(*mwl_vif));

The area should already be memset to 0, unless the interface had been
added before. Not sure you want to preserve or not, but you should be
aware.

> +	priv->macids_used |= 1 << mwl_vif->macid;

The mac-ID handling would appear to be missing locking? Unless you
really never ever access it from outside the add/remove context.

> +		rc = mwl_fwcmd_set_rf_channel(hw, conf);
> +
> +		if (rc)
> +			goto out;

I'd remove those extra blank lines after the assignments, and I note
that here you used more customary style with gotos.

> +static int mwl_mac80211_sta_add(struct ieee80211_hw *hw,
> +				struct ieee80211_vif *vif,
> +				struct ieee80211_sta *sta)

Please consider implementing sta_state, I hope we can perhaps one day
get rid of sta_add/sta_remove.


> +	if (mwl_vif->is_sta)
> +		mwl_fwcmd_set_new_stn_del(hw, vif, sta->addr);

That seems suspicious, it shouldn't be needed to delete before you add?

> +static int mwl_mac80211_ampdu_action(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
> +				     enum ieee80211_ampdu_mlme_action action,
> +				     struct ieee80211_sta *sta,
> +				     u16 tid, u16 *ssn, u8 buf_size)
> +{
> +	int i, rc = 0;
> +	struct mwl_priv *priv = hw->priv;
> +	struct mwl_ampdu_stream *stream;
> +	u8 *addr = sta->addr, idx;
> +	struct mwl_sta *sta_info = MWL_STA(sta);
> +
> +	WLDBG_ENTER(DBG_LEVEL_5);
> +
> +	if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
> +		WLDBG_EXIT_INFO(DBG_LEVEL_5, "no HW AMPDU");
> +		return -ENOTSUPP;
> +	}

I'm almost certain mac80211 checks this already :)

> +	case IEEE80211_AMPDU_TX_START:
> +		/* By the time we get here the hw queues may contain outgoing
> +		 * packets for this RA/TID that are not part of this BA
> +		 * session.  The hw will assign sequence numbers to these
> +		 * packets as they go out.  So if we query the hw for its next
> +		 * sequence number and use that for the SSN here, it may end up
> +		 * being wrong, which will lead to sequence number mismatch at
> +		 * the recipient.  To avoid this, we reset the sequence number
> +		 * to O for the first MPDU in this BA stream.
> +		 */
> +		*ssn = 0;

I'm not sure that does what you think it does? "ssn" is just what
mac80211 tells the remote side, which really shouldn't be 0 nor should
it be reset since otherwise the peer will expect something else:

Imagine you're at seqno 0xf00 now, with ssn=0 the peer would still
expect 0x100 packets before aggregation starts. That's probably not so
bad though, but imagine you're at 0 at this moment for wrapping
reasons ... seems that would get confused.

> +		/* Release the lock before we do the time consuming stuff
> +		*/
> +		SPIN_UNLOCK(&priv->locks.stream_lock);
> +
> +		for (i = 0; i < MAX_AMPDU_ATTEMPTS; i++) {
> +			/* Check if link is still valid
> +			*/
> +			if (!sta_info->is_ampdu_allowed) {
> +				SPIN_LOCK(&priv->locks.stream_lock);
> +				mwl_fwcmd_remove_stream(hw, stream);
> +				SPIN_UNLOCK(&priv->locks.stream_lock);
> +				WLDBG_EXIT_INFO(DBG_LEVEL_5,
> +						"link is no valid now");
> +				return -EBUSY;
> +			}
> +
> +			rc = mwl_fwcmd_check_ba(hw, stream, vif);
> +
> +			if (!rc)
> +				break;
> +
> +			WL_MSEC_SLEEP(1000);
> +		}

That seems FAR too long to do in the context of mac80211's work queue,
it'll stall a lot of other processing. You should do this
asynchronously.

> +	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
> +		mwl_fwcmd_set_radio_preamble(hw,
> +					     vif->bss_conf.use_short_preamble);
> +	}
> +
> +	if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc) {
> +		mwl_fwcmd_set_aid(hw, vif, (u8 *)vif->bss_conf.bssid,
> +				  vif->bss_conf.aid);
> +	}

No need for braces.

> +		if ((info->ssid[0] != '\0') &&
> +		    (info->ssid_len != 0) &&
> +		    (!info->hidden_ssid))
> +			mwl_fwcmd_broadcast_ssid_enable(hw, vif, true);
> +		else
> +			mwl_fwcmd_broadcast_ssid_enable(hw, vif, false);
> +	}

Why does the firmware need to know about this? What part does it offload
that makes this necessary? This seems a bit like a hack since we already
have this in struct cfg80211_ap_settings, but perhaps just are missing
to pass it through to the driver? Unless you have some offloads though
it shouldn't be needed?

> +	band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
> +	band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
> +	band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE;
> +	band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;

You should probably not yet advertise MU_BEAMFORMEE since mac80211
doesn't yet have the logic to properly split that per virtual
interface ... We're working on that. How come you haven't thought about
group collisions? I thought this driver supported >1 virtual client
interface.

> +	/* Extra headroom is the size of the required DMA header
> +	 * minus the size of the smallest 802.11 frame (CTS frame).
> +	 */
> +	hw->extra_tx_headroom =
> +		sizeof(struct mwl_dma_data) - sizeof(struct ieee80211_cts);

If you have an S/G DMA engine, consider avoiding this, it's often not
very efficient.

> +	/* Queue ADDBA request in the respective data queue.  While setting up
> +	 * the ampdu stream, mac80211 queues further packets for that
> +	 * particular ra/tid pair.  However, packets piled up in the hardware
> +	 * for that ra/tid pair will still go out. ADDBA request and the
> +	 * related data packets going out from different queues asynchronously
> +	 * will cause a shift in the receiver window which might result in
> +	 * ampdu packets getting dropped at the receiver after the stream has
> +	 * been setup.
> +	 */

That's why you're supposed to set the SSN correctly ... :)

> +	for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
> +		while (STALE_TXD(num) && (STALE_TXD(num)->status &
> +		       ENDIAN_SWAP32(EAGLE_TXD_STATUS_OK)) &&
> +		       (!(STALE_TXD(num)->status &
> +		       ENDIAN_SWAP32(EAGLE_TXD_STATUS_FW_OWNED)))) {
> +			pci_unmap_single(priv->pdev,
> +					 ENDIAN_SWAP32(STALE_TXD(num)->pkt_ptr),
> +					 STALE_TXD(num)->psk_buff->len,
> +					 PCI_DMA_TODEVICE);
> +			done_skb = STALE_TXD(num)->psk_buff;
> +			rate_info = STALE_TXD(num)->rate_info;
> +			STALE_TXD(num)->pkt_len = 0;
> +			STALE_TXD(num)->psk_buff = NULL;
> +			STALE_TXD(num)->status =
> +				ENDIAN_SWAP32(EAGLE_TXD_STATUS_IDLE);
> +			priv->fw_desc_cnt[num]--;
> +			STALE_TXD(num) = STALE_TXD(num)->pnext;
> +			wmb(); /* memory barrier */

That's not a very good comment. Are you sure that's correct btw? It
doesn't make much sense to me here.

> +				CURR_TXD(num).status =
> +					ENDIAN_SWAP32(EAGLE_TXD_STATUS_IDLE);
> +				CURR_TXD(num).psk_buff = NULL;
> +				CURR_TXD(num).pkt_ptr = 0;
> +				CURR_TXD(num).pkt_len = 0;

That's a bit macro-heavy for my taste - why not just have a local
variable curr_txd?

> +static inline void mwl_tx_insert_ccmp_hdr(u8 *pccmp_hdr,
> +					  u8 key_id, u16 iv16, u32 iv32)
> +{
> +	*((u16 *)pccmp_hdr) = iv16;
> +	pccmp_hdr[2] = 0;
> +	pccmp_hdr[3] = EXT_IV | (key_id << 6);
> +	*((u32 *)&pccmp_hdr[4]) = iv32;
> +}

Why don't you let mac80211 do this?

johannes

