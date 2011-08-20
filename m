Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41366 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1HTMX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 08:23:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110818133809.GG4786@shale.localdomain>
References: <20110818133809.GG4786@shale.localdomain>
Date: Sat, 20 Aug 2011 14:23:56 +0200
Message-ID: <CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com> (sfid-20110820_142402_266058_C25E1CEA)
Subject: Re: [patch -next] bcma: signedness bug in bcma_get_next_core()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "open list:BROADCOM SPECIFIC..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 sierpnia 2011 15:38 użytkownik Dan Carpenter
<error27@gmail.com> napisał:
> The u32 would never be less than zero so the error handling would
> break.  I changed it to int.

In declaration we use s32:
static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 **eromptr);

Doesn't it sound better to use s32 instead of int?

-- 
Rafał
