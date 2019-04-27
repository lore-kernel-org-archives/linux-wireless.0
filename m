Return-Path: <SRS0=RVLw=S5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BD9C43218
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 18:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CDD5214AE
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556388850;
	bh=jtA+Qr5Sowzpth0Px0TxHmGmrJLWsmOZkndaKShROJk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=HcMHsJtTtwbJ9RyzkyWjfgGGf73L/VGNf8ZPZ4ZpgnnYC880HtdxniSXK7ujQ+Fq1
	 NrBz3hlM5IJkISta3hk2CcwMnXVtqIpmf3u46bcZQxW5xeVb7r0T8zgW/WNWENiBjI
	 R2TyZ/AEZbcV1l+4F+bAA3F1w0GS4NWE8jlpxVpQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfD0SOD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 14:14:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:51200 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfD0SOC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 14:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qGs9gyd+8mbF58d9iNV6zlbIYiLoTBxs09/Lf+hRxz0=; b=AT03D5WhhdhSSqw5qyiTpKUV6a
        3eE4Wdu+1gVtasvrfougGt3ALT56zCvhZOn8KRHD7zUcFq3NeWJljEDtUKx1hHacFligCR1atNkYB
        7lixNeZeySWOMWwi7WjOC45YXLKKDC59/5LNIBW7wyRlyBJp/tCbSfs6pH30pSY5C2ArC+VSUUrZ3
        rv8R1F2vx5kXk1Akz0sAdpy+EXsdmSBFQvse1djp6fjsv1screwgGOVlsuUflM0CYFlWVTm1oiPcq
        uUZukeInFjffVcJMf83lAOtsqJuBv6F5ZEqcQz2+0bRES908WOMXDwi5JKQoivn+ja5POC6NbVNPZ
        7E3O+/Bw==;
Received: from 177.17.250.151.dynamic.adsl.gvt.net.br ([177.17.250.151] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hKRpd-000420-Hf; Sat, 27 Apr 2019 18:13:49 +0000
Date:   Sat, 27 Apr 2019 15:13:37 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 25/79] docs: convert docs to ReST and rename to *.rst
Message-ID: <20190427151337.2fb0ed5f@coco.lan>
In-Reply-To: <20190427172551.GI14916@sirena.org.uk>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
        <7adf9035ae06ecc6c7e46b51cb677f0a8f61d19a.1555938376.git.mchehab+samsung@kernel.org>
        <20190425180758.GC23183@sirena.org.uk>
        <20190426064609.7f00e013@coco.lan>
        <20190427172551.GI14916@sirena.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Em Sun, 28 Apr 2019 02:25:51 +0900
Mark Brown <broonie@kernel.org> escreveu:

> On Fri, Apr 26, 2019 at 06:46:09AM -0300, Mauro Carvalho Chehab wrote:
> > Mark Brown <broonie@kernel.org> escreveu:  
> 
> > > This is massively CCed covering a large range of subsystems and is patch
> > > 25 of a 79 patch series so I've no context for what's going on here or
> > > why...    
> 
> > You can see more details at patch 00/79:
> > 	https://lore.kernel.org/lkml/20190422115110.26443b44@coco.lan/  
> 
> OK, it would've helped to CC people on that. 

I know, but, due to bad experiences in the past, I had to actually
remove people from it, because several servers reject e-mails with 
more than ~30 destination addresses, as they consider it to be spam.

> Anyway
> 
> Acked-by: Mark Brown <broonie@kernel.org>

Thanks!

Thanks,
Mauro
