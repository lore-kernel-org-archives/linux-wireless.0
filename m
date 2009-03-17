Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50422 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbZCQWPm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 18:15:42 -0400
Message-ID: <49C020F9.9080301@hauke-m.de> (sfid-20090317_231547_221517_B686EF8A)
Date: Tue, 17 Mar 2009 23:15:21 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [compat] Make compat-wireless work with new wireless-testing again.
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3B0D3E226C1E6CD0DEC4BD2E"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3B0D3E226C1E6CD0DEC4BD2E
Content-Type: multipart/mixed;
 boundary="------------020105010809090701050906"

This is a multi-part message in MIME format.
--------------020105010809090701050906
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The first patch makes compat-wireless work with wireless-testing
master-2009-03-17 again. Patch number 2 and 3 are removing some diffs
and patch 4 makes the activation on debug options easier and adds some
missing ones.

--=20
Hauke Mehrtens

--------------020105010809090701050906
Content-Type: text/x-diff;
 name="0001-compat.diff-update-for-master-2009-03-17.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="0001-compat.diff-update-for-master-2009-03-17.patch"

=46rom 9ec07471e4e6ed09fd1069f4259719f92000aada Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 17 Mar 2009 22:59:14 +0100
Subject: [PATCH] compat.diff update for master-2009-03-17


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |  103 ++++++++++++++++++++++++++--------------------=
------
 config.mk          |    3 +-
 2 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index e00f943..5fc2dc2 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -10,7 +10,7 @@
   * 802.11 configuration in-kernel interface
 --- a/net/wireless/Makefile	2008-10-27 19:54:52.000000000 +0100
 +++ b/net/wireless/Makefile	2008-10-27 19:54:53.000000000 +0100
-@@ -1,10 +1,9 @@
+@@ -1,11 +1,10 @@
 -obj-$(CONFIG_WIRELESS_EXT) +=3D wext.o
  obj-$(CONFIG_CFG80211) +=3D cfg80211.o
  obj-$(CONFIG_LIB80211) +=3D lib80211.o
@@ -18,10 +18,11 @@
  obj-$(CONFIG_LIB80211_CRYPT_CCMP) +=3D lib80211_crypt_ccmp.o
  obj-$(CONFIG_LIB80211_CRYPT_TKIP) +=3D lib80211_crypt_tkip.o
 =20
--cfg80211-y +=3D core.o sysfs.o radiotap.o util.o reg.o scan.o
-+cfg80211-y +=3D core.o sysfs.o radiotap.o util.o reg.o scan.o compat.o
+-cfg80211-y +=3D core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o=

++cfg80211-y +=3D core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o=
 compat.o
  cfg80211-$(CONFIG_WIRELESS_EXT) +=3D wext-compat.o
- cfg80211-$(CONFIG_NL80211) +=3D nl80211.o
+=20
+ ccflags-y +=3D -D__CHECK_ENDIAN__
 --- a/drivers/net/wireless/zd1211rw/zd_chip.h	2008-03-07 20:02:06.000000=
000 -0500
 +++ b/drivers/net/wireless/zd1211rw/zd_chip.h	2008-03-07 20:02:07.000000=
000 -0500
 @@ -897,7 +897,7 @@
@@ -93,7 +94,7 @@ diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
 index a0c860f..9c6f214 100644
 --- a/net/mac80211/wme.c
 +++ b/net/mac80211/wme.c
-@@ -122,6 +122,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
+@@ -125,6 +125,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
  	if (unlikely(queue >=3D local->hw.queues))
  		queue =3D local->hw.queues - 1;
 =20
@@ -101,7 +102,7 @@ index a0c860f..9c6f214 100644
  	/*
  	 * Now we know the 1d priority, fill in the QoS header if
  	 * there is one (and we haven't done this before).
-@@ -137,6 +138,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
+@@ -140,6 +141,7 @@ u16 ieee80211_select_queue(struct net_device *dev, s=
truct sk_buff *skb)
  		*p++ =3D ack_policy | tid;
  		*p =3D 0;
  	}
@@ -175,7 +176,7 @@ index a0c860f..9c6f214 100644
  		break;
 --- a/drivers/net/wireless/zd1211rw/zd_mac.c	2009-03-02 12:40:07.0000000=
00 -0800
 +++ b/drivers/net/wireless/zd1211rw/zd_mac.c	2009-03-02 12:40:09.0000000=
00 -0800
-@@ -1047,5 +1047,5 @@
+@@ -1051,5 +1051,5 @@
  	dev_dbg_f(zd_mac_dev(mac), "\n");
  	cancel_rearming_delayed_workqueue(zd_workqueue,
  		&mac->housekeeping.link_led_work);
@@ -184,7 +185,7 @@ index a0c860f..9c6f214 100644
  }
 --- a/net/mac80211/rx.c	2009-02-10 23:51:58.000000000 -0800
 +++ b/net/mac80211/rx.c	2009-02-10 23:52:04.000000000 -0800
-@@ -804,12 +804,17 @@
+@@ -805,12 +805,17 @@
 =20
  	/* Send all buffered frames to the station */
  	while ((skb =3D skb_dequeue(&sta->tx_filtered)) !=3D NULL) {
@@ -202,7 +203,7 @@ index a0c860f..9c6f214 100644
  		sent++;
  #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
  		printk(KERN_DEBUG "%s: STA %pM aid %d send PS frame "
-@@ -818,6 +823,9 @@
+@@ -819,6 +824,9 @@
  #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
  		skb->requeue =3D 1;
  		dev_queue_xmit(skb);
@@ -258,7 +259,7 @@ index a0c860f..9c6f214 100644
  		} else {
  			printk(KERN_ERR PFX "%s: Error, poll already scheduled\n",
  			       dev->name);
-@@ -2108,6 +2123,7 @@
+@@ -2112,6 +2127,7 @@
  	return err;
  }
 =20
@@ -266,7 +267,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops b44_netdev_ops =3D {
  	.ndo_open		=3D b44_open,
  	.ndo_stop		=3D b44_close,
-@@ -2123,6 +2139,7 @@
+@@ -2127,6 +2143,7 @@
  	.ndo_poll_controller	=3D b44_poll_controller,
  #endif
  };
@@ -274,7 +275,7 @@ index a0c860f..9c6f214 100644
 =20
  static int __devinit b44_init_one(struct ssb_device *sdev,
  				  const struct ssb_device_id *ent)
-@@ -2162,9 +2179,26 @@
+@@ -2166,9 +2183,26 @@
  	bp->rx_pending =3D B44_DEF_RX_RING_PENDING;
  	bp->tx_pending =3D B44_DEF_TX_RING_PENDING;
 =20
@@ -303,7 +304,7 @@ index a0c860f..9c6f214 100644
 =20
 --- a/net/mac80211/iface.c	2009-02-13 14:25:06.000000000 -0800
 +++ b/net/mac80211/iface.c	2009-02-13 14:25:08.000000000 -0800
-@@ -667,6 +667,7 @@
+@@ -675,6 +675,7 @@
  	WARN_ON(flushed);
  }
 =20
@@ -311,7 +312,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_dataif_ops =3D {
  	.ndo_open		=3D ieee80211_open,
  	.ndo_stop		=3D ieee80211_stop,
-@@ -686,11 +687,22 @@
+@@ -694,11 +695,22 @@
  	.ndo_change_mtu 	=3D ieee80211_change_mtu,
  	.ndo_set_mac_address 	=3D eth_mac_addr,
  };
@@ -334,7 +335,7 @@ index a0c860f..9c6f214 100644
  	dev->wireless_handlers =3D &ieee80211_iw_handler_def;
  	dev->destructor =3D free_netdev;
  }
-@@ -706,7 +718,11 @@
+@@ -714,7 +726,11 @@
 =20
  	/* and set some type-dependent values */
  	sdata->vif.type =3D type;
@@ -346,7 +347,7 @@ index a0c860f..9c6f214 100644
  	sdata->wdev.iftype =3D type;
 =20
  	/* only monitor differs */
-@@ -729,7 +745,11 @@
+@@ -737,7 +753,11 @@
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type =3D ARPHRD_IEEE80211_RADIOTAP;
@@ -358,7 +359,7 @@ index a0c860f..9c6f214 100644
  		sdata->u.mntr_flags =3D MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -836,6 +856,10 @@
+@@ -844,6 +864,10 @@
  	if (ret)
  		goto fail;
 =20
@@ -371,7 +372,7 @@ index a0c860f..9c6f214 100644
  		ieee80211_sdata_set_mesh_id(sdata,
 --- a/net/mac80211/main.c	2009-02-13 14:25:06.000000000 -0800
 +++ b/net/mac80211/main.c	2009-02-13 14:25:08.000000000 -0800
-@@ -488,6 +488,7 @@
+@@ -482,6 +482,7 @@
  		return;
  	}
 =20
@@ -379,7 +380,7 @@ index a0c860f..9c6f214 100644
  	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
  		/* Software retry the packet once */
  		skb->requeue =3D 1;
-@@ -495,6 +496,7 @@
+@@ -489,6 +490,7 @@
  		dev_queue_xmit(skb);
  		return;
  	}
@@ -387,7 +388,7 @@ index a0c860f..9c6f214 100644
 =20
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -803,6 +805,7 @@
+@@ -797,6 +799,7 @@
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
 =20
@@ -395,7 +396,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_master_ops =3D {
  	.ndo_start_xmit =3D ieee80211_master_start_xmit,
  	.ndo_open =3D ieee80211_master_open,
-@@ -810,12 +813,22 @@
+@@ -804,12 +807,22 @@
  	.ndo_set_multicast_list =3D ieee80211_master_set_multicast_list,
  	.ndo_select_queue =3D ieee80211_select_queue,
  };
@@ -440,9 +441,9 @@ index a0c860f..9c6f214 100644
 =20
  	return ops;
  }
---- wireless-testing/net/wireless/nl80211.c	2009-02-27 18:27:32.00000000=
0 -0500
-+++ compat-wireless-2.6/net/wireless/nl80211.c	2009-02-27 19:51:08.00000=
0000 -0500
-@@ -614,15 +614,17 @@
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -641,15 +641,17 @@
  		if (!err)
  			flags =3D &_flags;
  	}
@@ -462,7 +463,7 @@ index a0c860f..9c6f214 100644
   unlock:
  	cfg80211_put_dev(drv);
  	return err;
-@@ -662,16 +664,18 @@
+@@ -689,16 +691,18 @@
  		params.mesh_id =3D nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
  		params.mesh_id_len =3D nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
  	}
@@ -483,7 +484,7 @@ index a0c860f..9c6f214 100644
 =20
   unlock:
  	cfg80211_put_dev(drv);
-@@ -694,11 +698,13 @@
+@@ -721,11 +725,13 @@
  		err =3D -EOPNOTSUPP;
  		goto out;
  	}
@@ -499,7 +500,7 @@ index a0c860f..9c6f214 100644
   out:
  	cfg80211_put_dev(drv);
  	return err;
-@@ -782,11 +788,15 @@
+@@ -809,11 +815,15 @@
  	if (mac_addr)
  		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 =20
@@ -516,7 +517,7 @@ index a0c860f..9c6f214 100644
  	if (err)
  		goto out;
 =20
-@@ -844,11 +854,13 @@
+@@ -871,11 +881,13 @@
  		err =3D -EOPNOTSUPP;
  		goto out;
  	}
@@ -532,7 +533,7 @@ index a0c860f..9c6f214 100644
   out:
  	cfg80211_put_dev(drv);
  	dev_put(dev);
-@@ -929,10 +941,13 @@
+@@ -956,10 +968,13 @@
  		err =3D -EOPNOTSUPP;
  		goto out;
  	}
@@ -547,7 +548,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	cfg80211_put_dev(drv);
-@@ -965,10 +980,13 @@
+@@ -992,10 +1007,13 @@
  		err =3D -EOPNOTSUPP;
  		goto out;
  	}
@@ -562,7 +563,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	cfg80211_put_dev(drv);
-@@ -1048,11 +1066,13 @@
+@@ -1075,11 +1093,13 @@
  		err =3D -EINVAL;
  		goto out;
  	}
@@ -578,7 +579,7 @@ index a0c860f..9c6f214 100644
   out:
  	cfg80211_put_dev(drv);
  	dev_put(dev);
-@@ -1073,11 +1093,13 @@
+@@ -1100,11 +1120,13 @@
  		err =3D -EOPNOTSUPP;
  		goto out;
  	}
@@ -594,7 +595,7 @@ index a0c860f..9c6f214 100644
   out:
  	cfg80211_put_dev(drv);
  	dev_put(dev);
-@@ -1260,16 +1282,20 @@
+@@ -1287,16 +1309,20 @@
  		err =3D -ENOSYS;
  		goto out_err;
  	}
@@ -617,7 +618,7 @@ index a0c860f..9c6f214 100644
 =20
  		if (nl80211_send_station(skb,
  				NETLINK_CB(cb->skb).pid,
-@@ -1285,8 +1311,10 @@
+@@ -1312,8 +1338,10 @@
   out:
  	cb->args[1] =3D sta_idx;
  	err =3D skb->len;
@@ -628,7 +629,7 @@ index a0c860f..9c6f214 100644
   out_err:
  	cfg80211_put_dev(dev);
   out_put_netdev:
-@@ -1320,9 +1348,13 @@
+@@ -1347,9 +1375,13 @@
  		goto out;
  	}
 =20
@@ -642,7 +643,7 @@ index a0c860f..9c6f214 100644
 =20
  	if (err)
  		goto out;
-@@ -1424,9 +1456,13 @@
+@@ -1451,9 +1483,13 @@
  		goto out;
  	}
 =20
@@ -656,7 +657,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	if (params.vlan)
-@@ -1487,9 +1523,13 @@
+@@ -1514,9 +1550,13 @@
  		goto out;
  	}
 =20
@@ -670,7 +671,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	if (params.vlan)
-@@ -1518,9 +1558,13 @@
+@@ -1545,9 +1585,13 @@
  		goto out;
  	}
 =20
@@ -684,7 +685,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	cfg80211_put_dev(drv);
-@@ -1620,7 +1664,9 @@
+@@ -1647,7 +1691,9 @@
  		goto out_err;
  	}
 =20
@@ -694,7 +695,7 @@ index a0c860f..9c6f214 100644
 =20
  	while (1) {
  		err =3D dev->ops->dump_mpath(&dev->wiphy, netdev, path_idx,
-@@ -1628,7 +1674,11 @@
+@@ -1655,7 +1701,11 @@
  		if (err =3D=3D -ENOENT)
  			break;
  		if (err)
@@ -706,7 +707,7 @@ index a0c860f..9c6f214 100644
 =20
  		if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).pid,
  				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-@@ -1643,8 +1693,10 @@
+@@ -1670,8 +1720,10 @@
   out:
  	cb->args[1] =3D path_idx;
  	err =3D skb->len;
@@ -717,7 +718,7 @@ index a0c860f..9c6f214 100644
   out_err:
  	cfg80211_put_dev(dev);
   out_put_netdev:
-@@ -1679,9 +1731,13 @@
+@@ -1706,9 +1758,13 @@
  		goto out;
  	}
 =20
@@ -731,7 +732,7 @@ index a0c860f..9c6f214 100644
 =20
  	if (err)
  		goto out;
-@@ -1732,9 +1788,13 @@
+@@ -1759,9 +1815,13 @@
  		goto out;
  	}
 =20
@@ -745,7 +746,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	cfg80211_put_dev(drv);
-@@ -1767,9 +1827,13 @@
+@@ -1794,9 +1854,13 @@
  		goto out;
  	}
 =20
@@ -759,7 +760,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	cfg80211_put_dev(drv);
-@@ -1796,9 +1860,13 @@
+@@ -1823,9 +1887,13 @@
  		goto out;
  	}
 =20
@@ -773,7 +774,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	cfg80211_put_dev(drv);
-@@ -1844,9 +1912,13 @@
+@@ -1871,9 +1939,13 @@
  		goto out;
  	}
 =20
@@ -787,7 +788,7 @@ index a0c860f..9c6f214 100644
 =20
   out:
  	cfg80211_put_dev(drv);
-@@ -1951,9 +2023,13 @@
+@@ -1978,9 +2050,13 @@
  		return err;
 =20
  	/* Get the mesh params */
@@ -801,7 +802,7 @@ index a0c860f..9c6f214 100644
  	if (err)
  		goto out;
 =20
-@@ -2099,9 +2175,13 @@
+@@ -2126,9 +2202,13 @@
  			nla_get_u16);
 =20
  	/* Apply changes */
@@ -815,7 +816,7 @@ index a0c860f..9c6f214 100644
 =20
  	/* cleanup */
  	cfg80211_put_dev(drv);
-@@ -2277,9 +2357,13 @@
+@@ -2304,9 +2384,13 @@
  		return err;
 =20
  	if (drv->ops->set_mgmt_extra_ie) {
@@ -829,7 +830,7 @@ index a0c860f..9c6f214 100644
  	} else
  		err =3D -EOPNOTSUPP;
 =20
-@@ -2311,9 +2395,9 @@
+@@ -2338,9 +2422,9 @@
  		err =3D -EOPNOTSUPP;
  		goto out;
  	}
@@ -841,7 +842,7 @@ index a0c860f..9c6f214 100644
  	if (drv->scan_req) {
  		err =3D -EBUSY;
  		goto out_unlock;
-@@ -2424,7 +2508,9 @@
+@@ -2451,7 +2535,9 @@
  		kfree(request);
  	}
   out_unlock:
diff --git a/config.mk b/config.mk
index 7ff46c3..1d197ec 100644
--- a/config.mk
+++ b/config.mk
@@ -119,13 +119,12 @@ CONFIG_IWLWIFI_LEDS=3Dy
 # CONFIG_IWLWIFI_RFKILL=3Dy
 CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=3Dy
 # CONFIG_IWLWIFI_DEBUG is not set
+# CONFIG_IWLWIFI_DEBUGFS is not set
 CONFIG_IWLAGN=3Dm
 CONFIG_IWL4965=3Dy
 CONFIG_IWL5000=3Dy
 CONFIG_IWL3945=3Dm
 CONFIG_IWL3945_SPECTRUM_MEASUREMENT=3Dy
-CONFIG_IWL3945_LEDS=3Dy
-# CONFIG_IWL3945_DEBUG is not set
=20
=20
 CONFIG_B43=3Dm
--=20
1.5.6.3


--------------020105010809090701050906
Content-Type: text/x-diff;
 name="0002-Remove-unnecessary-diffs-for-LED-enum-in-zd1211rw.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0002-Remove-unnecessary-diffs-for-LED-enum-in-zd1211rw.patch"

=46rom ca8fbb36e023f00199722d453bb2be73d8526591 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 17 Mar 2009 23:01:22 +0100
Subject: [PATCH] Remove unnecessary diffs for LED enum in zd1211rw
The conflicting header file is not include in compat.h for a long time. T=
his diff is not needed any more.


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 5fc2dc2..bc1363e 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -23,17 +23,6 @@
  cfg80211-$(CONFIG_WIRELESS_EXT) +=3D wext-compat.o
 =20
  ccflags-y +=3D -D__CHECK_ENDIAN__
---- a/drivers/net/wireless/zd1211rw/zd_chip.h	2008-03-07 20:02:06.000000=
000 -0500
-+++ b/drivers/net/wireless/zd1211rw/zd_chip.h	2008-03-07 20:02:07.000000=
000 -0500
-@@ -897,7 +897,7 @@
- int zd_chip_unlock_phy_regs(struct zd_chip *chip);
-=20
- enum led_status {
--	LED_OFF =3D 0,
-+	LED_OFF_ZD =3D 0,
- 	LED_SCANNING =3D 1,
- 	LED_ASSOCIATED =3D 2,
- };
 --- a/drivers/net/usb/Makefile	2008-10-27 09:41:27.000000000 -0700
 +++ b/drivers/net/usb/Makefile	2008-10-27 09:43:01.000000000 -0700
 @@ -2,21 +2,7 @@
@@ -163,26 +152,6 @@ index a0c860f..9c6f214 100644
 -obj-$(CONFIG_EEPROM_AT25)	+=3D at25.o
 -obj-$(CONFIG_EEPROM_LEGACY)	+=3D eeprom.o
  obj-$(CONFIG_EEPROM_93CX6)	+=3D eeprom_93cx6.o
---- a/drivers/net/wireless/zd1211rw/zd_chip.c	2009-01-15 16:35:33.000000=
000 -0800
-+++ b/drivers/net/wireless/zd1211rw/zd_chip.c	2009-01-15 16:35:33.000000=
000 -0800
-@@ -1278,7 +1278,7 @@
- 	other_led =3D chip->link_led =3D=3D LED1 ? LED2 : LED1;
-=20
- 	switch (status) {
--	case LED_OFF:
-+	case LED_OFF_ZD:
- 		ioreqs[0].value =3D FW_LINK_OFF;
- 		ioreqs[1].value =3D v[1] & ~(LED1|LED2);
- 		break;
---- a/drivers/net/wireless/zd1211rw/zd_mac.c	2009-03-02 12:40:07.0000000=
00 -0800
-+++ b/drivers/net/wireless/zd1211rw/zd_mac.c	2009-03-02 12:40:09.0000000=
00 -0800
-@@ -1051,5 +1051,5 @@
- 	dev_dbg_f(zd_mac_dev(mac), "\n");
- 	cancel_rearming_delayed_workqueue(zd_workqueue,
- 		&mac->housekeeping.link_led_work);
--	zd_chip_control_leds(&mac->chip, LED_OFF);
-+	zd_chip_control_leds(&mac->chip, LED_OFF_ZD);
- }
 --- a/net/mac80211/rx.c	2009-02-10 23:51:58.000000000 -0800
 +++ b/net/mac80211/rx.c	2009-02-10 23:52:04.000000000 -0800
 @@ -805,12 +805,17 @@
--=20
1.5.6.3


--------------020105010809090701050906
Content-Type: text/x-diff;
 name="0003-Remove-patch-for-net-wireless-nl80211.c-this-was-rev.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0003-Remove-patch-for-net-wireless-nl80211.c-this-was-rev.pa";
 filename*1="tch"

=46rom 5d80a3de2f574385a9743a5a54132556ce66dfe7 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 17 Mar 2009 23:01:53 +0100
Subject: [PATCH] Remove patch for net/wireless/nl80211.c this was reverte=
d in wireless-testing.


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |  411 ----------------------------------------------=
------
 1 files changed, 0 insertions(+), 411 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index bc1363e..e723fc8 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -410,414 +410,3 @@ index a0c860f..9c6f214 100644
 =20
  	return ops;
  }
---- a/net/wireless/nl80211.c
-+++ b/net/wireless/nl80211.c
-@@ -641,15 +641,17 @@
- 		if (!err)
- 			flags =3D &_flags;
- 	}
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
-+#endif
- 	err =3D drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
- 					    type, flags, &params);
-=20
- 	dev =3D __dev_get_by_index(&init_net, ifindex);
- 	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype !=3D type));
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_unlock();
--
-+#endif
-  unlock:
- 	cfg80211_put_dev(drv);
- 	return err;
-@@ -689,16 +691,18 @@
- 		params.mesh_id =3D nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
- 		params.mesh_id_len =3D nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
-+#endif
- 	err =3D parse_monitor_flags(type =3D=3D NL80211_IFTYPE_MONITOR ?
- 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
- 				  &flags);
- 	err =3D drv->ops->add_virtual_intf(&drv->wiphy,
- 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
- 		type, err ? NULL : &flags, &params);
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_unlock();
--
-+#endif
-=20
-  unlock:
- 	cfg80211_put_dev(drv);
-@@ -721,11 +725,13 @@
- 		err =3D -EOPNOTSUPP;
- 		goto out;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
- 	rtnl_unlock();
--
-+#else
-+	err =3D drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
-+#endif
-  out:
- 	cfg80211_put_dev(drv);
- 	return err;
-@@ -809,11 +815,15 @@
- 	if (mac_addr)
- 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
- 				&cookie, get_key_callback);
- 	rtnl_unlock();
--
-+#else
-+	err =3D drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
-+                                &cookie, get_key_callback);
-+#endif
- 	if (err)
- 		goto out;
-=20
-@@ -871,11 +881,13 @@
- 		err =3D -EOPNOTSUPP;
- 		goto out;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D func(&drv->wiphy, dev, key_idx);
- 	rtnl_unlock();
--
-+#else
-+	err =3D func(&drv->wiphy, dev, key_idx);
-+#endif
-  out:
- 	cfg80211_put_dev(drv);
- 	dev_put(dev);
-@@ -956,10 +968,13 @@
- 		err =3D -EOPNOTSUPP;
- 		goto out;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params=
);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params=
);
-+#endif
-=20
-  out:
- 	cfg80211_put_dev(drv);
-@@ -992,10 +1007,13 @@
- 		err =3D -EOPNOTSUPP;
- 		goto out;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
-+#endif
-=20
-  out:
- 	cfg80211_put_dev(drv);
-@@ -1075,11 +1093,13 @@
- 		err =3D -EINVAL;
- 		goto out;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D call(&drv->wiphy, dev, &params);
- 	rtnl_unlock();
--
-+#else
-+	err =3D call(&drv->wiphy, dev, &params);
-+#endif
-  out:
- 	cfg80211_put_dev(drv);
- 	dev_put(dev);
-@@ -1100,11 +1120,13 @@
- 		err =3D -EOPNOTSUPP;
- 		goto out;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->del_beacon(&drv->wiphy, dev);
- 	rtnl_unlock();
--
-+#else
-+	err =3D drv->ops->del_beacon(&drv->wiphy, dev);
-+#endif
-  out:
- 	cfg80211_put_dev(drv);
- 	dev_put(dev);
-@@ -1287,16 +1309,20 @@
- 		err =3D -ENOSYS;
- 		goto out_err;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
--
-+#endif
- 	while (1) {
- 		err =3D dev->ops->dump_station(&dev->wiphy, netdev, sta_idx,
- 					     mac_addr, &sinfo);
- 		if (err =3D=3D -ENOENT)
- 			break;
- 		if (err)
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 			goto out_err_rtnl;
-+#else
-+			goto out_err;
-+#endif
-=20
- 		if (nl80211_send_station(skb,
- 				NETLINK_CB(cb->skb).pid,
-@@ -1312,8 +1338,10 @@
-  out:
- 	cb->args[1] =3D sta_idx;
- 	err =3D skb->len;
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-  out_err_rtnl:
- 	rtnl_unlock();
-+#endif
-  out_err:
- 	cfg80211_put_dev(dev);
-  out_put_netdev:
-@@ -1347,9 +1375,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
-+#endif
-=20
- 	if (err)
- 		goto out;
-@@ -1451,9 +1483,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);=

- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);=

-+#endif
-=20
-  out:
- 	if (params.vlan)
-@@ -1514,9 +1550,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
-+#endif
-=20
-  out:
- 	if (params.vlan)
-@@ -1545,9 +1585,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->del_station(&drv->wiphy, dev, mac_addr);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->del_station(&drv->wiphy, dev, mac_addr);=09
-+#endif
-=20
-  out:
- 	cfg80211_put_dev(drv);
-@@ -1647,7 +1691,9 @@
- 		goto out_err;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
-+#endif
-=20
- 	while (1) {
- 		err =3D dev->ops->dump_mpath(&dev->wiphy, netdev, path_idx,
-@@ -1655,7 +1701,11 @@
- 		if (err =3D=3D -ENOENT)
- 			break;
- 		if (err)
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 			goto out_err_rtnl;
-+#else
-+			goto out_err;
-+#endif
-=20
- 		if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).pid,
- 				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-@@ -1670,8 +1720,10 @@
-  out:
- 	cb->args[1] =3D path_idx;
- 	err =3D skb->len;
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-  out_err_rtnl:
- 	rtnl_unlock();
-+#endif
-  out_err:
- 	cfg80211_put_dev(dev);
-  out_put_netdev:
-@@ -1706,9 +1758,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
-+#endif
-=20
- 	if (err)
- 		goto out;
-@@ -1759,9 +1815,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
-+#endif
-=20
-  out:
- 	cfg80211_put_dev(drv);
-@@ -1794,9 +1854,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
-+#endif
-=20
-  out:
- 	cfg80211_put_dev(drv);
-@@ -1823,9 +1887,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->del_mpath(&drv->wiphy, dev, dst);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->del_mpath(&drv->wiphy, dev, dst);
-+#endif
-=20
-  out:
- 	cfg80211_put_dev(drv);
-@@ -1871,9 +1939,13 @@
- 		goto out;
- 	}
-=20
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->change_bss(&drv->wiphy, dev, &params);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->change_bss(&drv->wiphy, dev, &params);
-+#endif
-=20
-  out:
- 	cfg80211_put_dev(drv);
-@@ -1978,9 +2050,13 @@
- 		return err;
-=20
- 	/* Get the mesh params */
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
-+#endif
- 	if (err)
- 		goto out;
-=20
-@@ -2126,9 +2202,13 @@
- 			nla_get_u16);
-=20
- 	/* Apply changes */
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
- 	err =3D drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
- 	rtnl_unlock();
-+#else
-+	err =3D drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
-+#endif
-=20
- 	/* cleanup */
- 	cfg80211_put_dev(drv);
-@@ -2304,9 +2384,13 @@
- 		return err;
-=20
- 	if (drv->ops->set_mgmt_extra_ie) {
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 		rtnl_lock();
- 		err =3D drv->ops->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
- 		rtnl_unlock();
-+#else
-+		err =3D drv->ops->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
-+#endif
- 	} else
- 		err =3D -EOPNOTSUPP;
-=20
-@@ -2338,9 +2422,9 @@
- 		err =3D -EOPNOTSUPP;
- 		goto out;
- 	}
--
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_lock();
--
-+#endif
- 	if (drv->scan_req) {
- 		err =3D -EBUSY;
- 		goto out_unlock;
-@@ -2451,7 +2535,9 @@
- 		kfree(request);
- 	}
-  out_unlock:
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
- 	rtnl_unlock();
-+#endif
-  out:
- 	cfg80211_put_dev(drv);
- 	dev_put(dev);
--=20
1.5.6.3


--------------020105010809090701050906
Content-Type: text/x-diff;
 name="0004-Make-activation-of-debug-options-simpler-and-add-som.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0004-Make-activation-of-debug-options-simpler-and-add-som.pa";
 filename*1="tch"

=46rom d6b41d04f2d8b2d52f1844983e8be92de35fb694 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Wed, 11 Mar 2009 21:23:17 +0100
Subject: [PATCH] Make activation of debug options simpler and add some mi=
ssing debug symbols.


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   48 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/config.mk b/config.mk
index 1d197ec..b0f6e44 100644
--- a/config.mk
+++ b/config.mk
@@ -74,10 +74,23 @@ endif # kernel Makefile check
=20
 # Wireless subsystem stuff
 CONFIG_MAC80211=3Dm
-# CONFIG_MAC80211_DEBUGFS is not set
+# CONFIG_MAC80211_DEBUGFS=3Dy
+# CONFIG_MAC80211_DEBUG_MENU=3Dy
+# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=3Dy
+# CONFIG_MAC80211_NOINLINE=3Dy
+# CONFIG_MAC80211_VERBOSE_DEBUG=3Dy
+# CONFIG_MAC80211_HT_DEBUG=3Dy
+# CONFIG_MAC80211_TKIP_DEBUG=3Dy
+# CONFIG_MAC80211_IBSS_DEBUG=3Dy
+# CONFIG_MAC80211_VERBOSE_PS_DEBUG=3Dy
+# CONFIG_MAC80211_VERBOSE_MPL_DEBUG=3Dy
+# CONFIG_MAC80211_DEBUG_COUNTERS=3Dy
+# CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG=3Dy
=20
 # choose between pid and minstrel as default rate control algorithm
 CONFIG_MAC80211_RC_DEFAULT=3Dminstrel
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
+# CONFIG_MAC80211_RC_DEFAULT_PID=3Dy
 # This is the one used by our compat-wireless net/mac80211/rate.c
 # in case you have and old kernel which is overriding this to pid.
 CONFIG_COMPAT_MAC80211_RC_DEFAULT=3Dminstrel
@@ -89,12 +102,13 @@ CONFIG_MAC80211_LEDS=3Dy
 CONFIG_MAC80211_MESH=3Dy
=20
 CONFIG_CFG80211=3Dm
-# CONFIG_CFG80211_REG_DEBUG is not set
+# CONFIG_CFG80211_REG_DEBUG=3Dy
=20
 CONFIG_LIB80211=3Dm
 CONFIG_LIB80211_CRYPT_WEP=3Dm
 CONFIG_LIB80211_CRYPT_CCMP=3Dm
 CONFIG_LIB80211_CRYPT_TKIP=3Dm
+# CONFIG_LIB80211_DEBUG=3Dy
=20
 CONFIG_NL80211=3Dy
=20
@@ -109,17 +123,17 @@ CONFIG_MAC80211_HWSIM=3Dm
 ifneq ($(CONFIG_PCI),)
=20
 CONFIG_ATH5K=3Dm
-# CONFIG_ATH5K_DEBUG is not set
+# CONFIG_ATH5K_DEBUG=3Dy
 CONFIG_ATH9K=3Dm
-# CONFIG_ATH9K_DEBUG is not set
+# CONFIG_ATH9K_DEBUG=3Dy
=20
=20
 CONFIG_IWLWIFI=3Dm
 CONFIG_IWLWIFI_LEDS=3Dy
 # CONFIG_IWLWIFI_RFKILL=3Dy
 CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=3Dy
-# CONFIG_IWLWIFI_DEBUG is not set
-# CONFIG_IWLWIFI_DEBUGFS is not set
+# CONFIG_IWLWIFI_DEBUG=3Dy
+# CONFIG_IWLWIFI_DEBUGFS=3Dy
 CONFIG_IWLAGN=3Dm
 CONFIG_IWL4965=3Dy
 CONFIG_IWL5000=3Dy
@@ -134,7 +148,8 @@ CONFIG_B43_PCMCIA=3Dy
 CONFIG_B43_PIO=3Dy
 CONFIG_B43_LEDS=3Dy
 # CONFIG_B43_RFKILL=3Dy
-# CONFIG_B43_DEBUG is not set
+# CONFIG_B43_DEBUG=3Dy
+# CONFIG_B43_FORCE_PIO=3Dy
=20
 CONFIG_B43LEGACY=3Dm
 CONFIG_B43LEGACY_PCI_AUTOSELECT=3Dy
@@ -145,22 +160,23 @@ CONFIG_B43LEGACY_LEDS=3Dy
 CONFIG_B43LEGACY_DMA=3Dy
 CONFIG_B43LEGACY_PIO=3Dy
 CONFIG_B43LEGACY_DMA_AND_PIO_MODE=3Dy
-# CONFIG_B43LEGACY_DMA_MODE is not set
-# CONFIG_B43LEGACY_PIO_MODE is not set
+# CONFIG_B43LEGACY_DMA_MODE=3Dy
+# CONFIG_B43LEGACY_PIO_MODE=3Dy
=20
 # The Intel ipws
 CONFIG_LIBIPW=3Dm
-# CONFIG_LIBIPW_DEBUG is not set
+# CONFIG_LIBIPW_DEBUG=3Dy
+
=20
 CONFIG_IPW2100=3Dm
 CONFIG_IPW2100_MONITOR=3Dy
-# CONFIG_IPW2100_DEBUG is not set
+# CONFIG_IPW2100_DEBUG=3Dy
 CONFIG_IPW2200=3Dm
 CONFIG_IPW2200_MONITOR=3Dy
 CONFIG_IPW2200_RADIOTAP=3Dy
 CONFIG_IPW2200_PROMISCUOUS=3Dy
 CONFIG_IPW2200_QOS=3Dy
-# CONFIG_IPW2200_DEBUG is not set
+# CONFIG_IPW2200_DEBUG=3Dy
 # The above enables use a second interface prefixed 'rtap'.
 #           Example usage:
 #
@@ -180,6 +196,7 @@ CONFIG_SSB_PCIHOST=3Dy
 CONFIG_SSB_B43_PCI_BRIDGE=3Dy
 CONFIG_SSB_PCMCIAHOST_POSSIBLE=3Dy
 CONFIG_SSB_PCMCIAHOST=3Dy
+# CONFIG_SSB_DEBUG=3Dy
 CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
 CONFIG_SSB_DRIVER_PCICORE=3Dy
=20
@@ -221,7 +238,7 @@ CONFIG_EEPROM_93CX6=3Dm
 # USB Drivers
 ifneq ($(CONFIG_USB),)
 CONFIG_ZD1211RW=3Dm
-# CONFIG_ZD1211RW_DEBUG is not set
+# CONFIG_ZD1211RW_DEBUG=3Dy
=20
 # Sorry, rndis_wlan uses cancel_work_sync which is new and can't be done=
 in compat...
=20
@@ -262,7 +279,8 @@ CONFIG_RT2X00_LIB_FIRMWARE=3Dy
 CONFIG_RT2X00_LIB_CRYPTO=3Dy
 # CONFIG_RT2X00_LIB_RFKILL=3Dy
 CONFIG_RT2X00_LIB_LEDS=3Dy
-# CONFIG_RT2X00_DEBUG is not set
+# CONFIG_RT2X00_LIB_DEBUGFS=3Dy
+# CONFIG_RT2X00_DEBUG=3Dy
 endif
=20
 ifeq ($(NEED_RT2X00_FIRMWARE),y)
@@ -277,7 +295,7 @@ CONFIG_P54_COMMON=3Dm
 CONFIG_SSB_POSSIBLE=3Dy
 CONFIG_SSB=3Dm
 CONFIG_SSB_SPROM=3Dy
-# CONFIG_SSB_DEBUG is not set
+# CONFIG_SSB_DEBUG=3Dy
=20
 ifneq ($(CONFIG_USB),)
 ifneq ($(CONFIG_LIBERTAS_THINFIRM_USB),m)
--=20
1.5.6.3


--------------020105010809090701050906--

--------------enig3B0D3E226C1E6CD0DEC4BD2E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJwCD9AAoJEIZ0px9YPRMyJBcP+wRB5LNxdnkgQJmytKDCvKxN
7WTMsy7FVrE9zOm4Vcfyszez0JSTF2dO6KHKWJDIoD8le697Qw5BfeWOLvBlx10d
NiWZz+HAOk8hjTHFJOwOo3U46xPe5zRW9gu88RNSHP2p1XfDQT4sv4MWYeul/pPM
e8jFIGsw7fHxYQlhvxn4wfLHwrU9OLrTcYHUnVLSHBqrubZbpxwT84Ls3/SWaVMC
jQiwKPdmirjGIftgYUJ001M8RW7OTfh7aS9Z06dLMsCjPhtPZ+w/AKXp4EJ2alMm
F+RBjpcGYHjcWTiXcuFgbaIC5ClgU3p0sq39XIjtcnqczGT0CDobGDKwzpo4FSY7
FbRghQPmAKgoONmFNb3R/5BtW7iAQNB/+wHM4tDjlfV8Q+7xeg36R025fYR1T07A
emYz9ZluZw7QLc0IVWVa7pnE166knAg45UiQDrUV+F0Z2ewEeMAyZMTeC5Rs40i8
klEK+QnBXyCnMe9jtGDEqhILP0gE0u/0AklTJzE0Wm59E6EUbgzRIjuypAA/oDTa
a6riHN5LpFIYFkH5NKiMnGCEo0rBBxEAeHIoK7+1w9/i4Vdobsx8ATiWKRCiDCKd
07L5hL1u+VqvnrUYshFeERXsyRkSqrJ6KRkjzwzU+l9pf5puh6Awbpe9NDI6eY1S
/Z6NeZctdz4JKOOUqHLB
=ev9f
-----END PGP SIGNATURE-----

--------------enig3B0D3E226C1E6CD0DEC4BD2E--
