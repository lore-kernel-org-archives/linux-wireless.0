Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:10067 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751169AbdHQGtp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 02:49:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [2/6] ath10k: refactor firmware crashdump code to coredump.c
Date: Thu, 17 Aug 2017 06:49:40 +0000
Message-ID: <87378q664c.fsf@kamboji.qca.qualcomm.com> (sfid-20170817_084949_032241_343D7FF7)
References: <150278538298.22482.10986802411848917689.stgit@potku.adurom.net>
        <ec54c0ff3af546d2a52d75428c38d06b@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <ec54c0ff3af546d2a52d75428c38d06b@euamsexm01a.eu.qualcomm.com>
        (Kalle Valo's message of "Thu, 17 Aug 2017 06:20:02 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>> In preparation to add RAM dump support. No functional changes, only movi=
ng code
>> and renaming function names.
>>=20
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> With only this patch applied, and CONFIG_DEV_COREDUMP disabled, there's a=
 build error:
>
> drivers/net/wireless/ath/ath10k/coredump.c:24:30: error: redefinition
> of 'ath10k_coredump_new'
> drivers/net/wireless/ath/ath10k/coredump.c:130:5: error: redefinition
> of 'ath10k_coredump_submit'

Fixed in pending branch like this:

--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -20,7 +20,7 @@ ath10k_core-$(CONFIG_ATH10K_TRACING) +=3D trace.o
 ath10k_core-$(CONFIG_THERMAL) +=3D thermal.o
 ath10k_core-$(CONFIG_MAC80211_DEBUGFS) +=3D debugfs_sta.o
 ath10k_core-$(CONFIG_PM) +=3D wow.o
-ath10k_core-$(CONFIG_ATH10K_DEBUGFS) +=3D coredump.o
+ath10k_core-$(CONFIG_DEV_COREDUMP) +=3D coredump.o

--=20
Kalle Valo=
