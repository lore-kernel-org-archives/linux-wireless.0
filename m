Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754010AbdCWCXm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 22:23:42 -0400
Date: Wed, 22 Mar 2017 19:23:04 -0700 (PDT)
Message-Id: <20170322.192304.1068066587902221771.davem@davemloft.net> (sfid-20170323_032402_818855_7BFF5B35)
To: marcel@holtmann.org
Cc: bjorn.andersson@linaro.org, gustavo@padovan.org,
        johan.hedberg@gmail.com, k.eugene.e@gmail.com,
        kvalo@codeaurora.org, andy.gross@linaro.org,
        david.brown@linaro.org, arnd@arndb.de,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] soc: qcom: smd: Transition client drivers from smd
 to rpmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <21FCFC89-07EE-49EE-81C2-A138DD4C5F99@holtmann.org>
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
        <20170322.114439.679826829857326050.davem@davemloft.net>
        <21FCFC89-07EE-49EE-81C2-A138DD4C5F99@holtmann.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcel Holtmann <marcel@holtmann.org>
Date: Wed, 22 Mar 2017 20:23:15 +0100

> Hi Dave,
> 
>>> By moving these client drivers to use RPMSG instead of the direct SMD
>>> API we can reuse them ontop of the newly added GLINK wire-protocol
>>> support found in the 820 and 835 Qualcomm platforms.
>>> 
>>> As the new (RPMSG-based) and old SMD implementations are mutually
>>> exclusive we have to change all client drivers in one commit, to make
>>> sure we have a working system before and after this transition.
>>> 
>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>>> ---
>>> 
>>> Based on v4.11-rc3 with Arnd's Kconfig dependency fixes for BT_QCOMSMD
>>> (https://lkml.org/lkml/2017/3/20/1038).
>> 
>> Just some questions since I'm supposed to merge this into my net-next
>> tree.
>> 
>> What is the status of the Kconfig dependency fix and how will I be
>> getting it?
> 
> I acked that one separately and added you:
> 
> [PATCH v2] Bluetooth: btqcomsmd: fix compile-test dependency

I applied this to my 'net' tree, thanks.
