Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:33616 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162889AbeBPSPd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 13:15:33 -0500
Subject: Re: [PATCH 1/6] staging: wilc1000: modified code comments as per
 linux coding style
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
 <1518606615-14404-2-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <7fa649ac-89b2-2267-099f-9f3f67bda93b@microchip.com> (sfid-20180216_191542_000484_34D73FAE)
Date: Fri, 16 Feb 2018 20:15:30 +0200
MIME-Version: 1.0
In-Reply-To: <1518606615-14404-2-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ajay,

Even I cannot locate something in Documentation/CodingStyle related to single
line comment, I prefer to use:
/* comment */

instead of:
/*
 * comment
 */

Do as you wish!

Thank you,
Claudiu

On 14.02.2018 13:10, Ajay Singh wrote:
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index 8f71a60..5d0de4e 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -422,9 +422,9 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		return N_FAIL;
>  	}
>  
> -	/**
> +	/*
>  	 * Command/Control response
> -	 **/
> +	 */
>  	if (cmd == CMD_RESET ||
>  	    cmd == CMD_TERMINATE ||
>  	    cmd == CMD_REPEAT) {
> @@ -443,9 +443,9 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		return N_FAIL;
>  	}
>  
> -	/**
> +	/*
>  	 * State response
> -	 **/
> +	 */
>  	rsp = rb[rix++];
>  	if (rsp != 0x00) {
>  		dev_err(&spi->dev, "Failed cmd state response state (%02x)\n",
> @@ -458,12 +458,15 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		int retry;
>  		/* u16 crc1, crc2; */
>  		u8 crc[2];
> -		/**
> +		/*
>  		 * Data Respnose header
> -		 **/
> +		 */
>  		retry = 100;
>  		do {
> -			/* ensure there is room in buffer later to read data and crc */
> +			/*
> +			 * ensure there is room in buffer later
> +			 * to read data and crc
> +			 */
>  			if (rix < len2) {
>  				rsp = rb[rix++];
>  			} else {
> @@ -481,9 +484,9 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		}
>  
>  		if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ) {
> -			/**
> +			/*
>  			 * Read bytes
> -			 **/
> +			 */
>  			if ((rix + 3) < len2) {
>  				b[0] = rb[rix++];
>  				b[1] = rb[rix++];
> @@ -496,9 +499,9 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  			}
>  
>  			if (!g_spi.crc_off) {
> -				/**
> +				/*
>  				 * Read Crc
> -				 **/
> +				 */
>  				if ((rix + 1) < len2) {
>  					crc[0] = rb[rix++];
>  					crc[1] = rb[rix++];
> @@ -524,18 +527,18 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  				else
>  					nbytes = DATA_PKT_SZ - ix;
>  
> -				/**
> +				/*
>  				 * Read bytes
> -				 **/
> +				 */
>  				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
>  					dev_err(&spi->dev, "Failed data block read, bus error...\n");
>  					result = N_FAIL;
>  					goto _error_;
>  				}
>  
> -				/**
> +				/*
>  				 * Read Crc
> -				 **/
> +				 */
>  				if (!g_spi.crc_off) {
>  					if (wilc_spi_rx(wilc, crc, 2)) {
>  						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
> @@ -548,7 +551,10 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  				sz -= nbytes;
>  			}
>  
> -			/*  if any data in left unread, then read the rest using normal DMA code.*/
> +			/*
> +			 * if any data in left unread,
> +			 * then read the rest using normal DMA code.
> +			 */
>  			while (sz > 0) {
>  				int nbytes;
>  
> @@ -557,14 +563,14 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  				else
>  					nbytes = DATA_PKT_SZ;
>  
> -				/**
> +				/*
>  				 * read data response only on the next DMA cycles not
>  				 * the first DMA since data response header is already
>  				 * handled above for the first DMA.
> -				 **/
> -				/**
> +				 */
> +				/*
>  				 * Data Respnose header
> -				 **/
> +				 */
>  				retry = 10;
>  				do {
>  					if (wilc_spi_rx(wilc, &rsp, 1)) {
> @@ -579,18 +585,18 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  				if (result == N_FAIL)
>  					break;
>  
> -				/**
> +				/*
>  				 * Read bytes
> -				 **/
> +				 */
>  				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
>  					dev_err(&spi->dev, "Failed data block read, bus error...\n");
>  					result = N_FAIL;
>  					break;
>  				}
>  
> -				/**
> +				/*
>  				 * Read Crc
> -				 **/
> +				 */
>  				if (!g_spi.crc_off) {
>  					if (wilc_spi_rx(wilc, crc, 2)) {
>  						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
> @@ -616,9 +622,9 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
>  	u8 cmd, order, crc[2] = {0};
>  	/* u8 rsp; */
>  
> -	/**
> -	 *      Data
> -	 **/
> +	/*
> +	 * Data
> +	 */
>  	ix = 0;
>  	do {
>  		if (sz <= DATA_PKT_SZ)
> @@ -626,9 +632,9 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
>  		else
>  			nbytes = DATA_PKT_SZ;
>  
> -		/**
> -		 *      Write command
> -		 **/
> +		/*
> +		 * Write command
> +		 */
>  		cmd = 0xf0;
>  		if (ix == 0) {
>  			if (sz <= DATA_PKT_SZ)
> @@ -650,9 +656,9 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
>  			break;
>  		}
>  
> -		/**
> -		 *      Write data
> -		 **/
> +		/*
> +		 * Write data
> +		 */
>  		if (wilc_spi_tx(wilc, &b[ix], nbytes)) {
>  			dev_err(&spi->dev,
>  				"Failed data block write, bus error...\n");
> @@ -660,9 +666,9 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
>  			break;
>  		}
>  
> -		/**
> -		 *      Write Crc
> -		 **/
> +		/*
> +		 * Write Crc
> +		 */
>  		if (!g_spi.crc_off) {
>  			if (wilc_spi_tx(wilc, crc, 2)) {
>  				dev_err(&spi->dev, "Failed data block crc write, bus error...\n");
> @@ -671,9 +677,9 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
>  			}
>  		}
>  
> -		/**
> -		 *      No need to wait for response
> -		 **/
> +		/*
> +		 * No need to wait for response
> +		 */
>  		ix += nbytes;
>  		sz -= nbytes;
>  	} while (sz);
> @@ -733,7 +739,7 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
>  
>  	data = cpu_to_le32(data);
>  	if (addr < 0x30) {
> -		/* Clockless register*/
> +		/* Clockless register */
>  		cmd = CMD_INTERNAL_WRITE;
>  		clockless = 1;
>  	}
> @@ -751,9 +757,9 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
>  	int result;
>  	u8 cmd = CMD_DMA_EXT_WRITE;
>  
> -	/**
> -	 *      has to be greated than 4
> -	 **/
> +	/*
> +	 * has to be greated than 4
> +	 */
>  	if (size <= 4)
>  		return 0;
>  
> @@ -764,9 +770,9 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
>  		return 0;
>  	}
>  
> -	/**
> -	 *      Data
> -	 **/
> +	/*
> +	 * Data
> +	 */
>  	result = spi_data_write(wilc, buf, size);
>  	if (result != N_OK)
>  		dev_err(&spi->dev, "Failed block data write...\n");
> @@ -783,7 +789,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
>  
>  	if (addr < 0x30) {
>  		/* dev_err(&spi->dev, "***** read addr %d\n\n", addr); */
> -		/* Clockless register*/
> +		/* Clockless register */
>  		cmd = CMD_INTERNAL_READ;
>  		clockless = 1;
>  	}
> @@ -825,9 +831,9 @@ static int wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
>  
>  static int _wilc_spi_deinit(struct wilc *wilc)
>  {
> -	/**
> -	 *      TODO:
> -	 **/
> +	/*
> +	 * TODO:
> +	 */
>  	return 1;
>  }
>  
> @@ -849,15 +855,19 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
>  
>  	memset(&g_spi, 0, sizeof(struct wilc_spi));
>  
> -	/**
> -	 *      configure protocol
> -	 **/
> +	/*
> +	 * configure protocol
> +	 */
>  	g_spi.crc_off = 0;
>  
> -	/* TODO: We can remove the CRC trials if there is a definite way to reset */
> +	/*
> +	 * TODO: We can remove the CRC trials if there is a definite
> +	 * way to reset
> +	 */
>  	/* the SPI to it's initial value. */
>  	if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
> -		/* Read failed. Try with CRC off. This might happen when module
> +		/*
> +		 * Read failed. Try with CRC off. This might happen when module
>  		 * is removed but chip isn't reset
>  		 */
>  		g_spi.crc_off = 1;
> @@ -870,7 +880,7 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
>  		}
>  	}
>  	if (g_spi.crc_off == 0)	{
> -		reg &= ~0xc;    /* disable crc checking */
> +		reg &= ~0xc; /* disable crc checking */
>  		reg &= ~0x70;
>  		reg |= (0x5 << 4);
>  		if (!spi_internal_write(wilc, WILC_SPI_PROTOCOL_OFFSET, reg)) {
> @@ -880,9 +890,9 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
>  		g_spi.crc_off = 1;
>  	}
>  
> -	/**
> -	 *      make sure can read back chip id correctly
> -	 **/
> +	/*
> +	 * make sure can read back chip id correctly
> +	 */
>  	if (!wilc_spi_read_reg(wilc, 0x1000, &chipid)) {
>  		dev_err(&spi->dev, "Fail cmd read chip id...\n");
>  		return 0;
> @@ -994,7 +1004,10 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
>  
>  			ret = 1;
>  			for (i = 0; i < g_spi.nint; i++) {
> -				/* No matter what you write 1 or 0, it will clear interrupt. */
> +				/*
> +				 * No matter what you write 1 or 0,
> +				 * it will clear interrupt.
> +				 */
>  				if (flags & 1)
>  					ret = wilc_spi_write_reg(wilc, 0x10c8 + i * 4, 1);
>  				if (!ret)
> @@ -1036,9 +1049,9 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
>  			}
>  
>  			if ((val & EN_VMM) == EN_VMM) {
> -				/**
> -				 *      enable vmm transfer.
> -				 **/
> +				/*
> +				 * enable vmm transfer.
> +				 */
>  				ret = wilc_spi_write_reg(wilc,
>  							 WILC_VMM_CORE_CTL, 1);
>  				if (!ret) {
> @@ -1065,9 +1078,9 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
>  
>  	g_spi.nint = nint;
>  
> -	/**
> -	 *      interrupt pin mux select
> -	 **/
> +	/*
> +	 * interrupt pin mux select
> +	 */
>  	ret = wilc_spi_read_reg(wilc, WILC_PIN_MUX_0, &reg);
>  	if (!ret) {
>  		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
> @@ -1082,9 +1095,9 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
>  		return 0;
>  	}
>  
> -	/**
> -	 *      interrupt enable
> -	 **/
> +	/*
> +	 * interrupt enable
> +	 */
>  	ret = wilc_spi_read_reg(wilc, WILC_INTR_ENABLE, &reg);
>  	if (!ret) {
>  		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
> -- 2.7.4
