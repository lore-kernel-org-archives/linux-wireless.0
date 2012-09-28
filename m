Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:56779 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751235Ab2I1JIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 05:08:52 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 24597-05 for <linux-wireless@vger.kernel.org>;
 Fri, 28 Sep 2012 10:08:48 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Subject: RE: [PATCH] rtlwifi: use %*ph[C] to dump small buffers
Date: Fri, 28 Sep 2012 10:04:41 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B700D@saturn3.aculab.com> (sfid-20120928_110857_756066_02E13600)
In-Reply-To: <1348802023.3030.11.camel@joe-AO722>
References: <1348667852-5957-1-git-send-email-andriy.shevchenko@linux.intel.com> <1348677946.15175.8.camel@joe-AO722> <5064D318.6090705@lwfinger.net> <1348802023.3030.11.camel@joe-AO722>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Cc: "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
	"Chaoming Li" <chaoming_li@realsil.com.cn>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> > ===================================================================
> > --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> > +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> > @@ -1964,8 +1965,9 @@ static void rtl92ce_update_hal_rate_mask
> >
> >          RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
> >                   "ratr_bitmap :%x\n", ratr_bitmap);
> > -       *(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) |
> > -                                    (ratr_index << 28);
> > +       for (i = 0; i < 3; i++)
> > +               rate_mask[i] = ratr_bitmap & (0xff << (i * 4));
> 
> rate_mask is u8, doesn't this needs (calc) >> (i * 8)
> 
> > +       rate_mask[3] = (ratr_bitmap & 0x0f000000) | (ratr_index << 28);
> 
> Perhaps you meant:
> 
> 		((ratr_bitmap & 0x0f000000) >> 24) | (ratr_index << 4)

I'd just do:
	rate_mask[0] = ratr_bitmap;
	rate_mask[1] = ratr_bitmap >>= 8;
	rate_mask[2] = ratr_bitmap >>= 8;
	rate_mask[3] = (ratr_bitmap >> 8) & 0xf | ratr_index << 4;
which is, of course, little endian.
Which means it is different from the original code on big-endian systems.
So changing this here ought to require a change when the data is read.
So this either fixes, or adds, an endianness bug.

	David



