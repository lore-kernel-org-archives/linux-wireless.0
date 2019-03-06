Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D056C10F00
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 20:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26DF420661
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 20:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbfCFUDV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 15:03:21 -0500
Received: from mout.gmx.net ([212.227.15.18]:54013 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfCFUDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 15:03:20 -0500
Received: from Juliuss-Air-2.fritz.box ([87.123.204.100]) by mail.gmx.com
 (mrgmx003 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0MOfcU-1h7gUY14nm-0064r7; Wed, 06 Mar 2019 21:02:56 +0100
From:   Julius Niedworok <julius.n@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     julius.n@gmx.net, ga58taw@mytum.de, david@redhat.com,
        nc@net.in.tum.de, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2] mac80211: debugfs option to force TX status frames
Date:   Wed,  6 Mar 2019 21:02:05 +0100
Message-Id: <20190306200206.60916-1-julius.n@gmx.net>
X-Mailer: git-send-email 2.10.1 (Apple Git-78)
In-Reply-To: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
X-Provags-ID: V03:K1:WED7gH8PQCymbI0Mi6oSuDmgSRevpD5vZTpEUQR3v+d71yp3lJT
 n60H5KmxOw+CWJb3BjkQJ2WlrMWKP1nc5jkpyt6KXP1rABexl9AQ0ktlZ9ho2avMW5yz4E/
 vFDiR4dYUH5cmSKlLJ32BVG5dhfNqtTl71mEfczqk3/qtl6P6gc2WY0YbFaPiNgskLD5eP9
 O+fX3wluxyDvHpc2phCPQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PQHMVE9NQYg=:fyj2pmY3xaurOGuW1iYLnL
 u7vUbYNR9pgad+LxhSe9OipTl/EI8Qv4HpyaXcIlPEUljAi7Oj1IIKzBD5JhoUVeAwHmkjmye
 H40YPn0wZcIHrtzHaU2PXqI8QeViiL3gYU8ba+rVOtn8C1O9KU1XuIEwKafsmHK5ZWE91b0Vi
 7sU6kMjfaUfZrno/LIbFz594exFoNGbpbrLtKVzu/if5hzCEo5w+ciU+WXvaLBCi6T21g2BWV
 tjRfoSBGpkVUnjNjDiQQX0KSgu8ryeOtSSEM6MdurvvGAv0Yu1+KpIRBA3xvMazURZDnP8JjD
 OSdWNHxpQSTVCH3dR4zoKz2v4iUI/HYC40XN3O1Bgo40eps7F8TP2DtY6Pm8dOlyntJHf27Tt
 jTFZrow1zdk/flPtVIJY6tYop+zrP8OM4kLNYQklV3WTXXt1P23XwqUwkT8xj04l2vUuUr3kt
 sIMYmI1SVIPW0UiCX9ebgv/IlBxvpct0K+l3jGIJHsKoSbr/wNKZfsgmCal2ZC3VLdAEzJwiB
 9fHzPvNWKhnBlKu6NXsUZTXEwIUGPsETKIBdX/D9BiRhSnJk6V1cFbUb8pUxKQ0hCAFyAI1rY
 pcf+mMwMovYc7C26/ZnWBhyczM8hMaC9/+3k9nbpj/iA++Dus8rre0JWTN4nahnpZNohyJJgT
 5pSOd07rnR1JuRfNdKw8amyIOREmovTAS4HyX3J3/XTd+Rbryfpi8zfcPV/R+17zm8r+c4jYe
 vKR5VwL4eiH1a1sh4Q0TnSLErFpL9Vo21D4sHOY1OeQZQvkgsrYFo7qoSpklFFyQ7qKxg5Gks
 kl+2KlvJlqE7/FlW6SCtYKJjZuGi4i+MY2fE53KGCpqRMyHSfGFutaAkZiBrQbNAZZGxOjF43
 qt8I1Rc/+RjmuJKua+iRVsSbhAJtVPoJu5jqqVfxoAN9czE1WSWfS0yYiSS4Jw
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

At Technical University of Munich we use MAC 802.11 TX status frames to
perform several measurements in MAC 802.11 setups.

With ath based drivers this was possible until commit d94a461d7a7df6
("ath9k: use ieee80211_tx_status_noskb where possible") as the driver
ignored the IEEE80211_TX_CTL_REQ_TX_STATUS flag and always delivered
tx_status frames. Since that commit, this behavior was changed and the
driver now adheres to IEEE80211_TX_CTL_REQ_TX_STATUS.

Due to performance reasons, IEEE80211_TX_CTL_REQ_TX_STATUS is not set for
data frames from interfaces in managed mode. Hence, frames that are sent
from a managed mode interface do never deliver tx_status frames. This
remains true even if a monitor mode interface (the measurement interface)
is added to the same ieee80211 physical device. Thus, there is no
possibility for receiving tx_status frames for frames sent on an interface
in managed mode, if the driver adheres to IEEE80211_TX_CTL_REQ_TX_STATUS.

In order to force delivery of tx_status frames for research and debugging
purposes, implement a debugfs option force_tx_status for ieee80211 physical
devices. When this option is set for a physical device,
IEEE80211_TX_CTL_REQ_TX_STATUS is enabled in all packets sent from that
device. This option can be set via
/sys/kernel/debug/ieee80211/<dev>/force_tx_status. The default is disabled.

Co-developed-by: Charlie Groh <ga58taw@mytum.de>
Signed-off-by: Charlie Groh <ga58taw@mytum.de>
Signed-off-by: Julius Niedworok <julius.n@gmx.net>
---
 net/mac80211/debugfs.c     | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/tx.c          | 10 +++++++++
 3 files changed, 64 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3fe541e..074b5d1 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -150,6 +150,58 @@ static const struct file_operations aqm_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t force_tx_status_read(struct file *file,
+				    char __user *user_buf,
+			size_t count,
+			loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[3];
+	int len = 0;
+
+	len = scnprintf(buf, sizeof(buf), "%d\n", (int)local->force_tx_status);
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       buf, len);
+}
+
+static ssize_t force_tx_status_write(struct file *file,
+				     const char __user *user_buf,
+			 size_t count,
+			 loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[3];
+	size_t len;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(buf, user_buf, count))
+		return -EFAULT;
+
+	buf[sizeof(buf) - 1] = '\0';
+	len = strlen(buf);
+	if (len > 0 && buf[len - 1] == '\n')
+		buf[len - 1] = 0;
+
+	if (buf[0] == '0' && buf[1] == '\0')
+		local->force_tx_status = 0;
+	else if (buf[0] == '1' && buf[1] == '\0')
+		local->force_tx_status = 1;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static const struct file_operations force_tx_status_ops = {
+	.write = force_tx_status_write,
+	.read = force_tx_status_read,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
@@ -379,6 +431,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
+	DEBUGFS_ADD_MODE(force_tx_status, 0600);
 
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD_MODE(aqm, 0600);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7dfb4e2..3339b5d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1367,6 +1367,7 @@ struct ieee80211_local {
 		struct dentry *rcdir;
 		struct dentry *keys;
 	} debugfs;
+	bool force_tx_status;
 #endif
 
 	/*
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 928f13a..717fa71 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2463,6 +2463,11 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	if (IS_ERR(sta))
 		sta = NULL;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+		if (local->force_tx_status)
+			info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+#endif
+
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
 	ethertype = (skb->data[12] << 8) | skb->data[13];
@@ -3468,6 +3473,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
 	info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+		if (local->force_tx_status)
+			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+#endif
+
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		*ieee80211_get_qos_ctl(hdr) = tid;
-- 
2.10.1 (Apple Git-78)

