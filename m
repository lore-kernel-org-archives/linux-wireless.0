Return-Path: <SRS0=dXk9=TI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EB8C04AAD
	for <linux-wireless@archiver.kernel.org>; Wed,  8 May 2019 11:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4B020989
	for <linux-wireless@archiver.kernel.org>; Wed,  8 May 2019 11:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="h8uS09r9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfEHLtO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 May 2019 07:49:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58456 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbfEHLtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 May 2019 07:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cHXDOAI/sb7qYnc/OEjR9OhWCqVE0yCfcRGxBY6Z0kM=; b=h8uS09r9tHqr1dIZuU0P8ieTGe
        Ay1aINmssQ22D65almIb0CMh4ccZ/IMgFRgo9OQ6OYSW99xZIJ0fo2q/z0cPr91eBvnC1lYJOCvWq
        WOW8e5cl83tFaLwLbOJNROmkMjhu94vfmmL/MW+c5/reEcIyC7Luq/WWsrG1aWDhTAp4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOL46-0000iQ-Vo; Wed, 08 May 2019 13:48:50 +0200
Date:   Wed, 8 May 2019 13:48:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Rob Herring <robh+dt@kernel.org>, netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v4 02/10] dt-bindings: doc: reflect new NVMEM
 of_get_mac_address behaviour
Message-ID: <20190508114850.GC30557@lunn.ch>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
 <1556893635-18549-3-git-send-email-ynezz@true.cz>
 <CAL_JsqLt6UFU_6bmh3Pc0taXUgMtAEV7kL7eZU13cLOjoakf=Q@mail.gmail.com>
 <20190508084152.GM81826@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508084152.GM81826@meh.true.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> I've just tried to reword what was already there, anyway, did I understood
> your remark properly, would this be more appropriate?
> 
>  The MAC address will be determined using the optional properties defined in
>  ethernet.txt and only if efuse-mac is set to 0. If any of the optional MAC
>  address properties are not present, then the driver will use random MAC
>  address.

If _all_ of the optional ...

   Andrew
