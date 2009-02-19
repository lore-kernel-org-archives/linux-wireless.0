Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59508 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZBSS3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 13:29:33 -0500
Message-ID: <499DA503.4070404@hauke-m.de> (sfid-20090219_192953_739304_7AAF4B42)
Date: Thu, 19 Feb 2009 19:29:23 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-2.6: compat.diff update for master-2009-02-18 wireless-testing.
Content-Type: multipart/mixed;
 boundary="------------040804030308010804020208"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040804030308010804020208
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Luis,

this patch makes compat-wireless work with the latest wireless-testing
again.
It also adds the at76c50x-usb driver.
I tested b43 with kernel 2.6.27 and rtl8187 with kernel 2.6.29-rc5.

--
Hauke

--------------040804030308010804020208
Content-Type: text/x-diff;
 name="0001-compat-wireless-compat.diff-update-for-master-2009.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0001-compat-wireless-compat.diff-update-for-master-2009.patc";
 filename*1="h"

=46rom 1bc134361dd56726fa3c9dfaeee2d59aa61f8a0d Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Thu, 19 Feb 2009 18:24:32 +0100
Subject: [PATCH] compat-wireless: compat.diff update for master-2009-02-1=
8 wireless-testing.
 Revert commit 65949939dd23bcde83dc0fa56dd5932eda38c050 in wireless-testi=
ng for kernels older than 2.6.30.
 Add at76c50x-usb driver.

---
 Makefile                |   16 +-
 compat/compat.diff      |  513 +++++++++++++++++++++++++++++++++++++++++=
++++--
 config.mk               |   11 +-
 scripts/admin-update.sh |    5 +-
 4 files changed, 509 insertions(+), 36 deletions(-)

diff --git a/Makefile b/Makefile
index 95b404b..4b0a7e5 100644
--- a/Makefile
+++ b/Makefile
@@ -104,14 +104,16 @@ install: uninstall modules
 	@$(MODPROBE) -l cfg80211
 	@$(MODPROBE) -l lib80211
 	@$(MODPROBE) -l adm8211
-	@$(MODPROBE) -l at76_usb
+	@$(MODPROBE) -l at76c50x-usb
 	@$(MODPROBE) -l ath5k
 	@$(MODPROBE) -l ath9k
 	@$(MODPROBE) -l b43
 	@$(MODPROBE) -l b43legacy
+	@$(MODPROBE) -l b44
 	@$(MODPROBE) -l ssb
+	@$(MODPROBE) -l rc80211_simple
+	@$(MODPROBE) -l iwlcore
 	@$(MODPROBE) -l iwl3945
-	@$(MODPROBE) -l iwl4965
 	@$(MODPROBE) -l iwlagn
 	@$(MODPROBE) -l ipw2100
 	@$(MODPROBE) -l ipw2200
@@ -122,8 +124,8 @@ install: uninstall modules
 	@$(MODPROBE) -l libertas_tf
 	@$(MODPROBE) -l libertas_tf_usb
 	@$(MODPROBE) -l ub8xxx
-	@$(MODPROBE) -l p54_pci
-	@$(MODPROBE) -l p54_usb
+	@$(MODPROBE) -l p54pci
+	@$(MODPROBE) -l p54usb
 	@$(MODPROBE) -l rt2400pci
 	@$(MODPROBE) -l rt2500pci
 	@$(MODPROBE) -l rt2500usb
@@ -164,15 +166,16 @@ uninstall:
 	@$(MODPROBE) -l cfg80211
 	@$(MODPROBE) -l lib80211
 	@$(MODPROBE) -l adm8211
+	@$(MODPROBE) -l at76c50x-usb
 	@$(MODPROBE) -l ath5k
 	@$(MODPROBE) -l ath9k
-	@$(MODPROBE) -l at76_usb
 	@$(MODPROBE) -l b43
 	@$(MODPROBE) -l b43legacy
+	@$(MODPROBE) -l b44
 	@$(MODPROBE) -l ssb
 	@$(MODPROBE) -l rc80211_simple
+	@$(MODPROBE) -l iwlcore
 	@$(MODPROBE) -l iwl3945
-	@$(MODPROBE) -l iwl4965
 	@$(MODPROBE) -l iwlagn
 	@$(MODPROBE) -l ipw2100
 	@$(MODPROBE) -l ipw2200
@@ -182,7 +185,6 @@ uninstall:
 	@$(MODPROBE) -l libertas_cs
 	@$(MODPROBE) -l libertas_tf
 	@$(MODPROBE) -l libertas_tf_usb
-	@$(MODPROBE) -l mac80211
 	@$(MODPROBE) -l ub8xxx
 	@$(MODPROBE) -l p54pci
 	@$(MODPROBE) -l p54usb
diff --git a/compat/compat.diff b/compat/compat.diff
index 1b93356..ce98e63 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -93,25 +93,25 @@ diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
 index a0c860f..9c6f214 100644
 --- a/net/mac80211/wme.c
 +++ b/net/mac80211/wme.c
-@@ -124,6 +124,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
+@@ -122,6 +122,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
  	if (unlikely(queue >=3D local->hw.queues))
  		queue =3D local->hw.queues - 1;
 =20
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
- 	if (skb->requeue) {
- 		if (!hw->ampdu_queues)
- 			return queue;
-@@ -142,6 +143,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
-=20
- 		return queue;
+ 	/*
+ 	 * Now we know the 1d priority, fill in the QoS header if
+ 	 * there is one (and we haven't done this before).
+@@ -137,6 +138,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
+ 		*p++ =3D ack_policy | tid;
+ 		*p =3D 0;
  	}
 +#endif
 =20
- 	/* Now we know the 1d priority, fill in the QoS header if
- 	 * there is one.
+ 	return queue;
+ }
 --- a/drivers/net/wireless/Makefile	2008-11-10 12:55:55.000000000 -0800
 +++ b/drivers/net/wireless/Makefile	2008-11-10 12:57:30.000000000 -0800
-@@ -5,41 +5,14 @@
+@@ -5,43 +5,17 @@
  obj-$(CONFIG_IPW2100) +=3D ipw2x00/
  obj-$(CONFIG_IPW2200) +=3D ipw2x00/
 =20
@@ -134,6 +134,8 @@ index a0c860f..9c6f214 100644
 -obj-$(CONFIG_PCI_ATMEL)         +=3D atmel_pci.o=20
 -obj-$(CONFIG_PCMCIA_ATMEL)      +=3D atmel_cs.o
 -
+ obj-$(CONFIG_AT76C50X_USB)      +=3D at76c50x-usb.o
+=20
 -obj-$(CONFIG_PRISM54)		+=3D prism54/
 -
 -obj-$(CONFIG_HOSTAP)		+=3D hostap/
@@ -146,7 +148,7 @@ index a0c860f..9c6f214 100644
 -# 16-bit wireless PCMCIA client drivers
 -obj-$(CONFIG_PCMCIA_RAYCS)	+=3D ray_cs.o
 -obj-$(CONFIG_PCMCIA_WL3501)	+=3D wl3501_cs.o
--
+=20
  obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+=3D rndis_wlan.o
 =20
 -obj-$(CONFIG_USB_ZD1201)	+=3D zd1201.o
@@ -301,7 +303,7 @@ index a0c860f..9c6f214 100644
 =20
 --- a/net/mac80211/iface.c	2009-02-13 14:25:06.000000000 -0800
 +++ b/net/mac80211/iface.c	2009-02-13 14:25:08.000000000 -0800
-@@ -657,6 +657,7 @@
+@@ -667,6 +667,7 @@
  	WARN_ON(flushed);
  }
 =20
@@ -309,7 +311,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_dataif_ops =3D {
  	.ndo_open		=3D ieee80211_open,
  	.ndo_stop		=3D ieee80211_stop,
-@@ -676,11 +677,22 @@
+@@ -686,11 +687,22 @@
  	.ndo_change_mtu 	=3D ieee80211_change_mtu,
  	.ndo_set_mac_address 	=3D eth_mac_addr,
  };
@@ -332,7 +334,7 @@ index a0c860f..9c6f214 100644
  	dev->wireless_handlers =3D &ieee80211_iw_handler_def;
  	dev->destructor =3D free_netdev;
  }
-@@ -696,7 +708,11 @@
+@@ -706,7 +718,11 @@
 =20
  	/* and set some type-dependent values */
  	sdata->vif.type =3D type;
@@ -344,7 +346,7 @@ index a0c860f..9c6f214 100644
  	sdata->wdev.iftype =3D type;
 =20
  	/* only monitor differs */
-@@ -717,7 +733,11 @@
+@@ -729,7 +745,11 @@
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type =3D ARPHRD_IEEE80211_RADIOTAP;
@@ -356,7 +358,7 @@ index a0c860f..9c6f214 100644
  		sdata->u.mntr_flags =3D MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -823,6 +843,10 @@
+@@ -836,6 +856,10 @@
  	if (ret)
  		goto fail;
 =20
@@ -369,7 +371,7 @@ index a0c860f..9c6f214 100644
  		ieee80211_sdata_set_mesh_id(sdata,
 --- a/net/mac80211/main.c	2009-02-13 14:25:06.000000000 -0800
 +++ b/net/mac80211/main.c	2009-02-13 14:25:08.000000000 -0800
-@@ -487,6 +487,7 @@
+@@ -488,6 +488,7 @@
  		return;
  	}
 =20
@@ -377,7 +379,7 @@ index a0c860f..9c6f214 100644
  	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
  		/* Software retry the packet once */
  		skb->requeue =3D 1;
-@@ -494,6 +495,7 @@
+@@ -495,6 +496,7 @@
  		dev_queue_xmit(skb);
  		return;
  	}
@@ -385,7 +387,7 @@ index a0c860f..9c6f214 100644
 =20
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -797,6 +799,7 @@
+@@ -803,6 +805,7 @@
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
 =20
@@ -393,7 +395,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_master_ops =3D {
  	.ndo_start_xmit =3D ieee80211_master_start_xmit,
  	.ndo_open =3D ieee80211_master_open,
-@@ -804,12 +807,22 @@
+@@ -810,12 +813,22 @@
  	.ndo_set_multicast_list =3D ieee80211_master_set_multicast_list,
  	.ndo_select_queue =3D ieee80211_select_queue,
  };
@@ -438,3 +440,474 @@ index a0c860f..9c6f214 100644
 =20
  	return ops;
  }
+diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
+index c157d60..40f86df 100644
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -21,6 +21,7 @@
+ #include "nl80211.h"
+ #include "reg.h"
+=20
++#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,30))
+ static int nl80211_lock_doit(struct sk_buff *skb, struct genl_info *inf=
o)
+ {
+ 	rtnl_lock();
+@@ -38,6 +39,7 @@
+ 	rtnl_unlock();
+ }
+=20
++#endif
+ /* the netlink family */
+ static struct genl_family nl80211_fam =3D {
+ 	.id =3D GENL_ID_GENERATE,	/* don't bother with a hardcoded ID */
+@@ -45,10 +47,12 @@
+ 	.hdrsize =3D 0,		/* no private header */
+ 	.version =3D 1,		/* no particular meaning now */
+ 	.maxattr =3D NL80211_ATTR_MAX,
++#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,30))
+ 	.pre_doit =3D nl80211_lock_doit,
+ 	.pre_dumpit =3D nl80211_lock_dumpit,
+ 	.post_doit =3D nl80211_unlock,
+ 	.post_dumpit =3D nl80211_unlock,
++#endif
+ };
+=20
+ /* internal helper: get drv and dev */
+@@ -637,12 +641,18 @@
+ 			flags =3D &_flags;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++#endif
+ 	err =3D drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
+ 					    type, flags, &params);
+=20
+ 	dev =3D __dev_get_by_index(&init_net, ifindex);
+ 	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype !=3D type));
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_unlock();
++#endif
+  unlock:
+ 	cfg80211_put_dev(drv);
+ 	return err;
+@@ -683,12 +693,18 @@
+ 		params.mesh_id_len =3D nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++#endif
+ 	err =3D parse_monitor_flags(type =3D=3D NL80211_IFTYPE_MONITOR ?
+ 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
+ 				  &flags);
+ 	err =3D drv->ops->add_virtual_intf(&drv->wiphy,
+ 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
+ 		type, err ? NULL : &flags, &params);
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_unlock();
++#endif
+=20
+  unlock:
+ 	cfg80211_put_dev(drv);
+@@ -712,7 +728,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -797,8 +819,15 @@
+ 	if (mac_addr)
+ 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
+ 				&cookie, get_key_callback);
++	rtnl_unlock();
++#else
++	err =3D drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
++				&cookie, get_key_callback);
++#endif
+=20
+ 	if (err)
+ 		goto out;
+@@ -858,7 +887,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D func(&drv->wiphy, dev, key_idx);
++	rtnl_unlock();
++#else
++	err =3D func(&drv->wiphy, dev, key_idx);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -941,7 +976,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params=
);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params=
);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -975,7 +1016,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1056,7 +1103,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D call(&drv->wiphy, dev, &params);
++	rtnl_unlock();
++#else
++	err =3D call(&drv->wiphy, dev, &params);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1079,7 +1132,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D drv->ops->del_beacon(&drv->wiphy, dev);
++	rtnl_unlock();
++#else
++	err =3D drv->ops->del_beacon(&drv->wiphy, dev);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1264,13 +1323,20 @@
+ 		goto out_err;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++#endif
+ 	while (1) {
+ 		err =3D dev->ops->dump_station(&dev->wiphy, netdev, sta_idx,
+ 					     mac_addr, &sinfo);
+ 		if (err =3D=3D -ENOENT)
+ 			break;
+ 		if (err)
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++			goto out_err_rtnl;
++#else
+ 			goto out_err;
++#endif
+=20
+ 		if (nl80211_send_station(skb,
+ 				NETLINK_CB(cb->skb).pid,
+@@ -1286,6 +1352,10 @@
+  out:
+ 	cb->args[1] =3D sta_idx;
+ 	err =3D skb->len;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++ out_err_rtnl:
++	rtnl_unlock();
++#endif
+  out_err:
+ 	cfg80211_put_dev(dev);
+  out_put_netdev:
+@@ -1319,7 +1389,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
++	rtnl_unlock();
++#else
++	err =3D drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
++#endif
+=20
+ 	if (err)
+ 		goto out;
+@@ -1421,7 +1497,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);=

++	rtnl_unlock();
++#else
++	err =3D drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);=

++#endif
+=20
+  out:
+ 	if (params.vlan)
+@@ -1482,7 +1564,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
++#endif
+=20
+  out:
+ 	if (params.vlan)
+@@ -1511,7 +1599,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->del_station(&drv->wiphy, dev, mac_addr);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->del_station(&drv->wiphy, dev, mac_addr);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1611,13 +1705,20 @@
+ 		goto out_err;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++#endif
+ 	while (1) {
+ 		err =3D dev->ops->dump_mpath(&dev->wiphy, netdev, path_idx,
+ 					   dst, next_hop, &pinfo);
+ 		if (err =3D=3D -ENOENT)
+ 			break;
+ 		if (err)
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++			goto out_err_rtnl;
++#else
+ 			goto out_err;
++#endif
+=20
+ 		if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).pid,
+ 				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
+@@ -1632,6 +1733,10 @@
+  out:
+ 	cb->args[1] =3D path_idx;
+ 	err =3D skb->len;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++ out_err_rtnl:
++	rtnl_unlock();
++#endif
+  out_err:
+ 	cfg80211_put_dev(dev);
+  out_put_netdev:
+@@ -1666,7 +1771,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
++#endif
+=20
+ 	if (err)
+ 		goto out;
+@@ -1717,7 +1828,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1750,7 +1867,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1777,7 +1900,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D drv->ops->del_mpath(&drv->wiphy, dev, dst);
++	rtnl_unlock();
++#else
++	err =3D drv->ops->del_mpath(&drv->wiphy, dev, dst);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1823,7 +1952,13 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
+ 	err =3D drv->ops->change_bss(&drv->wiphy, dev, &params);
++	rtnl_unlock();
++#else
++	err =3D drv->ops->change_bss(&drv->wiphy, dev, &params);
++#endif
+=20
+  out:
+ 	cfg80211_put_dev(drv);
+@@ -1920,7 +2055,13 @@
+ 		return err;
+=20
+ 	/* Get the mesh params */
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
++#endif
+ 	if (err)
+ 		goto out;
+=20
+@@ -2066,7 +2207,13 @@
+ 			nla_get_u16);
+=20
+ 	/* Apply changes */
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++	err =3D drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
++	rtnl_unlock();
++#else
+ 	err =3D drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
++#endif
+=20
+ 	/* cleanup */
+ 	cfg80211_put_dev(drv);
+@@ -2241,9 +2388,15 @@
+ 	if (err)
+ 		return err;
+=20
+-	if (drv->ops->set_mgmt_extra_ie)
++	if (drv->ops->set_mgmt_extra_ie) {
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++		rtnl_lock();
+ 		err =3D drv->ops->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
+-	else
++		rtnl_unlock();
++#else
++		err =3D drv->ops->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
++#endif
++	} else
+ 		err =3D -EOPNOTSUPP;
+=20
+ 	cfg80211_put_dev(drv);
+@@ -2275,9 +2428,16 @@
+ 		goto out;
+ 	}
+=20
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++	rtnl_lock();
++#endif
+ 	if (drv->scan_req) {
+ 		err =3D -EBUSY;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++		goto out_unlock;
++#else
+ 		goto out;
++#endif
+ 	}
+=20
+ 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+@@ -2285,7 +2445,11 @@
+ 			n_channels++;
+ 		if (!n_channels) {
+ 			err =3D -EINVAL;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++			goto out_unlock;
++#else
+ 			goto out;
++#endif
+ 		}
+ 	} else {
+ 		for (band =3D 0; band < IEEE80211_NUM_BANDS; band++)
+@@ -2299,7 +2463,11 @@
+=20
+ 	if (n_ssids > wiphy->max_scan_ssids) {
+ 		err =3D -EINVAL;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++		goto out_unlock;
++#else
+ 		goto out;
++#endif
+ 	}
+=20
+ 	if (info->attrs[NL80211_ATTR_IE])
+@@ -2313,7 +2481,11 @@
+ 			+ ie_len, GFP_KERNEL);
+ 	if (!request) {
+ 		err =3D -ENOMEM;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++		goto out_unlock;
++#else
+ 		goto out;
++#endif
+ 	}
+=20
+ 	request->channels =3D (void *)((char *)request + sizeof(*request));
+@@ -2384,6 +2556,10 @@
+ 		drv->scan_req =3D NULL;
+ 		kfree(request);
+ 	}
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
++ out_unlock:
++	rtnl_unlock();
++#endif
+  out:
+ 	cfg80211_put_dev(drv);
+ 	dev_put(dev);
diff --git a/config.mk b/config.mk
index 0e1546e..e9cdae7 100644
--- a/config.mk
+++ b/config.mk
@@ -113,21 +113,18 @@ CONFIG_ATH9K=3Dm
 # CONFIG_ATH9K_DEBUG is not set
=20
=20
-CONFIG_IWLWIFI=3Dy
-CONFIG_IWLCORE=3Dm
+CONFIG_IWLWIFI=3Dm
 CONFIG_IWLWIFI_LEDS=3Dy
 # CONFIG_IWLWIFI_RFKILL=3Dy
+CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=3Dy
 # CONFIG_IWLWIFI_DEBUG is not set
+# CONFIG_IWLWIFI_DEBUGFS is not set
 CONFIG_IWLAGN=3Dm
-CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=3Dy
-CONFIG_IWLAGN_LEDS=3Dy
 CONFIG_IWL4965=3Dy
 CONFIG_IWL5000=3Dy
 CONFIG_IWL3945=3Dm
-# CONFIG_IWL3945_RFKILL=3Dy
 CONFIG_IWL3945_SPECTRUM_MEASUREMENT=3Dy
 CONFIG_IWL3945_LEDS=3Dy
-# CONFIG_IWL3945_DEBUG is not set
=20
=20
 CONFIG_B43=3Dm
@@ -241,6 +238,8 @@ CONFIG_USB_NET_CDCETHER=3Dm
 CONFIG_P54_USB=3Dm
 CONFIG_RTL8187=3Dm
=20
+CONFIG_AT76C50X_USB=3Dm
+
=20
 # RT2500USB does not require firmware
 CONFIG_RT2500USB=3Dm
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 5fa23c0..8eeef89 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -24,10 +24,8 @@ INCLUDE_LINUX=3D"$INCLUDE_LINUX ath9k_platform.h"
 # For rndis_wext
 INCLUDE_LINUX_USB=3D"usbnet.h rndis_host.h"
=20
-# Stuff that should die or be merged, only ipw uses it
-INCLUDE_NET_OLD=3D"ieee80211.h"
 # The good new yummy stuff
-INCLUDE_NET=3D"$INCLUDE_NET_OLD cfg80211.h ieee80211_radiotap.h iw_handl=
er.h"
+INCLUDE_NET=3D"cfg80211.h ieee80211_radiotap.h iw_handler.h"
 INCLUDE_NET=3D"$INCLUDE_NET mac80211.h wext.h wireless.h lib80211.h"
=20
 NET_DIRS=3D"wireless mac80211"
@@ -66,6 +64,7 @@ DRIVERS=3D"$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVER_FILES=3D"adm8211.c  adm8211.h"
 DRIVER_FILES=3D"$DRIVER_FILES rndis_wlan.c"
 DRIVER_FILES=3D"$DRIVER_FILES mac80211_hwsim.c"
+DRIVER_FILES=3D"$DRIVER_FILES at76c50x-usb.c at76c50x-usb.h"
=20
 mkdir -p include/linux/ include/net/ include/linux/usb \
 	net/mac80211/ net/wireless/ \
--=20
1.5.6.3


--------------040804030308010804020208--
