Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38640 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZJUSX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 14:23:27 -0400
Received: by pwj1 with SMTP id 1so1126504pwj.21
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2009 11:23:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910201513.10880.hs4233@mail.mn-solutions.de>
References: <200910201513.10880.hs4233@mail.mn-solutions.de>
Date: Wed, 21 Oct 2009 11:23:30 -0700
Message-ID: <45e8e6c40910211123t4501242ftbd3fe635344493b5@mail.gmail.com>
Subject: Re: l
From: Andrey Yurovsky <andrey@cozybit.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2009 at 6:13 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> [PATCH] libertas spi: fix sparse errors
>
> This fixes the following sparse warnings:
>
> $ make modules SUBDIRS=drivers/net/wireless/libertas C=1 CF=-D__CHECK_ENDIAN__
> make: Entering directory `/usr/src/linux-wl'
>  CHECK   drivers/net/wireless/libertas/if_spi.c
> drivers/net/wireless/libertas/if_spi.c:137:16: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/libertas/if_spi.c:137:16:    expected unsigned short [unsigned] [usertype] reg_out
> drivers/net/wireless/libertas/if_spi.c:137:16:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:191:16: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/libertas/if_spi.c:191:16:    expected unsigned short [unsigned] [usertype] reg_out
> drivers/net/wireless/libertas/if_spi.c:191:16:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:256:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:256:24:    expected restricted __le32 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:256:24:    got unsigned int *<noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
> drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
> drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
> drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>
> ---
>
> Andrey, can you test this?
>
> Dan, John: this is completely unrelated to my other libertas patches
>
> --- linux-wl.orig/drivers/net/wireless/libertas/if_spi.c
> +++ linux-wl/drivers/net/wireless/libertas/if_spi.c
> @@ -134,7 +134,7 @@
>  static int spu_write(struct if_spi_card *card, u16 reg, const u8 *buf, int len)
>  {
>        int err = 0;
> -       u16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);
> +       __le16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);
>        struct spi_message m;
>        struct spi_transfer reg_trans;
>        struct spi_transfer data_trans;
> @@ -166,7 +166,7 @@
>
>  static inline int spu_write_u16(struct if_spi_card *card, u16 reg, u16 val)
>  {
> -       u16 buff;
> +       __le16 buff;
>
>        buff = cpu_to_le16(val);
>        return spu_write(card, reg, (u8 *)&buff, sizeof(u16));
> @@ -188,7 +188,7 @@
>  {
>        unsigned int delay;
>        int err = 0;
> -       u16 reg_out = cpu_to_le16(reg | IF_SPI_READ_OPERATION_MASK);
> +       __le16 reg_out = cpu_to_le16(reg | IF_SPI_READ_OPERATION_MASK);
>        struct spi_message m;
>        struct spi_transfer reg_trans;
>        struct spi_transfer dummy_trans;
> @@ -235,7 +235,7 @@
>  /* Read 16 bits from an SPI register */
>  static inline int spu_read_u16(struct if_spi_card *card, u16 reg, u16 *val)
>  {
> -       u16 buf;
> +       __le16 buf;
>        int ret;
>
>        ret = spu_read(card, reg, (u8 *)&buf, sizeof(buf));
> @@ -248,7 +248,7 @@
>  * The low 16 bits are read first. */
>  static int spu_read_u32(struct if_spi_card *card, u16 reg, u32 *val)
>  {
> -       u32 buf;
> +       __le32 buf;
>        int err;
>
>        err = spu_read(card, reg, (u8 *)&buf, sizeof(buf));
>
> --
> http://www.holgerschurig.de
>

Tested-by: Andrey Yurovsky <andrey@cozybit.com>

On a Blackfin (LE) machine.  Also, please fix the subject line : )
