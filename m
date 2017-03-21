Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756305AbdCUMRN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 08:17:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list\:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] soc: qcom: smd: Transition client drivers from smd to rpmsg
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
        <3DCEF38C-F8FC-4941-936F-921247E13B78@holtmann.org>
Date: Tue, 21 Mar 2017 14:17:02 +0200
In-Reply-To: <3DCEF38C-F8FC-4941-936F-921247E13B78@holtmann.org> (Marcel
        Holtmann's message of "Tue, 21 Mar 2017 09:20:01 +0100")
Message-ID: <87zige6czl.fsf@kamboji.qca.qualcomm.com> (sfid-20170321_131751_150003_B39F22D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

>> By moving these client drivers to use RPMSG instead of the direct SMD
>> API we can reuse them ontop of the newly added GLINK wire-protocol
>> support found in the 820 and 835 Qualcomm platforms.
>> 
>> As the new (RPMSG-based) and old SMD implementations are mutually
>> exclusive we have to change all client drivers in one commit, to make
>> sure we have a working system before and after this transition.
>> 
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> ---
>> 
>> Based on v4.11-rc3 with Arnd's Kconfig dependency fixes for BT_QCOMSMD
>> (https://lkml.org/lkml/2017/3/20/1038).
>> 
>> drivers/bluetooth/Kconfig                  |  2 +-
>> drivers/bluetooth/btqcomsmd.c              | 32 +++++++++----------
>> drivers/net/wireless/ath/wcn36xx/Kconfig   |  2 +-
>> drivers/net/wireless/ath/wcn36xx/main.c    |  6 ++--
>> drivers/net/wireless/ath/wcn36xx/smd.c     | 10 +++---
>> drivers/net/wireless/ath/wcn36xx/smd.h     |  6 ++--
>> drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  2 +-
>> drivers/soc/qcom/Kconfig                   |  4 +--
>> drivers/soc/qcom/smd-rpm.c                 | 43 +++++++++++++------------
>> drivers/soc/qcom/wcnss_ctrl.c              | 50 +++++++++++++++++-------------
>> include/linux/soc/qcom/wcnss_ctrl.h        | 11 ++++---
>> net/qrtr/Kconfig                           |  2 +-
>> net/qrtr/smd.c                             | 42 ++++++++++++-------------
>> 13 files changed, 108 insertions(+), 104 deletions(-)
>
> I think that it is best if Dave takes these directly then and I pull
> them back down later into our trees. Including the Kconfig fix that I
> will ACK as well.
>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

Sounds good to me.

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
