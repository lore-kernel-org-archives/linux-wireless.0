Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06216C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 10:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA00C20675
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 10:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfCGKVa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:21:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfCGKV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 05:21:29 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 667AB318A61F;
        Thu,  7 Mar 2019 10:21:29 +0000 (UTC)
Received: from localhost (unknown [10.43.2.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18EE2413B;
        Thu,  7 Mar 2019 10:21:25 +0000 (UTC)
Date:   Thu, 7 Mar 2019 11:21:22 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: Re: mediatek: duplicate usb devices
Message-ID: <20190307102120.GA18424@redhat.com>
References: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com>
 <20190306075053.GA12946@redhat.com>
 <CAA2SeN+V_ug2JPNQ++ZTj4hYh-YDOkNhiyP_dsaYnpddXDb6PA@mail.gmail.com>
 <20190306110329.GD12946@redhat.com>
 <20190306104240.64a26c51@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190306104240.64a26c51@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 07 Mar 2019 10:21:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 06, 2019 at 10:42:40AM -0800, Jakub Kicinski wrote:
> On Wed, 6 Mar 2019 12:03:30 +0100, Stanislaw Gruszka wrote:
> > On Wed, Mar 06, 2019 at 11:09:12AM +0100, Lorenzo Bianconi wrote:
> > > >
> > > > On Tue, Mar 05, 2019 at 07:33:51PM +0100, Xose Vazquez Perez wrote:  
> > > > > There a three duplicate devices at:
> > > > >
> > > > > mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
> > > > > mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Aukey USB-AC1200 */  
> > > > One duplicated entry should be removed.
> > > >  
> > > > > mt76/mt76x0/usb.c:      { USB_DEVICE(0x148f, 0x760a) }, /* TP-Link unknown */
> > > > > mt7601u/usb.c:          { USB_DEVICE(0x148f, 0x760a) },  
> > > 
> > > IIUC this is not in the mt7601u driver available on mtk website.  
> > 
> > The same apply to mt7610u. Vendor driver have only IDs for some
> > reference devices. Both mt7601u and mt7610u drivers do not include
> > 0x7610.
> > 
> > For mt76x0u ids were provided by Hans 
> > https://lore.kernel.org/linux-wireless/alpine.LNX.2.00.1804092042320.8369@T420s/
> > I'm not sure where they came from.
> 
> The ones in mt7601u came from Xose, the GitHub repo has fuller history:
> 
> https://github.com/kuba-moo/mt7601u/commit/5e6b565301d9882aab9af46b396a5cf489db6c78
> 
> I don't really mind which one stays :)

I think this is same case as with duplicated id's for mt76x0u and
mt76x2u. We should not remove the IDs. I will just post patches that
will check chip version. 

Stanislaw
 
