Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab1HXJFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 05:05:07 -0400
Date: Wed, 24 Aug 2011 11:03:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [compat-wireless-3.1-rc1-1] rt2800usb crashes the machine
Message-ID: <20110824090340.GA2277@redhat.com> (sfid-20110824_110511_086213_6CE16508)
References: <4E536DD8.6030308@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E536DD8.6030308@01019freenet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 11:07:36AM +0200, Andreas Hartmann wrote:
> using rt2800usb with a Linksys WUSB600N v2 (rt3572) crashes the complete
> machine (SMP, Core i5, linux 3.0) on unloading the module after using it
> for a short period of time:
> - 2 times netperf -t TCP_MAERTS -H host
> - 2 times netperf -t TCP_STREAM -H host
> 
> The error message in /var/log/messages is:
> 
> phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting
> 
> After the crash, you have to hard reset the machine.
Did you hibernate machine anytime before the rmmod ?

If so, we have fix on wireless-testing tree:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=543cc38c8fe86deba4169977c61eb88491036837

Otherwise perhaps you could photo crash logs on virtual terminal
(switched by Alt+Ctrl+F2 from X-window) or by using netconsole or kdump.

Stanislaw
