Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60866 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2GZPss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 11:48:48 -0400
Message-ID: <501166D5.2040007@hauke-m.de> (sfid-20120726_174905_717193_3933CCAF)
Date: Thu, 26 Jul 2012 17:48:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: bcma_bus_scan/bcma_bus_scan_early: missing iounmap
References: <20120725110523.GA24514@localhost>
In-Reply-To: <20120725110523.GA24514@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2012 01:05 PM, Fengguang Wu wrote:
> Hi Hauke,
> 
> The coccinelle static checker emits these warnings:
> 
> drivers/bcma/scan.c:466:3-9: ERROR: missing iounmap; ioremap on line 451 and execution via conditional on line 465
> drivers/bcma/scan.c:540:3-9: ERROR: missing iounmap; ioremap on line 515 and execution via conditional on line 539
> 
> It seems we need to change the return statements to goto/break statements.
> 
> Thanks,
> Fengguang

Hi Fengguang,

Thanks for the hint on this problem, I just sent a patch to fix this to
John Linville and the linux-wireless mailing list.

Hauke
