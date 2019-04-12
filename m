Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0111C282CE
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 23:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85EB220869
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 23:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="BmHf4XQm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfDLXbg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 19:31:36 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:53078 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfDLXbf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 19:31:35 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 3463D2F28FBF;
        Fri, 12 Apr 2019 19:31:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555111893;
        bh=rimSzx0ZYGZZ5jb4ghIWV17gFb2jTDUA34yHd5IGqSw=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=BmHf4XQmvnirJmVQ0BTAgVUqos7dTFY+a+X0qYuhnCF6TK7GyHA0rFJPhAY7uu2a3
         x+D5T0I2ra7etPwsRTl2wiCEOF7eOu4FBqo35lQySjhOIuwrcJ0qPf1kDkPxyjK38K
         7A5B8NdUOvq1LPjDbNxRSxoEjypurheCaOV8T8Tx+ZYcv6pYZNojmiN/HQ4MH8O5xq
         7ro/4yPZGSkS+1M57Ebbs/QvVKeRgp2F8Ztg8Eu2HFvOYIAacxeJ8wTajfclD71z2W
         +GXQfSGuQv7j4GBAG9/7yEZvhrFIvAWyYc1lYHwgJ93VPzp2e8B0aqMP/zgWA8SYD4
         9ayqarDJFUMpz4HvfYhY+dCncyJKmXsIMPmaDTR6ah89MtOlAJ8+eGO8kUQeXtxlXF
         hFK+3AnQRca77X0oS6wLM3pB719GFPjweWEdjnbAoWlq0vAWoZIQI+ugxbuLJtoYRt
         kxGIGqLIPgBaQhMRu9lVy8zBH8t034fiZURri3a+LkDTzAJJEezF7XFpxXryFE2//P
         Jlw0ruVT+OCUm+7EPPtd/4CITmRWlf/PQNtwebTwXpvKJ+Ofw9TKggeON3mUdBHCS+
         wUVLn+3Rs0Vz+6CW5zYqoWknEw1uu2PTtPQUXA9HfSyT8jOyvHHt2kIfE2PSi7/O9k
         QbALBi51LUi9HtlX1EmFRaOw=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3CNVRg7018852
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 13 Apr 2019 09:31:27 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'Petr Mladek'" <pmladek@suse.com>,
        "'Alastair D'Silva'" <alastair@au1.ibm.com>
Cc:     "'Jani Nikula'" <jani.nikula@linux.intel.com>,
        "'Joonas Lahtinen'" <joonas.lahtinen@linux.intel.com>,
        "'Rodrigo Vivi'" <rodrigo.vivi@intel.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Daniel Vetter'" <daniel@ffwll.ch>,
        "'Karsten Keil'" <isdn@linux-pingi.de>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        "'Tom Lendacky'" <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jose Abreu'" <Jose.Abreu@synopsys.com>,
        "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'Stanislaw Gruszka'" <sgruszka@redhat.com>,
        "'Benson Leung'" <bleung@chromium.org>,
        "'Enric Balletbo i Serra'" <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-4-alastair@au1.ibm.com> <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
In-Reply-To: <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date:   Sat, 13 Apr 2019 09:31:27 +1000
Message-ID: <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1ALvlgN3AdorRAijh70pcA==
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Sat, 13 Apr 2019 09:31:28 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Saturday, 13 April 2019 12:12 AM
> To: Alastair D'Silva <alastair@au1.ibm.com>
> Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
Joonas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel Vetter
> <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi Brar
> <jassisinghbrar@gmail.com>; Tom Lendacky <thomas.lendacky@amd.com>;
> David S. Miller <davem@davemloft.net>; Jose Abreu
> <Jose.Abreu@synopsys.com>; Kalle Valo <kvalo@codeaurora.org>;
> Stanislaw Gruszka <sgruszka@redhat.com>; Benson Leung
> <bleung@chromium.org>; Enric Balletbo i Serra
> <enric.balletbo@collabora.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com>; Steven Rostedt <rostedt@goodmis.org>;
> Andrew Morton <akpm@linux-foundation.org>; intel-
> gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
> hex_dump_to_buffer with flags
> 
> On Wed 2019-04-10 13:17:19, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> >
> > In order to support additional features in hex_dump_to_buffer, replace
> > the ascii bool parameter with flags.
> >
> > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > ---
> >  drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
> >  drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
> >  drivers/mailbox/mailbox-test.c                    |  2 +-
> >  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
> >  drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
> >  drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
> >  drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
> >  drivers/platform/chrome/wilco_ec/debugfs.c        |  3 ++-
> >  drivers/scsi/scsi_logging.c                       |  8 +++-----
> >  drivers/staging/fbtft/fbtft-core.c                |  2 +-
> >  fs/seq_file.c                                     |  3 ++-
> >  include/linux/printk.h                            |  2 +-
> >  lib/hexdump.c                                     | 15 ++++++++-------
> >  lib/test_hexdump.c                                |  5 +++--
> >  14 files changed, 31 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c
> > b/drivers/gpu/drm/i915/intel_engine_cs.c
> > index 49fa43ff02ba..fb133e729f9a 100644
> > --- a/drivers/gpu/drm/i915/intel_engine_cs.c
> > +++ b/drivers/gpu/drm/i915/intel_engine_cs.c
> > @@ -1318,7 +1318,7 @@ static void hexdump(struct drm_printer *m, const
> void *buf, size_t len)
> >  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len -
> pos,
> >  						rowsize, sizeof(u32),
> >  						line, sizeof(line),
> > -						false) >= sizeof(line));
> > +						0) >= sizeof(line));
> 
> It might be more clear when we define:
> 
> #define HEXDUMP_BINARY 0

This feels unnecessary, and weird. Omitting the flag won't disable the hex
output (as expected), and if you don't want hex output, why call hexdump in
the first place?

> >  		drm_printf(m, "[%04zx] %s\n", pos, line);
> >
> >  		prev = buf + pos;
> > diff --git a/include/linux/printk.h b/include/linux/printk.h index
> > c014e5573665..82975853c400 100644
> > --- a/include/linux/printk.h
> > +++ b/include/linux/printk.h
> > @@ -493,7 +493,7 @@ enum {
> >
> >  extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
> >  			      int groupsize, char *linebuf, size_t
linebuflen,
> > -			      bool ascii);
> > +			      u64 flags);
> 
> I wonder how fancy hex_dump could be. IMHO, u32 should be enough.
> The last famous words ;-)
> 
> Best Regards,
> Petr
> 
> 
> ---
> This email has been checked for viruses by AVG.
> https://www.avg.com


