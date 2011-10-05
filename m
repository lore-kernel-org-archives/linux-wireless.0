Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:28801 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858Ab1JEGHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 02:07:53 -0400
Date: Wed, 5 Oct 2011 09:07:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org
Subject: re: mwifiex: add cfg80211 handlers add/del_virtual_intf
Message-ID: <20111005060744.GB32513@elgon.mountain> (sfid-20111005_080756_874227_E45CE90D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yogesh,

The Smatch static checker complains that 93a1df48d22429 "mwifiex: add
cfg80211 handlers add/del_virtual_intf" introduces a potential NULL
dereference.

@@ -985,9 +817,20 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
                       atomic_read(&adapter->cmd_pending));
        }

-       /* Remove interface */
-       for (i = 0; i < adapter->priv_num; i++)
-               mwifiex_remove_interface(adapter, i);
+       for (i = 0; i < adapter->priv_num; i++) {
+               priv = adapter->priv[i];
+
+               if (!priv)
+                       continue;
+
+               rtnl_lock();
+               mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
+               rtnl_unlock();
+       }
+
+       wiphy_unregister(priv->wdev->wiphy);
                         ^^^^^^^^^^
Can priv be NULL here?  How do we know that the last element of
adapter->priv[]; is non-NULL when we have to check the others?

regards,
dan carpenter
