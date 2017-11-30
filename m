Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:5479 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdK3FzZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 00:55:25 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Peter Oh <peter.oh@bowerswilkins.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: RE: [PATCH] ath10k: unify rx processing in napi_poll
Date: Thu, 30 Nov 2017 05:55:23 +0000
Message-ID: <b4d1ec9afff447fc92d92645a4273222@NALASEXR01H.na.qualcomm.com> (sfid-20171130_065535_266570_B0C04E21)
References: <1511991212-4837-1-git-send-email-rmanohar@qti.qualcomm.com>
 <01899b3e-15c5-4f23-5c3c-86b23a0a9451@bowerswilkins.com>
In-Reply-To: <01899b3e-15c5-4f23-5c3c-86b23a0a9451@bowerswilkins.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm wondering if this patch is related to kernel crash due to ath10k napi=
.
>=20
> Do you think this patch helps the crash below?
>=20
> This crash happened ath10k v4.14 (10/04/2017, commit id c09dbd7) +
> 3.14.43 kernel backports.
>=20
> [ 6866.655419] ------------[ cut here ]------------
> [ 6866.659029] kernel BUG at /net/core/dev.c:4301!
> [ 6866.666404] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
> [ 6866.672206] Modules linked in: asix essedma qca_ssdk ath9k
>
This change solves WARN_ON_ONCE in napi_poll.=20
WARNING: CPU: 0 PID: 7 at ../net/core/dev.c:5274=20

Im not sure about BUG_ON that you mentioned. Feel free to verify the change=
.

-Rajkumar
