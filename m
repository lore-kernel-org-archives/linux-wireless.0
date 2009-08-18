Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:52271 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZHRJwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 05:52:16 -0400
Date: Tue, 18 Aug 2009 11:52:17 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/29] mwl8k: remove usage of deprecated radio_enabled
Message-ID: <20090818095217.GA6195@mail.wantstofly.org>
References: <20090818035220.GN18639@mail.wantstofly.org> <1250580509.30538.2.camel@johannes.local> <20090818082537.GK18639@mail.wantstofly.org> <1250583993.30538.3.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250583993.30538.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 10:26:33AM +0200, Johannes Berg wrote:

> > The logic is just:
> > 
> > 	if (idle) {
> > 		issue "radio disable" command
> > 	} else {
> > 		issue "radio enable" command
> > 		set channel
> > 		set tx power
> > 		set antenna config
> > 	}
> > 
> > So if a channel change hapens while we are idle, that event won't get
> > lost -- it'll just happen later.
> 
> Ok, yeah, that looks fine.

OK, thanks.

Since your patch is already in, I've replaced this patch by:


>From 1af73ff8d1309b924f6f4accd61245b57374dd78 Mon Sep 17 00:00:00 2001
From: Lennert Buytenhek <buytenh@wantstofly.org>
Date: Mon, 17 Aug 2009 23:59:40 +0200
Subject: [PATCH 15/29] mwl8k: implement rfkill

By checking IEEE80211_CONF_CHANGE_IDLE in mwl8k_config().

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 177d92f..65eefe8 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2854,6 +2854,12 @@ static int mwl8k_config_wt(struct work_struct *wt)
 	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
 
+	if (conf->flags & IEEE80211_CONF_IDLE) {
+		mwl8k_cmd_802_11_radio_disable(hw);
+		priv->current_channel = NULL;
+		goto mwl8k_config_exit;
+	}
+
 	if (mwl8k_cmd_802_11_radio_enable(hw)) {
 		rc = -EINVAL;
 		goto mwl8k_config_exit;
-- 
1.5.6.4
