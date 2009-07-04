Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:35049 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbZGDCPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 22:15:55 -0400
Message-ID: <4A4EBB68.6050502@lwfinger.net>
Date: Fri, 03 Jul 2009 21:16:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
References: <200907040053.05654.chunkeey@web.de>
In-Reply-To: <200907040053.05654.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch tries to address a long standing issue: 
> how to survive serve memory starvation situations,
> without losing the device due to missing transfer-buffers.
> 
> And with a flick of __GFP_NOWARN, we're able to handle ?all? memory
> allocation failures on the rx-side during operation without much fuss.
> 
> However, there is still an issue within the xmit-part.
> This is likely due to p54's demand for a large free headroom for
> every outgoing frame:
> 
-- snip --

> diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
> index 349375f..c9bc1da 100644
> --- a/drivers/net/wireless/p54/fwio.c
> +++ b/drivers/net/wireless/p54/fwio.c
> @@ -94,7 +94,7 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>  			else
>  				priv->rx_mtu = (size_t)
>  					0x620 - priv->tx_hdr_len;
> -			maxlen = priv->tx_hdr_len + /* USB devices */
> +			maxlen = priv->rx_hdr_len + /* USB devices */
>  				 sizeof(struct p54_rx_data) +
>  				 4 + /* rx alignment */
>  				 IEEE80211_MAX_FRAG_THRESHOLD;
> @@ -103,6 +103,18 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>  				       "to %d\n", priv->rx_mtu, maxlen);
>  				priv->rx_mtu = maxlen;
>  			}
> +
> +			/*
> +			 * Firmware may insert up to 4 padding bytes after
> +			 * the lmac header, but it doesn't amend the size
> +			 * of data transfer.
> +			 * Such packets has correct data size in header, thus
                                        ===
s/has/have/

> +			 * referencing past the end of allocated skb.
> +			 * Therefore reserve 4 extra bytes for this case.
> +			 */
> +			if (priv->rx_wa_extra_tail_space)
> +				priv->rx_mtu += 4;
> +
>  			break;
>  			}
>  		case BR_CODE_EXPOSED_IF:
> @@ -312,7 +324,7 @@ int p54_setup_mac(struct p54_common *priv)
>  {
>  	struct sk_buff *skb;
>  	struct p54_setup_mac *setup;
> -	u16 mode;
> +	u16 mode, rx_mtu = priv->rx_mtu;
>  
>  	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*setup),
>  			    P54_CONTROL_TYPE_SETUP, GFP_ATOMIC);
> @@ -356,17 +368,25 @@ int p54_setup_mac(struct p54_common *priv)
>  	memcpy(setup->bssid, priv->bssid, ETH_ALEN);
>  	setup->rx_antenna = 2 & priv->rx_diversity_mask; /* automatic */
>  	setup->rx_align = 0;
> +
> +	/*
> +	 * reserve additional bytes to compensate for the possible
> +	 * alignment-caused truncation.
> +	 */
> +	if (priv->rx_wa_extra_tail_space)
> +		rx_mtu -= 4;
> +
>  	if (priv->fw_var < 0x500) {
>  		setup->v1.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
>  		memset(setup->v1.rts_rates, 0, 8);
>  		setup->v1.rx_addr = cpu_to_le32(priv->rx_end);
> -		setup->v1.max_rx = cpu_to_le16(priv->rx_mtu);
> +		setup->v1.max_rx = cpu_to_le16(rx_mtu);
>  		setup->v1.rxhw = cpu_to_le16(priv->rxhw);
>  		setup->v1.wakeup_timer = cpu_to_le16(priv->wakeup_timer);
>  		setup->v1.unalloc0 = cpu_to_le16(0);
>  	} else {
>  		setup->v2.rx_addr = cpu_to_le32(priv->rx_end);
> -		setup->v2.max_rx = cpu_to_le16(priv->rx_mtu);
> +		setup->v2.max_rx = cpu_to_le16(rx_mtu);
>  		setup->v2.rxhw = cpu_to_le16(priv->rxhw);
>  		setup->v2.timer = cpu_to_le16(priv->wakeup_timer);
>  		setup->v2.truncate = cpu_to_le16(48896);
> diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
> index 6772ed5..30ebde1 100644
> --- a/drivers/net/wireless/p54/p54.h
> +++ b/drivers/net/wireless/p54/p54.h
> @@ -176,6 +176,8 @@ struct p54_common {
>  
>  	/* firmware/hardware info */
>  	unsigned int tx_hdr_len;
> +	unsigned int rx_hdr_len;
> +	bool rx_wa_extra_tail_space;
>  	unsigned int fw_var;
>  	unsigned int fw_interface;
>  	u8 version;
> @@ -234,7 +236,7 @@ struct p54_common {
>  };
>  
>  /* interfaces for the drivers */
> -int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
> +struct sk_buff *p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
>  void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb);
>  int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
>  int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len);
> @@ -245,5 +247,6 @@ int p54_register_common(struct ieee80211_hw *dev, struct device *pdev);
>  void p54_free_common(struct ieee80211_hw *dev);
>  
>  void p54_unregister_common(struct ieee80211_hw *dev);
> +struct sk_buff *p54_alloc_rxskb(struct p54_common *priv, gfp_t gfp_mask);
>  
>  #endif /* P54_H */
> diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
> index d348c26..7d055da 100644
> --- a/drivers/net/wireless/p54/p54pci.c
> +++ b/drivers/net/wireless/p54/p54pci.c
> @@ -149,7 +149,7 @@ static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
>  		if (!desc->host_addr) {
>  			struct sk_buff *skb;
>  			dma_addr_t mapping;
> -			skb = dev_alloc_skb(priv->common.rx_mtu + 32);
> +			skb = dev_alloc_skb(priv->common.rx_mtu);
>  			if (!skb)
>  				break;
>  
> @@ -186,6 +186,7 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
>  	(*index) = idx = le32_to_cpu(ring_control->device_idx[ring_index]);
>  	idx %= ring_limit;
>  	while (i != idx) {
> +		dma_addr_t mapping;
>  		u16 len;
>  		struct sk_buff *skb;
>  		desc = &ring[i];
> @@ -197,25 +198,32 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
>  			i %= ring_limit;
>  			continue;
>  		}
> +
> +		pci_unmap_single(priv->pdev,
> +				 le32_to_cpu(desc->host_addr),
> +				 priv->common.rx_mtu + 32,
> +				 PCI_DMA_FROMDEVICE);
> +		rx_buf[i] = NULL;
> +		desc->host_addr = 0;
>  		skb_put(skb, len);
>  
> -		if (p54_rx(dev, skb)) {
> -			pci_unmap_single(priv->pdev,
> -					 le32_to_cpu(desc->host_addr),
> -					 priv->common.rx_mtu + 32,
> +		skb = p54_rx(dev, skb);
> +		mapping = pci_map_single(priv->pdev,
> +					 skb_tail_pointer(skb),
> +					 skb->len,
>  					 PCI_DMA_FROMDEVICE);
> -			rx_buf[i] = NULL;
> -			desc->host_addr = 0;
> -		} else {
> -			skb_trim(skb, 0);
> -			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
> -		}
> +
> +		desc->host_addr = cpu_to_le32(mapping);
> +		desc->device_addr = 0;
> +		desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
> +		desc->flags = 0;
> +		rx_buf[i] = skb;
>  
>  		i++;
>  		i %= ring_limit;
>  	}
> -
> -	p54p_refill_rx_ring(dev, ring_index, ring, ring_limit, rx_buf);
> +	wmb();
> +	ring_control->host_idx[ring_index] = cpu_to_le32(idx);
>  }
>  
>  /* caller must hold priv->lock */
> diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
> index 9b347ce..4c6ac3f 100644
> --- a/drivers/net/wireless/p54/p54spi.c
> +++ b/drivers/net/wireless/p54/p54spi.c
> @@ -389,14 +389,10 @@ static int p54spi_rx(struct p54s_priv *priv)
>  		return 0;
>  	}
>  
> -	/* Firmware may insert up to 4 padding bytes after the lmac header,
> -	 * but it does not amend the size of SPI data transfer.
> -	 * Such packets has correct data size in header, thus referencing
                        ===

s/has/have/

> -	 * past the end of allocated skb. Reserve extra 4 bytes for this case */
> -	skb = dev_alloc_skb(len + 4);
> +	skb = skb_dequeue(&priv->rx_pool);
>  	if (!skb) {
>  		p54spi_sleep(priv);
> -		dev_err(&priv->spi->dev, "could not alloc skb");
> +		dev_err(&priv->spi->dev, "could not get skb");
>  		return -ENOMEM;
>  	}
>  
> @@ -409,12 +405,9 @@ static int p54spi_rx(struct p54s_priv *priv)
>  				len - READAHEAD_SZ);
>  	}
>  	p54spi_sleep(priv);
> -	/* Put additional bytes to compensate for the possible
> -	 * alignment-caused truncation */
> -	skb_put(skb, 4);
>  
> -	if (p54_rx(priv->hw, skb) == 0)
> -		dev_kfree_skb(skb);
> +	skb = p54_rx(priv->hw, skb);
> +	skb_queue_tail(&priv->rx_pool, skb);
>  
>  	return 0;
>  }
> @@ -629,6 +622,7 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
>  static int __devinit p54spi_probe(struct spi_device *spi)
>  {
>  	struct p54s_priv *priv = NULL;
> +	struct sk_buff *skb;
>  	struct ieee80211_hw *hw;
>  	int ret = -EINVAL;
>  
> @@ -645,6 +639,8 @@ static int __devinit p54spi_probe(struct spi_device *spi)
>  
>  	spi->bits_per_word = 16;
>  	spi->max_speed_hz = 24000000;
> +	skb_queue_head_init(&priv->rx_pool);
> +	priv->common.rx_wa_extra_tail_space = true;
>  
>  	ret = spi_setup(spi);
>  	if (ret < 0) {
> @@ -689,6 +685,11 @@ static int __devinit p54spi_probe(struct spi_device *spi)
>  	priv->common.stop = p54spi_op_stop;
>  	priv->common.tx = p54spi_op_tx;
>  
> +	skb = __dev_alloc_skb(priv->common.rx_mtu, GFP_KERNEL);
> +	if (!skb)
> +		goto err_free_common;
> +	skb_queue_tail(&priv->rx_pool, skb);
> +
>  	ret = p54spi_request_firmware(hw);
>  	if (ret < 0)
>  		goto err_free_common;
> @@ -705,6 +706,7 @@ static int __devinit p54spi_probe(struct spi_device *spi)
>  
>  err_free_common:
>  	p54_free_common(priv->hw);
> +	skb_queue_purge(&priv->rx_pool);
>  	return ret;
>  }
>  
> @@ -715,6 +717,7 @@ static int __devexit p54spi_remove(struct spi_device *spi)
>  	p54_unregister_common(priv->hw);
>  
>  	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
> +	skb_queue_purge(&priv->rx_pool);
>  
>  	gpio_free(p54spi_gpio_power);
>  	gpio_free(p54spi_gpio_irq);
> diff --git a/drivers/net/wireless/p54/p54spi.h b/drivers/net/wireless/p54/p54spi.h
> index 7fbe8d8..11ef2d5 100644
> --- a/drivers/net/wireless/p54/p54spi.h
> +++ b/drivers/net/wireless/p54/p54spi.h
> @@ -120,6 +120,8 @@ struct p54s_priv {
>  
>  	enum fw_state fw_state;
>  	const struct firmware *firmware;
> +
> +	struct sk_buff_head rx_pool;
>  };
>  
>  #endif /* P54SPI_H */
> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> index 461d88f..c521bbc 100644
> --- a/drivers/net/wireless/p54/p54usb.c
> +++ b/drivers/net/wireless/p54/p54usb.c
> @@ -120,37 +120,14 @@ static void p54u_rx_cb(struct urb *urb)
>  	}
>  
>  	skb_put(skb, urb->actual_length);
> +	skb = p54_rx(dev, skb);
>  
> -	if (priv->hw_type == P54U_NET2280)
> -		skb_pull(skb, priv->common.tx_hdr_len);
> -	if (priv->common.fw_interface == FW_LM87) {
> -		skb_pull(skb, 4);
> -		skb_put(skb, 4);
> -	}
> -
> -	if (p54_rx(dev, skb)) {
> -		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
> -		if (unlikely(!skb)) {
> -			/* TODO check rx queue length and refill *somewhere* */
> -			return;
> -		}
> +	info = (struct p54u_rx_info *) skb->cb;
> +	info->urb = urb;
> +	info->dev = dev;
> +	urb->transfer_buffer = skb_tail_pointer(skb);
> +	urb->context = skb;
>  
> -		info = (struct p54u_rx_info *) skb->cb;
> -		info->urb = urb;
> -		info->dev = dev;
> -		urb->transfer_buffer = skb_tail_pointer(skb);
> -		urb->context = skb;
> -	} else {
> -		if (priv->hw_type == P54U_NET2280)
> -			skb_push(skb, priv->common.tx_hdr_len);
> -		if (priv->common.fw_interface == FW_LM87) {
> -			skb_push(skb, 4);
> -			skb_put(skb, 4);
> -		}
> -		skb_reset_tail_pointer(skb);
> -		skb_trim(skb, 0);
> -		urb->transfer_buffer = skb_tail_pointer(skb);
> -	}
>  	skb_queue_tail(&priv->rx_queue, skb);
>  	usb_anchor_urb(urb, &priv->submitted);
>  	if (usb_submit_urb(urb, GFP_ATOMIC)) {
> @@ -186,7 +163,7 @@ static int p54u_init_urbs(struct ieee80211_hw *dev)
>  	int ret = 0;
>  
>  	while (skb_queue_len(&priv->rx_queue) < 32) {
> -		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
> +		skb = __dev_alloc_skb(priv->common.rx_mtu, GFP_KERNEL);
>  		if (!skb) {
>  			ret = -ENOMEM;
>  			goto err;
> @@ -927,14 +904,17 @@ static int __devinit p54u_probe(struct usb_interface *intf,
>  #endif
>  
>  		priv->hw_type = P54U_3887;
> +		priv->common.rx_wa_extra_tail_space = true;
>  		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
>  		priv->common.tx_hdr_len = sizeof(struct lm87_tx_hdr);
> +		priv->common.rx_hdr_len = sizeof(struct lm87_rx_hdr);
>  		priv->common.tx = p54u_tx_lm87;
>  		priv->upload_fw = p54u_upload_firmware_3887;
>  	} else {
>  		priv->hw_type = P54U_NET2280;
>  		dev->extra_tx_headroom += sizeof(struct net2280_tx_hdr);
>  		priv->common.tx_hdr_len = sizeof(struct net2280_tx_hdr);
> +		priv->common.rx_hdr_len = sizeof(struct net2280_tx_hdr);
                                                                ==
Should this be rx rather than tx?

-- skip --

I have a problem that is not new with this patch. Using p54usb with
LM87 firmware and under the heavy load of building a kernel with the
source tree mounted with NFS, the interface will go off-line and
cannot reconnect. When the driver is unloaded and reloaded, it is
unable to reload the firmware. My log is as follows:

usb 1-5: new high speed USB device using ehci_hcd and address 3
usb 1-5: configuration #1 chosen from 1 choice
cfg80211: Calling CRDA to update world regulatory domain
usb 1-5: reset high speed USB device using ehci_hcd and address 3
usb 1-5: firmware: requesting isl3887usb
phy0: p54 detected a LM87 firmware
p54: rx_mtu reduced from 3240 to 2380
phy0: FW rev 2.13.24.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: hwaddr 00:90:4b:d2:1f:cd, MAC:isl3892 RF:Xbow
phy0: Selected rate control algorithm 'minstrel'
Registered led device: p54-phy0::assoc
Registered led device: p54-phy0::tx
Registered led device: p54-phy0::rx
Registered led device: p54-phy0::radio
usb 1-5: is registered as 'phy0'
usbcore: registered new interface driver p54usb
wlan0: authenticate with AP 00:1a:70:46:ba:b1
wlan0: authenticated
wlan0: associate with AP 00:1a:70:46:ba:b1
wlan0: RX AssocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=1)
wlan0: associated
wlan0: no probe response from AP 00:1a:70:46:ba:b1 - disassociating
usbcore: deregistering interface driver p54usb
cfg80211: Calling CRDA to update world regulatory domain
usb 1-5: reset high speed USB device using ehci_hcd and address 3
usb 1-5: firmware: requesting isl3887usb
phy0: p54 detected a LM87 firmware
p54: rx_mtu reduced from 3240 to 2380
phy0: FW rev 2.13.24.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
usb 1-5: (p54usb) firmware upload failed!
p54usb: probe of 1-5:1.0 failed with error -110
