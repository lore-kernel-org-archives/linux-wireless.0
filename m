Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbZEaGW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 02:22:27 -0400
Date: Sun, 31 May 2009 02:22:17 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] Crda oopses the system
Message-ID: <20090531062217.GB23972@bombadil.infradead.org>
References: <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com> <1242256950.3241.13.camel@maxim-laptop> <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com> <1242258469.3241.19.camel@maxim-laptop> <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com> <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com> <1242742647.23110.10.camel@ibm172> <1242951611.5206.9.camel@maxim-laptop> <43e72e890905211736i3dfaf7d5q78d511eac0fbca1e@mail.gmail.com> <1242986902.5544.8.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242986902.5544.8.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 22, 2009 at 01:08:22PM +0300, Maxim Levitsky wrote:
> I am talking about 
> 
> BUG_ON(!country_ie_regdomain);
> in net/wireless/reg.c

Please try this patch and leave a window open with this running:

iw event

Please be sure to grab iw from git, not sure if the reg events
have all gone into an official release yet. What I'm looking for
is whether or not a previous 11d setting was already processed
or if the !country_ie_regdomain condition happens from the first
11d processing.

  Luis

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f87ac1d..1b60dfc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2171,7 +2171,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 * the country IE rd with what CRDA believes that country should have
 	 */
 
-	BUG_ON(!country_ie_regdomain);
+	if (WARN_ON(!country_ie_regdomain)) {
+		kfree(rd);
+		rd = NULL;
+		return -EINVAL;
+	}
 	BUG_ON(rd == country_ie_regdomain);
 
 	/*
@@ -2268,6 +2272,8 @@ int regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
+	country_ie_regdomain = NULL;
+
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 
