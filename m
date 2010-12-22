Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0LVR1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 12:27:38 -0500
Subject: Re: [PATCH] iwlagn: only enable rfkill interrupt when device is
 down
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
In-Reply-To: <1293022913-4692-1-git-send-email-sgruszka@redhat.com>
References: <1293022913-4692-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 18:27:19 +0100
Message-ID: <1293038839.3531.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 14:01 +0100, Stanislaw Gruszka wrote:
> Since commit 6cd0b1cb872b3bf9fc5de4536404206ab74bafdd "iwlagn: fix
> hw-rfkill while the interface is down", we enable interrupts when
> device is not ready to receive them. However hardware, when it is in
> some inconsistent state, can generate other than rfkill interrupts
> and crash the system. I can reproduce crash with "kernel BUG at
> drivers/net/wireless/iwlwifi/iwl-agn.c:1010!" message, when forcing
> firmware restarts.
> 
> To fix only enable rfkill interrupt when down device and after probe.
> I checked patch on laptop with 5100 device, rfkill change is still
> passed to user space when device is down.

Should the subject say "enable only rfkill interrupt when device is
down" instead? As it is, to me it reads like rfkill interrupt would be
disabled while up, which can't be right?

johannes

