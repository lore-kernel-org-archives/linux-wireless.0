Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33694 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdCVV5i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 17:57:38 -0400
Received: by mail-pf0-f174.google.com with SMTP id o190so15208400pfo.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 14:57:37 -0700 (PDT)
Date: Wed, 22 Mar 2017 14:57:33 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        k.eugene.e@gmail.com, kvalo@codeaurora.org, andy.gross@linaro.org,
        david.brown@linaro.org, arnd@arndb.de,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] soc: qcom: smd: Transition client drivers from smd
 to rpmsg
Message-ID: <20170322215733.GH20094@minitux> (sfid-20170322_225814_830696_C247A629)
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
 <20170322.114439.679826829857326050.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170322.114439.679826829857326050.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 22 Mar 11:44 PDT 2017, David Miller wrote:

> From: Bjorn Andersson <bjorn.andersson@linaro.org>
> Date: Mon, 20 Mar 2017 16:35:42 -0700
> 
> > By moving these client drivers to use RPMSG instead of the direct SMD
> > API we can reuse them ontop of the newly added GLINK wire-protocol
> > support found in the 820 and 835 Qualcomm platforms.
> > 
> > As the new (RPMSG-based) and old SMD implementations are mutually
> > exclusive we have to change all client drivers in one commit, to make
> > sure we have a working system before and after this transition.
> > 
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> > 
> > Based on v4.11-rc3 with Arnd's Kconfig dependency fixes for BT_QCOMSMD
> > (https://lkml.org/lkml/2017/3/20/1038).
> 
> Just some questions since I'm supposed to merge this into my net-next
> tree.
> 
> What is the status of the Kconfig dependency fix and how will I be
> getting it?
> 

There are two Kconfig dependencies in play here, the first is
c3104aae5d8c ("remoteproc: qcom: fix QCOM_SMD dependencies"), this was
picked up by Linus yesterday and will as such be in v4.10-rc4.

The other dependency, is the one Marcel wants you to pick up here is
https://patchwork.kernel.org/patch/9635385/. It's on LKML, but if you
want I can resend it with you as direct recipient, with Marcel's ack.

Likely Arnd would like this fix to be sent upstream for v4.11 already.

> Second, should I merge all three of these patches to net-next or just
> this one?
> 

I would like all three to be merged in this cycle and in addition I have
a couple of patches coming up that will cause some minor conflicts with
patch 2 - so I would prefer if patch 2 was available in a tag I can
merge into my tree.

Would it be possible for you to prepare merge all 4 (these 3 and the
bluetooth fix) and prepare a tag for Andy, Marcel and myself to include
in our trees?

Regards,
Bjorn
