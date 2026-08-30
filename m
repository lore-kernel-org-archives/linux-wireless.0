Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40E933E367;
	Sun, 30 Aug 2026 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788098104; cv=none; b=LSclg2Hm53ZFvzMVGoqRQKNwaAR6nd5fMO7WZpqYbBz41PLTKiB3QoI+v67dqU8WfoCYqJFJCio9M1FTCzqughMrN2K4M6kAxBqY2OmrlV6zpikLN9K/24FhLDVL9aK6gmgu8na7WXtMTeC+RBC96Ti0/Bf4Y50OLFJSI/j0PdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788098104; c=relaxed/simple;
	bh=6QBQHY6j0RoXtMeUaJX91ag21Ctgs1KUznPZxmunG4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MJeolaW6x6cE1byuZiA5f3pyDYpEOfVCN/q5FS6mOahKIGG6vg7VzSm6G0Pe4gUsP9JHJ6AoxrZkL3m+aCS32tb7FDUApP9yG+Q+k1/3nFR9Ysim9OeqK+mZr5skqQ6QJo6Tq6Uk/1ypK0vbjiLcapSuOrY17r/lAE8PYwlfyug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowAC3wT8xNpRqDWWbBg--.23198S2;
	Sun, 30 Aug 2026 21:54:57 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: p54: validate USB receive prefixes
Date: Sun, 30 Aug 2026 21:54:55 +0800
Message-ID: <20260830135455.14096-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAC3wT8xNpRqDWWbBg--.23198S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar43CFyrWFykWrW5tw4fXwb_yoW8uryxpF
	4fC3W5KFs0qF4Yg3WxAF4fZFWft3WrWFyI9FyfG395Cr4kXr1rXas0gFy2vrn5GrWFqws8
	Arn8tr1rWrnrJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUna9aUUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

p54u_rx_cb() strips transport-specific prefixes from a successful USB
receive without checking urb->actual_length. A short transfer can leave
skb_pull() ineffective and pass an unstripped buffer to p54_rx().

Compute the required prefix length and recycle a short receive buffer
before parsing it.

Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/intersil/p54/p54usb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/p54usb.c b/drivers/net/wireless/intersil/p54/p54usb.c
index b88a3dadddc09..c689b98418ddd 100644
--- a/drivers/net/wireless/intersil/p54/p54usb.c
+++ b/drivers/net/wireless/intersil/p54/p54usb.c
@@ -143,6 +143,7 @@ static void p54u_rx_cb(struct urb *urb)
 	struct p54u_rx_info *info = (struct p54u_rx_info *)skb->cb;
 	struct ieee80211_hw *dev = info->dev;
 	struct p54u_priv *priv = dev->priv;
+	unsigned int prefix_len = 0;
 
 	skb_unlink(skb, &priv->rx_queue);
 
@@ -151,8 +152,18 @@ static void p54u_rx_cb(struct urb *urb)
 		return;
 	}
 
-	skb_put(skb, urb->actual_length);
+	if (priv->hw_type == P54U_NET2280)
+		prefix_len += priv->common.tx_hdr_len;
+	if (priv->common.fw_interface == FW_LM87)
+		prefix_len += 4;
+	if (urb->actual_length < prefix_len) {
+		skb_reset_tail_pointer(skb);
+		skb_trim(skb, 0);
+		urb->transfer_buffer = skb_tail_pointer(skb);
+		goto resubmit;
+	}
 
+	skb_put(skb, urb->actual_length);
 	if (priv->hw_type == P54U_NET2280)
 		skb_pull(skb, priv->common.tx_hdr_len);
 	if (priv->common.fw_interface == FW_LM87) {
@@ -183,6 +194,7 @@ static void p54u_rx_cb(struct urb *urb)
 		skb_trim(skb, 0);
 		urb->transfer_buffer = skb_tail_pointer(skb);
 	}
+resubmit:
 	skb_queue_tail(&priv->rx_queue, skb);
 	usb_anchor_urb(urb, &priv->submitted);
 	if (usb_submit_urb(urb, GFP_ATOMIC)) {

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

