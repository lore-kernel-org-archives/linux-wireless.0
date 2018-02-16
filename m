Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:44761 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032592AbeBPSPq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 13:15:46 -0500
Subject: Re: [PATCH 3/6] staging: wilc1000: fix line over 80 characters in
 spi_cmd_complete()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
 <1518606615-14404-4-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <1e3a5f46-be73-ec8e-6670-179e6ab45d0b@microchip.com> (sfid-20180216_191552_771412_06F66564)
Date: Fri, 16 Feb 2018 20:15:42 +0200
MIME-Version: 1.0
In-Reply-To: <1518606615-14404-4-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.02.2018 13:10, Ajay Singh wrote:
> Refactor spi_cmd_complete() to fix the line over 80 char issues reported
> by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c | 250 ++++++++++++++++++------------------
>  1 file changed, 124 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index 66b6aea..30a9a61 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -287,17 +287,19 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  	u8 rsp;
>  	int len = 0;
>  	int result = N_OK;
> +	int retry;
> +	u8 crc[2];
>  
>  	wb[0] = cmd;
>  	switch (cmd) {
> -	case CMD_SINGLE_READ:                           /* single word (4 bytes) read */
> +	case CMD_SINGLE_READ: /* single word (4 bytes) read */
Ok with this but I think would be nicer to have them documented the place were
they are defined.
>  		wb[1] = (u8)(adr >> 16);
>  		wb[2] = (u8)(adr >> 8);
>  		wb[3] = (u8)adr;
>  		len = 5;
>  		break;
>  
> -	case CMD_INTERNAL_READ:                 /* internal register read */
> +	case CMD_INTERNAL_READ: /* internal register read */
Ditto
>  		wb[1] = (u8)(adr >> 8);
>  		if (clockless == 1)
>  			wb[1] |= BIT(7);
> @@ -306,29 +308,29 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		len = 5;
>  		break;
>  
> -	case CMD_TERMINATE:                                     /* termination */
> +	case CMD_TERMINATE:
Ditto
>  		wb[1] = 0x00;
>  		wb[2] = 0x00;
>  		wb[3] = 0x00;
>  		len = 5;
>  		break;
>  
> -	case CMD_REPEAT:                                                /* repeat */
> +	case CMD_REPEAT:
Ditto
>  		wb[1] = 0x00;
>  		wb[2] = 0x00;
>  		wb[3] = 0x00;
>  		len = 5;
>  		break;
>  
> -	case CMD_RESET:                                                 /* reset */
> +	case CMD_RESET:
Ditto
>  		wb[1] = 0xff;
>  		wb[2] = 0xff;
>  		wb[3] = 0xff;
>  		len = 5;
>  		break;
>  
> -	case CMD_DMA_WRITE:                                     /* dma write */
> -	case CMD_DMA_READ:                                      /* dma read */
> +	case CMD_DMA_WRITE: /* dma write */
> +	case CMD_DMA_READ:  /* dma read */
Ditto
>  		wb[1] = (u8)(adr >> 16);
>  		wb[2] = (u8)(adr >> 8);
>  		wb[3] = (u8)adr;
> @@ -337,8 +339,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		len = 7;
>  		break;
>  
> -	case CMD_DMA_EXT_WRITE:         /* dma extended write */
> -	case CMD_DMA_EXT_READ:                  /* dma extended read */
> +	case CMD_DMA_EXT_WRITE: /* dma extended write */
> +	case CMD_DMA_EXT_READ:  /* dma extended read */
Ditto
>  		wb[1] = (u8)(adr >> 16);
>  		wb[2] = (u8)(adr >> 8);
>  		wb[3] = (u8)adr;
> @@ -348,7 +350,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		len = 8;
>  		break;
>  
> -	case CMD_INTERNAL_WRITE:                /* internal register write */
> +	case CMD_INTERNAL_WRITE: /* internal register write */
Ditto
>  		wb[1] = (u8)(adr >> 8);
>  		if (clockless == 1)
>  			wb[1] |= BIT(7);
> @@ -360,7 +362,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  		len = 8;
>  		break;
>  
> -	case CMD_SINGLE_WRITE:                  /* single word write */
> +	case CMD_SINGLE_WRITE: /* single word write */
Ditto
>  		wb[1] = (u8)(adr >> 16);
>  		wb[2] = (u8)(adr >> 8);
>  		wb[3] = (u8)(adr);
> @@ -395,13 +397,12 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  	    cmd == CMD_REPEAT) {
>  		len2 = len + (NUM_SKIP_BYTES + NUM_RSP_BYTES + NUM_DUMMY_BYTES);
>  	} else if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ) {
> -		if (!g_spi.crc_off) {
> -			len2 = len + (NUM_RSP_BYTES + NUM_DATA_HDR_BYTES + NUM_DATA_BYTES
> -				      + NUM_CRC_BYTES + NUM_DUMMY_BYTES);
> -		} else {
> -			len2 = len + (NUM_RSP_BYTES + NUM_DATA_HDR_BYTES + NUM_DATA_BYTES
> -				      + NUM_DUMMY_BYTES);
> -		}
> +		int tmp = NUM_RSP_BYTES + NUM_DATA_HDR_BYTES + NUM_DATA_BYTES
> +			+ NUM_DUMMY_BYTES;
> +		if (!g_spi.crc_off)
> +			len2 = len + tmp + NUM_CRC_BYTES;
> +		else
> +			len2 = len + tmp;
>  	} else {
>  		len2 = len + (NUM_RSP_BYTES + NUM_DUMMY_BYTES);
>  	}
> @@ -425,11 +426,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  	/*
>  	 * Command/Control response
>  	 */
> -	if (cmd == CMD_RESET ||
> -	    cmd == CMD_TERMINATE ||
> -	    cmd == CMD_REPEAT) {
> -		rix++;         /* skip 1 byte */
> -	}
> +	if (cmd == CMD_RESET || cmd == CMD_TERMINATE || cmd == CMD_REPEAT)
> +		rix++; /* skip 1 byte */
>  
>  	rsp = rb[rix++];
>  
> @@ -452,8 +450,6 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  
>  	if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ ||
>  	    cmd == CMD_DMA_READ || cmd == CMD_DMA_EXT_READ) {
> -		int retry;
> -		u8 crc[2];
>  		/*
>  		 * Data Respnose header
>  		 */
> @@ -478,132 +474,134 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
>  				"Error, data read response (%02x)\n", rsp);
>  			return N_RESET;
>  		}
> +	}
> +
> +	if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ) {
> +		/*
> +		 * Read bytes
> +		 */
> +		if ((rix + 3) < len2) {
> +			b[0] = rb[rix++];
> +			b[1] = rb[rix++];
> +			b[2] = rb[rix++];
> +			b[3] = rb[rix++];
> +		} else {
> +			dev_err(&spi->dev,
> +				"buffer overrun when reading data.\n");
> +			return N_FAIL;
> +		}
>  
> -		if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ) {
> +		if (!g_spi.crc_off) {
>  			/*
> -			 * Read bytes
> +			 * Read Crc
>  			 */
> -			if ((rix + 3) < len2) {
> -				b[0] = rb[rix++];
> -				b[1] = rb[rix++];
> -				b[2] = rb[rix++];
> -				b[3] = rb[rix++];
> +			if ((rix + 1) < len2) {
> +				crc[0] = rb[rix++];
> +				crc[1] = rb[rix++];
>  			} else {
>  				dev_err(&spi->dev,
> -					"buffer overrun when reading data.\n");
> +					"buffer overrun when reading crc.\n");
Since you refactor, you may try to have a consistent way of returning in case of
errors. I'm thinking that this kind of block:
{
	dev_err(&spi->dev, "msg");
	return N_FAIL;
}

could be replaced with:
- at the beginning of function:
const char *errmsg = NULL;

- and in case of error you could add this block:
{
	errmsg = "you error string";
	result = N_FAIL;
	goto _error_;
}

and for _error_ label:
_error_:
	if (errmsg)
		dev_err(&spi->dev, errmsg);
	return result;

And use this pattern wherever an error needs to be thrown, in a consistent way.
This could remain as is in this patch, for the moment, but further re-factors
might be needed for this function to look better, maybe should be added to backlog.

I want to say that might be nice to have a consistent way of returning with
errors, some paths in this function just uses "return error;" other paths are using:
result = error;
goto _error_;
and the result is the same.

>  				return N_FAIL;
>  			}
> +		}
> +	} else if ((cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
> +		int ix;
>  
> -			if (!g_spi.crc_off) {
> -				/*
> -				 * Read Crc
> -				 */
> -				if ((rix + 1) < len2) {
> -					crc[0] = rb[rix++];
> -					crc[1] = rb[rix++];
> -				} else {
> -					dev_err(&spi->dev, "buffer overrun when reading crc.\n");
> -					return N_FAIL;
> -				}
> -			}
> -		} else if ((cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
> -			int ix;
> -
> -			/* some data may be read in response to dummy bytes. */
> -			for (ix = 0; (rix < len2) && (ix < sz); )
> -				b[ix++] = rb[rix++];
> -
> -			sz -= ix;
> -
> -			if (sz > 0) {
> -				int nbytes;
> +		/* some data may be read in response to dummy bytes. */
> +		for (ix = 0; (rix < len2) && (ix < sz); )
> +			b[ix++] = rb[rix++];
>  
> -				if (sz <= (DATA_PKT_SZ - ix))
> -					nbytes = sz;
> -				else
> -					nbytes = DATA_PKT_SZ - ix;
> +		sz -= ix;
>  
> -				/*
> -				 * Read bytes
> -				 */
> -				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
> -					dev_err(&spi->dev, "Failed data block read, bus error...\n");
> -					result = N_FAIL;
> -					goto _error_;
> -				}
> +		if (sz > 0) {
> +			int nbytes;
>  
> -				/*
> -				 * Read Crc
> -				 */
> -				if (!g_spi.crc_off) {
> -					if (wilc_spi_rx(wilc, crc, 2)) {
> -						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
> -						result = N_FAIL;
> -						goto _error_;
> -					}
> -				}
> +			if (sz <= (DATA_PKT_SZ - ix))
> +				nbytes = sz;
> +			else
> +				nbytes = DATA_PKT_SZ - ix;
>  
> -				ix += nbytes;
> -				sz -= nbytes;
> +			/*
> +			 * Read bytes
> +			 */
> +			if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
> +				dev_err(&spi->dev,
> +					"Failed block read, bus err\n");
> +				result = N_FAIL;
> +				goto _error_;
>  			}
>  
>  			/*
> -			 * if any data in left unread,
> -			 * then read the rest using normal DMA code.
> +			 * Read Crc
>  			 */
> -			while (sz > 0) {
> -				int nbytes;
> +			if (!g_spi.crc_off && wilc_spi_rx(wilc, crc, 2)) {
> +				dev_err(&spi->dev,
> +					"Failed block crc read, bus err\n");
> +				result = N_FAIL;
> +				goto _error_;
> +			}
>  
> -				if (sz <= DATA_PKT_SZ)
> -					nbytes = sz;
> -				else
> -					nbytes = DATA_PKT_SZ;
> +			ix += nbytes;
> +			sz -= nbytes;
> +		}
>  
> -				/*
> -				 * read data response only on the next DMA cycles not
> -				 * the first DMA since data response header is already
> -				 * handled above for the first DMA.
> -				 */
> -				/*
> -				 * Data Respnose header
> -				 */
> -				retry = 10;
> -				do {
> -					if (wilc_spi_rx(wilc, &rsp, 1)) {
> -						dev_err(&spi->dev, "Failed data response read, bus error...\n");
> -						result = N_FAIL;
> -						break;
> -					}
> -					if (((rsp >> 4) & 0xf) == 0xf)
> -						break;
> -				} while (retry--);
> -
> -				if (result == N_FAIL)
> -					break;
> +		/*
> +		 * if any data in left unread,
> +		 * then read the rest using normal DMA code.
> +		 */
> +		while (sz > 0) {
> +			int nbytes;
>  
> -				/*
> -				 * Read bytes
> -				 */
> -				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
> -					dev_err(&spi->dev, "Failed data block read, bus error...\n");
> +			if (sz <= DATA_PKT_SZ)
> +				nbytes = sz;
> +			else
> +				nbytes = DATA_PKT_SZ;
> +
> +			/*
> +			 * read data response only on the next DMA cycles not
> +			 * the first DMA since data response header is already
> +			 * handled above for the first DMA.
> +			 */
> +			/*
> +			 * Data Respnose header
> +			 */
> +			retry = 10;
> +			do {
> +				if (wilc_spi_rx(wilc, &rsp, 1)) {
> +					dev_err(&spi->dev,
> +						"Failed resp read, bus err\n");
>  					result = N_FAIL;
>  					break;
Here, also, the proposed solution could be used. Or just return as in the other
cases or just goto _error_ instead of break and then check for result == N_FAIL.
>  				}
> +				if (((rsp >> 4) & 0xf) == 0xf)
> +					break;
> +			} while (retry--);
>  
> -				/*
> -				 * Read Crc
> -				 */
> -				if (!g_spi.crc_off) {
> -					if (wilc_spi_rx(wilc, crc, 2)) {
> -						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
> -						result = N_FAIL;
> -						break;
> -					}
> -				}
> +			if (result == N_FAIL)
> +				break;
>  
> -				ix += nbytes;
> -				sz -= nbytes;
> +			/*
> +			 * Read bytes
> +			 */
> +			if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
> +				dev_err(&spi->dev,
> +					"Failed block read, bus err\n");
> +				result = N_FAIL;
> +				break;
>  			}
> +
> +			/*
> +			 * Read Crc
> +			 */
> +			if (!g_spi.crc_off && wilc_spi_rx(wilc, crc, 2)) {
> +				dev_err(&spi->dev,
> +					"Failed block crc read, bus err\n");
> +				result = N_FAIL;
> +				break;
> +			}
> +
> +			ix += nbytes;
> +			sz -= nbytes;
>  		}
>  	}
>  _error_:
> 
