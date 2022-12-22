Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41942C4332F
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Dec 2022 13:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLVNjK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Dec 2022 08:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLVNjJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2022 08:39:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC021CEF;
        Thu, 22 Dec 2022 05:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C12F61B87;
        Thu, 22 Dec 2022 13:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDDAC433F0;
        Thu, 22 Dec 2022 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671716346;
        bh=yS7HKNuyi7mY2vch1fKOPIjO+678P8Ts9QJUAtVHVBE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YCZzIJDK/CbHqh5WsE5tCSYjVyfSElNxBjqOHJzJo5obHknTKNaQgMmInFe5pHiO+
         ChholLIBSfN/Lcu7esTRH2qcqAm9h4/GUhNjo7rlntIQZ4WDxbqGN3M0jbXwIoX1/R
         HMU2rfifrs+kISxPGE+F5GbuGDYvabnQrbt8rZiP2MHU8WQxCcHFRHJmIV9ARK72AE
         W0igAHGegXVeh2lWb0t/lds4Cd/mIt0iak57ECyghrNe6dte5DpxMlV6dMlY+V/cSq
         qJX81nDMLDBFJ7jquAQ9H2p/Xl9fv+mL63xgBoEC1Ba7/5+lEhCQYg52KR5nmQliOm
         76TafiCWRM5vA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Youghandhar Chintala <quic_youghand@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_mpubbise@quicinc.com>, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] wifi: ath10k: update the channel list if change in channel flags.
References: <20221222120529.31436-1-quic_youghand@quicinc.com>
        <20221222120529.31436-3-quic_youghand@quicinc.com>
Date:   Thu, 22 Dec 2022 15:38:59 +0200
In-Reply-To: <20221222120529.31436-3-quic_youghand@quicinc.com> (Youghandhar
        Chintala's message of "Thu, 22 Dec 2022 17:35:29 +0530")
Message-ID: <87sfh7zhfw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Youghandhar Chintala <quic_youghand@quicinc.com> writes:

> There are connection failures in hidden SSID case when the device is
> with default reg domain WW.
> For WW reg domain most of the 5 GHz channels are passive. When device
> listens to the beacon on that channel, the driver is updating its
> channel flag but firmware is not aware of it and firmware is not
> sending probes on that channels.
> Due to this, we are seeing connection failures when a device is trying
> to connect with hidden SSID AP.
> Register beacon hint notifier to the regulatory core so that driver get
> notified when there is a change in channel flags. Driver's notifier
> callback will send the updated flags to the firmware.
>
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00174
>
> Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 11 +++++++++++

Please send ath10k patches to the ath10k list. I added that list now,
but no need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
