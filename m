Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49102 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1LFUAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 15:00:21 -0500
Date: Tue, 6 Dec 2011 14:56:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <m@bues.ch>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] ssb: fix init regression with SoCs
Message-ID: <20111206195642.GC30288@tuxdriver.com> (sfid-20111206_210026_025513_32D90D67)
References: <1323123591-11982-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1323123591-11982-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 05, 2011 at 11:19:51PM +0100, Hauke Mehrtens wrote:
> This fixes a Data bus error on some SoCs. The first fix for this
> problem did not solve it on all devices.
>     commit 6ae8ec27868bfdbb815287bee8146acbefaee867
>     Author: Rafał Miłecki <zajec5@gmail.com>
>     Date:   Tue Jul 5 17:25:32 2011 +0200
>         ssb: fix init regression of hostmode PCI core
> 
> In ssb_pcicore_fix_sprom_core_index() the sprom on the PCI core is
> accessed, but the sprom only exists when the ssb bus is connected over
> a PCI bus to the rest of the system and not when the SSB Bus is the
> main system bus. SoCs sometimes have a PCI host controller and there
> this code will not be executed, but there are some old SoCs with an PCI
> controller in client mode around and ssb_pcicore_fix_sprom_core_index()
> should not be called on these devices too. The PCI controller on these
> devices are unused, but without this fix it results in an Data bus
> error when it gets initialized.
> 
> CC: Michael Buesch <m@bues.ch>
> CC: Rafał Miłecki <zajec5@gmail.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Should this go to the stable list?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
