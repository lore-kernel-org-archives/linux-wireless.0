Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58291 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbcL3JPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 04:15:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: recal the txpower when removing interface
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1482445906-20421-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1482445906-20421-1-git-send-email-ryanhsu@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qca.qualcomm.com>
Message-ID: <9db0c0c5b7294f3fa73d25bf70eebad6@euamsexm01a.eu.qualcomm.com> (sfid-20161230_101524_442778_8E1DE1A2)
Date: Fri, 30 Dec 2016 10:15:13 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qca.qualcomm.com> wrote:
> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> 
> The txpower is being recalculated when adding interface to make sure
> txpower won't overshoot the spec, and when removing the interface,
> the txpower should again to be recalculated to restore the correct value
> from the active interface list.
> 
> Following is one of the scenario
> 	vdev0 is created as STA and connected: txpower:23
> 	vdev1 is created as P2P_DEVICE for control interface: txpower:0
> 	vdev2 is created as p2p go/gc interface: txpower is 21
> 
> So the vdev2@txpower:21 will be set to firmware when vdev2 is created.
> When we tear down the vdev2, the txpower needs to be recalculated to
> re-set it to vdev0@txpower:23 as vdev0/vdev1 are the active interface.
> 
> 	ath10k_pci mac vdev 0 peer create 8c:fd:f0:01:62:98
> 	ath10k_pci mac vdev_id 0 txpower 23
> 	... (adding interface)
> 	ath10k_pci mac vdev create 2 (add interface) type 1 subtype 3
> 	ath10k_pci mac vdev_id 2 txpower 21
> 	ath10k_pci mac txpower 21
> 	... (removing interface)
> 	ath10k_pci mac vdev 2 delete (remove interface)
> 	ath10k_pci vdev 1 txpower 0
> 	ath10k_pci vdev 0 txpower 23
> 	ath10k_pci mac txpower 23
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

d679fa1b3c89 ath10k: recal the txpower when removing interface

-- 
https://patchwork.kernel.org/patch/9486925/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
