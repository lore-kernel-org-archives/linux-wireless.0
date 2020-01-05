Return-Path: <SRS0=kXDB=22=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E753C33C9B
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 22:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14E6F21582
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 22:08:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="idZIs0K6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgAEWIq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 5 Jan 2020 17:08:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgAEWIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Jan 2020 17:08:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aEHWEEo6XrkuQmxbIi/VOLDO1KN+ijDmrPx0ATskWBA=; b=idZIs0K6tVwGiyWJKDRknZN0An
        cRoK7GkFfUEADbdBu9CL598ESka2Oin0LiGpIE4vWlU5iTY9VUTiavkoUe/iUb7Cbzm9MGMQv1lig
        XWKrMnskOLwxGWAliUaeS1KKZGFf94dkS4jFTQzTGVNZcgco3owQkWJkj/kCgA8ESaYc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioE4W-0000rJ-HB; Sun, 05 Jan 2020 23:08:32 +0100
Date:   Sun, 5 Jan 2020 23:08:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Francois Romieu <romieu@fr.zoreil.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 3/3] epic100: allow nesting of ethtool_ops
 begin() and complete()
Message-ID: <20200105220832.GA21914@lunn.ch>
References: <cover.1578257976.git.mkubecek@suse.cz>
 <146ace9856b8576eea83a1a5dc6329315831c44e.1578257976.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <146ace9856b8576eea83a1a5dc6329315831c44e.1578257976.git.mkubecek@suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> @@ -1435,8 +1436,10 @@ static int ethtool_begin(struct net_device *dev)
>  	struct epic_private *ep = netdev_priv(dev);
>  	void __iomem *ioaddr = ep->ioaddr;
>  
> +	if (ep->ethtool_ops_nesting == U32_MAX)
> +		return -EBUSY;
>  	/* power-up, if interface is down */
> -	if (!netif_running(dev)) {
> +	if (ep->ethtool_ops_nesting++ && !netif_running(dev)) {
>  		ew32(GENCTL, 0x0200);
>  		ew32(NVCTL, (er32(NVCTL) & ~0x003c) | 0x4800);
>  	}

Hi Michal

In the via-velocity you added:

+       if (vptr->ethtool_ops_nesting == U32_MAX)
+               return -EBUSY;
+       if (!vptr->ethtool_ops_nesting++ && !netif_running(dev))
                velocity_set_power_state(vptr, PCI_D0);
        return 0;

These two fragments differ by a ! . Is that correct?

      Andrew
