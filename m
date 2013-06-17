Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49878 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3FQUim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 16:38:42 -0400
Received: by mail-ob0-f171.google.com with SMTP id dn14so3707381obc.16
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 13:38:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371491780-23412-1-git-send-email-zajec5@gmail.com>
References: <1371491780-23412-1-git-send-email-zajec5@gmail.com>
Date: Mon, 17 Jun 2013 22:38:42 +0200
Message-ID: <CACna6rzDv1d4Znni+XUXprZp4RrFLr5yyBdJyPVLHB9n2U3_BQ@mail.gmail.com> (sfid-20130617_223845_690731_CBD8D37E)
Subject: Re: [PATCH] ssb: add struct for serial flash
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/17 Rafał Miłecki <zajec5@gmail.com>:
> This data allow writing for example MTD driver.

To make this a bit more clear:

Up until now, we were detecting flash model in
driver_chipcommon_sflash.c, but nothing more than that. It was printed
and that's all. Noone could read it's details or/and use it.

As providing an access to the flash is usually a good idea, we need an
additional MTD driver for it. Such MTD driver needs some basic info
about flash. It's mapping address and size at least.
With this patch we put all important data in struct ssb_sflash. It can
be accessed in two possible ways:
1) With the: bus->mipscore.sflash path. How to get a reference to the
"bus"? It's an static exported symbols on some archs (bcm47xx).
2) Directly, it "sflash" is registered as a platform driver data. My
next patch will address that.

-- 
Rafał
