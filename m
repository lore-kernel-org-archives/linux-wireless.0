Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab1AKNRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 08:17:07 -0500
Date: Tue, 11 Jan 2011 14:17:00 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	Tim Gardner <tim.gardner@canonical.com>, stable@kernel.org
Subject: Re: [PATCH] hostap_cs: fix sleeping function called from invalid
 context
Message-ID: <20110111131659.GA13429@redhat.com>
References: <20110110115551.GA3227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110110115551.GA3227@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 10, 2011 at 12:56:03PM +0100, Stanislaw Gruszka wrote:
> pcmcia_request_irq() and pcmcia_enable_device() are intended
> to be called from process context (first function allocate memory
> with GFP_KERNEL, second take a mutex). We can not take spin lock
> and call them.
> 
> It's safe to move spin lock after pcmcia_enable_device() as we
> still hold off IRQ until dev->base_addr is 0 and driver will
> not proceed with interrupts when is not ready.
> 
> Patch resolves:
> https://bugzilla.redhat.com/show_bug.cgi?id=643758
> 
> Reported-and-tested-by: rbugz@biobind.com
> Cc: stable@kernel.org  # 2.6.34+

Patch is also needed for 2.6.32, I will post that version too.

Stanislaw
