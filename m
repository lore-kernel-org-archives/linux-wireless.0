Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42083 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1EMOOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:14:23 -0400
Received: by qyg14 with SMTP id 14so1485187qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 07:14:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110513133345.GA10555@tuxdriver.com>
References: <20110512161914.e16be4d3.randy.dunlap@oracle.com>
	<1305293189-20605-1-git-send-email-linville@tuxdriver.com>
	<BANLkTi=+b_kTSGKNho4cF3A5KhHwpi1yJg@mail.gmail.com>
	<20110513133345.GA10555@tuxdriver.com>
Date: Fri, 13 May 2011 16:14:22 +0200
Message-ID: <BANLkTimEQe=G7+Wx1tgtGFD5t4R2KffVHA@mail.gmail.com> (sfid-20110513_161427_807228_0F8FD22A)
Subject: Re: [PATCH] ssb: fix pcicore build breakage
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 13 maja 2011 15:33 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Fri, May 13, 2011 at 03:33:03PM +0200, Rafał Miłecki wrote:
>> 2011/5/13 John W. Linville <linville@tuxdriver.com>:
>> > drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
>> > drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
>> > drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'
>> >
>> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> > ---
>> >  drivers/ssb/main.c |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
>> > index ee2937c..a53fc4d 100644
>> > --- a/drivers/ssb/main.c
>> > +++ b/drivers/ssb/main.c
>> > @@ -1332,6 +1332,7 @@ EXPORT_SYMBOL(ssb_bus_powerup);
>> >  static void ssb_broadcast_value(struct ssb_device *dev,
>> >                                u32 address, u32 data)
>> >  {
>> > +#ifdef CONFIG_SSB_DRIVER_PCICORE
>> >        /* This is used for both, PCI and ChipCommon core, so be careful. */
>> >        BUILD_BUG_ON(SSB_PCICORE_BCAST_ADDR != SSB_CHIPCO_BCAST_ADDR);
>> >        BUILD_BUG_ON(SSB_PCICORE_BCAST_DATA != SSB_CHIPCO_BCAST_DATA);
>> > @@ -1340,6 +1341,7 @@ static void ssb_broadcast_value(struct ssb_device *dev,
>> >        ssb_read32(dev, SSB_PCICORE_BCAST_ADDR); /* flush */
>> >        ssb_write32(dev, SSB_PCICORE_BCAST_DATA, data);
>> >        ssb_read32(dev, SSB_PCICORE_BCAST_DATA); /* flush */
>> > +#endif
>> >  }
>> >
>> >  void ssb_commit_settings(struct ssb_bus *bus)
>>
>> From *quick* review I think it's wrong. WIth this patch we don't do
>> commiting without PCI driver. This is still possible, we just need to
>> use ChipCommon for commiting.
>
> I'm happy for a better patch, but since the build is failing as-is...

Today late night will submit.

-- 
Rafał
