Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:54415 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935003AbdCVTYO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 15:24:14 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: [PATCH 1/3] soc: qcom: smd: Transition client drivers from smd to
 rpmsg
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20170322.114439.679826829857326050.davem@davemloft.net>
Date: Wed, 22 Mar 2017 20:23:15 +0100
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>, arnd@arndb.de,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Message-Id: <21FCFC89-07EE-49EE-81C2-A138DD4C5F99@holtmann.org> (sfid-20170322_204006_728406_D16FFC8D)
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
 <20170322.114439.679826829857326050.davem@davemloft.net>
To: "David S. Miller" <davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

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
> 
> Just some questions since I'm supposed to merge this into my net-next
> tree.
> 
> What is the status of the Kconfig dependency fix and how will I be
> getting it?

I acked that one separately and added you:

[PATCH v2] Bluetooth: btqcomsmd: fix compile-test dependency

> Second, should I merge all three of these patches to net-next or just
> this one?

I think you have to take all 3 patches. Otherwise it will break.

Regards

Marcel
