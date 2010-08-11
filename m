Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:41546 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab0HKS6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:58:13 -0400
Date: Wed, 11 Aug 2010 21:57:25 +0300
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
Message-ID: <20100811185724.GD21778@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
 <1281550913-17633-4-git-send-email-ohad@wizery.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
 <20100811184742.GA21778@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC1@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC1@dbde02.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Aug 11, 2010 at 08:52:54PM +0200, ext DebBarma, Tarun Kanti wrote:
>True; however if we go by that argument than we can also assume pdata 
>is valid, so that we would not need the below check.

of course not. You can have devices that just play well with default 
values or devices where you don't need the flexibility of platform data. 
That's why we check.

platform_device pointers on the other hand, are guaranteed to be always 
true, if it isn't then you should oops, you deserve to oops because 
something is really really wrong.

>Still, I would go ahead and find out if there is any scenario where 
>pdev can go wrong during device registration. Thanks.

if that scenario ever happens, it's either a bug on your implementation 
or driver-core. In both cases you deserve to oops so we catch such 
problems at early stages.

-- 
balbi

DefectiveByDesign.org
