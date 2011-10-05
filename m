Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:44123 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934227Ab1JETJm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 15:09:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Yogesh Powar <yogeshp@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 5 Oct 2011 12:08:36 -0700
Subject: RE: mwifiex: add cfg80211 handlers add/del_virtual_intf
Message-ID: <477F20668A386D41ADCC57781B1F70430815597445@SC-VEXCH1.marvell.com> (sfid-20111005_210945_726441_B6C9AC7A)
References: <20111005060744.GB32513@elgon.mountain>
In-Reply-To: <20111005060744.GB32513@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for your comment.

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, October 04, 2011 11:08 PM
> To: Yogesh Powar
> Cc: Bing Zhao; linux-wireless@vger.kernel.org
> Subject: re: mwifiex: add cfg80211 handlers add/del_virtual_intf
> 
> Hi Yogesh,
> 
> The Smatch static checker complains that 93a1df48d22429 "mwifiex: add
> cfg80211 handlers add/del_virtual_intf" introduces a potential NULL
> dereference.
> 
> @@ -985,9 +817,20 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
>                        atomic_read(&adapter->cmd_pending));
>         }
> 
> -       /* Remove interface */
> -       for (i = 0; i < adapter->priv_num; i++)
> -               mwifiex_remove_interface(adapter, i);
> +       for (i = 0; i < adapter->priv_num; i++) {
> +               priv = adapter->priv[i];
> +
> +               if (!priv)
> +                       continue;
> +
> +               rtnl_lock();
> +               mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
> +               rtnl_unlock();
> +       }
> +
> +       wiphy_unregister(priv->wdev->wiphy);
>                          ^^^^^^^^^^
> Can priv be NULL here?  How do we know that the last element of
> adapter->priv[]; is non-NULL when we have to check the others?

That's a good catch.

Since the first element of priv[] cannot be NULL. How about this fix?

+       priv = adapter->priv[0];
+       BUG_ON(!priv);
+
        wiphy_unregister(priv->wdev->wiphy);

Thanks,
Bing

> 
> regards,
> dan carpenter
