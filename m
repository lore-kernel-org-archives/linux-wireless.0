Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58665 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaAWPq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:46:28 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH] iwlwifi: pcie: don't panic on host commands in iwldvm
References: <52DCFE87.9080103@gmail.com>
	<1390214977-29202-1-git-send-email-egrumbach@gmail.com>
Date: Thu, 23 Jan 2014 17:46:26 +0200
In-Reply-To: <1390214977-29202-1-git-send-email-egrumbach@gmail.com> (Emmanuel
	Grumbach's message of "Mon, 20 Jan 2014 12:49:36 +0200")
Message-ID: <87fvoen1kd.fsf@purkki.adurom.net> (sfid-20140123_164631_631391_672075C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@gmail.com> writes:

> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> None of the devices supported by iwldvm have support for
> shadow registers. This means that we wake the NIC
> when we increment the write pointer on Tx ring.
> This happened even before my bad commit mentionned below.
> Since my commit below, we wake up the NIC when we put a
> host command on the ring regardless of shadow register
> support. This means that in iwldvm (when the NIC doesn't
> support shadow register), we wake up the NIC twice:
>
> pcie_enqueue_hcmd:
> 	wake up the NIC
> 	iwl_pcie_txq_inc_wr_ptr:
> 		wake up the NIC - no shadow reg support
>
> Since waking up the NIC means that we need to acquire a
> spinlock, this obviously leads to a recursive spinlock
> and hence a freeze.
>
> Fixes: b9439491055a ("iwlwifi: pcie: keep the NIC awake when commands are in flight")
> Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Ah, this is why my laptop was hanging during boot with latest
wireless-testing? Thanks for fixing this. 

FWIW:

Tested-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
