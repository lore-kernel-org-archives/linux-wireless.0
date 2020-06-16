Return-Path: <SRS0=h/PO=75=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48351C433DF
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Jun 2020 13:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 244DA20A8B
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Jun 2020 13:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgFPNfo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Jun 2020 09:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgFPNfo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jun 2020 09:35:44 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37483C061573
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2020 06:35:44 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jlBkR-0006Hx-LT; Tue, 16 Jun 2020 15:35:31 +0200
Date:   Tue, 16 Jun 2020 15:35:31 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "kernel@iuliancostan.com" <kernel@iuliancostan.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "i@outv.im" <i@outv.im>,
        "trevor@shartrec.com" <trevor@shartrec.com>
Subject: Re: [PATCH v1] rtw88: pci: disable aspm for platform inter-op with
 module parameter
Message-ID: <20200616133531.7eyfu6jniywhak7h@linutronix.de>
References: <20200605074703.32726-1-yhchuang@realtek.com>
 <20200610213720.3sopcuimas375xl2@linutronix.de>
 <a2aac609b5e2416b899c5842817da4bb@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a2aac609b5e2416b899c5842817da4bb@realtek.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-06-16 11:06:28 [+0000], Tony Chuang wrote:
> > On 2020-06-05 15:47:03 [+0800], yhchuang@realtek.com wrote:
> > > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > >
> > > Some platforms cannot read the DBI register successfully for the
> > > ASPM settings. After the read failed, the bus could be unstable,
> > > and the device just became unavailable [1]. For those platforms,
> > > the ASPM should be disabled. But as the ASPM can help the driver
> > > to save the power consumption in power save mode, the ASPM is still
> > > needed. So, add a module parameter for them to disable it, then
> > > the device can still work, while others can benefit from the less
> > > power consumption that brings by ASPM enabled.
> > 
> > Can you set disable_aspm if rtw_dbi_read8() fails? Or make a test if it
> > is save to use?
> > 
> > If someone notices the warning they still have to search for the warning
> > in order to make the link towards loading the module with the
> > disable_aspm=1 paramter.
> > Is it known what causes the failure?
> > 
> 
> I think as long as the rtw_dbi_read() fails, the consequent register
> operation will also fail, and still get an error read/write the register.
> And this is some sort of PCI issue, and I am not really familiar with it.
> Such as the root cause or how it fails.

Then it does not sound safe to enable it by default.

> If we can default disable it, then we can help those platforms, but
> then other platform will suffer from higher power consumption.

So for those platform, where the error occurs, you expect that the user
manages to read the error message (a backtrace from rtw_dbi_read8()) and
connects this the need to set a certain module option.

> Yen-Hsuan

Sebastian
