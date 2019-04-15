Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143CCC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C36DA20848
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:07:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="kMNWUtJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfDOKH2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:07:28 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:43656 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfDOKH2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:07:28 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 1806F2F28FBB;
        Mon, 15 Apr 2019 06:07:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555322845;
        bh=t09Knx8R5HfcZX8J+2yfarnsGrDTECfqtExsbS+W1mE=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=kMNWUtJJGkTY37RBDPDNzpNbgYjTzzev5jSu074WJF5x66i6AzjklMQxc6s1vuDdt
         KYzD05HCHCN0gSIYihNVo9Wz7JiCsnV6X5NAtdjm0RRJ3bPZhkxLKbxcp1ew5KfhwT
         AqD2U30GGY10GbGL2mTFTi2dWxmNdSY71M7B0aNHo/c30iH4AMUaHcwz58+ch5KG8Y
         Yj4n/ITZrdch1b3fEhvbXOd8HJxP10TthIaYRl3tHRNo4FM4JXm4tbi9lzwbo/+zKA
         XyR/hnhc/dndRGyR9PCq5pdt0/EeG7wc8yyKJJa6F3/tK/Tbq11GRcmg/nYfySL/P8
         bA0qzdtOwOgSjhBVcgWBj/VzXn9mqR4niQFtQ6wqgZqJG6JcL68/KxvXcwHgkH/qAB
         vGzRoD883zXi/7dHV1uO1rW9n0PiriDz3M+EwetK82bGUqWPRBwd23M4ZFTYP9UGye
         pn7BZ+27NnxvDiShGlJyX95T01CjQD7AOuBIQkHv4LpuT9Sg/nPst8lpv890sYLrBW
         jn2mCeOXCD0vzxYMZcIG/Reb0GpYEOnUHM+ULPnF/XuaoTnzM1Rwqgdd1hi4YXyi1+
         UJalVDCCuJjWGujnF+4H0xFvIuI96v2ExzZ08tneQ23n3dOoYWwRJu7yUgf3ZFbOEM
         hNg++l+W72BaPPeRkPUOdYx4=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3FA7BdX038442
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Apr 2019 20:07:12 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'Petr Mladek'" <pmladek@suse.com>
Cc:     "'Alastair D'Silva'" <alastair@au1.ibm.com>,
        "'Jani Nikula'" <jani.nikula@linux.intel.com>,
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
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-4-alastair@au1.ibm.com> <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz> <093301d4f187$da0756a0$8e1603e0$@d-silva.org> <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz>
In-Reply-To: <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date:   Mon, 15 Apr 2019 20:07:10 +1000
Message-ID: <0da301d4f373$01d5bb80$05813280$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1ALvlgN3AdorRAgCCza9VAHVj+h+o2yMYSA=
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 15 Apr 2019 20:07:19 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Monday, 15 April 2019 7:24 PM
> To: Alastair D'Silva <alastair@d-silva.org>
> Cc: 'Alastair D'Silva' <alastair@au1.ibm.com>; 'Jani Nikula'
> <jani.nikula@linux.intel.com>; 'Joonas Lahtinen'
> <joonas.lahtinen@linux.intel.com>; 'Rodrigo Vivi'
<rodrigo.vivi@intel.com>;
> 'David Airlie' <airlied@linux.ie>; 'Daniel Vetter' <daniel@ffwll.ch>;
'Karsten
> Keil' <isdn@linux-pingi.de>; 'Jassi Brar' <jassisinghbrar@gmail.com>; 'Tom
> Lendacky' <thomas.lendacky@amd.com>; 'David S. Miller'
> <davem@davemloft.net>; 'Jose Abreu' <Jose.Abreu@synopsys.com>; 'Kalle
> Valo' <kvalo@codeaurora.org>; 'Stanislaw Gruszka' <sgruszka@redhat.com>;
> 'Benson Leung' <bleung@chromium.org>; 'Enric Balletbo i Serra'
> <enric.balletbo@collabora.com>; 'James E.J. Bottomley'
> <jejb@linux.ibm.com>; 'Martin K. Petersen' <martin.petersen@oracle.com>;
> 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>; 'Alexander Viro'
> <viro@zeniv.linux.org.uk>; 'Sergey Senozhatsky'
> <sergey.senozhatsky@gmail.com>; 'Steven Rostedt'
> <rostedt@goodmis.org>; 'Andrew Morton' <akpm@linux-foundation.org>;
> intel-gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
> hex_dump_to_buffer with flags
> 
> On Sat 2019-04-13 09:31:27, Alastair D'Silva wrote:
> > > -----Original Message-----
> > > From: Petr Mladek <pmladek@suse.com>
> > > Sent: Saturday, 13 April 2019 12:12 AM
> > > To: Alastair D'Silva <alastair@au1.ibm.com>
> > > Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
> > Joonas
> > > Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> > > <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel
> > > Vetter <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi
> > > Brar <jassisinghbrar@gmail.com>; Tom Lendacky
> > > <thomas.lendacky@amd.com>; David S. Miller
> <davem@davemloft.net>;
> > > Jose Abreu <Jose.Abreu@synopsys.com>; Kalle Valo
> > > <kvalo@codeaurora.org>; Stanislaw Gruszka <sgruszka@redhat.com>;
> > > Benson Leung <bleung@chromium.org>; Enric Balletbo i Serra
> > > <enric.balletbo@collabora.com>; James E.J. Bottomley
> > > <jejb@linux.ibm.com>; Martin K. Petersen
> > > <martin.petersen@oracle.com>; Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org>; Alexander Viro
> > > <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> > > <sergey.senozhatsky@gmail.com>; Steven Rostedt
> > > <rostedt@goodmis.org>; Andrew Morton <akpm@linux-
> foundation.org>;
> > > intel- gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org;
> > > ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> > > scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> > > devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> > > Subject: Re: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
> > > hex_dump_to_buffer with flags
> > >
> > > On Wed 2019-04-10 13:17:19, Alastair D'Silva wrote:
> > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > >
> > > > In order to support additional features in hex_dump_to_buffer,
> > > > replace the ascii bool parameter with flags.
> > > >
> > > > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > > > ---
> > > >  drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
> > > >  drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
> > > >  drivers/mailbox/mailbox-test.c                    |  2 +-
> > > >  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
> > > >  drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
> > > >  drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
> > > >  drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
> > > >  drivers/platform/chrome/wilco_ec/debugfs.c        |  3 ++-
> > > >  drivers/scsi/scsi_logging.c                       |  8 +++-----
> > > >  drivers/staging/fbtft/fbtft-core.c                |  2 +-
> > > >  fs/seq_file.c                                     |  3 ++-
> > > >  include/linux/printk.h                            |  2 +-
> > > >  lib/hexdump.c                                     | 15
++++++++-------
> > > >  lib/test_hexdump.c                                |  5 +++--
> > > >  14 files changed, 31 insertions(+), 26 deletions(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c
> > > > b/drivers/gpu/drm/i915/intel_engine_cs.c
> > > > index 49fa43ff02ba..fb133e729f9a 100644
> > > > --- a/drivers/gpu/drm/i915/intel_engine_cs.c
> > > > +++ b/drivers/gpu/drm/i915/intel_engine_cs.c
> > > > @@ -1318,7 +1318,7 @@ static void hexdump(struct drm_printer *m,
> > > > const
> > > void *buf, size_t len)
> > > >  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len -
> > > pos,
> > > >  						rowsize,
sizeof(u32),
> > > >  						line, sizeof(line),
> > > > -						false) >=
sizeof(line));
> > > > +						0) >= sizeof(line));
> > >
> > > It might be more clear when we define:
> > >
> > > #define HEXDUMP_BINARY 0
> >
> > This feels unnecessary, and weird. Omitting the flag won't disable the
> > hex output (as expected), and if you don't want hex output why call
> > hexdump in the first place?
> 
> Why do we have HEXDUMP_ASCII then?
> Why is the above funtion not using HEXDUMP_ASCII?
> Who would call it with (HEXDUMP_ASCII | HEXDUMP_BINARY)?

The ASCII flag controls the optional ASCII output, and replaces the boolean
that existed prior. A user would enable it in the same situations where they
currently pass true for the ascii parameter.

In the above example the author only wants the hex output, while in other
situations, both hex & ASCII output is desirable. If you just want ASCII
output, the caller should just use a printk or one of it's wrappers.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece

