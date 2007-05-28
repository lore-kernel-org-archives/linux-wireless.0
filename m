Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:55877 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXE1Qm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 12:42:28 -0400
Message-Id: <20070528164201.814381185@localhost>
References: <20070528163845.448090722@localhost>
Date: Mon, 28 May 2007 09:38:48 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] hostap: Use list_for_each_entry
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Use list_for_each_entry() instead of manual iteration and
substitute some list_for_each() loops with list_for_each_entry().

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Jouni Malinen <j@w1.fi>


Index: linux-2.6/drivers/net/wireless/hostap/hostap_ap.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_ap.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_ap.c
@@ -326,7 +326,6 @@ static int ap_control_proc_read(char *pa
 	char *p = page;
 	struct ap_data *ap = (struct ap_data *) data;
 	char *policy_txt;
-	struct list_head *ptr;
 	struct mac_entry *entry;
 
 	if (off != 0) {
@@ -352,14 +351,12 @@ static int ap_control_proc_read(char *pa
 	p += sprintf(p, "MAC entries: %u\n", ap->mac_restrictions.entries);
 	p += sprintf(p, "MAC list:\n");
 	spin_lock_bh(&ap->mac_restrictions.lock);
-	for (ptr = ap->mac_restrictions.mac_list.next;
-	     ptr != &ap->mac_restrictions.mac_list; ptr = ptr->next) {
+	list_for_each_entry(entry, &ap->mac_restrictions.mac_list, list) {
 		if (p - page > PAGE_SIZE - 80) {
 			p += sprintf(p, "All entries did not fit one page.\n");
 			break;
 		}
 
-		entry = list_entry(ptr, struct mac_entry, list);
 		p += sprintf(p, MACSTR "\n", MAC2STR(entry->addr));
 	}
 	spin_unlock_bh(&ap->mac_restrictions.lock);
@@ -413,7 +410,6 @@ int ap_control_del_mac(struct mac_restri
 static int ap_control_mac_deny(struct mac_restrictions *mac_restrictions,
 			       u8 *mac)
 {
-	struct list_head *ptr;
 	struct mac_entry *entry;
 	int found = 0;
 
@@ -421,10 +417,7 @@ static int ap_control_mac_deny(struct ma
 		return 0;
 
 	spin_lock_bh(&mac_restrictions->lock);
-	for (ptr = mac_restrictions->mac_list.next;
-	     ptr != &mac_restrictions->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, list);
-
+	list_for_each_entry(entry, &mac_restrictions->mac_list, list) {
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
 			found = 1;
 			break;
@@ -519,7 +512,7 @@ static int prism2_ap_proc_read(char *pag
 {
 	char *p = page;
 	struct ap_data *ap = (struct ap_data *) data;
-	struct list_head *ptr;
+	struct sta_info *sta;
 	int i;
 
 	if (off > PROC_LIMIT) {
@@ -529,9 +522,7 @@ static int prism2_ap_proc_read(char *pag
 
 	p += sprintf(p, "# BSSID CHAN SIGNAL NOISE RATE SSID FLAGS\n");
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
-		struct sta_info *sta = (struct sta_info *) ptr;
-
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		if (!sta->ap)
 			continue;
 
@@ -861,7 +852,7 @@ void hostap_init_ap_proc(local_info_t *l
 
 void hostap_free_data(struct ap_data *ap)
 {
-	struct list_head *n, *ptr;
+	struct sta_info *n, *sta;
 
 	if (ap == NULL || !ap->initialized) {
 		printk(KERN_DEBUG "hostap_free_data: ap has not yet been "
@@ -875,8 +866,7 @@ void hostap_free_data(struct ap_data *ap
 	ap->crypt = ap->crypt_priv = NULL;
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 
-	list_for_each_safe(ptr, n, &ap->sta_list) {
-		struct sta_info *sta = list_entry(ptr, struct sta_info, list);
+	list_for_each_entry_safe(sta, n, &ap->sta_list, list) {
 		ap_sta_hash_del(ap, sta);
 		list_del(&sta->list);
 		if ((sta->flags & WLAN_STA_ASSOC) && !sta->ap && sta->local)
@@ -3200,15 +3190,14 @@ int hostap_update_rx_stats(struct ap_dat
 
 void hostap_update_rates(local_info_t *local)
 {
-	struct list_head *ptr;
+	struct sta_info *sta;
 	struct ap_data *ap = local->ap;
 
 	if (!ap)
 		return;
 
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
-		struct sta_info *sta = (struct sta_info *) ptr;
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		prism2_check_tx_rates(sta);
 	}
 	spin_unlock_bh(&ap->sta_table_lock);
@@ -3244,11 +3233,10 @@ void * ap_crypt_get_ptrs(struct ap_data 
 void hostap_add_wds_links(local_info_t *local)
 {
 	struct ap_data *ap = local->ap;
-	struct list_head *ptr;
+	struct sta_info *sta;
 
 	spin_lock_bh(&ap->sta_table_lock);
-	list_for_each(ptr, &ap->sta_list) {
-		struct sta_info *sta = list_entry(ptr, struct sta_info, list);
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		if (sta->ap)
 			hostap_wds_link_oper(local, sta->addr, WDS_ADD);
 	}

--

-- 
Jouni Malinen                                            PGP id EFC895FA
