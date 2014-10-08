Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaJHOcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 10:32:48 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
References: <20141008104014.GA23096@mwanda> <wrfj4mvezmpm.fsf@redhat.com>
	<20141008142451.GE26918@mwanda>
Date: Wed, 08 Oct 2014 16:32:37 +0200
In-Reply-To: <20141008142451.GE26918@mwanda> (Dan Carpenter's message of "Wed,
	8 Oct 2014 17:24:51 +0300")
Message-ID: <wrfjr3yiy6m2.fsf@redhat.com> (sfid-20141008_163253_277511_AB20F290)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:
> On Wed, Oct 08, 2014 at 03:59:33PM +0200, Jes Sorensen wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>> > The return from myid() isn't aligned correctly for ether_addr_copy().
>> >
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> 
>> Sorry, this makes no sense, just fix it properly!
>> 
>> drivers/staging/rtl8723au/include/rtw_eeprom.h:
>> 
>> struct eeprom_priv {
>>         u8              bautoload_fail_flag;
>>         u8              bloadfile_fail_flag;
>>         u8              bloadmac_fail_flag;
>>         /* u8           bempty; */
>>         /* u8           sys_config; */
>>         u8              mac_addr[6];    /* PermanentAddress */
>>         /* u8           config0; */
>> 
>> Move mac_addr[6] to the top of the struct and be done with it.
>> 
>> NACK
>
> Oops.  I thought it was something from the hardware.  Actually can you
> fix it and give me a reported-by tag?

That stuff is just copied into memory from the eeprom, so we can pretty
much do with it as we like.

I'll put it on my list.

Jes
