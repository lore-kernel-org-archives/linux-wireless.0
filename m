Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41517 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3FQVJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 17:09:37 -0400
Received: by mail-wi0-f174.google.com with SMTP id k10so2773478wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 14:09:36 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH] ssb: add struct for serial flash
Date: Mon, 17 Jun 2013 22:09:28 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
References: <1371491780-23412-1-git-send-email-zajec5@gmail.com> <CACna6rzDv1d4Znni+XUXprZp4RrFLr5yyBdJyPVLHB9n2U3_BQ@mail.gmail.com>
In-Reply-To: <CACna6rzDv1d4Znni+XUXprZp4RrFLr5yyBdJyPVLHB9n2U3_BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201306172209.28529.florian@openwrt.org> (sfid-20130617_230940_685622_06BD11C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le lundi 17 juin 2013 21:38:42, Rafał Miłecki a écrit :
> 2013/6/17 Rafał Miłecki <zajec5@gmail.com>:
> > This data allow writing for example MTD driver.
> 
> To make this a bit more clear:
> 
> Up until now, we were detecting flash model in
> driver_chipcommon_sflash.c, but nothing more than that. It was printed
> and that's all. Noone could read it's details or/and use it.
> 
> As providing an access to the flash is usually a good idea, we need an
> additional MTD driver for it. Such MTD driver needs some basic info
> about flash. It's mapping address and size at least.
> With this patch we put all important data in struct ssb_sflash. It can
> be accessed in two possible ways:
> 1) With the: bus->mipscore.sflash path. How to get a reference to the
> "bus"? It's an static exported symbols on some archs (bcm47xx).
> 2) Directly, it "sflash" is registered as a platform driver data. My
> next patch will address that.

Ok, well this was probably worth a cover letter just for this, and the second 
patch to be posted too ;) Thanks for the explanation


-- 
Florian
