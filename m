Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46656 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750736AbdCNWTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 18:19:32 -0400
Message-ID: <1489529967.10872.16.camel@sipsolutions.net> (sfid-20170314_231935_637157_B95B1FB7)
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network
 namespace
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Mark Asselstine <mark.asselstine@windriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 14 Mar 2017 23:19:27 +0100
In-Reply-To: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170314_225203_353339_3E88A6E0)
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com>
         (sfid-20170314_225203_353339_3E88A6E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-14 at 21:51 +0000, Arend van Spriel wrote:
> To support network namespace the driver must assure all created
> network interfaces are in the same namespace as the wiphy instance.

FWIW, looks fine to me.

>  	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
> +	wiphy = cfg_to_wiphy(drvr->config);
> +	dev_net_set(ndev, wiphy_net(wiphy));

You (almost?) don't need the wiphy variable :)

johannes
