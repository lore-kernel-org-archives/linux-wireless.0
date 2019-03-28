Return-Path: <SRS0=yxJm=R7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB65C10F06
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 20:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CFA82173C
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 20:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="QXyiaEen"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfC1UBi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Mar 2019 16:01:38 -0400
Received: from mout.gmx.net ([212.227.15.15]:41261 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfC1UBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Mar 2019 16:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553803280;
        bh=8MV4QEQyumeAPThgLt4Ov47M7GijIT8QbX87vM4i5uE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QXyiaEenuVkW3M7ENnArUzTGqK2JusZPCO+LxO89qNaTP58FF6wZJUJX1swJnz2gS
         YQyBVQQA00wGkT6e4I2aui+nxgg7pv5McEOw59LD4mMKvFJqHyAOEZO1HglMIO8OaX
         8txPA5jS74tdEeBxETEpd8cayBwYUMgI8rsahqfc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Juliuss-Air-2.fritz.box ([92.195.129.110]) by mail.gmx.com
 (mrgmx001 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0MhQxO-1hNR8E0CXa-00MZa6; Thu, 28 Mar 2019 21:01:20 +0100
From:   Julius Niedworok <julius.n@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     julius.n@gmx.net, ga58taw@mytum.de, david@redhat.com,
        nc@net.in.tum.de, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] mac80211: debugfs option to force TX status frames
Date:   Thu, 28 Mar 2019 21:01:06 +0100
Message-Id: <20190328200108.98981-1-julius.n@gmx.net>
X-Mailer: git-send-email 2.10.1 (Apple Git-78)
In-Reply-To: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
X-Provags-ID: V03:K1:DeGiNNCRwiCItmKzCKHlW92Lcyo5uzx1nW6z68uGMhfnuN5q3a4
 uc0qAtjEyFN8fFUXRaO85iVTFEMumVDAky+Gmla8VfNioUKsREHT8h0uFx/q6IQE+OyP3Aj
 bEyinCUihdEmcd5NzpAIkGy8+lIp0e3s2ONw0ZVv2P7BtuY0sJPR4C9BnRkUt520Z7DCZ9R
 dfNHXuhlaX29GYs7i6r3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y49Ny4mZGhs=:WF8sqz1gWOmarDbbg/p/C+
 0CjAmjMzgAnm5TU6kJ488gqo+fLqdZMejkHL2M3MHjAqqBqJhy+xuj4nQtJQkaf9YQyEIZoNM
 QMCI4nb2EGsOToGoHiH7Ds+1TqeZi2B7Kyo3/ix2VHjZuUIH7WxNqXhx8z+uCxXZd+29W09M9
 kky32rkiwzs/TCxahWwXtXY7g4ZGvKryCaimknWWzI7bt9ZqBziz71P2TOSRTHxQ5bGNKydul
 /ijtLVqmyyWEDUoLCIoY09Jz/rfPrjYqXPsLulVYUJNL9fr5HSgeIqvO+CRk2Ma48amLUW4wf
 TRdCMyyuDgAVxKHQky8gdt+cxff4EkUOckkfeLmWlPh0Oaa0QekSW7RJqLJ8DJ+ibu+IoYEv/
 oa24Q+dqufEsIRzIWIMdDZcxwJxPIMxEYmRHfvAaPhqEnvdb3m4NgE8HeSiGd7NoUgnaMzNMh
 fU9MdPI9jP4sqG55aytBkV1R7DsGlNJqYG8KnafVXVRhh1F+TsJEaQ4Sd6lOec9/lpAhFPpdo
 /xtf9pa7F8Waq7xYhkuKy2WK/0BNlgRv6LMenkMn59YI/zMeRmwgXYFyB+CDHygpym9Nc5I+F
 gtAj1H4dLGPm66s9RCMJC7a6Stuu8D7f7sn16LhVmgVudys9vFccPaR89mSjklFLqlTfMsFxn
 ULBoTSPvS1N0J8m5w63mM0W3wfzk+VkjZ11tTEC1K93FcTCUbbkByAEkN4wCvkqIxu30Be/UM
 Boe/KpOgwhHn7MK28MWVnt1PnbD98UhFW/a/QN86tbH6KFzx7sbe5nHo+gMtmTjPr1giZNOOc
 SO9wbLbKHiwk8XHIrht0hTb7tuliVFlMkZ/9kEmVcxoXcwjmytdYQ/O0KHw6mh6nb+bayLhFh
 vnDPerBWMPe5saYocV+Sxtaa8Uly1eecexOesYhzI4bYbZ9dU4wEUnZr9B594P
Content-Transfer-Encoding: quoted-printable
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
purposes, implement a debugfs option force_tx_status for ieee80211 physica=
l
devices. When this option is set for a physical device,
IEEE80211_TX_CTL_REQ_TX_STATUS is enabled in all packets sent from that
device. This option can be set via
/sys/kernel/debug/ieee80211/<dev>/force_tx_status. The default is disabled=
.

Co-developed-by: Charlie Groh <ga58taw@mytum.de>
Signed-off-by: Charlie Groh <ga58taw@mytum.de>
Signed-off-by: Julius Niedworok <julius.n@gmx.net>
=2D--
 net/mac80211/debugfs.c     | 53 +++++++++++++++++++++++++++++++++++++++++=
+++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/tx.c          | 10 +++++++++
 3 files changed, 64 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2d43bc1..da8f27c 100644
=2D-- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -150,6 +150,58 @@ static const struct file_operations aqm_ops =3D {
 	.llseek =3D default_llseek,
 };

+static ssize_t force_tx_status_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count,
+				    loff_t *ppos)
+{
+	struct ieee80211_local *local =3D file->private_data;
+	char buf[3];
+	int len =3D 0;
+
+	len =3D scnprintf(buf, sizeof(buf), "%d\n", (int)local->force_tx_status)=
;
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       buf, len);
+}
+
+static ssize_t force_tx_status_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count,
+				     loff_t *ppos)
+{
+	struct ieee80211_local *local =3D file->private_data;
+	char buf[3];
+	size_t len;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(buf, user_buf, count))
+		return -EFAULT;
+
+	buf[sizeof(buf) - 1] =3D '\0';
+	len =3D strlen(buf);
+	if (len > 0 && buf[len - 1] =3D=3D '\n')
+		buf[len - 1] =3D 0;
+
+	if (buf[0] =3D=3D '0' && buf[1] =3D=3D '\0')
+		local->force_tx_status =3D 0;
+	else if (buf[0] =3D=3D '1' && buf[1] =3D=3D '\0')
+		local->force_tx_status =3D 1;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static const struct file_operations force_tx_status_ops =3D {
+	.write =3D force_tx_status_write,
+	.read =3D force_tx_status_read,
+	.open =3D simple_open,
+	.llseek =3D default_llseek,
+};
+
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf=
,
 			   size_t count, loff_t *ppos)
@@ -382,6 +434,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
+	DEBUGFS_ADD_MODE(force_tx_status, 0600);

 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD_MODE(aqm, 0600);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e170f98..28ac87c 100644
=2D-- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1384,6 +1384,7 @@ struct ieee80211_local {
 		struct dentry *rcdir;
 		struct dentry *keys;
 	} debugfs;
+	bool force_tx_status;
 #endif

 	/*
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8a49a74..a39ce49 100644
=2D-- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2470,6 +2470,11 @@ static struct sk_buff *ieee80211_build_hdr(struct i=
eee80211_sub_if_data *sdata,
 	if (IS_ERR(sta))
 		sta =3D NULL;

+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (local->force_tx_status)
+		info_flags |=3D IEEE80211_TX_CTL_REQ_TX_STATUS;
+#endif
+
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
 	ethertype =3D (skb->data[12] << 8) | skb->data[13];
@@ -3475,6 +3480,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_su=
b_if_data *sdata,
 		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
 	info->control.flags =3D IEEE80211_TX_CTRL_FAST_XMIT;

+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (local->force_tx_status)
+		info->flags |=3D IEEE80211_TX_CTL_REQ_TX_STATUS;
+#endif
+
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid =3D skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		*ieee80211_get_qos_ctl(hdr) =3D tid;
=2D-
2.10.1 (Apple Git-78)

