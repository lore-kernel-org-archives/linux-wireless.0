Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE649C4151A
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD0C22183F
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548755018;
	bh=taV/+ifmVkxL4cVvYXiY2zaw5q7QAnGib/C25UWUI44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=q5JgUxeNGm0M/Hy90W5DogvX/Gkz/B99L72dO5B8ceuonReLdyWpbhMXKb/N4fFgV
	 WYRRA2q1S2af8jr2M3h97T5ywVoi12tDEs1Xu7sNYzw7pNHHSoRCbpVLyAm9ddoOVK
	 QHwWJMWFFy7dmxd/CLKWBP+dOAuKc8x4cJUvQoes=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfA2Jni (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:43:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfA2Jnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:43:37 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C8772084A;
        Tue, 29 Jan 2019 09:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548755017;
        bh=taV/+ifmVkxL4cVvYXiY2zaw5q7QAnGib/C25UWUI44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xuo9bLv+T9kqGBflPOIEOsz3dpcn+7bgpZ7/H2UDPrpTloQBWYrN9gt4imlijehQ+
         SwJBIcXx9bZmiNfutyPi8S+NyZCzUWx9sgFckQbWcAx0pbStQiE2LqADfrQBvlCFSR
         cHdr7YY6s7dwaAkifojnkU0e8ZcQln5AwVeoYfD8=
Date:   Tue, 29 Jan 2019 10:43:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH 4.20.x 0/7] mt76x0 fixes for 4.20 stable
Message-ID: <20190129094334.GC20645@kroah.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbBz4hLWuN5oAGJV9rXEGuHP1UDPsL2fYaKJA6pRJG1MDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0KTbBz4hLWuN5oAGJV9rXEGuHP1UDPsL2fYaKJA6pRJG1MDA@mail.gmail.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 11:06:41AM -0500, Sid Hayn wrote:
> On Tue, Jan 22, 2019 at 7:41 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >
> > There ware several bugs introduced in 4.20 development cycle
> > for mt76x0 driver, that were fixed later but missed 4.20
> > release. This patche set fixes issues for MT7610U and
> > MT7630E.
> >
> > Bug reference:
> > https://bugzilla.kernel.org/show_bug.cgi?id=202243
> >
> > Lorenzo Bianconi (1):
> >   mt76x0: phy: unify calibration between mt76x0u and mt76x0e
> >
> > Stanislaw Gruszka (6):
> >   mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
> >   mt76x0: use band parameter for LC calibration
> >   mt76x02: run calibration after scanning
> >   mt76x02: assure we update gain after scan
> >   mt76x0: do not perform MCU calibration for MT7630
> >   mt76x0: antenna select corrections
> >
> >  drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
> >  drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   9 +-
> >  drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   5 +
> >  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 170 +++++++--------------
> >  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   1 +
> >  drivers/net/wireless/mediatek/mt76/mt76x02.h       |   1 +
> >  .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |  10 +-
> >  drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |   1 +
> >  .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   3 +
> >  9 files changed, 76 insertions(+), 125 deletions(-)
> >
> > --
> > 1.9.3
> >
> 
> Please forgive if I'm mistaken, but I haven't seen this hit the stable
> queue or see any response at all.  Did this get missed or just hasn't
> been reached yet?

Not reached yet, please give us a chance :)

Backports that have to be "applied by hand" like this are at the bottom
of the pile...

greg k-h
