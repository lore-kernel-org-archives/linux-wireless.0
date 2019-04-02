Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF44C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 13:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0985520856
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 13:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfDBNFE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:05:04 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38948 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfDBNFD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 09:05:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBJ65-0006mK-IL; Tue, 02 Apr 2019 15:05:01 +0200
Message-ID: <2c0321130116163bc92f9738b2c31126557d819f.camel@sipsolutions.net>
Subject: Re: [PATCH v4 1/3] cfg80211: Add support to set tx power for a
 station associated
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Bob Copeland <me@bobcopeland.com>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Date:   Tue, 02 Apr 2019 15:04:59 +0200
In-Reply-To: <20190402125908.GD32168@localhost> (sfid-20190402_145911_852222_9FB31AF6)
References: <1553856501-21492-1-git-send-email-bpothuno@codeaurora.org>
         <20190401204611.GA8910@localhost>
         <cd497042d164c322bc06c4cfbf26435a@codeaurora.org>
         <20190402125908.GD32168@localhost> (sfid-20190402_145911_852222_9FB31AF6)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-02 at 08:59 -0400, Bob Copeland wrote:
> On Tue, Apr 02, 2019 at 12:00:29PM +0530, Balaji Pothunoori wrote:
> > > Should this really dBm?  It's a bit asymmetric for WIPHY_TX_POWER_LEVEL
> > > to
> > > use mBm and this to use dBm, and I might want to adjust in half-dB steps
> > > if
> > > supported by hardware.  Also allocating an s16 is a bit much for dBm.
> > 
> > if user will send mBm value then driver has to convert to dBm because
> > firmware will expect the value in dBm.
> > Please refer johannes comments on following patch " [EXT] Re: [PATCH] iw:
> > Add support for controlling tx power for per station"
> > for the reason why we opted dBm.
> 
> The quote was:
> 
> > I would prefer if this was *dBm*, rather than mBm, and be allowed to
> > take float values, i.e. this would become "limit 20".
> 
> I read that as "iw should convert fractional dBm to mBm" not "kernel should
> only support dBm".

Yeah, I was scratching my head here now wondering why I'd have said
that... But yes, I intended that we should present the nicer UI (float
dBm or so) and then send mBm :)

johannes

