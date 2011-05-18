Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:50380 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab1ERKLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 06:11:22 -0400
Date: Wed, 18 May 2011 12:11:16 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [BUG] ath9k_htc: new devices get name wlan%d if not in rules
Message-ID: <20110518101116.GA14900@zenon.in.qult.net> (sfid-20110518_121126_179770_EA86C9CA)
References: <BANLkTim-XdEJNfSS1UtP7Yf1UZVaPonvQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
In-Reply-To: <BANLkTim-XdEJNfSS1UtP7Yf1UZVaPonvQA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 17, 2011 at 03:33:34PM -0400, thus spake George Nychis:
> I haven't narrowed it down to the exact build date where this breaks,
> but I know that it works in compat-wireless-2011-05-01, and not in
> compat-wireless-2011-05-11+ (including last night's build).  I had
> trouble building compat-wireless-2011-05-04/05 so it was hard for me
> to narrow it down.

The parsing of the format of interface name has been reworked in some recent
commit in the kernel.  Consequently, several calls to dev_alloc_name (which
does the actual parsing of the format string and allocation of a number) have
been removed from several kernel components and the parsing and number
allocation is done in some unique common place down the road.  The problem is,
compat-wireless doesn't add this bit of "common place" code, but still removes
the original calls to dev_alloc_name.

This is something that should be added to compat/, but in the meantime, you
can apply the attached patch.

Ignacy

-- 
A person is shit's way of making more shit.
		-- S. Barnett, anthropologist.

--8t9RHnE3ZwKMSgU+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="compat-wireless-dev-alloc-name.patch"

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8531915..27264de 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1173,6 +1173,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
 #endif
 
+	ret = dev_alloc_name(ndev, ndev->name);
+	if (ret < 0)
+		goto fail;
+
 	ieee80211_assign_perm_addr(local, ndev, type);
 	memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));

--8t9RHnE3ZwKMSgU+--
