Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbbJSOk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 10:40:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Disable PCI PS for QCA988X and QCA99X0
References: <1443445278-11051-1-git-send-email-akolli@qti.qualcomm.com>
Date: Mon, 19 Oct 2015 17:40:40 +0300
In-Reply-To: <1443445278-11051-1-git-send-email-akolli@qti.qualcomm.com>
	(akolli@qti.qualcomm.com's message of "Mon, 28 Sep 2015 18:31:18
	+0530")
Message-ID: <87zizegbvb.fsf@kamboji.qca.qualcomm.com> (sfid-20151019_164103_667145_881644CB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<akolli@qti.qualcomm.com> writes:

> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> This patch disables PCI PS for QCA988X and QCA99X0, Since PCI PS is
> validated for QCA6174, let it be enabled only for QCA6174. It would be
> better to execute PCI PS related functions only for the supported devices.
>
> PCI time out issue is observed with QCA99X0 on x86 platform, We will
> disable PCI PS for QCA988X and QCA99X0 until PCI PS is properly implemented.
>
> Taking and releasing ps_lock is causing higher CPU consumption. Michal Kazior
> suggested ps_lock overhead to be reworked so that ath10k_pci_wake/sleep
> functions are called less often, i.e. move the powersave logic up (only during
> irq handling, tx path, submitting fw commands).
>
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
