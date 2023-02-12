Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616DBC636D4
	for <linux-wireless@archiver.kernel.org>; Sun, 12 Feb 2023 15:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBLPtW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 12 Feb 2023 10:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBLPtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Feb 2023 10:49:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CDBEC5C;
        Sun, 12 Feb 2023 07:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4ENNKNgGMla2jgQ0hM3x3OTfeS7knIzg4lDu/hDJhGs=; b=pjaD8GgURVm2ZZeYXWXhmoy2N3
        PgbU+sjLUnirG2jKrbaQFSH451K0vx3vO8oAv1m4CJ1Sf4usvEi3CZcfPVXZuPIzW+7yLIMIcp2pe
        4/LfgR4XxkEcRUNhQwycLFHmE+QhcDQd3cako+wKpxYOGk79VKWGm3AcuJOxoD3gld6I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pREbJ-004lSF-1A; Sun, 12 Feb 2023 16:49:13 +0100
Date:   Sun, 12 Feb 2023 16:49:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Janne Grunau <j@jannau.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dt-bindings: wireless: bcm4329-fmac: Use
 network-class.yaml schema
Message-ID: <Y+kKeTBw/Vmap0MH@lunn.ch>
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
 <20230203-dt-bindings-network-class-v2-2-499686795073@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203-dt-bindings-network-class-v2-2-499686795073@jannau.net>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 12, 2023 at 01:16:30PM +0100, Janne Grunau wrote:
> The network-class schema specifies local-mac-address as used in the
> bcm4329-fmac device nodes of Apple silicon devices
> (arch/arm64/boot/dts/apple).
> Fixes `make dtbs_check` for those devices.

Maybe a more hierarchical approach would be better? Add a
wireless-controller.yaml which includes ieee80211.yaml and
network-class.yaml? It would then follow the structure of Ethernet
controllers, bluetooth controllers, and can controllers.

	Andrew
