Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32905 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932967AbeGIUf7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:35:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id t21-v6so15070579lji.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2018 13:35:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180709200945.30116-12-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com> <20180709200945.30116-12-boris.brezillon@bootlin.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 9 Jul 2018 22:35:56 +0200
Message-ID: <CAK8P3a1Ndys3MMxLqL-hTFVDSZGm5ASEnQ7K+8dScvFrp=RTdA@mail.gmail.com> (sfid-20180709_223603_766377_F98D9637)
Subject: Re: [PATCH v2 11/24] mtd: rawnand: sunxi: Make sure ret is
 initialized in sunxi_nfc_read_byte()
To: Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2018 at 10:09 PM, Boris Brezillon
<boris.brezillon@bootlin.com> wrote:
> Fixes the following smatch warning:
>
> drivers/mtd/nand/raw/sunxi_nand.c:551 sunxi_nfc_read_byte() error: uninitialized symbol 'ret'.
>
> Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
> ---
>  drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
> index 99043c3a4fa7..4b11cd4a79be 100644
> --- a/drivers/mtd/nand/raw/sunxi_nand.c
> +++ b/drivers/mtd/nand/raw/sunxi_nand.c
> @@ -544,7 +544,7 @@ static void sunxi_nfc_write_buf(struct mtd_info *mtd, const uint8_t *buf,
>
>  static uint8_t sunxi_nfc_read_byte(struct mtd_info *mtd)
>  {
> -       uint8_t ret;
> +       uint8_t ret = 0;
>
>         sunxi_nfc_read_buf(mtd, &ret, 1);
>

Should there perhaps be a warning when no data was returned after a timeout?

      Arnd
