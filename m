Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:46788 "EHLO
	smtp3.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0L2RQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 12:16:55 -0500
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: fix compiler-warning when no P54_LEDS are configured
Date: Wed, 29 Dec 2010 18:16:27 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	chunkeey@googlemail.com
References: <1293635679-9783-1-git-send-email-christoph.paasch@uclouvain.be> <4D1B65D7.8090103@lwfinger.net>
In-Reply-To: <4D1B65D7.8090103@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012291816.27302.christoph.paasch@uclouvain.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, December 29, 2010 wrote Larry Finger:
> I was too quick to ACK this. The second hunk causes a compiler ERROR as
> priv is needed in the mutex_destroy() calls.

Oups, sorry. I did not have CONFIG_DEBUG_MUTEXES enabled when trying it out. 
Thus the compile-error did not happen.

What about the following patch?

>From 5701b5f5ffbf0927025906e968c957f3b2292ece Mon Sep 17 00:00:00 2001
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Date: Wed, 29 Dec 2010 12:40:43 +0100
Subject: [PATCH] p54: fix compiler-warning when no P54_LEDS are configured

The priv-variable is unused when compiling without CONFIG_P54_LEDS.

Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
---
 drivers/net/wireless/p54/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 622d27b..56ea1ce 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -611,7 +611,9 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 
 int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
 {
+#ifdef CONFIG_P54_LEDS
 	struct p54_common *priv = dev->priv;
+#endif /* CONFIG_P54_LEDS */
 	int err;
 
 	err = ieee80211_register_hw(dev);
@@ -653,7 +655,9 @@ EXPORT_SYMBOL_GPL(p54_free_common);
 
 void p54_unregister_common(struct ieee80211_hw *dev)
 {
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_P54_LEDS)
 	struct p54_common *priv = dev->priv;
+#endif
 
 #ifdef CONFIG_P54_LEDS
 	p54_unregister_leds(priv);
-- 
1.7.1




--
Christoph Paasch

Research Assistant
IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP --- http://inl.info.ucl.ac.be/mptcp
Université Catholique de Louvain

www.rollerbulls.be
--
