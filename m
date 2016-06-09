Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35560 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbcFIW6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 18:58:04 -0400
Date: Thu, 9 Jun 2016 17:57:58 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Chris Milsted <cmilsted@redhat.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andi Kleen <ak@linux.intel.com>, Michael Buesch <m@bues.ch>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Konstantin Simanov <k.simanov@stlk.ru>,
	Bryan Paradis <bryan.paradis@gmail.com>,
	Andrew Worsley <amworsley@gmail.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, zajec5@gmail.com
Subject: Re: [PATCH] x86: Add early quirk to reset Apple AirPort card
Message-ID: <20160609225758.GC19309@localhost> (sfid-20160610_005825_256568_531E9354)
References: <82c2548dffc6cfbc484b9111b1073f407c946061.1464477483.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <82c2548dffc6cfbc484b9111b1073f407c946061.1464477483.git.lukas@wunner.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 29, 2016 at 01:35:28AM +0200, Lukas Wunner wrote:
> The EFI firmware on Macs contains a full-fledged network stack for
> downloading OS X images from osrecovery.apple.com. Unfortunately
> on Macs introduced 2011 and 2012, EFI brings up the Broadcom 4331
> wireless card on every boot and leaves it enabled even after
> ExitBootServices has been called. The card continues to assert its IRQ
> line, causing spurious interrupts if the IRQ is shared. It also corrupts
> memory by DMAing received packets, allowing for remote code execution
> over the air. This only stops when a driver is loaded for the wireless
> card, which may be never if the driver is not installed or blacklisted.
> ...

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=111781
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=728916
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951#c16
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1098621
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632#c5
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1279130
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1332732

I think I saw mail about this being applied via the x86 tree.  Let me
know if I need to do anything more here.
