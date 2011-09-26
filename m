Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37295 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1IZPqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 11:46:33 -0400
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM
 Fritz!Box (7390)" incompatible
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	 <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	 <1317048872.2400.4.camel@wwguy-ubuntu>
	 <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-IMeINq6A+GC2kkh0M6Ec"
Date: Mon, 26 Sep 2011 07:59:20 -0700
Message-ID: <1317049160.1958.8.camel@wwguy-huron> (sfid-20110926_174637_374843_29296144)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IMeINq6A+GC2kkh0M6Ec
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi HEnrik,


On Mon, 2011-09-26 at 08:20 -0700, Henrik Friedrichsen wrote:
> Hey Wey,
> 
> Sure! Here's the information you asked for:
> 
> On Mon, Sep 26, 2011 at 4:54 PM, wwguy <wey-yi.w.guy@intel.com> wrote:
> > Hi Henrik,
> >
> > On Mon, 2011-09-26 at 07:07 -0700, Henrik Friedrichsen wrote:
> >> One more thing I have noticed:
> >>
> >> This message is only being printed when I connect to the AP, that I
> >> have problems with:
> >>
> >> Sep 26 07:05:03 dharma kernel: [ 2213.379252] iwlagn 0000:03:00.0: Tx
> >> aggregation enabled on ra = xx:xx:xx:xx:xx:xx tid = 0
> >>
> > this message telling us "11n/aggregation" is started; so looks like the
> > problem is aggregation related.
> I see. Well only after that has been printed, I can surf the internet.
> It takes a few seconds for that message to appear (after DHCP info
> retrieval).
> >
> >> On the APs that work fine, it DOES NOT get printed.
> >
> > I don't see anything special in the dmesg log you send, could you
> > provide us more information?
> >
> > 1. AP brand and model
> AVM Fritz!Box Fon WLAN 7390
> > 2. channel band and number
> It happens in the 2,4GHz and 5GHz frequencies, no matter what channel I use.
> > 3. firmware version
> 17.168.5.3 build 42301
> > 4. system setup (bluetooth or any other wireless devices on the system?)
> It's a Lenovo x220i laptop. It does have a Bluetooth chip, which is,
> however, deactived. Other than that there are no other wireless
> devices.
> > 5. if you can provide us more detail log, it will be great. (loading the
> > iwlagn with debug=0x43fff)
> Here's a more detailed log connecting to that AP in the 5GHz range:
> http://diff.cc/tmp/kernel_iwlagn.log
> >
> >
> > 
not seeing anything stand-out in the log.

few things I will suggest and please give a try:
1. Please try to apply the following two patches I attach here.
2. load the iwlagn with debug=0x45800006, the log will be big, but it
will contain more information on the tx/rx path.

thanks
Wey


--=-IMeINq6A+GC2kkh0M6Ec
Content-Type: application/mbox; name*0="[Internal-wifi-devel]_[PATCH]_iwlagn:_set_the_sequence_control_fr"; name*1="om_the_transport_layer"
Content-Disposition: attachment; filename*0="[Internal-wifi-devel]_[PATCH]_iwlagn:_set_the_sequence_contro"; filename*1="l_from_the_transport_layer"
Content-Transfer-Encoding: 7bit

>From internal-wifi-devel-bounces@linux.intel.com Mon Sep 19 04:08:12 2011
Received: from orsmsx106.amr.corp.intel.com (10.22.225.133) by
 orsmsx603.amr.corp.intel.com (10.22.226.49) with Microsoft SMTP Server
 (TLS) id 8.2.255.0; Mon, 19 Sep 2011 04:08:12 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.19.9.53) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server
 (TLS) id 14.1.323.3; Mon, 19 Sep 2011 04:08:12 -0700
Received: from rrsmsx603.amr.corp.intel.com (10.31.0.57) by
 FMSMSX102.amr.corp.intel.com (10.19.9.53) with Microsoft SMTP Server (TLS)
 id 14.1.323.3; Mon, 19 Sep 2011 04:08:11 -0700
Received: from orsmga002.jf.intel.com (10.7.209.21) by
 rrsmsx603-2.rr.intel.com (10.31.0.37) with Microsoft SMTP Server id
 8.2.255.0; Mon, 19 Sep 2011 05:08:10 -0600
Received: from linux.jf.intel.com (HELO linux.intel.com) ([10.23.219.25]) 
 by orsmga002.jf.intel.com with ESMTP; 19 Sep 2011 04:08:08 -0700
Received: from linux.intel.com (linux.intel.com [127.0.0.1])	by
 linux.intel.com (Postfix) with ESMTP id 1277B6A408D;	Mon, 19 Sep 2011
 04:08:06 -0700 (PDT)
Received: from orsmga002.jf.intel.com (orsmga002.jf.intel.com
 [10.7.209.21]) by linux.intel.com (Postfix) with ESMTP id 49B5E6A408D	for
 <internal-wifi-devel@linux.intel.com>;	Mon, 19 Sep 2011 04:08:03 -0700 (PDT)
Received: from iapp029.jer.intel.com (HELO localhost.localdomain)
 ([10.12.252.35])	by orsmga002.jf.intel.com with ESMTP; 19 Sep 2011 04:08:03
 -0700
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "internal-wifi-devel@linux.intel.com" <internal-wifi-devel@linux.intel.com>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Sender: "internal-wifi-devel-bounces@linux.intel.com"
 <internal-wifi-devel-bounces@linux.intel.com>
Date: Mon, 19 Sep 2011 04:08:02 -0700
Subject: [Internal-wifi-devel] [PATCH] iwlagn: set the sequence control
 from the transport layer
Thread-Topic: [Internal-wifi-devel] [PATCH] iwlagn: set the sequence
 control from	the transport layer
Thread-Index: Acx2vGw/bbi89ah9TqejpGI9dkTrvg==
Message-ID: <1316430482-5157-1-git-send-email-emmanuel.grumbach@intel.com>
List-Help: <mailto:internal-wifi-devel-request@linux.intel.com?subject=help>
List-Subscribe:
 <http://linux.intel.com/mailman/listinfo/internal-wifi-devel>,
 <mailto:internal-wifi-devel-request@linux.intel.com?subject=subscribe>
List-Unsubscribe:
 <http://linux.intel.com/mailman/listinfo/internal-wifi-devel>,
 <mailto:internal-wifi-devel-request@linux.intel.com?subject=unsubscribe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: rrsmsx603.amr.corp.intel.com
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.67,351,1309762800"; d="scan'208";a="50054931"
x-extloop1: 1
x-extloopcount2: 2 from 10.23.219.25
errors-to: internal-wifi-devel-bounces@linux.intel.com
list-id: internal wifi development mailing list
 <internal-wifi-devel.linux.intel.com>
list-post: <mailto:internal-wifi-devel@linux.intel.com>
list-archive: <http://linux.intel.com/pipermail/internal-wifi-devel>
x-original-to: internal-wifi-devel@linux.intel.com
delivered-to: internal-wifi-devel@localhost.localdomain
x-beenthere: internal-wifi-devel@linux.intel.com
x-mailman-version: 2.1.5
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Evolution-Source: imap://wwguy@imapmail.intel.com/
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since all the queue logic has been moved to the transport layer,
the sequence number is set in the transport layer.
While doing that I forgot that the mac header is copied to the
TB of the TX cmd in the upper layer before the call to the transport
layer. So basically we used the sequence number from mac80211...
This was fine for the first assocation but after the second, mac80211
resets its counters while we don't hence a shift that led to terrible
impact on performance.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
Johannes will say that we _really_ need to move the logic that chooses the txq
back to the upper layer (won't you ? :-)). And I will tend to agree with him.
I am pretty sure I have another issue there... I still TCP retransmissions.
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |    3 ---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 06503d8..1a475a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -327,9 +327,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	memset(dev_cmd, 0, sizeof(*dev_cmd));
 	tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
 
-	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, hdr_len);
-
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	tx_cmd->len = cpu_to_le16(len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index b78ac65..781f6aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1101,6 +1101,9 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		}
 	}
 
+	/* Copy MAC header from skb into command buffer */
+	memcpy(tx_cmd->hdr, hdr, hdr_len);
+
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
-- 
1.7.1

_______________________________________________
internal-wifi-devel mailing list
internal-wifi-devel@linux.intel.com
http://linux.intel.com/mailman/listinfo/internal-wifi-devel


--=-IMeINq6A+GC2kkh0M6Ec
Content-Type: application/mbox; name*0="[Internal-wifi-devel]_[PATCH]_iwlagn:_update_rate_scaling_with_BA"; name*1="_notifications"
Content-Disposition: attachment; filename*0="[Internal-wifi-devel]_[PATCH]_iwlagn:_update_rate_scaling_wit"; filename*1="h_BA_notifications"
Content-Transfer-Encoding: 7bit

>From internal-wifi-devel-bounces@linux.intel.com Mon Sep 19 22:17:03 2011
Received: from fmsmsx101.amr.corp.intel.com (10.19.9.52) by
 orsmsx605.amr.corp.intel.com (10.22.226.10) with Microsoft SMTP Server
 (TLS) id 8.2.255.0; Mon, 19 Sep 2011 22:17:03 -0700
Received: from rrsmsx606.amr.corp.intel.com (10.31.1.130) by
 FMSMSX101.amr.corp.intel.com (10.19.9.52) with Microsoft SMTP Server (TLS)
 id 14.1.323.3; Mon, 19 Sep 2011 22:17:02 -0700
Received: from orsmga001.jf.intel.com (10.7.209.18) by
 rrsmsx606-2.rr.intel.com (10.31.1.136) with Microsoft SMTP Server id
 8.2.255.0; Mon, 19 Sep 2011 23:17:01 -0600
Received: from linux.jf.intel.com (HELO linux.intel.com) ([10.23.219.25]) 
 by orsmga001.jf.intel.com with ESMTP; 19 Sep 2011 22:16:59 -0700
Received: from linux.intel.com (linux.intel.com [127.0.0.1])	by
 linux.intel.com (Postfix) with ESMTP id 6A1466A4082;	Mon, 19 Sep 2011
 22:16:57 -0700 (PDT)
Received: from azsmga001.ch.intel.com (azsmga001.ch.intel.com [10.2.17.19])
	by linux.intel.com (Postfix) with ESMTP id 87C516A4082	for
 <internal-wifi-devel@linux.intel.com>;	Mon, 19 Sep 2011 22:16:56 -0700 (PDT)
Received: from iapp029.jer.intel.com (HELO localhost.localdomain)
 ([10.12.252.35])	by azsmga001.ch.intel.com with ESMTP; 19 Sep 2011 22:16:56
 -0700
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "internal-wifi-devel@linux.intel.com" <internal-wifi-devel@linux.intel.com>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Sender: "internal-wifi-devel-bounces@linux.intel.com"
 <internal-wifi-devel-bounces@linux.intel.com>
Date: Mon, 19 Sep 2011 22:16:54 -0700
Subject: [Internal-wifi-devel] [PATCH] iwlagn: update rate scaling with BA
 notifications
Thread-Topic: [Internal-wifi-devel] [PATCH] iwlagn: update rate scaling
 with BA	notifications
Thread-Index: Acx3VJZ7Wv3bk11hTxOeFpC21jME+g==
Message-ID: <1316495814-16512-1-git-send-email-emmanuel.grumbach@intel.com>
List-Help: <mailto:internal-wifi-devel-request@linux.intel.com?subject=help>
List-Subscribe:
 <http://linux.intel.com/mailman/listinfo/internal-wifi-devel>,
 <mailto:internal-wifi-devel-request@linux.intel.com?subject=subscribe>
List-Unsubscribe:
 <http://linux.intel.com/mailman/listinfo/internal-wifi-devel>,
 <mailto:internal-wifi-devel-request@linux.intel.com?subject=unsubscribe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: RRSMSX606.amr.corp.intel.com
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.68,409,1312182000"; d="scan'208";a="50725773"
x-extloop1: 1
x-extloopcount2: 2 from 10.23.219.25
errors-to: internal-wifi-devel-bounces@linux.intel.com
list-id: internal wifi development mailing list
 <internal-wifi-devel.linux.intel.com>
list-post: <mailto:internal-wifi-devel@linux.intel.com>
list-archive: <http://linux.intel.com/pipermail/internal-wifi-devel>
x-original-to: internal-wifi-devel@linux.intel.com
delivered-to: internal-wifi-devel@localhost.localdomain
x-beenthere: internal-wifi-devel@linux.intel.com
x-mailman-version: 2.1.5
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Evolution-Source: imap://wwguy@imapmail.intel.com/
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the current code, the rate scaling isn't fed with
statistics from the BA notifications.

This is since my patch:

	iwlagn: reclaim the packets in transport layer

Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 1a475a5..5e5a09b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -342,6 +342,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	iwl_update_stats(priv, true, fc, len);
 
+	memset(&info->status, 0, sizeof(info->status));
+
 	info->driver_data[0] = ctx;
 	info->driver_data[1] = dev_cmd;
 
@@ -580,6 +582,9 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 		IWL_DEBUG_COEX(priv, "receive reply tx w/ bt_kill\n");
 	}
 
+	if (tx_resp->frame_count == 1)
+		return;
+
 	/* Construct bit-map of pending frames within Tx window */
 	for (i = 0; i < tx_resp->frame_count; i++) {
 		u16 fstatus = le16_to_cpu(frame_status[i].status);
@@ -937,7 +942,10 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		else
 			WARN_ON_ONCE(1);
 
-		if (freed == 0) {
+		info = IEEE80211_SKB_CB(skb);
+		kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
+
+		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
 			/* put the rate scaling data there */
 			info = IEEE80211_SKB_CB(skb);
@@ -950,9 +958,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 						    info);
 		}
 
-		info = IEEE80211_SKB_CB(skb);
-		kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
-
 		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
-- 
1.7.1

_______________________________________________
internal-wifi-devel mailing list
internal-wifi-devel@linux.intel.com
http://linux.intel.com/mailman/listinfo/internal-wifi-devel


--=-IMeINq6A+GC2kkh0M6Ec--

