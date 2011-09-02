Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13381 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1IBHzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 03:55:20 -0400
Message-ID: <4E608BD7.5060104@qca.qualcomm.com> (sfid-20110902_095528_277580_7787FFB7)
Date: Fri, 2 Sep 2011 10:55:03 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3] ath6kl: ath6kl: Add debugfs interface to dump diagnostic
 registers
References: <1314871752-13740-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1314871752-13740-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2011 01:09 PM, Vasanthakumar Thiagarajan wrote:
> To dump a particular register, echo reg_addr > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr,
> to dump the entire register set, echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr, and
> register values will be available at <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump.

Thanks, applied. But I did minor changes:

commit 91d57de5adfc40184ef7cb8974104459c5211add
Author: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Date:   Fri Sep 2 10:40:06 2011 +0300

    ath6kl: Add debugfs interface to dump diagnostic registers from firmware

    To dump a particular register:

        echo <reg_addr> > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr

    To dump the entire register set:

        echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr

    Register values will be available at:

        cat <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump

    kvalo: commit log cleanup, renamed few functions, removed a warning
    message

    Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>


Kalle
