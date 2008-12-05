Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n10.bullet.re3.yahoo.com ([68.142.237.123]:41006 "HELO
	n10.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756703AbYLEVtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 16:49:53 -0500
Date: Fri, 5 Dec 2008 13:37:48 -0800 (PST)
From: Igor Trindade Oliveira <igor_trindade@yahoo.com.br>
Reply-To: igor_trindade@yahoo.com.br
Subject: [PATCH] mac80211_hwsim: configfs support
To: j@w1.fi
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <52953.29307.qm@web59310.mail.re1.yahoo.com> (sfid-20081205_224959_154282_E7288ABE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211_hwsim: Support to configfs operations for create a new radio

Signed-off-by: Igor Trindade Oliveira (igor_trindade@yahoo.com.br)

--- wireless-testing/drivers/net/wireless/mac80211_hwsim.c.orig	2008-12=
-01 10:43:42.000000000 -0400
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-12-02 0=
6:21:56.000000000 -0400
@@ -21,15 +21,13 @@
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <linux/etherdevice.h>
-#include <linux/debugfs.h>
+#include <linux/configfs.h>
=20
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211=
");
 MODULE_LICENSE("GPL");
=20
-static int radios =3D 2;
-module_param(radios, int, 0444);
-MODULE_PARM_DESC(radios, "Number of simulated radios");
+static int radios;
=20
 struct hwsim_vif_priv {
 	u32 magic;
@@ -140,10 +138,15 @@ struct mac80211_hwsim_data {
 		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
 	} ps;
 	bool ps_poll_pending;
-	struct dentry *debugfs;
-	struct dentry *debugfs_ps;
+	struct config_item item;
 };
=20
+struct mac80211_hwsim_attr {
+	struct configfs_attribute attr;
+	 ssize_t(*show) (struct mac80211_hwsim_data *hwsim, char *buf);
+	 ssize_t(*store) (struct mac80211_hwsim_data *hwsim,
+			  const char *buf, ssize_t count);
+};
=20
 struct hwsim_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
@@ -576,8 +579,6 @@ static void mac80211_hwsim_free(void)
 	spin_unlock_bh(&hwsim_radio_lock);
=20
 	list_for_each_entry(data, &tmplist, list) {
-		debugfs_remove(data->debugfs_ps);
-		debugfs_remove(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
 		device_unregister(data->dev);
 		ieee80211_free_hw(data->hw);
@@ -683,150 +684,266 @@ static void hwsim_send_nullfunc_no_ps(vo
 	hwsim_send_nullfunc(data, mac, vif, 0);
 }
=20
+/*
+ *ConfigFs operations
+ */
=20
-static int hwsim_fops_ps_read(void *dat, u64 *val)
+static struct mac80211_hwsim_data *to_target(struct config_item *item)
 {
-	struct mac80211_hwsim_data *data =3D dat;
-	*val =3D data->ps;
-	return 0;
+	return item ?
+	    container_of(item, struct mac80211_hwsim_data, item) : NULL;
 }
=20
-static int hwsim_fops_ps_write(void *dat, u64 val)
+static int show_ps_status(struct mac80211_hwsim_data *hwsim, char *buf=
)
 {
-	struct mac80211_hwsim_data *data =3D dat;
+	return snprintf(buf, PAGE_SIZE, "%d\n", hwsim->ps);
+}
+
+static int store_ps_status(struct mac80211_hwsim_data *hwsim,
+			   const char *buf, ssize_t count)
+{
+	unsigned long int ps;
 	enum ps_mode old_ps;
+	int ret;
+
+	ret =3D strict_strtoul(buf, 10, &ps);
=20
-	if (val !=3D PS_DISABLED && val !=3D PS_ENABLED && val !=3D PS_AUTO_P=
OLL &&
-	    val !=3D PS_MANUAL_POLL)
+	if (ret)
+		return ret;
+
+	if (ps !=3D PS_DISABLED && ps !=3D PS_ENABLED && ps !=3D PS_AUTO_POLL=
 &&
+	    ps !=3D PS_MANUAL_POLL)
 		return -EINVAL;
=20
-	old_ps =3D data->ps;
-	data->ps =3D val;
+	old_ps =3D hwsim->ps;
+	hwsim->ps =3D ps;
=20
-	if (val =3D=3D PS_MANUAL_POLL) {
-		ieee80211_iterate_active_interfaces(data->hw,
-						    hwsim_send_ps_poll, data);
-		data->ps_poll_pending =3D true;
-	} else if (old_ps =3D=3D PS_DISABLED && val !=3D PS_DISABLED) {
-		ieee80211_iterate_active_interfaces(data->hw,
+	if (ps =3D=3D PS_MANUAL_POLL) {
+		ieee80211_iterate_active_interfaces(hwsim->hw,
+						    hwsim_send_ps_poll, hwsim);
+		hwsim->ps_poll_pending =3D true;
+	} else if (old_ps =3D=3D PS_DISABLED && ps !=3D PS_DISABLED) {
+		ieee80211_iterate_active_interfaces(hwsim->hw,
 						    hwsim_send_nullfunc_ps,
-						    data);
-	} else if (old_ps !=3D PS_DISABLED && val =3D=3D PS_DISABLED) {
-		ieee80211_iterate_active_interfaces(data->hw,
+						    hwsim);
+	} else if (old_ps !=3D PS_DISABLED && ps =3D=3D PS_DISABLED) {
+		ieee80211_iterate_active_interfaces(hwsim->hw,
 						    hwsim_send_nullfunc_no_ps,
-						    data);
+						    hwsim);
 	}
=20
-	return 0;
+	return strnlen(buf, count);
 }
=20
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_=
ps_write,
-			"%llu\n");
+/*
+ *ConfigFS attribute declaration
+ */
+#define MAC80211_HWSIM_ATTR_RW(_name, _show, _store)                  =
  \
+static struct  mac80211_hwsim_attr mac80211_hwsim_##_name =3D	        =
\
+		 __CONFIGFS_ATTR(_name, S_IRUGO | S_IWUSR, _show, _store)
=20
+MAC80211_HWSIM_ATTR_RW(ps, show_ps_status, store_ps_status);
=20
-static int __init init_mac80211_hwsim(void)
+static struct configfs_atribbute *mac80211_hwsim_attrs[] =3D {
+	&mac80211_hwsim_ps.attr,
+	NULL,
+};
+
+/*
+ *ConfigFS: Item operations
+ */
+
+static void mac80211_hwsim_release(struct config_item *item)
+{
+	kfree(to_target(item));
+}
+
+/*
+ * now we just have one attribute with this function we can
+ * add new attributes in mac80211_hwsim_attrs and do not change
+ * others parts of the code
+ */
+
+static ssize_t mac80211_hwsim_attr_show(struct config_item *item,
+					struct configfs_attribute *attr,
+					char *buf)
 {
-	int i, err =3D 0;
+	struct mac80211_hwsim_data *data =3D to_target(item);
+	struct mac80211_hwsim_attr *hwsim_attr =3D
+	    container_of(attr, struct mac80211_hwsim_attr, attr);
+
+	return hwsim_attr->show ? hwsim_attr->show(data, buf) : EINVAL;
+}
+
+static ssize_t mac80211_hwsim_attr_store(struct config_item *item,
+					 struct configfs_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct mac80211_hwsim_data *data =3D to_target(item);
+	struct mac80211_hwsim_attr *hwsim_attr =3D
+	    container_of(attr, struct mac80211_hwsim_attr, attr);
+
+	return hwsim_attr->store ? hwsim_attr->store(data, buf, count) : EINV=
AL;
+}
+
+static struct configfs_item_operations mac80211_hwsim_item_ops =3D {
+	.release =3D mac80211_hwsim_release,
+	.show_attribute =3D mac80211_hwsim_attr_show,
+	.store_attribute =3D mac80211_hwsim_attr_store,
+};
+
+static struct config_item_type mac80211_hwsim_type =3D {
+	.ct_attrs =3D mac80211_hwsim_attrs,
+	.ct_item_ops =3D &mac80211_hwsim_item_ops,
+	.ct_owner =3D THIS_MODULE,
+};
+
+
+static struct config_item *make_mac80211_hwsim(struct config_group *gr=
oup,
+					       const char *name)
+{
+	int err =3D 0;
 	u8 addr[ETH_ALEN];
 	struct mac80211_hwsim_data *data;
 	struct ieee80211_hw *hw;
 	DECLARE_MAC_BUF(mac);
=20
-	if (radios < 1 || radios > 100)
-		return -EINVAL;
-
-	spin_lock_init(&hwsim_radio_lock);
-	INIT_LIST_HEAD(&hwsim_radios);
-
-	hwsim_class =3D class_create(THIS_MODULE, "mac80211_hwsim");
-	if (IS_ERR(hwsim_class))
-		return PTR_ERR(hwsim_class);
-
 	memset(addr, 0, ETH_ALEN);
 	addr[0] =3D 0x02;
=20
-	for (i =3D 0; i < radios; i++) {
-		printk(KERN_DEBUG "mac80211_hwsim: Initializing radio %d\n",
-		       i);
-		hw =3D ieee80211_alloc_hw(sizeof(*data), &mac80211_hwsim_ops);
-		if (!hw) {
-			printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw "
-			       "failed\n");
-			err =3D -ENOMEM;
+	printk(KERN_DEBUG "mac80211_hwsim: Initializing radio %d\n",
+		       radios);
+	hw =3D ieee80211_alloc_hw(sizeof(*data), &mac80211_hwsim_ops);
+	if (!hw) {
+		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw "
+			"failed\n");
+		err =3D -ENOMEM;
 			goto failed;
-		}
-		data =3D hw->priv;
-		data->hw =3D hw;
+	}
+	data =3D hw->priv;
+	data->hw =3D hw;
=20
-		data->dev =3D device_create(hwsim_class, NULL, 0, hw,
-					  "hwsim%d", i);
-		if (IS_ERR(data->dev)) {
-			printk(KERN_DEBUG
-			       "mac80211_hwsim: device_create "
-			       "failed (%ld)\n", PTR_ERR(data->dev));
-			err =3D -ENOMEM;
-			goto failed_drvdata;
-		}
-		data->dev->driver =3D &mac80211_hwsim_driver;
+	data->dev =3D device_create(hwsim_class, NULL, 0, hw,
+					  "hwsim%d", radios);
+	if (IS_ERR(data->dev)) {
+		printk(KERN_DEBUG
+			"mac80211_hwsim: device_create "
+			"failed (%ld)\n", PTR_ERR(data->dev));
+		err =3D -ENOMEM;
+		goto failed_drvdata;
+	}
+	data->dev->driver =3D &mac80211_hwsim_driver;
+
+	SET_IEEE80211_DEV(hw, data->dev);
+	addr[3] =3D radios >> 8;
+	addr[4] =3D radios;
+	SET_IEEE80211_PERM_ADDR(hw, addr);
+
+	hw->channel_change_time =3D 1;
+	hw->queues =3D 4;
+	hw->wiphy->interface_modes =3D
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
+	hw->ampdu_queues =3D 1;
+
+	/* ask mac80211 to reserve space for magic */
+	hw->vif_data_size =3D sizeof(struct hwsim_vif_priv);
+	hw->sta_data_size =3D sizeof(struct hwsim_sta_priv);
+
+	memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
+	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
+	data->band.channels =3D data->channels;
+	data->band.n_channels =3D ARRAY_SIZE(hwsim_channels);
+	data->band.bitrates =3D data->rates;
+	data->band.n_bitrates =3D ARRAY_SIZE(hwsim_rates);
+	data->band.ht_cap.ht_supported =3D true;
+	data->band.ht_cap.cap =3D IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+		IEEE80211_HT_CAP_GRN_FLD |
+		IEEE80211_HT_CAP_SGI_40 |
+		IEEE80211_HT_CAP_DSSSCCK40;
+	data->band.ht_cap.ampdu_factor =3D 0x3;
+	data->band.ht_cap.ampdu_density =3D 0x6;
+	memset(&data->band.ht_cap.mcs, 0,
+		  sizeof(data->band.ht_cap.mcs));
+	data->band.ht_cap.mcs.rx_mask[0] =3D 0xff;
+	data->band.ht_cap.mcs.rx_mask[1] =3D 0xff;
+	data->band.ht_cap.mcs.tx_params =3D IEEE80211_HT_MCS_TX_DEFINED;
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =3D &data->band;
+
+	err =3D ieee80211_register_hw(hw);
+	if (err < 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: "
+		      "ieee80211_register_hw failed (%d)\n", err);
+		goto failed_hw;
+	}
+
+	printk(KERN_DEBUG "%s: hwaddr %s registered\n",
+		  wiphy_name(hw->wiphy),
+		  print_mac(mac, hw->wiphy->perm_addr));
+
+	setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
+		   (unsigned long) hw);
=20
-		SET_IEEE80211_DEV(hw, data->dev);
-		addr[3] =3D i >> 8;
-		addr[4] =3D i;
-		SET_IEEE80211_PERM_ADDR(hw, addr);
-
-		hw->channel_change_time =3D 1;
-		hw->queues =3D 4;
-		hw->wiphy->interface_modes =3D
-			BIT(NL80211_IFTYPE_STATION) |
-			BIT(NL80211_IFTYPE_AP) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
-		hw->ampdu_queues =3D 1;
-
-		/* ask mac80211 to reserve space for magic */
-		hw->vif_data_size =3D sizeof(struct hwsim_vif_priv);
-		hw->sta_data_size =3D sizeof(struct hwsim_sta_priv);
-
-		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
-		memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
-		data->band.channels =3D data->channels;
-		data->band.n_channels =3D ARRAY_SIZE(hwsim_channels);
-		data->band.bitrates =3D data->rates;
-		data->band.n_bitrates =3D ARRAY_SIZE(hwsim_rates);
-		data->band.ht_cap.ht_supported =3D true;
-		data->band.ht_cap.cap =3D IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-			IEEE80211_HT_CAP_GRN_FLD |
-			IEEE80211_HT_CAP_SGI_40 |
-			IEEE80211_HT_CAP_DSSSCCK40;
-		data->band.ht_cap.ampdu_factor =3D 0x3;
-		data->band.ht_cap.ampdu_density =3D 0x6;
-		memset(&data->band.ht_cap.mcs, 0,
-		       sizeof(data->band.ht_cap.mcs));
-		data->band.ht_cap.mcs.rx_mask[0] =3D 0xff;
-		data->band.ht_cap.mcs.rx_mask[1] =3D 0xff;
-		data->band.ht_cap.mcs.tx_params =3D IEEE80211_HT_MCS_TX_DEFINED;
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =3D &data->band;
-
-		err =3D ieee80211_register_hw(hw);
-		if (err < 0) {
-			printk(KERN_DEBUG "mac80211_hwsim: "
-			       "ieee80211_register_hw failed (%d)\n", err);
-			goto failed_hw;
-		}
+	list_add_tail(&data->list, &hwsim_radios);
=20
-		printk(KERN_DEBUG "%s: hwaddr %s registered\n",
-		       wiphy_name(hw->wiphy),
-		       print_mac(mac, hw->wiphy->perm_addr));
+	config_item_init_type_name(&data->item, name, &mac80211_hwsim_type);
+	radios++;
+
+	return &data->item;
+
+failed_hw:
+	device_unregister(data->dev);
+failed_drvdata:
+	ieee80211_free_hw(hw);
+failed:
+	mac80211_hwsim_free();
+	return ERR_PTR(err);
+
+}
+
+static struct configfs_group_operations mac80211_hwsim_group_ops =3D {
+	.make_item =3D make_mac80211_hwsim,
+};
+
+static struct config_item_type mac80211_hwsim_subsys_type =3D {
+	.ct_group_ops =3D &mac80211_hwsim_group_ops,
+	.ct_owner =3D THIS_MODULE,
+};
+
+/*
+ *Mac80211_hwsim Subsystem definition
+ */
+
+static struct configfs_subsystem mac80211_hwsim_subsys =3D {
+	.su_group =3D {
+		.cg_item =3D {
+			.ci_namebuf =3D "mac80211_hwsim",
+			.ci_type =3D &mac80211_hwsim_subsys_type,
+		},
+	},
+};
=20
-		data->debugfs =3D debugfs_create_dir("hwsim",
-						   hw->wiphy->debugfsdir);
-		data->debugfs_ps =3D debugfs_create_file("ps", 0666,
-						       data->debugfs, data,
-						       &hwsim_fops_ps);
=20
-		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
-			    (unsigned long) hw);
+static int __init init_mac80211_hwsim(void)
+{
+	int err =3D 0;
+
+	spin_lock_init(&hwsim_radio_lock);
+	INIT_LIST_HEAD(&hwsim_radios);
=20
-		list_add_tail(&data->list, &hwsim_radios);
+	hwsim_class =3D class_create(THIS_MODULE, "mac80211_hwsim");
+	if (IS_ERR(hwsim_class))
+		return PTR_ERR(hwsim_class);
+
+	config_group_init(&mac80211_hwsim_subsys.su_group);
+	mutex_init(&mac80211_hwsim_subsys.su_mutex);
+	err =3D configfs_register_subsystem(&mac80211_hwsim_subsys);
+	if (err) {
+		printk(KERN_ERR "Error %d while registering mac80211_hwsim_subsystem=
 %s\n",
+			err,
+			mac80211_hwsim_subsys.su_group.cg_item.ci_namebuf);
+		goto out_unregister;
 	}
=20
 	hwsim_mon =3D alloc_netdev(0, "hwsim%d", hwsim_mon_setup);
@@ -848,16 +965,16 @@ static int __init init_mac80211_hwsim(vo
=20
 	return 0;
=20
+out_unregister:
+	configfs_unregister_subsystem(&mac80211_hwsim_subsys);
+	return err;
+
 failed_mon:
 	rtnl_unlock();
 	free_netdev(hwsim_mon);
 	mac80211_hwsim_free();
 	return err;
=20
-failed_hw:
-	device_unregister(data->dev);
-failed_drvdata:
-	ieee80211_free_hw(hw);
 failed:
 	mac80211_hwsim_free();
 	return err;
@@ -868,6 +985,7 @@ static void __exit exit_mac80211_hwsim(v
 {
 	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
=20
+	configfs_unregister_subsystem(&mac80211_hwsim_subsys);
 	unregister_netdev(hwsim_mon);
 	mac80211_hwsim_free();
 }
@@ -875,3 +993,4 @@ static void __exit exit_mac80211_hwsim(v
=20
 module_init(init_mac80211_hwsim);
 module_exit(exit_mac80211_hwsim);
+



      Veja quais s=E3o os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
