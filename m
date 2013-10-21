Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61565 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3JUOTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add error handling to ath10k_pci_wait()
References: <20131017083615.31028.25088.stgit@localhost6.localdomain6>
Date: Mon, 21 Oct 2013 17:19:02 +0300
In-Reply-To: <20131017083615.31028.25088.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Thu, 17 Oct 2013 11:36:15 +0300")
Message-ID: <87vc0qso4p.fsf@kamboji.qca.qualcomm.com> (sfid-20131021_161937_290690_70EAEBED)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> ath10k_pci_wait() didn't notify any errors to callers, it
> just printed a warning so add proper error handling.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied, I just changed the commit log to this:

commit f3782744c9b50edf94d28e37a937ff84f267dfab
Author: Kalle Valo <kvalo@qca.qualcomm.com>
Date:   Thu Oct 17 11:36:15 2013 +0300

    ath10k: add error handling to ath10k_pci_wait()
    
    ath10k_pci_wait() didn't notify any errors to callers, it
    just printed a warning so add proper error handling. This fixes
    a crash Ben reported:
    
    ath10k: MSI-X interrupt handling (8 intrs)
    ath10k: Unable to wakeup target
    ath10k: target took longer 5000 us to wake up (awake count 1)
    ath10k: Failed to get pcie state addr: -16
    ath10k: early firmware event indicated
    BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
    IP: [<ffffffffa06ae46c>] ath10k_ce_completed_send_next+0x47/0x122 [ath10k_pci]
    
    Reported-by: Ben Greear <greearb@candelatech.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
