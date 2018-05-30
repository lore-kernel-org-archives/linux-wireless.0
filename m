Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:40301 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752886AbeE3OuM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 10:50:12 -0400
Date: Wed, 30 May 2018 20:20:06 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Thibaut Robert <thibaut.robert@gmail.com>
CC: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: wilc1000: fix some endianness sparse
 warnings
Message-ID: <20180530202006.393f3dea@ajaysk-VirtualBox> (sfid-20180530_165017_951457_3000F621)
In-Reply-To: <20180529191143.13081-1-thibaut.robert@gmail.com>
References: <20180529191143.13081-1-thibaut.robert@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 29 May 2018 21:11:43 +0200
Thibaut Robert <thibaut.robert@gmail.com> wrote:

> This commit fix a few sparse warnings. It mostly consists of fixing
> the type declarations and avoiding the use of variables with mixed
> endianness values.
> 
> Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c           | 15 ++++++-----
>  .../staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
>  drivers/staging/wilc1000/wilc_wlan.c          | 26
> +++++++++---------- drivers/staging/wilc1000/wilc_wlan_cfg.c      |
> 8 +++--- drivers/staging/wilc1000/wilc_wlan_cfg.h      |  4 +--
>  5 files changed, 27 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c
> b/drivers/staging/wilc1000/wilc_spi.c index
> 647526387784..e51f0d91a376 100644 ---
> a/drivers/staging/wilc1000/wilc_spi.c +++
> b/drivers/staging/wilc1000/wilc_spi.c @@ -666,11 +666,11 @@ static
> int spi_data_write(struct wilc *wilc, u8 *b, u32 sz) static int
> spi_internal_write(struct wilc *wilc, u32 adr, u32 dat) {
>  	struct spi_device *spi = to_spi_device(wilc->dev);
> +	__le32 le32dat = cpu_to_le32(dat);
>  	int result;
>  
> -	dat = cpu_to_le32(dat);
> -	result = spi_cmd_complete(wilc, CMD_INTERNAL_WRITE, adr, (u8
> *)&dat, 4,
> -				  0);
> +	result = spi_cmd_complete(wilc, CMD_INTERNAL_WRITE, adr, (u8
> *)&le32dat,
> +				  4, 0);
>  	if (result != N_OK)
>  		dev_err(&spi->dev, "Failed internal write cmd...\n");
>  
> @@ -689,7 +689,7 @@ static int spi_internal_read(struct wilc *wilc,
> u32 adr, u32 *data) return 0;
>  	}
>  
> -	*data = cpu_to_le32(*data);
> +	le32_to_cpus(data);
>  
>  	return 1;
>  }
> @@ -706,15 +706,16 @@ static int wilc_spi_write_reg(struct wilc
> *wilc, u32 addr, u32 data) int result = N_OK;
>  	u8 cmd = CMD_SINGLE_WRITE;
>  	u8 clockless = 0;
> +	__le32 le32data = cpu_to_le32(data);
>  
> -	data = cpu_to_le32(data);
>  	if (addr < 0x30) {
>  		/* Clockless register */
>  		cmd = CMD_INTERNAL_WRITE;
>  		clockless = 1;
>  	}
>  
> -	result = spi_cmd_complete(wilc, cmd, addr, (u8 *)&data, 4,
> clockless);
> +	result = spi_cmd_complete(wilc, cmd, addr, (u8 *)&le32data,
> 4,
> +				  clockless);
>  	if (result != N_OK)
>  		dev_err(&spi->dev, "Failed cmd, write reg
> (%08x)...\n", addr); 
> @@ -769,7 +770,7 @@ static int wilc_spi_read_reg(struct wilc *wilc,
> u32 addr, u32 *data) return 0;
>  	}
>  
> -	*data = cpu_to_le32(*data);
> +	le32_to_cpus(data);
>  
>  	return 1;
>  }
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c index
> e248702ee519..745bf5ca2622 100644 ---
> a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c +++
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c @@ -1431,7
> +1431,7 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32
> size) freq = ieee80211_channel_to_frequency(curr_channel,
> NL80211_BAND_2GHZ); 
> -	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
> +	if (!ieee80211_is_action(cpu_to_le16(buff[FRAME_TYPE_ID]))) {
>  		cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
>  		return;
>  	}
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> b/drivers/staging/wilc1000/wilc_wlan.c index
> 28c93f3f846e..a5ac1d26590b 100644 ---
> a/drivers/staging/wilc1000/wilc_wlan.c +++
> b/drivers/staging/wilc1000/wilc_wlan.c @@ -560,7 +560,8 @@ int
> wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count) int ret
> = 0; int counter;
>  	int timeout;
> -	u32 vmm_table[WILC_VMM_TBL_SIZE];
> +	__le32 vmm_table[WILC_VMM_TBL_SIZE];
> +	u32 table_entry;
>  	struct wilc_vif *vif;
>  	struct wilc *wilc;
>  	const struct wilc_hif_func *func;
> @@ -598,10 +599,10 @@ int wilc_wlan_handle_txq(struct net_device
> *dev, u32 *txq_count) if ((sum + vmm_sz) > LINUX_TX_SIZE)
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
> @@ -704,8 +705,7 @@ int wilc_wlan_handle_txq(struct net_device *dev,
> u32 *txq_count) if (vmm_table[i] == 0)
>  			break;
>  
> -		vmm_table[i] = cpu_to_le32(vmm_table[i]);
> -		vmm_sz = (vmm_table[i] & 0x3ff);
> +		vmm_sz = (le32_to_cpu(vmm_table[i]) & 0x3ff);
>  		vmm_sz *= 4;
>  		header = (tqe->type << 31) |
>  			 (tqe->buffer_size << 15) |
> @@ -715,8 +715,7 @@ int wilc_wlan_handle_txq(struct net_device *dev,
> u32 *txq_count) else
>  			header &= ~BIT(30);
>  
> -		header = cpu_to_le32(header);
> -		memcpy(&txb[offset], &header, 4);
> +		*((__le32 *)&txb[offset]) = cpu_to_le32(header);
>  		if (tqe->type == WILC_CFG_PKT) {
>  			buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
>  		} else if (tqe->type == WILC_NET_PKT) {
> @@ -770,8 +769,7 @@ static void wilc_wlan_handle_rx_buff(struct wilc
> *wilc, u8 *buffer, int size) 
>  	do {
>  		buff_ptr = buffer + offset;
> -		memcpy(&header, buff_ptr, 4);
> -		header = cpu_to_le32(header);
> +		header = le32_to_cpup((__le32 *)buff_ptr);
>  
>  		is_cfg_packet = (header >> 31) & 0x1;
>  		pkt_offset = (header >> 22) & 0x1ff;
> @@ -942,6 +940,7 @@ int wilc_wlan_firmware_download(struct wilc
> *wilc, const u8 *buffer, u32 offset;
>  	u32 addr, size, size2, blksz;
>  	u8 *dma_buffer;
> +	const __le32 *header;
>  	int ret = 0;
>  
>  	blksz = BIT(12);
> @@ -952,10 +951,9 @@ int wilc_wlan_firmware_download(struct wilc
> *wilc, const u8 *buffer, 
>  	offset = 0;
>  	do {
> -		memcpy(&addr, &buffer[offset], 4);
> -		memcpy(&size, &buffer[offset + 4], 4);
> -		addr = cpu_to_le32(addr);
> -		size = cpu_to_le32(size);
> +		header = (__le32 *)buffer + offset;

In addition to Dan's comments, I have one more observation.

The above line has a crash(Oops), while downloading the firmware to
WILC1000 module i.e "header = (__le32 *)buffer + offset;".

The crash can be fixes by putting extra bracket like 
header = (__le32 *)(buffer + offset);

But I suggest to avoid use of 'header' variable and only change the
below 2 lines.
		
   addr = cpu_to_le32(addr);
   size = cpu_to_le32(size);

to 

   le32_to_cpus(addr);
   le32_to_cpus(size);


> +		addr = le32_to_cpu(header[0]);
> +		size = le32_to_cpu(header[1]);
>  		acquire_bus(wilc, ACQUIRE_ONLY);
>  		offset += 8;
>  		while (((int)size) && (offset < buffer_size)) {
> diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c
> b/drivers/staging/wilc1000/wilc_wlan_cfg.c index
> c0b9b700f4d7..4a914d8572aa 100644 ---
> a/drivers/staging/wilc1000/wilc_wlan_cfg.c +++
> b/drivers/staging/wilc1000/wilc_wlan_cfg.c @@ -275,14 +275,14 @@
> static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8
> *b, u32 size) static void wilc_wlan_parse_response_frame(u8 *info,
> int size) {
> -	u32 wid, len = 0, i = 0;
> +	u32 wid;
> +	int len = 0, i = 0;
>  
>  	while (size > 0) {
>  		i = 0;
> -		wid = info[0] | (info[1] << 8);
> -		wid = cpu_to_le32(wid);
> +		wid = le16_to_cpup((__le16 *)info);
>  
> -		switch ((wid >> 12) & 0x7) {
> +		switch (info[1] >> 4) {
>  		case WID_CHAR:
>  			do {
>  				if (g_cfg_byte[i].id == WID_NIL)
> diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h
> b/drivers/staging/wilc1000/wilc_wlan_cfg.h index
> 08092a551840..9e029338bcab 100644 ---
> a/drivers/staging/wilc1000/wilc_wlan_cfg.h +++
> b/drivers/staging/wilc1000/wilc_wlan_cfg.h @@ -18,12 +18,12 @@ struct
> wilc_cfg_byte { 
>  struct wilc_cfg_hword {
>  	u16 id;
> -	u16 val;
> +	__le16 val;
>  };
>  
>  struct wilc_cfg_word {
>  	u32 id;
> -	u32 val;
> +	__le32 val;
>  };
>  
>  struct wilc_cfg_str {
