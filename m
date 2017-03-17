Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31989 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdCQPLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 11:11:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4.11] ath10k: fix incorrect wlan_mac_base in qca6174_regs
Date: Fri, 17 Mar 2017 15:10:45 +0000
Message-ID: <87mvckq6q3.fsf@kamboji.qca.qualcomm.com> (sfid-20170317_161111_239269_6F5D78F6)
References: <1489445343-8719-1-git-send-email-ryanhsu@qca.qualcomm.com>
In-Reply-To: <1489445343-8719-1-git-send-email-ryanhsu@qca.qualcomm.com>
        (ryanhsu@qca.qualcomm.com's message of "Mon, 13 Mar 2017 15:49:03       -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<ryanhsu@qca.qualcomm.com> writes:

> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
>
> In the 'commit ebee76f7fa46 ("ath10k: allow setting coverage class")',
> it inherits the design and the address offset from ath9k, but the address
> is not applicable to QCA6174, which leads to a random crash while doing t=
he
> resume() operation, since the set_coverage_class.ops will be called from
> ieee80211_reconfig() when resume() (if the wow is not configured).
>
> Fix the incorrect address offset here to avoid the random crash.
>
> Verified on QCA6174/hw3.0 with firmware WLAN.RM.4.4-00022-QCARMSWPZ-2.

This also seems to fix a regression related to firmware restart. I was
testing simulate_fw_crash on qca6174 with current ath.git master branch
and noticed firmware crash recovery fails every time:

[   90.402204] ath10k_pci 0000:02:00.0: device is wedged, will not restart

With this patch the recovery works every time I tested this. But I'm not
100% sure yet about this, need to test more.

> Cc: stable@vger.kernel.org

I'll add '# v4.10' because that should be first release which had
ebee76f7fa46, no need to backport to older releases.

--=20
Kalle Valo=
