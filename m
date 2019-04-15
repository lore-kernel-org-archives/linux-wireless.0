Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B21C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0FBC20656
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfDOJYc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:24:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:53656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfDOJYc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 05:24:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 697AEAFE8;
        Mon, 15 Apr 2019 09:24:29 +0000 (UTC)
Date:   Mon, 15 Apr 2019 11:24:24 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Alastair D'Silva <alastair@d-silva.org>
Cc:     'Alastair D'Silva' <alastair@au1.ibm.com>,
        'Jani Nikula' <jani.nikula@linux.intel.com>,
        'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>,
        'Rodrigo Vivi' <rodrigo.vivi@intel.com>,
        'David Airlie' <airlied@linux.ie>,
        'Daniel Vetter' <daniel@ffwll.ch>,
        'Karsten Keil' <isdn@linux-pingi.de>,
        'Jassi Brar' <jassisinghbrar@gmail.com>,
        'Tom Lendacky' <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jose Abreu' <Jose.Abreu@synopsys.com>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Stanislaw Gruszka' <sgruszka@redhat.com>,
        'Benson Leung' <bleung@chromium.org>,
        'Enric Balletbo i Serra' <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        'Alexander Viro' <viro@zeniv.linux.org.uk>,
        'Sergey Senozhatsky' <sergey.senozhatsky@gmail.com>,
        'Steven Rostedt' <rostedt@goodmis.org>,
        'Andrew Morton' <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Message-ID: <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-4-alastair@au1.ibm.com>
 <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
 <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat 2019-04-13 09:31:27, Alastair D'Silva wrote:
> > -----Original Message-----
> > From: Petr Mladek <pmladek@suse.com>
> > Sent: Saturday, 13 April 2019 12:12 AM
> > To: Alastair D'Silva <alastair@au1.ibm.com>
> > Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
> Joonas
> > Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> > <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel Vetter
> > <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi Brar
> > <jassisinghbrar@gmail.com>; Tom Lendacky <thomas.lendacky@amd.com>;
> > David S. Miller <davem@davemloft.net>; Jose Abreu
> > <Jose.Abreu@synopsys.com>; Kalle Valo <kvalo@codeaurora.org>;
> > Stanislaw Gruszka <sgruszka@redhat.com>; Benson Leung
> > <bleung@chromium.org>; Enric Balletbo i Serra
> > <enric.balletbo@collabora.com>; James E.J. Bottomley
> > <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> > <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> > <sergey.senozhatsky@gmail.com>; Steven Rostedt <rostedt@goodmis.org>;
> > Andrew Morton <akpm@linux-foundation.org>; intel-
> > gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org;
> > ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> > scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> > devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> > Subject: Re: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
> > hex_dump_to_buffer with flags
> > 
> > On Wed 2019-04-10 13:17:19, Alastair D'Silva wrote:
> > > From: Alastair D'Silva <alastair@d-silva.org>
> > >
> > > In order to support additional features in hex_dump_to_buffer, replace
> > > the ascii bool parameter with flags.
> > >
> > > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > > ---
> > >  drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
> > >  drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
> > >  drivers/mailbox/mailbox-test.c                    |  2 +-
> > >  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
> > >  drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
> > >  drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
> > >  drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
> > >  drivers/platform/chrome/wilco_ec/debugfs.c        |  3 ++-
> > >  drivers/scsi/scsi_logging.c                       |  8 +++-----
> > >  drivers/staging/fbtft/fbtft-core.c                |  2 +-
> > >  fs/seq_file.c                                     |  3 ++-
> > >  include/linux/printk.h                            |  2 +-
> > >  lib/hexdump.c                                     | 15 ++++++++-------
> > >  lib/test_hexdump.c                                |  5 +++--
> > >  14 files changed, 31 insertions(+), 26 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c
> > > b/drivers/gpu/drm/i915/intel_engine_cs.c
> > > index 49fa43ff02ba..fb133e729f9a 100644
> > > --- a/drivers/gpu/drm/i915/intel_engine_cs.c
> > > +++ b/drivers/gpu/drm/i915/intel_engine_cs.c
> > > @@ -1318,7 +1318,7 @@ static void hexdump(struct drm_printer *m, const
> > void *buf, size_t len)
> > >  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len -
> > pos,
> > >  						rowsize, sizeof(u32),
> > >  						line, sizeof(line),
> > > -						false) >= sizeof(line));
> > > +						0) >= sizeof(line));
> > 
> > It might be more clear when we define:
> > 
> > #define HEXDUMP_BINARY 0
> 
> This feels unnecessary, and weird. Omitting the flag won't disable the hex
> output (as expected), and if you don't want hex output why call hexdump in
> the first place?

Why do we have HEXDUMP_ASCII then?
Why is the above funtion not using HEXDUMP_ASCII?
Who would call it with (HEXDUMP_ASCII | HEXDUMP_BINARY)?

Best Regards,
Petr
