Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43138 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754517AbeGIVAO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 17:00:14 -0400
Date: Mon, 9 Jul 2018 23:00:11 +0200
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Subject: Re: [PATCH v2 11/24] mtd: rawnand: sunxi: Make sure ret is
 initialized in sunxi_nfc_read_byte()
Message-ID: <20180709230011.1ca3f9ce@bbrezillon> (sfid-20180709_230017_622291_1D30E2C9)
In-Reply-To: <CAK8P3a1Ndys3MMxLqL-hTFVDSZGm5ASEnQ7K+8dScvFrp=RTdA@mail.gmail.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
        <20180709200945.30116-12-boris.brezillon@bootlin.com>
        <CAK8P3a1Ndys3MMxLqL-hTFVDSZGm5ASEnQ7K+8dScvFrp=RTdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 9 Jul 2018 22:35:56 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Mon, Jul 9, 2018 at 10:09 PM, Boris Brezillon
> <boris.brezillon@bootlin.com> wrote:
> > Fixes the following smatch warning:
> >
> > drivers/mtd/nand/raw/sunxi_nand.c:551 sunxi_nfc_read_byte() error: uninitialized symbol 'ret'.
> >
> > Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
> > ---
> >  drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
> > index 99043c3a4fa7..4b11cd4a79be 100644
> > --- a/drivers/mtd/nand/raw/sunxi_nand.c
> > +++ b/drivers/mtd/nand/raw/sunxi_nand.c
> > @@ -544,7 +544,7 @@ static void sunxi_nfc_write_buf(struct mtd_info *mtd, const uint8_t *buf,
> >
> >  static uint8_t sunxi_nfc_read_byte(struct mtd_info *mtd)
> >  {
> > -       uint8_t ret;
> > +       uint8_t ret = 0;
> >
> >         sunxi_nfc_read_buf(mtd, &ret, 1);
> >  
> 
> Should there perhaps be a warning when no data was returned after a timeout?

We're planning to move this driver to ->exec_op() soon, and with
->exec_op() errors are properly propagated to the core. I guess we can
live with this lack of dev_warn() for a bit longer :-).
