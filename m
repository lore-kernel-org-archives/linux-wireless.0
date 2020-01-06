Return-Path: <SRS0=OLg+=23=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EFFC32771
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 06:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E27D215A4
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 06:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgAFGIz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Jan 2020 01:08:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:37024 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgAFGIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Jan 2020 01:08:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 40CA6AC46;
        Mon,  6 Jan 2020 06:08:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 53217E048A; Mon,  6 Jan 2020 07:08:51 +0100 (CET)
Date:   Mon, 6 Jan 2020 07:08:51 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Francois Romieu <romieu@fr.zoreil.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 3/3] epic100: allow nesting of ethtool_ops
 begin() and complete()
Message-ID: <20200106060851.GE22387@unicorn.suse.cz>
References: <cover.1578257976.git.mkubecek@suse.cz>
 <146ace9856b8576eea83a1a5dc6329315831c44e.1578257976.git.mkubecek@suse.cz>
 <20200105220832.GA21914@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200105220832.GA21914@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Jan 05, 2020 at 11:08:32PM +0100, Andrew Lunn wrote:
> > @@ -1435,8 +1436,10 @@ static int ethtool_begin(struct net_device *dev)
> >  	struct epic_private *ep = netdev_priv(dev);
> >  	void __iomem *ioaddr = ep->ioaddr;
> >  
> > +	if (ep->ethtool_ops_nesting == U32_MAX)
> > +		return -EBUSY;
> >  	/* power-up, if interface is down */
> > -	if (!netif_running(dev)) {
> > +	if (ep->ethtool_ops_nesting++ && !netif_running(dev)) {
> >  		ew32(GENCTL, 0x0200);
> >  		ew32(NVCTL, (er32(NVCTL) & ~0x003c) | 0x4800);
> >  	}
> 
> Hi Michal
> 
> In the via-velocity you added:
> 
> +       if (vptr->ethtool_ops_nesting == U32_MAX)
> +               return -EBUSY;
> +       if (!vptr->ethtool_ops_nesting++ && !netif_running(dev))
>                 velocity_set_power_state(vptr, PCI_D0);
>         return 0;
> 
> These two fragments differ by a ! . Is that correct?

You are right, thank you for catching it. This should be 

	if (!ep->ethtool_ops_nesting++ && !netif_running(dev)) {

as well, we only want to wake the device up in the first (outermost)
->begin(). (It would probably do no harm to do it each time but not
doing it in the first would be wrong.)

I'll send v2 in a moment.

Michal
