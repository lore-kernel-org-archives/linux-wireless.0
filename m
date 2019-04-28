Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE66C43218
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 16:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63F8E206BB
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 16:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="1E1ztWBv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfD1Qxv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Apr 2019 12:53:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47381 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbfD1Qxv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Apr 2019 12:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cRMd8mueGQjf3u9Ez32aIcf72f+Jx2olgX7/QRk0Jr8=; b=1E1ztWBvomZnvKFV+Oeb5y2OcO
        Bpc/PetqYR0pYDGHQitn0xdRSySMdTKgJk6OnpFmXMqNDmDniFTuUXyxNLxqJtypiWSNowTRvFzsF
        79dvP93+AwqQgUhxDcfh6xM+JQcDfAApsJ3rNvb8/RciAFp7MzdZW0QXd3hQtNvDiMkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hKn3O-0000uS-PY; Sun, 28 Apr 2019 18:53:26 +0200
Date:   Sun, 28 Apr 2019 18:53:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
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
        Alban Bedel <albeu@free.fr>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 2/4] dt-bindings: doc: Reflect new NVMEM
 of_get_mac_address behaviour
Message-ID: <20190428165326.GI23059@lunn.ch>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-3-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1556456002-13430-3-git-send-email-ynezz@true.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Apr 28, 2019 at 02:53:20PM +0200, Petr Štetiar wrote:
> As of_get_mac_address now supports NVMEM under the hood, we need to update
> the bindings documentation with the new nvmem-cell* properties, which would
> mean copy&pasting a lot of redundant information to every binding
> documentation currently referencing some of the MAC address properties.
> 
> So I've just removed all the references to the optional MAC address
> properties and replaced them with the reference to the net/ethernet.txt
> file.  While at it, I've also removed other optional Ethernet properties.

Hi Petr

I think each individual binding needs to give a hint if
of_get_mac_address() is used, and hence if these optional properties
are respected. The same is true for other optional properties. I don't
want to have to look at the driver to know which optional properties
are implemented, the binding should tell me. What the optional
properties mean, and which order they are used in can then be defined
in ethernet.txt.

So i would suggests something like:

The MAC address will be determined using the optional properties
defined in ethernet.txt.

And leave all the other optional parameters in the bindings.

	Andrew
