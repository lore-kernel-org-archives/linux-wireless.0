Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbaJHOdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 10:33:43 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
References: <20141008104014.GA23096@mwanda>
	<1412771171.3438.25.camel@joe-AO725> <20141008124631.GC26918@mwanda>
	<1412778150.3438.30.camel@joe-AO725>
Date: Wed, 08 Oct 2014 16:33:26 +0200
In-Reply-To: <1412778150.3438.30.camel@joe-AO725> (Joe Perches's message of
	"Wed, 08 Oct 2014 07:22:30 -0700")
Message-ID: <wrfjmw96y6kp.fsf@redhat.com> (sfid-20141008_163348_015624_B98D3BB2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Wed, 2014-10-08 at 15:46 +0300, Dan Carpenter wrote:
>> On Wed, Oct 08, 2014 at 05:26:11AM -0700, Joe Perches wrote:
>> > On Wed, 2014-10-08 at 13:40 +0300, Dan Carpenter wrote:
>> > > The return from myid() isn't aligned correctly for ether_addr_copy().
>> > 
>> > Hey Dan.
>> > 
>> > Actual evidence showing ether_addr_copy conversions
>> > may not always be wise.
>> > 
>> > How did you find them?
>> 
>> I was just trying to see how common these kinds of bugs are.  It didn't
>> take long to find, but my impression is that they are rare and I got
>> lucky.  These kinds of bugs are tricky to find and we don't have any
>> tools for it.
>
> As far as I know, that's true too.
>
> Jes, was the mac_addr field in this struct
> ever __aligned(2)?
>
> struct eeprom_priv {
>        u8              bautoload_fail_flag;
>        u8              bloadfile_fail_flag;
>        u8              bloadmac_fail_flag;
>        /* u8           bempty; */
>        /* u8           sys_config; */
>        u8              mac_addr[6];    /* PermanentAddress */
> ...
> }
>
> As far as I can tell from git history, it was
> that way at the first check-in.

I may have removed other entries that were unused, and that caused it to
become mis-aligned. I can't say for sure - the fix is straight forward
though.

Jes
