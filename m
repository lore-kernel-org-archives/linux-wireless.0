Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbXHTMKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 08:10:17 -0400
Subject: Re: [RFC] mac80211: fix software decryption with b43legacy
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46C752FE.4030706@lwfinger.net>
References: <1187346385.23489.157.camel@johannes.berg>
	 <46C5CC0D.2040609@lwfinger.net> <1187384230.6090.7.camel@johannes.berg>
	 <46C612E8.4020604@lwfinger.net> <1187387215.6090.13.camel@johannes.berg>
	 <46C64777.1000602@lwfinger.net> <1187453173.6090.33.camel@johannes.berg>
	 <46C752FE.4030706@lwfinger.net>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 14:09:53 +0200
Message-Id: <1187611793.6090.102.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-08-18 at 15:13 -0500, Larry Finger wrote:

> The rest of the call trace is available if needed. The crash occurred when ieee80211_key_free was
> trying to unlock the mutex key_idx. I added printk's to dump the pointer to sdata at the point where 
> that mutex is initialized and where the key is freed. The mutex that errs was inited.

Ho humm, yes, I'm dumb, patch below but I'll fold it into my key patch.
Sorry about that, classic use-after-free condition here.

johannes

--- wireless-dev.orig/net/mac80211/key.c	2007-08-20 14:07:43.165963896 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-20 14:08:04.265963896 +0200
@@ -255,12 +255,16 @@ static void __ieee80211_key_free(struct 
 
 void ieee80211_key_free(struct ieee80211_key *key)
 {
+	struct ieee80211_sub_if_data *sdata;
+
 	if (!key)
 		return;
 
-	mutex_lock(&key->sdata->key_mtx);
+	sdata = key->sdata;
+
+	mutex_lock(&sdata->key_mtx);
 	__ieee80211_key_free(key);
-	mutex_unlock(&key->sdata->key_mtx);
+	mutex_unlock(&sdata->key_mtx);
 }
 
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx)


