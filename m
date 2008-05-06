Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:13947 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYEFVmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 17:42:35 -0400
Received: by ug-out-1314.google.com with SMTP id h2so453935ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 14:42:33 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH v2] mac80211: Add RTNL version of ieee80211_iterate_active_interfaces
Date: Tue, 6 May 2008 23:50:00 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200805061943.31902.IvDoorn@gmail.com>
In-Reply-To: <200805061943.31902.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200805062350.00648.IvDoorn@gmail.com> (sfid-20080506_234146_840000_60BDFA8D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit e38bad4766a110b61fa6038f10be16ced8c6cc38
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mac80211: make ieee8021=
1_iterate_active_interfaces not need rtnl
rt2500usb and rt73usb broke down due to attempting register access
in atomic context (which is not possible for USB hardware).

This patch restores ieee80211_iterate_active_interfaces() to use RTNL l=
ock,
and provides the non-RTNL version under a new name:
	ieee80211_iterate_active_interfaces_atomic()

So far only rt2x00 uses ieee80211_iterate_active_interfaces(), and thos=
e
drivers require the RTNL version of ieee80211_iterate_active_interfaces=
().
Since they already call that function directly, this patch will automat=
ically
fix the USB rt2x00 drivers.

v2: Rename ieee80211_iterate_active_interfaces_rtnl

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, this is still 2.6.26 material. ;)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7e75516..7d6de23 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1586,13 +1586,16 @@ void ieee80211_wake_queues(struct ieee80211_hw =
*hw);
 void ieee80211_scan_completed(struct ieee80211_hw *hw);
=20
 /**
- * ieee80211_iterate_active_interfaces - iterate active interfaces
+ * ieee80211_iterate_active_interfaces- iterate active interfaces
  *
  * This function iterates over the interfaces associated with a given
  * hardware that are currently active and calls the callback for them.
+ * This function allows the iterator function to sleep, when the itera=
tor
+ * function is atomic @ieee80211_iterate_active_interfaces_atomic can
+ * be used.
  *
  * @hw: the hardware struct of which the interfaces should be iterated=
 over
- * @iterator: the iterator function to call, cannot sleep
+ * @iterator: the iterator function to call
  * @data: first argument of the iterator function
  */
 void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
@@ -1601,6 +1604,24 @@ void ieee80211_iterate_active_interfaces(struct =
ieee80211_hw *hw,
 					 void *data);
=20
 /**
+ * ieee80211_iterate_active_interfaces_atomic - iterate active interfa=
ces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware that are currently active and calls the callback for them.
+ * This function requires the iterator callback function to be atomic,
+ * if that is not desired, use @ieee80211_iterate_active_interfaces in=
stead.
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated=
 over
+ * @iterator: the iterator function to call, cannot sleep
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *h=
w,
+						void (*iterator)(void *data,
+						    u8 *mac,
+						    struct ieee80211_vif *vif),
+						void *data);
+
+/**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @ra: receiver address of the BA session recipient
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 74c48ef..2a8c0c5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -401,6 +401,41 @@ void ieee80211_iterate_active_interfaces(
 	struct ieee80211_local *local =3D hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
=20
+	rtnl_lock();
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		switch (sdata->vif.type) {
+		case IEEE80211_IF_TYPE_INVALID:
+		case IEEE80211_IF_TYPE_MNTR:
+		case IEEE80211_IF_TYPE_VLAN:
+			continue;
+		case IEEE80211_IF_TYPE_AP:
+		case IEEE80211_IF_TYPE_STA:
+		case IEEE80211_IF_TYPE_IBSS:
+		case IEEE80211_IF_TYPE_WDS:
+		case IEEE80211_IF_TYPE_MESH_POINT:
+			break;
+		}
+		if (sdata->dev =3D=3D local->mdev)
+			continue;
+		if (netif_running(sdata->dev))
+			iterator(data, sdata->dev->dev_addr,
+				 &sdata->vif);
+	}
+
+	rtnl_unlock();
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+
+void ieee80211_iterate_active_interfaces_atomic(
+	struct ieee80211_hw *hw,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	struct ieee80211_local *local =3D hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
 	rcu_read_lock();
=20
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -425,4 +460,4 @@ void ieee80211_iterate_active_interfaces(
=20
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
