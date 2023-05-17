Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A605DC7EE2C
	for <linux-wireless@archiver.kernel.org>; Wed, 17 May 2023 11:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjEQLFQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 May 2023 07:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjEQLE4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2023 07:04:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FC9658E;
        Wed, 17 May 2023 04:04:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793E963B0C;
        Wed, 17 May 2023 11:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E08C433A1;
        Wed, 17 May 2023 11:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684321445;
        bh=tR3qS12+MUYmkZK6jLAcuvivmBsfJSWs1iLgSwCi8fY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Q6w2br9fnsK/saD7J/nbmuE4MtaDXepq8RRZpSubF96Trnm6BvliJeDLqoVyWp+8z
         egyinTUw3TEb4Y0N8JqJj19LLSGRYy8AwmGRHsov8tnU7aYGwUAXMoOD/7ZOxJ1Jn2
         sIBxxCFFMzvMJYG1uWo5JZR1i2U6GBQdoW0xx/9JOt+ZgA96vEljgHPYz+ZJEcW3iZ
         Pz1tXLN2HjdWaBEuYzPqNICJAGHli8WhH5+0PKIkpAb5t5/Tj8p0aoiIqZ2c6AZlox
         gvjjVTQRDDlvr2prU1hIAtj7QPMX8jgFBRFhd0SGyfMKEtS8mNuV1RdNiuOY6Xnj4U
         v2nQnGG9XAu1Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 8/9] wifi: ath12k: Use RMW accessors for changing LNKCTL
References: <20230517105235.29176-1-ilpo.jarvinen@linux.intel.com>
        <20230517105235.29176-9-ilpo.jarvinen@linux.intel.com>
Date:   Wed, 17 May 2023 14:03:57 +0300
In-Reply-To: <20230517105235.29176-9-ilpo.jarvinen@linux.intel.com> ("Ilpo
        \=\?utf-8\?Q\?J\=C3\=A4rvinen\=22's\?\= message of "Wed, 17 May 2023 13:52:34
 +0300")
Message-ID: <871qjfmd7m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com> writes:

> Don't assume that only the driver would be accessing LNKCTL. ASPM
> policy changes can trigger write to LNKCTL outside of driver's control.
>
> Use RMW capability accessors which do proper locking to avoid losing
> concurrent updates to the register value. On restore, clear the ASPMC
> field properly.
>
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> Cc: stable@vger.kernel.org

Acked-by: Kalle Valo <kvalo@kernel.org>

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
