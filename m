Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7249 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967338AbeCAKNn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:13:43 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [PATCH 01/13] ath10k: platform driver for WCN3990 SNOC WLAN
 module
Date: Thu, 1 Mar 2018 10:13:35 +0000
Message-ID: <d396df1b09da4dd7aa14d6af2c2b2b18@aphydexm01b.ap.qualcomm.com> (sfid-20180301_111349_682595_65433EBC)
References: <1518684458-5338-1-git-send-email-govinds@codeaurora.org>
 <87371kqfda.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87371kqfda.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I didn't encountered this issue as in my defconfig only CONFIG_ATH10K_SNOC =
was defined.
This problem is coming when we define CONFIG_ATH10K_SNOC and CONFIG_ATH10K_=
PCI simultaneously in defconfig and this is=20
known issue when multiple modules share objects(in this case ce.o). I saw s=
imilar reported problem and found https://patchwork.kernel.org/patch/100608=
25/.

After picking the below change issue is not seen.

BR,
Govind

-----Original Message-----
From: ath10k [mailto:ath10k-bounces@lists.infradead.org] On Behalf Of Kalle=
 Valo
Sent: Thursday, March 1, 2018 3:37 PM
To: Govind Singh <govinds@codeaurora.org>
Cc: linux-wireless@vger.kernel.org; ath10k@lists.infradead.org
Subject: Re: [PATCH 01/13] ath10k: platform driver for WCN3990 SNOC WLAN mo=
dule

Govind Singh <govinds@codeaurora.org> writes:

> WCN3990 is integrated 802.11ac chipset with SNOC bus interface. Add=20
> snoc layer driver registration and associated ops.
>
> WCN3990 support is not yet complete as cold-boot handshake is done=20
> using qmi(Qualcomm-MSM-Interface) and qmi client support will be added=20
> once qmi framework is available.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>

Kbuild bot found an odd problem with this patch:

 include/linux/dynamic_debug.h:77:14: error: 'KBUILD_MODNAME'
 undeclared (first use in this function); did you mean  'KBUILD_BASENAME'?

Full report:

http://lists.infradead.org/pipermail/ath10k/2018-February/010907.html

Any ideas? Is this is some unrelated issue or what? This patch is not even =
touching hif.h or ce.c.

--
Kalle Valo

_______________________________________________
ath10k mailing list
ath10k@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/ath10k
