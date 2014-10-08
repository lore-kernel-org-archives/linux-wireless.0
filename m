Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:37864 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753787AbaJHOWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 10:22:35 -0400
Message-ID: <1412778150.3438.30.camel@joe-AO725> (sfid-20141008_162240_672826_241E8E8E)
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Date: Wed, 08 Oct 2014 07:22:30 -0700
In-Reply-To: <20141008124631.GC26918@mwanda>
References: <20141008104014.GA23096@mwanda>
	 <1412771171.3438.25.camel@joe-AO725> <20141008124631.GC26918@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-08 at 15:46 +0300, Dan Carpenter wrote:
> On Wed, Oct 08, 2014 at 05:26:11AM -0700, Joe Perches wrote:
> > On Wed, 2014-10-08 at 13:40 +0300, Dan Carpenter wrote:
> > > The return from myid() isn't aligned correctly for ether_addr_copy().
> > 
> > Hey Dan.
> > 
> > Actual evidence showing ether_addr_copy conversions
> > may not always be wise.
> > 
> > How did you find them?
> 
> I was just trying to see how common these kinds of bugs are.  It didn't
> take long to find, but my impression is that they are rare and I got
> lucky.  These kinds of bugs are tricky to find and we don't have any
> tools for it.

As far as I know, that's true too.

Jes, was the mac_addr field in this struct
ever __aligned(2)?

struct eeprom_priv {
       u8              bautoload_fail_flag;
       u8              bloadfile_fail_flag;
       u8              bloadmac_fail_flag;
       /* u8           bempty; */
       /* u8           sys_config; */
       u8              mac_addr[6];    /* PermanentAddress */
...
}

As far as I can tell from git history, it was
that way at the first check-in.

Dan, did you also look for any other alignment
defects in uses of any is_<foo>_ether_addr calls?


