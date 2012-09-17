Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:48790 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755501Ab2IQOn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 10:43:28 -0400
Message-ID: <1347893006.2050.2.camel@joe2Laptop> (sfid-20120917_164331_513983_7C08C30D)
Subject: Re: [PATCH] wireless: remove unreachable code
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Mon, 17 Sep 2012 07:43:26 -0700
In-Reply-To: <20120917105354.30097.45595.stgit@localhost.localdomain>
References: <20120917105354.30097.45595.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-17 at 11:54 +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> The only case where intersected_rd can become non NULL is within an if. All
> paths from that if return, so the end chunk has therefore squawked its
> last and is no more.

It might be better to move the declaration into the if brace too
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ad04e5..7985ab2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2192,7 +2192,6 @@ static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 /* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
-	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct cfg80211_registered_device *rdev = NULL;
 	struct wiphy *request_wiphy;
 	/* Some basic sanity checks first */
@@ -2282,6 +2281,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	/* Intersection requires a bit more work */
 
 	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+		const struct ieee80211_regdomain *intersected_rd;
 
 		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
 		if (!intersected_rd)



