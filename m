Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46469 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864AbYFJWUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 18:20:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K6CCA-0003xQ-H8
	for linux-wireless@vger.kernel.org; Tue, 10 Jun 2008 22:20:02 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2008 22:20:02 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2008 22:20:02 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: DEBUG_LOCK_ALLOC causes hostap kernel lockup
Date: Tue, 10 Jun 2008 23:16:13 +0100
Message-ID: <g2mufc$c16$1@ger.gmane.org> (sfid-20080611_002021_064537_04BA25D0)
References: <g2760n$7f0$1@ger.gmane.org> <g2la7s$g8r$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel-testers@vger.kernel.org, linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sitsofe Wheeler wrote:

> Sitsofe Wheeler wrote:
> 
>> hostap_pci on a 32bit x86 machine seems to be unstable under load in
>> next-20080604. Using iperf between a wired machine on the other side of
>> the AP and the hostap box makes hostap output the message
>> wifi0: SW TICK stuck? bits=0x0 EvStat=8000 IntEn=e09f
>> before things slowly grind to a halt in a lockup that seemingly needs a
> 
> things always seem to be recoverable. Sometimes the system will recover
> after the lockup with a message like:
> Clocksource tsc unstable (delta = 9377016871 ns)
> Time acpi_pm clocksource has been installed.

The lockups seem to be down to DEBUG_LOCK_ALLOC (Lock debugging: detect
incorrect freeing of live locks). If that is enabled then after enough
iperf runs the kernel will lock solid. This problems seems to happen in
kernels from at least 2.6.22 onwards.

I had no idea that enabling lock checking could itself result in a lockup...

-- 
Sitsofe | http://sucs.org/~sits/

