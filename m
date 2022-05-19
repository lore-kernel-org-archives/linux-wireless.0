Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D458C433F5
	for <linux-wireless@archiver.kernel.org>; Thu, 19 May 2022 14:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiESOAx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 May 2022 10:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbiESN7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 May 2022 09:59:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7736532FC
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2022 06:58:14 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrgfL-0008PA-Bo; Thu, 19 May 2022 15:58:11 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrgfJ-0001l5-M4; Thu, 19 May 2022 15:58:09 +0200
Date:   Thu, 19 May 2022 15:58:09 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        kernel@pengutronix.de, neo_jou <neo_jou@realtek.com>
Subject: Re: [PATCH 06/10] rtw88: Add common USB chip support
Message-ID: <20220519135809.GA25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-7-s.hauer@pengutronix.de>
 <20220518083230.GR25578@pengutronix.de>
 <f3d20127a3e24f8f5e4a8faa559908c420a47117.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3d20127a3e24f8f5e4a8faa559908c420a47117.camel@sipsolutions.net>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:57:14 up 50 days,  2:26, 49 users,  load average: 0.06, 0.08,
 0.04
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, May 18, 2022 at 10:34:58AM +0200, Johannes Berg wrote:
> On Wed, 2022-05-18 at 10:32 +0200, Sascha Hauer wrote:
> > 
> > >  	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
> > > +			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
> > >  			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
> > 
> > This change should be in a separate patch. I don't have an idea though
> > what it's good for anyway. Is this change desired for the PCI variants
> > as well or only for USB? Do we want to have this change at all?
> > 
> 
> This driver uses mac80211, so that change should just not be there.
> mac80211 will set it automatically if it's possible, see in
> net/mac80211/main.c.

Ok, removing it doesn't seem to have any visible effect. I'll drop that
hunk for the next round.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
