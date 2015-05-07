Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0140.outbound.protection.outlook.com ([157.55.234.140]:18086
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751107AbbEGOFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 10:05:13 -0400
From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jes Sorensen <Jes.Sorensen@redhat.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Babu, Viswanathan (V.)" <vbabu3@visteon.com>
Subject: Re: [PATCH] staging: rtl8723au : remove goto & return error directly
Date: Thu, 7 May 2015 13:49:07 +0000
Message-ID: <20150507134344.GA11599@IND12F0122> (sfid-20150507_160519_336415_3B9B0218)
References: <20150507111652.GA10574@IND12F0122>
 <wrfjk2wkoarp.fsf@ultrasam.lan.trained-monkey.org>
 <20150507121934.GH14154@mwanda>
In-Reply-To: <20150507121934.GH14154@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 07, 2015 at 03:19:34PM +0300, Dan Carpenter wrote:
> On Thu, May 07, 2015 at 08:03:06AM -0400, Jes Sorensen wrote:
> > "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com> writes:
> > > Remove the goto and return error directly thereby removing a variable
> > >
> > > Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> > > ---
> > >  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 7 ++-----
> > >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > NACK!
> 
> SHOUTING!
> 
> > 
> > The goto is cleaner and more consistent, rather than hiding a return in
> > the middle of the code.
> 
> More consistent with what?  There are already returns earlier in the
> function.  Do-nothing gotos are pointless and annoying.
> 
> regards,
> dan carpenter
> 

I sent this patch  because goto & return was mixed up in this function.
There was a return as well as goto used. And i guess goto is not 
encouraged anywhere. In this case especially,I couldn't see any 
significant cleanup being done in the goto label.