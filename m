Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35828 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751588AbdCVV43 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 17:56:29 -0400
Received: by mail-oi0-f47.google.com with SMTP id a94so56081986oic.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 14:56:28 -0700 (PDT)
Date: Wed, 22 Mar 2017 16:56:27 -0500
From: Andy Gross <andy.gross@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: bjorn.andersson@linaro.org, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com, k.eugene.e@gmail.com,
        kvalo@codeaurora.org, david.brown@linaro.org, arnd@arndb.de,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] soc: qcom: smd: Transition client drivers from smd
 to rpmsg
Message-ID: <20170322215627.GD22585@hector.attlocal.net> (sfid-20170322_225813_771416_743B5836)
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
 <20170322.114439.679826829857326050.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170322.114439.679826829857326050.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 22, 2017 at 11:44:39AM -0700, David Miller wrote:
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
> Second, should I merge all three of these patches to net-next or just
> this one?

David,
I ack'd all three.  Please take these through your tree.


Bjorn,
Are we going to need an immutable branch or tag for sychronizing work?

Regards,

Andy Gross
