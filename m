Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3BEC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF28206BA
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556272002;
	bh=9RT8xA5jMBv6EzT8N9JRPoEns1coQhC9bYDVc6PmTws=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=AwolLZBD7dimBnWvkx4xw670MdVlpBKYK8LFfo6RmX44H1oc/putJiB9hpzvJiPcO
	 oX93LcvsPbzsP2gR573qOTZF1XufCXGs2YVIx2zuJ5KMcMfAESTNcsJPkubUrskPiO
	 EX3wOiZz9j8URDB5Kig7zBZS5HlDCsQWAyQQVUuw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfDZJqf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:46:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:52042 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfDZJqf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gTBjYHF7PdfcMS747oVD2PM5dGAfiuGzrLBbmiynnAI=; b=ThiRHSVnK8igKQlUt70ItUpgfn
        ahvUpV2Rj5VYX6v2qdgqkJ5YDlrjlEHjCiqciVId/LoW/vvbKtqqhjBZvImCJFrk4tTc96+SgQTMt
        3OwLruS8ajlGs/wQ20K30ls643aeeOVpb/B7MjXylL0emp1dw6nykZEPhyzyfDfgrbPNaH7y3BxV8
        0/Pf9E/MtLsN+dZ02jvg38Neh4bT8CtGsUuBDGhhjAjqMii4uRKfUZed6iZ/INQKwoT8UUu5T/2j8
        o0WOHq5yMZ0fJgkLpfKIpMcsztztvKqpYFW56Aq/Y4OzodfEabMJl4Dq9mXtvOf21R/5AYdWX7Hzf
        niiIxfrA==;
Received: from [179.95.39.209] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJxQz-000573-Hl; Fri, 26 Apr 2019 09:46:22 +0000
Date:   Fri, 26 Apr 2019 06:46:09 -0300
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
Message-ID: <20190426064609.7f00e013@coco.lan>
In-Reply-To: <20190425180758.GC23183@sirena.org.uk>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
        <7adf9035ae06ecc6c7e46b51cb677f0a8f61d19a.1555938376.git.mchehab+samsung@kernel.org>
        <20190425180758.GC23183@sirena.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Mark,

Em Thu, 25 Apr 2019 19:07:58 +0100
Mark Brown <broonie@kernel.org> escreveu:

> On Mon, Apr 22, 2019 at 10:27:14AM -0300, Mauro Carvalho Chehab wrote:
> > Convert the PM documents to ReST, in order to allow them to
> > build with Sphinx.  
> 
> This is massively CCed covering a large range of subsystems and is patch
> 25 of a 79 patch series so I've no context for what's going on here or
> why...  

There are two goals of this series:

1) to prepare for placing the new *.rst files under Documentation/ into an
   index file, being part of one of the books. Most of the stuff covered
   on this series either fit at the system admin guide or at the
   Kernel API documentation book;

2) to ensure that, if some edition on a file would cause warnings at
   Sphinx build, someone will notice and submit a followup patch.

You can see more details at patch 00/79:
	https://lore.kernel.org/lkml/20190422115110.26443b44@coco.lan/

In order to do that, this series has one patch per Documentation/*
sub-directory. This specific one is for the documents under
Documentation/power/ [1].

[1] btw, the title of this specific patch should be, instead:
	docs: power: convert docs to ReST and rename to *.rst

The series is long because I'm trying to cover a significant part
of the documentation files. In any case, except if an eventual
conflict might rise on some file, this patch is independent from
all other files, and should be safe to apply directly via the
subsystem git tree.

I'm working on a follow-up patch series that should be adding the
power/index.rst file into another index file - probably at
Documentation/index.rst[1]. As such patch will be adding a lot of other
index files, the best would be to merge it via the docs tree, in
order to avoid conflicts.


[1] such patch will be removing the ":orphan:" meta-tag from it
(that basically tells the build system to not produce warnings if
the file is not directly or indirectly referenced by the main
index file).

Thanks,
Mauro
