Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:12802 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267AbZI0QOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 12:14:05 -0400
Date: Sun, 27 Sep 2009 17:14:04 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Arjan van de Ven <arjan@infradead.org>
cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [bisected] Wireless regression in 2.6.32-git
In-Reply-To: <20090927151855.29efcc53@infradead.org>
Message-ID: <Pine.LNX.4.64.0909271708210.8927@sister.anvils>
References: <20090927151855.29efcc53@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Sep 2009, Arjan van de Ven wrote:
> 
> With todays git my laptop fails to associate with my access point.
> Bisection points to the commit below, and reverting this one commit on
> the HEAD of tree also fixes the issue, so I'm pretty confident that this
> commit is to blame.
> 
> I have a 4965 wifi card in my laptop, and the network I'm trying to
> connect to has no encryption. I'm running Fedora 11 as OS.
> 
> I would like to kindly request for this commit to be reverted until a
> more permanent solution is found (I'm happy to test any patches)..
> 
> 94f85853324e02c3a32bc3101f090dc9a3f512b4 is first bad commit
> commit 94f85853324e02c3a32bc3101f090dc9a3f512b4
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu Sep 17 17:15:31 2009 -0700
> 
>     cfg80211: don't overwrite privacy setting
>     
>     When cfg80211 is instructed to connect, it always
>     uses the default WEP key for the privacy setting,
>     which clearly is wrong when using wpa_supplicant.
>     Don't overwrite the setting, and rely on it being
>     false when wpa_supplicant is not running, instead
>     set it to true when we have keys.
>     
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> :040000 040000 27fb46273e88eefee373699eb7e3f2923ac0886b
> 9518ee3e52c8320613cc5eee5ac54aabf082432f M	net

I've a different problem with wireless that Johannes is investigating
for me on linux-wireless; but here's a patch that he pointed me to
along the way, didn't help my issue but I expect it will help yours...


Subject: cfg80211: don't set privacy w/o key

When wpa_supplicant is used to connect to open networks,
it causes the wdev->wext.keys to point to key memory, but
that key memory is all empty. Only use privacy when there
is a default key to be used.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-sme.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/wext-sme.c	2009-09-24 08:51:14.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-09-24 08:57:01.000000000 +0200
@@ -30,7 +30,8 @@ int cfg80211_mgd_wext_connect(struct cfg
 	if (wdev->wext.keys) {
 		wdev->wext.keys->def = wdev->wext.default_key;
 		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
-		wdev->wext.connect.privacy = true;
+		if (wdev->wext.default_key != -1)
+			wdev->wext.connect.privacy = true;
 	}
 
 	if (!wdev->wext.connect.ssid_len)
