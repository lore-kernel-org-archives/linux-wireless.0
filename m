Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48131 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0LVRRR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 12:17:17 -0500
Subject: Re: [PATCH] iwlagn: only enable rfkill interrupt when device is
 down
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <1293022913-4692-1-git-send-email-sgruszka@redhat.com>
References: <1293022913-4692-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 09:08:12 -0800
Message-ID: <1293037692.3997.47.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 05:01 -0800, Stanislaw Gruszka wrote:
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
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: stable@kernel.org
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>



