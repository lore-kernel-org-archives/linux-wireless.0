Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:54844 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0HLFV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 01:21:58 -0400
Date: Thu, 12 Aug 2010 08:21:26 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "ext DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
Cc: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	"Pandita, Vikram" <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v4 3/8] wireless: wl1271: add platform driver to get
 board data
Message-ID: <20100812052126.GA23362@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
 <1281550913-17633-4-git-send-email-ohad@wizery.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
 <20100811184742.GA21778@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC1@dbde02.ent.ti.com>
 <20100811185724.GD21778@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC7@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC7@dbde02.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Aug 11, 2010 at 09:27:18PM +0200, ext DebBarma, Tarun Kanti wrote:
>Sounds perfect!
>What that means is _probe() function makes sense only for cases where 
>we have valid platform data because we are returning right at the top 
>if pdata is not valid. If this is the case I was curious to know why 
>not framework make another check for valid pdata before calling 
>_probe() instead of coming all the way to _probe() and then returning!

because pdata is completely optional. pdev OTOH isn't. Without a matched 
platform_device, your probe() won't get called.

-- 
balbi

DefectiveByDesign.org
