Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28311.mail.ukl.yahoo.com ([87.248.110.130]:21505 "HELO
	web28311.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753034AbZI1WaV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 18:30:21 -0400
Message-ID: <200395.81672.qm@web28311.mail.ukl.yahoo.com>
References: <200909231851.22110.mb@bu3sch.de>
Date: Mon, 28 Sep 2009 15:30:24 -0700 (PDT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] b43: Always use block-I/O for the PIO data registers
To: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200909231851.22110.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On SDIO the PIO data register seems to be hardwired to LE. So
> the MACCTL bit has no effect on the endianness.
> So also use block-I/O for the last word of the packet. block-I/O is always LE.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> 
> Index: wireless-testing/drivers/net/wireless/b43/pio.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/pio.c    2009-09-10 20:14:37.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/pio.c    2009-09-10 21:08:11.000000000 +0200
> @@ -340,10 +340,15 @@ static u16 tx_write_2byte_queue(struct b
>              q->mmio_base + B43_PIO_TXDATA,
>              sizeof(u16));
>      if (data_len & 1) {
> +        u8 tail[2] = { 0, };
> +
>          /* Write the last byte. */
>          ctl &= ~B43_PIO_TXCTL_WRITEHI;
>          b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
> -        b43_piotx_write16(q, B43_PIO_TXDATA, data[data_len - 1]);
> +        tail[0] = data[data_len - 1];
> +        ssb_block_write(dev->dev, tail, 2,
> +                q->mmio_base + B43_PIO_TXDATA,
> +                sizeof(u16));
>      }
>  
>      return ctl;
> @@ -386,26 +391,31 @@ static u32 tx_write_4byte_queue(struct b
>              q->mmio_base + B43_PIO8_TXDATA,
>              sizeof(u32));
>      if (data_len & 3) {
> -        u32 value = 0;
> +        u8 tail[4] = { 0, };
>  
>          /* Write the last few bytes. */
>          ctl &= ~(B43_PIO8_TXCTL_8_15 | B43_PIO8_TXCTL_16_23 |
>               B43_PIO8_TXCTL_24_31);
> -        data = &(data[data_len - 1]);
>          switch (data_len & 3) {
>          case 3:
> -            ctl |= B43_PIO8_TXCTL_16_23;
> -            value |= (u32)(*data) << 16;
> -            data--;
> +            ctl |= B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_8_15;
> +            tail[0] = data[data_len - 3];
> +            tail[1] = data[data_len - 2];
> +            tail[2] = data[data_len - 1];
> +            break;
>          case 2:
>              ctl |= B43_PIO8_TXCTL_8_15;
> -            value |= (u32)(*data) << 8;
> -            data--;
> +            tail[0] = data[data_len - 2];
> +            tail[1] = data[data_len - 1];
> +            break;
>          case 1:
> -            value |= (u32)(*data);
> +            tail[0] = data[data_len - 1];
> +            break;
>          }
>          b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
> -        b43_piotx_write32(q, B43_PIO8_TXDATA, value);
> +        ssb_block_write(dev->dev, tail, 4,
> +                q->mmio_base + B43_PIO8_TXDATA,
> +                sizeof(u32));
>      }
>  
>      return ctl;
> @@ -693,21 +703,25 @@ data_ready:
>                     q->mmio_base + B43_PIO8_RXDATA,
>                     sizeof(u32));
>          if (len & 3) {
> -            u32 value;
> -            char *data;
> +            u8 tail[4] = { 0, };
>  
>              /* Read the last few bytes. */
> -            value = b43_piorx_read32(q, B43_PIO8_RXDATA);
> -            data = &(skb->data[len + padding - 1]);
> +            ssb_block_read(dev->dev, tail, 4,
> +                       q->mmio_base + B43_PIO8_RXDATA,
> +                       sizeof(u32));
>              switch (len & 3) {
>              case 3:
> -                *data = (value >> 16);
> -                data--;
> +                skb->data[len + padding - 3] = tail[0];
> +                skb->data[len + padding - 2] = tail[1];
> +                skb->data[len + padding - 1] = tail[2];
> +                break;
>              case 2:
> -                *data = (value >> 8);
> -                data--;
> +                skb->data[len + padding - 2] = tail[0];
> +                skb->data[len + padding - 1] = tail[1];
> +                break;
>              case 1:
> -                *data = value;
> +                skb->data[len + padding - 1] = tail[0];
> +                break;
>              }
>          }
>      } else {
> @@ -715,11 +729,13 @@ data_ready:
>                     q->mmio_base + B43_PIO_RXDATA,
>                     sizeof(u16));
>          if (len & 1) {
> -            u16 value;
> +            u8 tail[2] = { 0, };
>  
>              /* Read the last byte. */
> -            value = b43_piorx_read16(q, B43_PIO_RXDATA);
> -            skb->data[len + padding - 1] = value;
> +            ssb_block_read(dev->dev, tail, 2,
> +                       q->mmio_base + B43_PIO_RXDATA,
> +                       sizeof(u16));
> +            skb->data[len + padding - 1] = tail[0];
>          }
>      }
>  
> 

Without this patch, the last bytes of data sent/received to/from PIO FIFOs on SDIO-based cards get "swizzled" when its length is not multiple of 4 bytes.

Tested-by: Albert Herranz <albert_herranz@yahoo.es>


      
