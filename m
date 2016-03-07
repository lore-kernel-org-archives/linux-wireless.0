Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48476 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbcCGJv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 04:51:29 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"greearb@candelatech.com" <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix firmware assert in monitor mode
Date: Mon, 7 Mar 2016 09:51:17 +0000
Message-ID: <87a8mavcoh.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_105140_297516_EC984991)
References: <1456929832-6147-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1456929832-6147-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 2 Mar 2016 20:13:52 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> commit 166de3f1895d ("ath10k: remove supported chain mask") had revealed
> an issue on monitor mode. Configuring NSS upon monitor interface
> creation is causing target assert in all qca9888x and qca6174 firmware.
> Firmware assert issue can be reproduced by below sequence even after
> reverting commit 166de3f1895d ("ath10k: remove supported chain mask").
>
> ip link set wlan0 down
> iw wlan0 set type monitor
> iw phy0 set antenna 7
> ip link set wlan0 up
>
> This issue is originally reported on qca9888 with 10.1 firmware.
>
> Fixes: 5572a95b4b ("ath10k: apply chainmask settings to vdev on creation")
> Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Applied, thanks for fixing this. I also CCed stable.

But I'm not actually sure if the "Fixes" lines implies "Cc stable"? I
think I saw one patch going into stable like that so I have been
wondering how this works. Does anyone know?

-- 
Kalle Valo