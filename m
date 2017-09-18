Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37324 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdIRIlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 04:41:10 -0400
Message-ID: <1505724068.13691.0.camel@sipsolutions.net> (sfid-20170918_104119_890217_954BB331)
Subject: Re: [PATCH 2/2] qtnfmac: abort scans on wireless interface changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Mon, 18 Sep 2017 10:41:08 +0200
In-Reply-To: <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com> (sfid-20170918_100515_833823_05EC3731)
References: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com>
         <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com>
         (sfid-20170918_100515_833823_05EC3731)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-09-18 at 11:04 +0300, Sergey Matyukevich wrote:
> 
>   */
>  static int qtnf_netdev_close(struct net_device *ndev)
>  {
> -	netif_carrier_off(ndev);
>  	qtnf_virtual_intf_cleanup(ndev);
>  	qtnf_netdev_updown(ndev, 0);
> +	netif_carrier_off(ndev);
>  	return 0;
>  }

This seems unrelated?

> -	if (timer_pending(&mac->scan_timeout))
> -		del_timer_sync(&mac->scan_timeout);
>  	qtnf_scan_done(mac, le32_to_cpu(status->flags) &
> QLINK_SCAN_ABORTED);

and that's related perhaps but not really explained in the changelog,
not sure?

johannes
