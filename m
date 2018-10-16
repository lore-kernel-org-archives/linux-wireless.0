Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5A9C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3C520881
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD3C520881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbeJPS2k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 14:28:40 -0400
Received: from fudo.makrotopia.org ([185.142.180.71]:56751 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbeJPS2k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 14:28:40 -0400
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.90_1)
        (envelope-from <daniel@makrotopia.org>)
        id 1gCMkQ-0008Fz-Lx; Tue, 16 Oct 2018 12:38:47 +0200
Date:   Tue, 16 Oct 2018 12:38:07 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
Message-ID: <20181016103806.GA1544@makrotopia.org>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
 <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181016081115.GA4401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181016081115.GA4401@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 16, 2018 at 10:11:16AM +0200, Stanislaw Gruszka wrote:
> On Fri, Oct 12, 2018 at 12:48:07PM +0200, Tom Psyborg wrote:
> > chip version support exist in daniel's tree since a long time ago. so
> > don't disable registers initialization but try to upstream his
> > changes.
> 
> Where is this patch ? I can not find it.

So this requires to make the chip version and package available to
drivers like rt2x00. First of all, this is a patch for linux-mips:

https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=blob;f=target/linux/ramips/patches-4.4/300-mt7620-export-chip-version-and-pkg.patch;h=f6aca6c90516f9c534b3c51e9f99dff6a3f41b75;hb=709fe05dfea58728d6accb9fe56c7056d9d0715b

It belongs to this (very outdated) tree:
https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=shortlog;h=refs/heads/differentiate-pkg-ver-eco

I'm not sure whether this is the right way to do this, but it worked.


Cheers


Daniel



> 
> Thanks
> Stanislaw
