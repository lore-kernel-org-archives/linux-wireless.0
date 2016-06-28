Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44839 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbcF1Kkc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 06:40:32 -0400
Message-ID: <1467110427.2493.8.camel@sipsolutions.net> (sfid-20160628_124135_698192_320EC4DF)
Subject: Re: [PATCH] mac80211: Fix mesh estab_plinks counting in STA removal
 case
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Jun 2016 12:40:27 +0200
In-Reply-To: <20160619205102.GA28350@w1.fi> (sfid-20160619_225105_265465_B90726F0)
References: <20160619205102.GA28350@w1.fi>
	 (sfid-20160619_225105_265465_B90726F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-06-19 at 23:51 +0300, Jouni Malinen wrote:
> If a user space program (e.g., wpa_supplicant) deletes a STA entry
> that
> is currently in NL80211_PLINK_ESTAB state, the number of established
> plinks counter was not decremented and this could result in rejecting
> new plink establishment before really hitting the real maximum plink
> limit. For !user_mpm case, this decrementation is handled by
> mesh_plink_deactive().
> 
> Fix this by decrementing estab_plinks on STA deletion
> (mesh_sta_cleanup() gets called from there) so that the counter has a
> correct value and the Beacon frame advertisement in Mesh
> Configuration
> element shows the proper value for capability to accept additional
> peers.
> 

Applied.

johannes
