Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:27052 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaFMQp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 12:45:57 -0400
Message-ID: <539B2AB6.4040107@broadcom.com> (sfid-20140613_184601_269321_BD4C8FA0)
Date: Fri, 13 Jun 2014 18:45:42 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jahnavi Meher <jahnavi.meher@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] Fixes and clean up of code
References: <1402670645-8853-1-git-send-email-jahnavi.meher@gmail.com>
In-Reply-To: <1402670645-8853-1-git-send-email-jahnavi.meher@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-06-14 16:44, Jahnavi Meher wrote:
> Changed the SDIO interrupt type variables according to changes
> in firmware, made fixes to auto rate code and radio-caps frame,
> added defines for endpoints and some other minor fixes.

This commit sure changes a lot of stuff all over the place. Would you 
mind splitting it up:

> Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
> ---
>   drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +-
>   drivers/net/wireless/rsi/rsi_91x_mac80211.c |    7 +-
>   drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  113 ++++++++++++---------------
>   drivers/net/wireless/rsi/rsi_91x_pkt.c      |    7 ++
>   drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    8 +-
>   drivers/net/wireless/rsi/rsi_mgmt.h         |   21 +++++
>   drivers/net/wireless/rsi/rsi_sdio.h         |    8 +-
>   7 files changed, 95 insertions(+), 79 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
> index c466246..828a042 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
> @@ -145,7 +145,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
>   	seq_printf(seq, "total_mgmt_pkt_send : %d\n",
>   		   common->tx_stats.total_tx_pkt_send[MGMT_SOFT_Q]);
>   	seq_printf(seq, "total_mgmt_pkt_queued : %d\n",
> -		   skb_queue_len(&common->tx_queue[4]));
> +		   skb_queue_len(&common->tx_queue[MGMT_SOFT_Q]));
>   	seq_printf(seq, "total_mgmt_pkt_freed  : %d\n",
>   		   common->tx_stats.total_tx_pkt_freed[MGMT_SOFT_Q]);
>
> @@ -153,25 +153,25 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
>   	seq_printf(seq, "total_data_vo_pkt_send: %8d\t",
>   		   common->tx_stats.total_tx_pkt_send[VO_Q]);
>   	seq_printf(seq, "total_data_vo_pkt_queued:  %8d\t",
> -		   skb_queue_len(&common->tx_queue[0]));
> +		   skb_queue_len(&common->tx_queue[VO_Q]));
>   	seq_printf(seq, "total_vo_pkt_freed: %8d\n",
>   		   common->tx_stats.total_tx_pkt_freed[VO_Q]);
>   	seq_printf(seq, "total_data_vi_pkt_send: %8d\t",
>   		   common->tx_stats.total_tx_pkt_send[VI_Q]);
>   	seq_printf(seq, "total_data_vi_pkt_queued:  %8d\t",
> -		   skb_queue_len(&common->tx_queue[1]));
> +		   skb_queue_len(&common->tx_queue[VI_Q]));
>   	seq_printf(seq, "total_vi_pkt_freed: %8d\n",
>   		   common->tx_stats.total_tx_pkt_freed[VI_Q]);
>   	seq_printf(seq,  "total_data_be_pkt_send: %8d\t",
>   		   common->tx_stats.total_tx_pkt_send[BE_Q]);
>   	seq_printf(seq, "total_data_be_pkt_queued:  %8d\t",
> -		   skb_queue_len(&common->tx_queue[2]));
> +		   skb_queue_len(&common->tx_queue[BE_Q]));
>   	seq_printf(seq, "total_be_pkt_freed: %8d\n",
>   		   common->tx_stats.total_tx_pkt_freed[BE_Q]);
>   	seq_printf(seq, "total_data_bk_pkt_send: %8d\t",
>   		   common->tx_stats.total_tx_pkt_send[BK_Q]);
>   	seq_printf(seq, "total_data_bk_pkt_queued:  %8d\t",
> -		   skb_queue_len(&common->tx_queue[3]));
> +		   skb_queue_len(&common->tx_queue[BK_Q]));
>   	seq_printf(seq, "total_bk_pkt_freed: %8d\n",
>   		   common->tx_stats.total_tx_pkt_freed[BK_Q]);

above could be:

rsi: remove magic values in tx index

> diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> index 54aaeb0..45bdb99 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> @@ -185,7 +185,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
>   }
>
>   /**
> - * rsi_mac80211_attach() - This function is used to de-initialize the
> + * rsi_mac80211_detach() - This function is used to de-initialize the

rsi: fix kernel doc

>    *			   Mac80211 stack.
>    * @adapter: Pointer to the adapter structure.
>    *
> @@ -770,10 +770,7 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
>
>   	rxs->signal = -(rssi);
>
> -	if (channel <= 14)
> -		rxs->band = IEEE80211_BAND_2GHZ;
> -	else
> -		rxs->band = IEEE80211_BAND_5GHZ;
> +	rxs->band = common->band;

rsi: use band from rsi_common in rx status

>   	freq = ieee80211_channel_to_frequency(channel, rxs->band);
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> index 2eefbf1..38e7692 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> @@ -217,6 +217,7 @@ static void rsi_set_default_parameters(struct rsi_common *common)
>   	common->min_rate = 0xffff;
>   	common->fsm_state = FSM_CARD_NOT_READY;
>   	common->iface_down = true;
> +	common->endpoint = EP_2GHZ_20MHZ;
>   }
>
>   /**
> @@ -276,7 +277,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
>   {
>   	struct rsi_radio_caps *radio_caps;
>   	struct rsi_hw *adapter = common->priv;
> -	struct ieee80211_hw *hw = adapter->hw;
>   	u16 inx = 0;
>   	u8 ii;
>   	u8 radio_id = 0;
> @@ -285,7 +285,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
>   		      0xf0, 0xf0, 0xf0, 0xf0,
>   		      0xf0, 0xf0, 0xf0, 0xf0,
>   		      0xf0, 0xf0, 0xf0, 0xf0};
> -	struct ieee80211_conf *conf = &hw->conf;
>   	struct sk_buff *skb;
>
>   	rsi_dbg(INFO_ZONE, "%s: Sending rate symbol req frame\n", __func__);
> @@ -307,29 +306,36 @@ static int rsi_load_radio_caps(struct rsi_common *common)
>   	if (common->channel_width == BW_40MHZ) {
>   		radio_caps->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
>   		radio_caps->desc_word[7] |= cpu_to_le16(RSI_ENABLE_40MHZ);
> -		if (common->channel_width) {
> -			radio_caps->desc_word[5] =
> -				cpu_to_le16(common->channel_width << 12);
> -			radio_caps->desc_word[5] |= cpu_to_le16(FULL40M_ENABLE);
> -		}
> -
> -		if (conf_is_ht40_minus(conf)) {
> -			radio_caps->desc_word[5] = 0;
> -			radio_caps->desc_word[5] |=
> -				cpu_to_le16(LOWER_20_ENABLE);
> -			radio_caps->desc_word[5] |=
> -				cpu_to_le16(LOWER_20_ENABLE >> 12);
> -		}
>
> -		if (conf_is_ht40_plus(conf)) {
> -			radio_caps->desc_word[5] = 0;
> -			radio_caps->desc_word[5] |=
> -				cpu_to_le16(UPPER_20_ENABLE);
> -			radio_caps->desc_word[5] |=
> -				cpu_to_le16(UPPER_20_ENABLE >> 12);
> +		if (common->fsm_state == FSM_MAC_INIT_DONE) {
> +			struct ieee80211_hw *hw = adapter->hw;
> +			struct ieee80211_conf *conf = &hw->conf;

At first I though you were removing assigned but unused variable 
declarations, but I see you moved them inside this if block statement. 
The CodingStyle does not complain about this, but I prefer all 
declarations at start of the function. Stack scoping brings more hassle 
than it solves (personal opinion).

> +			if (conf_is_ht40_plus(conf)) {
> +				radio_caps->desc_word[5] =
> +					cpu_to_le16(LOWER_20_ENABLE);
> +				radio_caps->desc_word[5] |=
> +					cpu_to_le16(LOWER_20_ENABLE >> 12);
> +			} else if (conf_is_ht40_minus(conf)) {
> +				radio_caps->desc_word[5] =
> +					cpu_to_le16(UPPER_20_ENABLE);
> +				radio_caps->desc_word[5] |=
> +					cpu_to_le16(UPPER_20_ENABLE >> 12);
> +			} else {
> +				radio_caps->desc_word[5] =
> +					cpu_to_le16(BW_40MHZ << 12);
> +				radio_caps->desc_word[5] |=
> +					cpu_to_le16(FULL40M_ENABLE);
> +			}

the above seems to belong to PATCH 5/5.

>   		}
>   	}
>
> +	radio_caps->sifs_tx_11n = cpu_to_le16(SIFS_TX_11N_VALUE);
> +	radio_caps->sifs_tx_11b = cpu_to_le16(SIFS_TX_11B_VALUE);
> +	radio_caps->slot_rx_11n = cpu_to_le16(SHORT_SLOT_VALUE);
> +	radio_caps->ofdm_ack_tout = cpu_to_le16(OFDM_ACK_TOUT_VALUE);
> +	radio_caps->cck_ack_tout = cpu_to_le16(CCK_ACK_TOUT_VALUE);
> +	radio_caps->preamble_type = cpu_to_le16(LONG_PREAMBLE);
> +
>   	radio_caps->desc_word[7] |= cpu_to_le16(radio_id << 8);
>
>   	for (ii = 0; ii < MAX_HW_QUEUES; ii++) {
> @@ -359,7 +365,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
>   						FRAME_DESC_SZ) |
>   					       (RSI_WIFI_MGMT_Q << 12));
>
> -
>   	skb_put(skb, (sizeof(struct rsi_radio_caps)));
>
>   	return rsi_send_internal_mgmt_frame(common, skb);
> @@ -588,7 +593,7 @@ static int rsi_program_bb_rf(struct rsi_common *common)
>
>   	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
>   	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
> -	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint << 8);
> +	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint);
>
>   	if (common->rf_reset) {
>   		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
> @@ -841,23 +846,6 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
>   	rsi_dbg(MGMT_TX_ZONE,
>   		"%s: Sending scan req frame\n", __func__);
>
> -	if (common->band == IEEE80211_BAND_5GHZ) {
> -		if ((channel >= 36) && (channel <= 64))
> -			channel = ((channel - 32) / 4);
> -		else if ((channel > 64) && (channel <= 140))
> -			channel = ((channel - 102) / 4) + 8;
> -		else if (channel >= 149)
> -			channel = ((channel - 151) / 4) + 18;
> -		else
> -			return -EINVAL;
> -	} else {
> -		if (channel > 14) {
> -			rsi_dbg(ERR_ZONE, "%s: Invalid chno %d, band = %d\n",
> -				__func__, channel, common->band);
> -			return -EINVAL;
> -		}
> -	}
> -
>   	skb = dev_alloc_skb(FRAME_DESC_SZ);
>   	if (!skb) {
>   		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
> @@ -877,6 +865,7 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
>   					       (RSI_RF_TYPE << 4));
>
>   	mgmt_frame->desc_word[5] = cpu_to_le16(0x01);
> +	mgmt_frame->desc_word[6] = cpu_to_le16(0x12);
>
>   	if (common->channel_width == BW_40MHZ)
>   		mgmt_frame->desc_word[5] |= cpu_to_le16(0x1 << 8);
> @@ -950,7 +939,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
>   	struct ieee80211_hw *hw = common->priv->hw;
>   	u8 band = hw->conf.chandef.chan->band;
>   	u8 num_supported_rates = 0;
> -	u8 rate_offset = 0;
> +	u8 rate_table_offset, rate_offset = 0;
>   	u32 rate_bitmap = common->bitrate_mask[band];
>
>   	u16 *selected_rates, min_rate;
> @@ -986,14 +975,18 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
>   	if (common->channel_width == BW_40MHZ)
>   		auto_rate->desc_word[7] |= cpu_to_le16(1);
>
> -	if (band == IEEE80211_BAND_2GHZ)
> -		min_rate = STD_RATE_01;
> -	else
> -		min_rate = STD_RATE_06;
> +	if (band == IEEE80211_BAND_2GHZ) {
> +		min_rate = RSI_RATE_1;
> +		rate_table_offset = 0;
> +	} else {
> +		min_rate = RSI_RATE_6;
> +		rate_table_offset = 4;
> +	}
>
>   	for (ii = 0, jj = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
>   		if (rate_bitmap & BIT(ii)) {
> -			selected_rates[jj++] = (rsi_rates[ii].bitrate / 5);
> +			selected_rates[jj++] =
> +			(rsi_rates[ii + rate_table_offset].bitrate / 5);
>   			rate_offset++;
>   		}
>   	}
> @@ -1006,13 +999,6 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
>   		rate_offset += ARRAY_SIZE(mcs);
>   	}
>
> -	if (rate_offset < (RSI_TBL_SZ / 2) - 1) {
> -		for (ii = jj; ii < (RSI_TBL_SZ / 2); ii++) {
> -			selected_rates[jj++] = min_rate;
> -			rate_offset++;
> -		}
> -	}
> -
>   	sort(selected_rates, jj, sizeof(u16), &rsi_compare, NULL);
>
>   	/* mapping the rates to RSI rates */
> @@ -1028,25 +1014,25 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
>
>   	/* loading HT rates in the bottom half of the auto rate table */
>   	if (common->vif_info[0].is_ht) {
> -		if (common->vif_info[0].sgi)
> -			auto_rate->supported_rates[rate_offset++] =
> -				cpu_to_le16(RSI_RATE_MCS7_SG);
> -
>   		for (ii = rate_offset, kk = ARRAY_SIZE(rsi_mcsrates) - 1;
>   		     ii < rate_offset + 2 * ARRAY_SIZE(rsi_mcsrates); ii++) {
> -			if (common->vif_info[0].sgi)
> +			if (common->vif_info[0].sgi ||
> +			    conf_is_ht40(&common->priv->hw->conf))
>   				auto_rate->supported_rates[ii++] =
>   					cpu_to_le16(rsi_mcsrates[kk] | BIT(9));
>   			auto_rate->supported_rates[ii] =
>   				cpu_to_le16(rsi_mcsrates[kk--]);
>   		}
>
> -		for (; ii < RSI_TBL_SZ; ii++) {
> +		for (; ii < (RSI_TBL_SZ - 1); ii++) {
>   			auto_rate->supported_rates[ii] =
>   				cpu_to_le16(rsi_mcsrates[0]);
>   		}
>   	}
>
> +	for (; ii < RSI_TBL_SZ; ii++)
> +		auto_rate->supported_rates[ii] = min_rate;
> +

rsi: change supported rate handling

>   	auto_rate->num_supported_rates = cpu_to_le16(num_supported_rates * 2);
>   	auto_rate->moderate_rate_inx = cpu_to_le16(num_supported_rates / 2);
>   	auto_rate->desc_word[7] |= cpu_to_le16(0 << 8);
> @@ -1164,7 +1150,7 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
>   				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
>   			}
>   		} else {
> -			rsi_dbg(ERR_ZONE,
> +			rsi_dbg(INFO_ZONE,
>   				"%s: Received bootup params cfm in %d state\n",
>   				 __func__, common->fsm_state);
>   			return 0;
> @@ -1227,7 +1213,7 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
>   					__func__);
>   			}
>   		} else {
> -			rsi_dbg(ERR_ZONE,
> +			rsi_dbg(INFO_ZONE,
>   				"%s: Received radio caps cfm in %d state\n",
>   				 __func__, common->fsm_state);
>   			return 0;
> @@ -1245,7 +1231,10 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
>   				return rsi_mac80211_attach(common);
>   			}
>   		} else {
> -			goto out;
> +			rsi_dbg(INFO_ZONE,
> +				"%s: Received bbb_rf cfm in %d state\n",
> +				 __func__, common->fsm_state);
> +			return 0;

rsi: lower level for some debug messages

>   		}
>   		break;
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
> index 8e48e72..2221c23 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
> @@ -81,6 +81,13 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
>   		/* Send fixed rate */
>   		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
>   		frame_desc[4] = cpu_to_le16(common->min_rate);
> +
> +		if (common->vif_info[0].sgi) {
> +			if (common->min_rate & 0x100) /* Only MCS rates */
> +				frame_desc[4] |=
> +					cpu_to_le16(ENABLE_SHORTGI_RATE);
> +		}
> +

rsi: use SGI if configured

>   	}
>
>   	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
> index 20d11cc..4834a9a 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
> @@ -401,14 +401,16 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
>   			case BUFFER_AVAILABLE:
>   				dev->rx_info.watch_bufferfull_count = 0;
>   				dev->rx_info.buffer_full = false;
> +				dev->rx_info.semi_buffer_full = false;
>   				dev->rx_info.mgmt_buffer_full = false;
>   				rsi_sdio_ack_intr(common->priv,
>   						  (1 << PKT_BUFF_AVAILABLE));
> -				rsi_set_event((&common->tx_thread.event));
> +				rsi_set_event(&common->tx_thread.event);
> +
>   				rsi_dbg(ISR_ZONE,
> -					"%s: ==> BUFFER_AVILABLE <==\n",
> +					"%s: ==> BUFFER_AVAILABLE <==\n",
>   					__func__);
> -				dev->rx_info.buf_avilable_counter++;
> +				dev->rx_info.buf_available_counter++;
>   				break;
>
>   			case FIRMWARE_ASSERT_IND:
> diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
> index 225215a..8bff664 100644
> --- a/drivers/net/wireless/rsi/rsi_mgmt.h
> +++ b/drivers/net/wireless/rsi/rsi_mgmt.h
> @@ -69,6 +69,7 @@
>
>   #define RSI_LMAC_CLOCK_80MHZ            0x1
>   #define RSI_ENABLE_40MHZ                (0x1 << 3)
> +#define ENABLE_SHORTGI_RATE		BIT(9)
>
>   #define RX_BA_INDICATION                1
>   #define RSI_TBL_SZ                      40
> @@ -123,6 +124,20 @@
>   #define BW_20MHZ                        0
>   #define BW_40MHZ                        1
>
> +#define EP_2GHZ_20MHZ			0
> +#define EP_2GHZ_40MHZ			1
> +#define EP_5GHZ_20MHZ			2
> +#define EP_5GHZ_40MHZ			3
> +
> +#define SIFS_TX_11N_VALUE		580
> +#define SIFS_TX_11B_VALUE		346
> +#define SHORT_SLOT_VALUE		360
> +#define LONG_SLOT_VALUE			640
> +#define OFDM_ACK_TOUT_VALUE		2720
> +#define CCK_ACK_TOUT_VALUE		9440
> +#define LONG_PREAMBLE			0x0000
> +#define SHORT_PREAMBLE			0x0001
> +
>   #define RSI_SUPP_FILTERS	(FIF_ALLMULTI | FIF_PROBE_REQ |\
>   				 FIF_BCN_PRBRESP_PROMISC)
>   enum opmode {
> @@ -238,6 +253,12 @@ struct rsi_radio_caps {
>   	u8 num_11n_rates;
>   	u8 num_11ac_rates;
>   	__le16 gcpd_per_rate[20];
> +	__le16 sifs_tx_11n;
> +	__le16 sifs_tx_11b;
> +	__le16 slot_rx_11n;
> +	__le16 ofdm_ack_tout;
> +	__le16 cck_ack_tout;
> +	__le16 preamble_type;
>   } __packed;
>
>   static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
> diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
> index df4b5e2..c7e8f2b 100644
> --- a/drivers/net/wireless/rsi/rsi_sdio.h
> +++ b/drivers/net/wireless/rsi/rsi_sdio.h
> @@ -30,7 +30,7 @@
>
>   enum sdio_interrupt_type {
>   	BUFFER_FULL         = 0x0,
> -	BUFFER_AVAILABLE    = 0x1,
> +	BUFFER_AVAILABLE    = 0x2,
>   	FIRMWARE_ASSERT_IND = 0x3,
>   	MSDU_PACKET_PENDING = 0x4,
>   	UNKNOWN_INT         = 0XE
> @@ -42,7 +42,7 @@ enum sdio_interrupt_type {
>   #define PKT_MGMT_BUFF_FULL                      2
>   #define MSDU_PKT_PENDING                        3
>   /* Interrupt Bit Related Macros */
> -#define PKT_BUFF_AVAILABLE                      0
> +#define PKT_BUFF_AVAILABLE                      1

rsi: change interrupt definitions

>   #define FW_ASSERT_IND                           2
>
>   #define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
> @@ -84,7 +84,7 @@ enum sdio_interrupt_type {
>   #define TA_HOLD_THREAD_VALUE         cpu_to_le32(0xF)
>   #define TA_RELEASE_THREAD_VALUE      cpu_to_le32(0xF)
>   #define TA_BASE_ADDR                 0x2200
> -#define MISC_CFG_BASE_ADDR           0x4150
> +#define MISC_CFG_BASE_ADDR           0x4105
>
>   struct receive_info {
>   	bool buffer_full;
> @@ -98,7 +98,7 @@ struct receive_info {
>   	u32 total_sdio_msdu_pending_intr;
>   	u32 total_sdio_unknown_intr;
>   	u32 buf_full_counter;
> -	u32 buf_avilable_counter;
> +	u32 buf_available_counter;
>   };
>
>   struct rsi_91x_sdiodev {
>

Regards,
Arend

