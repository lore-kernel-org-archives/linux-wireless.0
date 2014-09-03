Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:44695 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaICTyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:54:40 -0400
Message-ID: <540771FE.5040600@hauke-m.de> (sfid-20140903_215443_179463_B8132A88)
Date: Wed, 03 Sep 2014 21:54:38 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
CC: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 2/2] bcma: use separated function to initialize bus on
 SoC
References: <1409605867-30051-1-git-send-email-zajec5@gmail.com> <1409605867-30051-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1409605867-30051-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2014 11:11 PM, Rafał Miłecki wrote:
> This is required to split SoC bus init into two phases. The later one
> (which includes scanning) should be called when kalloc is available.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
> John: please note this patch touches arch/mips/bcm47xx/setup.c
> 
> This patches is a first step of simplifying MIPS booting process on
> Broadcom SoCs. My research described in:
>> Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
> e-mail thread explained how we could get rid of all these early scanning
> tricks. The main idea is to postpone bus initialization a bit and use
> all standard calls then. So far we were doing it so early we had to
> avoid kalloc.
> ---
>  arch/mips/bcm47xx/setup.c     |  4 ++++
>  drivers/bcma/host_soc.c       | 11 +++++++++--
>  include/linux/bcma/bcma_soc.h |  1 +
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 


