Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752517AbeE3LRr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 07:17:47 -0400
Date: Wed, 30 May 2018 14:17:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: wilc1000: fix some endianness sparse
 warnings
Message-ID: <20180530111725.gmigyddsp2i6mgzw@mwanda> (sfid-20180530_131913_188902_7E35C2A7)
References: <20180529191143.13081-1-thibaut.robert@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180529191143.13081-1-thibaut.robert@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2018 at 09:11:43PM +0200, Thibaut Robert wrote:
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index e248702ee519..745bf5ca2622 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -1431,7 +1431,7 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
>  
>  	freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
>  
> -	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
> +	if (!ieee80211_is_action(cpu_to_le16(buff[FRAME_TYPE_ID]))) {

"buff" comes from the network, it's going to be little endian, not cpu
endian.  The rest of the function treats it as CPU endian but I'm pretty
sure it's wrong...

>  		cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
>  		return;
>  	}


> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 28c93f3f846e..a5ac1d26590b 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -560,7 +560,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
>  	int ret = 0;
>  	int counter;
>  	int timeout;
> -	u32 vmm_table[WILC_VMM_TBL_SIZE];
> +	__le32 vmm_table[WILC_VMM_TBL_SIZE];
> +	u32 table_entry;
>  	struct wilc_vif *vif;
>  	struct wilc *wilc;
>  	const struct wilc_hif_func *func;
> @@ -598,10 +599,10 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
>  			if ((sum + vmm_sz) > LINUX_TX_SIZE)
>  				break;
>  
> -			vmm_table[i] = vmm_sz / 4;
> +			table_entry = vmm_sz / 4;
>  			if (tqe->type == WILC_CFG_PKT)
> -				vmm_table[i] |= BIT(10);
> -			vmm_table[i] = cpu_to_le32(vmm_table[i]);
> +				table_entry |= BIT(10);
> +			vmm_table[i] = cpu_to_le32(table_entry);
>  
>  			i++;
>  			sum += vmm_sz;
> @@ -704,8 +705,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
>  		if (vmm_table[i] == 0)
>  			break;
>  
> -		vmm_table[i] = cpu_to_le32(vmm_table[i]);
> -		vmm_sz = (vmm_table[i] & 0x3ff);
> +		vmm_sz = (le32_to_cpu(vmm_table[i]) & 0x3ff);
>  		vmm_sz *= 4;
>  		header = (tqe->type << 31) |
>  			 (tqe->buffer_size << 15) |
> @@ -715,8 +715,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
>  		else
>  			header &= ~BIT(30);
>  
> -		header = cpu_to_le32(header);
> -		memcpy(&txb[offset], &header, 4);
> +		*((__le32 *)&txb[offset]) = cpu_to_le32(header);

I worry about alignment issues here.  That might be the reason for the
memcpy().  (I'm reading as fast as I can and don't the code so I may
be wrong).

>  		if (tqe->type == WILC_CFG_PKT) {
>  			buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
>  		} else if (tqe->type == WILC_NET_PKT) {
> @@ -770,8 +769,7 @@ static void wilc_wlan_handle_rx_buff(struct wilc *wilc, u8 *buffer, int size)
>  
>  	do {
>  		buff_ptr = buffer + offset;
> -		memcpy(&header, buff_ptr, 4);
> -		header = cpu_to_le32(header);
> +		header = le32_to_cpup((__le32 *)buff_ptr);

Maybe the same, whenever you see a memcpy().

>  
>  		is_cfg_packet = (header >> 31) & 0x1;
>  		pkt_offset = (header >> 22) & 0x1ff;
> @@ -942,6 +940,7 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
>  	u32 offset;
>  	u32 addr, size, size2, blksz;
>  	u8 *dma_buffer;
> +	const __le32 *header;
>  	int ret = 0;
>  
>  	blksz = BIT(12);
> @@ -952,10 +951,9 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
>  
>  	offset = 0;
>  	do {
> -		memcpy(&addr, &buffer[offset], 4);
> -		memcpy(&size, &buffer[offset + 4], 4);
> -		addr = cpu_to_le32(addr);
> -		size = cpu_to_le32(size);
> +		header = (__le32 *)buffer + offset;
> +		addr = le32_to_cpu(header[0]);
> +		size = le32_to_cpu(header[1]);
>  		acquire_bus(wilc, ACQUIRE_ONLY);
>  		offset += 8;
>  		while (((int)size) && (offset < buffer_size)) {
> diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
> index c0b9b700f4d7..4a914d8572aa 100644
> --- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
> +++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
> @@ -275,14 +275,14 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
>  
>  static void wilc_wlan_parse_response_frame(u8 *info, int size)
>  {
> -	u32 wid, len = 0, i = 0;
> +	u32 wid;
> +	int len = 0, i = 0;

Why did we make these int now?

>  
>  	while (size > 0) {
>  		i = 0;
> -		wid = info[0] | (info[1] << 8);
> -		wid = cpu_to_le32(wid);
> +		wid = le16_to_cpup((__le16 *)info);
>  
> -		switch ((wid >> 12) & 0x7) {
> +		switch (info[1] >> 4) {

Why do we not need to mask by 0x7?  Anyway, I feel like this isn't
beautiful.  We should be using a macro and "wid" instead of magically
poking into info[1].

		switch(SOME_MACRO(wid)) {


regards,
dan carpenter
