Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33208 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbbFBJB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 05:01:58 -0400
Date: Tue, 2 Jun 2015 14:31:47 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: fix warning while printing
Message-ID: <20150602090127.GA5576@sudip-PC> (sfid-20150602_110224_937848_7F17C037)
References: <1433231814-4204-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20150602082917.GB5903@patagonia>
 <20150602083532.GA5331@sudip-PC>
 <20150602085840.GC5903@patagonia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150602085840.GC5903@patagonia>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2015 at 10:58:40AM +0200, Konrad Zapalowicz wrote:
> On 06/02, Sudip Mukherjee wrote:
> > On Tue, Jun 02, 2015 at 10:29:17AM +0200, Konrad Zapalowicz wrote:
> > > On 06/02, Sudip Mukherjee wrote:
> > > > size_t should print using %zu, but here it was using %d and hence we
> > > > were getting warning while printing.
> > > > 
> > > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > > ---
> > > > 
> > > > I think it will be easy to remove the other warnings if all the typedefs
> > > > are removed first.
> > > > 
> > > >  drivers/staging/wilc1000/wilc_spi.c               | 2 +-
> > > >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
> > > >  2 files changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> > > > index d0e7610..6d854fd 100644
> > > > --- a/drivers/staging/wilc1000/wilc_spi.c
> > > > +++ b/drivers/staging/wilc1000/wilc_spi.c
> > > > @@ -404,7 +404,7 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
> > > >  #undef NUM_DUMMY_BYTES
> > > >  
> > > >  	if (len2 > (sizeof(wb) / sizeof(wb[0]))) {
> > > > -		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%d)\n",
> > > > +		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%lu)\n",
> > > 
> > > Hi, it seems that the above line should use %zu too. Am I correct or I'm
> > > missing something?
> > oops. my mistake. %lu is correct but i missed mentioning the warning
> > about long unsigned int in the commit message.
> 
> Why %lu here and %zu in other places? I mean that it is the same size_t
> or I'm missing something?
no, this is unsigned long int.
The warning here was:
drivers/staging/wilc1000/wilc_spi.c:407:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘long unsigned int’ [-Wformat]

so size_t used %zu and unsigned long int should use %lu

regards
sudip
> 
>  - konrad
> 
> > regards
> > sudip
