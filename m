Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:54065 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727633AbeITPkE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 11:40:04 -0400
Message-ID: <6e925b2021d5fbc59f1933d37a1deb1332ede752.camel@perches.com> (sfid-20180920_115726_764260_1659902B)
Subject: Re: [PATCH v2 28/29] staging: wilc1000: avoid spaces preferred
 around checkpatch issue
From: Joe Perches <joe@perches.com>
To: Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date: Thu, 20 Sep 2018 02:57:21 -0700
In-Reply-To: <1537424620-6982-29-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
         <1537424620-6982-29-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-20 at 11:53 +0530, Ajay Singh wrote:
> Cleanup patch to add extra spaces around the '/' to avoid the below
> checkpatch warning.
> 
> 'spaces preferred around that '/' (ctx:VxV)'
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 695d5b2..29c1317 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -823,7 +823,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
>  
>  	netdev_for_each_mc_addr(ha, dev) {
>  		memcpy(mc_list + i, ha->addr, ETH_ALEN);
> -		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i/ETH_ALEN,
> +		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i / ETH_ALEN,
>  			   mc_list[i], mc_list[i + 1], mc_list[i + 2],
>  			   mc_list[i + 3], mc_list[i + 4], mc_list[i + 5]);
>  		i += ETH_ALEN;

Probably better using the vsprintf %pM extension:

	netdev_dbg(dev, Entry[%d]: %pM\n", i / ETH_ALEN, mc_list + i);

though I would also suggest using another temporary
pointer instead of an offset and divisions.

Something like:

o use kmalloc_array
o remove unnecessary res
o add u8 *cur_mc
o use i as index

---
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 49afda669393..2b4c92319507 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -802,9 +802,9 @@ static void wilc_set_multicast_list(struct net_device *dev)
 {
 	struct netdev_hw_addr *ha;
 	struct wilc_vif *vif = netdev_priv(dev);
-	int i = 0;
+	int i;
 	u8 *mc_list;
-	int res;
+	u8 *cur_mc;
 
 	if (dev->flags & IFF_PROMISC)
 		return;
@@ -820,20 +820,20 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		return;
 	}
 
-	mc_list = kmalloc(dev->mc.count * ETH_ALEN, GFP_KERNEL);
+	mc_list = kmalloc_array(dev->mc.count, ETH_ALEN, GFP_KERNEL);
 	if (!mc_list)
 		return;
 
+	cur_mc = mc_list;
+	i = 0;
 	netdev_for_each_mc_addr(ha, dev) {
-		memcpy(mc_list + i, ha->addr, ETH_ALEN);
-		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i/ETH_ALEN,
-			   mc_list[i], mc_list[i + 1], mc_list[i + 2],
-			   mc_list[i + 3], mc_list[i + 4], mc_list[i + 5]);
-		i += ETH_ALEN;
+		memcpy(cur_mc, ha->addr, ETH_ALEN);
+		netdev_dbg(dev, "Entry[%d]: %pM\n", i, cur_mc);
+		i++;
+		cur_mc += ETH_ALEN;
 	}
 
-	res = wilc_setup_multicast_filter(vif, true, dev->mc.count, mc_list);
-	if (res)
+	if (wilc_setup_multicast_filter(vif, true, dev->mc.count, mc_list))
 		kfree(mc_list);
 }
 
