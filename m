Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034CBC10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 14:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C972B20656
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555942085;
	bh=NxH2GbPXCABQ9ahzYNEtjo/tx6Kmx5oUcsi6PZlIyaM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=T3XVzBJv21Av8B9/toyGPLMaiP+0177guhvY03le542heHqO6dxJKZi0Y32Cgt4Wh
	 UlZ2RcxMLl4+ze40TgDW5W0vHo3xCy3Tcflg+cpoSX928K8/vSuTKwzGNHwVJYJeS4
	 q4pETq7jHftSXlAKuTnEn+DhiYoXFMA66xd7LMUI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfDVOIB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 10:08:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:60354 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727277AbfDVOIB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 10:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rW+1ITQQ2cRfyxA1nnCqjk9QBb4ZXRDOBeynG64FjUQ=; b=OdSRHFJmvpAZP5xtGWteR9B1oK
        tdNSGqoa0D5/t74ihdTjnMiNf2BAZy7OQNcY1jUJxOQJpM1Uc+4WYZfq4ivUTBXF1okPedKidG4gH
        0Ywdq3sm/jTLhsG5YCah35Bh3Gk6KsCW4NtS6KvlWuvjlA8YlSP0oiDWc+8P9EHSaJagVJVhkG88w
        zgOxlKflOaD3TzqGtpd6MHrydi6CemoNUxOyjiXekehQqEauuJt08+Y4Oke48RD7V1T0NDy4gh0wn
        ViBjqkj89WPHGX0Xbj33EqKQFClQfGl6Eaq184Etq3CZPl5DqBMDfq0r/BGnObu1rksZaMo9Tunwd
        7nwHzMgQ==;
Received: from 179.176.125.229.dynamic.adsl.gvt.net.br ([179.176.125.229] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hIZby-0005Jf-HD; Mon, 22 Apr 2019 14:07:58 +0000
Date:   Mon, 22 Apr 2019 11:07:54 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux PCI <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Changbin Du <changbin.du@gmail.com>
Subject: Re: [PATCH v2 25/79] docs: convert docs to ReST and rename to *.rst
Message-ID: <20190422110754.4d75c5ce@coco.lan>
In-Reply-To: <CAErSpo4FLuCVPGAZGKeBn=-oyaw6eTrseMnaHJo1TVjxnfCZrw@mail.gmail.com>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
        <7adf9035ae06ecc6c7e46b51cb677f0a8f61d19a.1555938376.git.mchehab+samsung@kernel.org>
        <CAErSpo4FLuCVPGAZGKeBn=-oyaw6eTrseMnaHJo1TVjxnfCZrw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Em Mon, 22 Apr 2019 08:48:10 -0500
Bjorn Helgaas <bhelgaas@google.com> escreveu:

> [+cc Changbin, -cc many others]
> 
> On Mon, Apr 22, 2019 at 8:28 AM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > Convert the PM documents to ReST, in order to allow them to
> > build with Sphinx.
> >
> > The conversion is actually:
> >   - add blank lines and identation in order to identify paragraphs;  
> 
> s/identation/indentation/
> 
> >   - fix tables markups;
> >   - add some lists markups;
> >   - mark literal blocks;
> >   - adjust title markups.
> >
> > At its new index.rst, let's add a :orphan: while this is not linked to
> > the main index.rst file, in order to avoid build warnings.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>  
> 
> The PCI part of this is fine with me but may conflict with Changbin's work:
> 
> https://lore.kernel.org/lkml/20190409155626.6049-1-changbin.du@gmail.com

Yes it could generate a conflict, but it is a trivial change:

--- a/Documentation/PCI/pci.txt
+++ b/Documentation/PCI/pci.txt
@@ -110,7 +110,7 @@ initialization with a pointer to a structure describing the driver
 	resume_early	Wake device from low power state.
 	resume		Wake device from low power state.
 
-		(Please see Documentation/power/pci.txt for descriptions
+		(Please see Documentation/power/pci.rst for descriptions
 		of PCI Power Management and the related functions.)
 
 	shutdown	Hook into reboot_notifier_list (kernel/sys.c).

Looking at Changbin's patch 02/12 v3:

	https://lore.kernel.org/lkml/20190409155626.6049-3-changbin.du@gmail.com/

It doesn't touch the above line, nor the context lines, and it doesn't 
change more than 50% of the file. So, even if this patch gets merged
after the PCI changeset, git will very likely recognize it as a
rename and will apply it anyway.

> Since this doesn't look like it's targeting merge via the PCI tree,
> I'll let you two work out any conflicts.
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks!
Mauro
