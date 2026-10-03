Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18BE41DEE7
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 11:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791026888; cv=none; b=fgti7lh4WD5kTBiD/tnNM824bLqwbepbmYdOP7ldV9evNaz6gTApWcRiVd4jfd9SLDzP7kduyBXQGPvshD1Vm7WZRiWyoh0NFSG3/IEjWCJDZB49hJCO6SNbayTV0b4WwGHbJWUkY29GtIrs1yMWz5jtgSM6gAAP5eHzrqJzf9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791026888; c=relaxed/simple;
	bh=MmyAHK9+FJcu2pnKsCcuiXzyK3XdbTE0yY89As4vQD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KOHe4eRsCSYcQzWuLBaQzndGjZK+BJz9ceiVRJ4Vlw5aK+YMf9MyTc+3ZWZOHaZ/ZIMAT3L1Qi8t37hUfqfwEPhjN3Sko6SSUXhq+/EDajIjvJCO7jHPpZgADz8VXu7VjWXzVMueEqQMBlHokfjbnFPUBbH6bfLvgyj/uY1HQk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rTqRlDok; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTqRlDok"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-3511e727e66so28782eec.0
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 04:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791026886; x=1791631686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wPM3CqOSqDsNCyUXz38kq8QIKEbOP+NtaeKrn3nF51o=;
        b=rTqRlDokmPHhoYbl7MlRzhlUxO2qXJ63WpOUmOq6uQlfB7o+bxzQZolRFFkcoeyi04
         78OwtvVyavHBZxP9jSRxDvRLuKpLTUhPsb/dZVSUFxgF9quhoHCo5zE/TCjZhixmPIyE
         BR196Ly6c+uL84GFaigV9tND06M+Uzt0wCIKPGUp0RVLVzYAYzp2PN5w3LmKQXGVg+iN
         xroC2q3VuLXb0fDUL0luD9auyKSMLK5Pyod51L5e9GiTT1NXz30bsMenkz+WboOSMqGd
         qi2qYr+1WIrrz0YNBnFe7tUGYrxGHXehmmVC/49qpZFfqveDHGxZqcdB4WJrrlowW+ao
         +MDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791026886; x=1791631686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wPM3CqOSqDsNCyUXz38kq8QIKEbOP+NtaeKrn3nF51o=;
        b=ONYq8mYIv/0PLcPRCWIbCLPrcw7dX316mwyc8Un5xZMIvYVU6YKL37gQ7s+4fz0yG4
         uRY8p/E3vdg1oYki30KIgHdIkxnKKJzfdvEuKKFZMWiRiqbsZjBp3fwx5yCUtx76C9EF
         dbnIBMGr9XFjAqbyWIs/hoJuZlR3DM7dW3vRuhBDxBySCWHvgOXbkfKpa4TZIUB2FJ7P
         dEgPu/WnzlbyK8vchTM96Kl9WhAGAIuQpdkw0MiqVd3H0CyTo+q5m+vXDuG4bXJ0uekg
         Ne0yN0iS+xxva6V2otC5z9CDwW1GB0GXpxtgdntCizfQ8Jn6ei5TcEAxMnsBSpzU05o4
         n8Gg==
X-Gm-Message-State: AFq9FYJ69Z5Vweb9V15em0TLmAyuPSOBzQl+7Fa1lgVb1Be6QX/MdCWP
	6zpp4/ccN2c3qQUFdkkCs9mR+x8iWvVFQIjVhKzo5vHzcOvrJpRRPIEm
X-Gm-Gg: AYBFou0NVN0SFjaFOcf4qoH9Inhna74QaTb1sAnW/v6Wx4KlLD0f5hIoDDE9FasJ8oC
	QPK1Ah50M4ADSOciH6/2r4YHkkITTV7ekxMbuvcfbQdEQK5AOrIC3+gcP8k1vnrMn9H/8w/xf1p
	DADC/rVRyXzwQjhe3+39seU5LnSbuYKiofOJTey1DlxyItkdsWuOEHvdr2gFA5gfjuYOfKIuZL+
	uLT9e1CKM8J1k+0/41SjmRRMS5bMCdmUENPqDVcE6OqUCvTz8RFdnW0k3B5UZtyDoV01SKhpwSq
	Vx4MBK/DkSq7y/0kh0DlKzBdlQ1UkKTJgneYEI12E1VeVddoRUiIL42A3fZ/wfTl8V+RRizqTGY
	+ZCDhxT0EHvBKIGRQxENuVI7NDiPsu9X+iVqgfv62eXJQ+nwgqVcWVSlYV/90mKovK3Sl/nBGEd
	OIdG7UXYU8VipSU9W1YoO5cONWGK6He17PRVikjVnKbV5rnor5DDastLrJsPlEG/g5SCtFWx0hr
	jh30H70AhcBll44Zfb29Q==
X-Received: by 2002:a05:693c:41d6:20b0:34c:d55e:a752 with SMTP id 5a478bee46e88-34f150ab8b9mr6673210eec.8.1791026885694;
        Sat, 03 Oct 2026 04:28:05 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5a:270d:d8d9:1655:523e:290e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f15001196sm12909334eec.27.2026.10.03.04.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 04:28:05 -0700 (PDT)
From: Raj Ojha <rajojha047@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	syzbot+e9cbd080a7801f06cf08@syzkaller.appspotmail.com,
	Raj Ojha <rajojha047@gmail.com>
Subject: [PATCH] wifi: mac80211: acquire wiphy lock for unlisted sdata teardown
Date: Sat,  3 Oct 2026 16:57:41 +0530
Message-ID: <20261003112741.52-1-rajojha047@gmail.com>
X-Mailer: git-send-email 2.47.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When netdev registration fails or an interface cannot be moved out of a
dying network namespace, the netdev core calls ->ndo_uninit()
(ieee80211_uninit) with RTNL held.

However, ieee80211_uninit() calls ieee80211_teardown_sdata() without
holding wiphy_lock. During teardown, ieee80211_free_keys() invokes
wiphy_delayed_work_cancel(), which triggers a lockdep warning:

  WARNING: CPU: 0 PID: 6112 at net/wireless/core.c:1839 wiphy_delayed_work_cancel+0x85/0xb0
  ...
  Call Trace:
   ieee80211_free_keys+0x31a/0x3c0 net/mac80211/key.c:380
   ieee80211_teardown_sdata+0x2b8/0x10f0 net/mac80211/iface.c:928
   ieee80211_uninit+0x3f/0x50 net/mac80211/iface.c:954
   rollback_registered_many+0xa5c/0xef0 net/core/dev.c:10065

In the normal deletion path (ieee80211_del_virtual_intf), both RTNL and
wiphy_lock are held when ieee80211_teardown_sdata() runs, and the sdata
is removed from local->interfaces.

Change ieee80211_unlist_sdata() to return a boolean indicating whether the
sdata was present in the list, and acquire wiphy_lock in ieee80211_uninit()
only if the interface is actually being unlisted here.

Reported-by: syzbot+e9cbd080a7801f06cf08@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9cbd080a7801f06cf08
Tested-by: syzbot+e9cbd080a7801f06cf08@syzkaller.appspotmail.com
Signed-off-by: Raj Ojha <rajojha047@gmail.com>
---
 net/mac80211/iface.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5f0c482..175965f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -931,7 +931,7 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
  * core when cfg80211 couldn't move it out of a network namespace that's being
  * destroyed. Drop it from the interface list either way.
  */
-static void ieee80211_unlist_sdata(struct ieee80211_sub_if_data *sdata)
+static bool ieee80211_unlist_sdata(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *iter;
@@ -943,16 +943,25 @@ static void ieee80211_unlist_sdata(struct ieee80211_sub_if_data *sdata)
 			continue;
 		guard(mutex)(&local->iflist_mtx);
 		list_del_rcu(&sdata->list);
-		return;
+		return true;
 	}
+
+	return false;
 }
 
 static void ieee80211_uninit(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct wiphy *wiphy = sdata->local->hw.wiphy;
+	bool unlisted = ieee80211_unlist_sdata(sdata);
+
+	if (unlisted)
+		wiphy_lock(wiphy);
 
-	ieee80211_unlist_sdata(sdata);
 	ieee80211_teardown_sdata(sdata);
+
+	if (unlisted)
+		wiphy_unlock(wiphy);
 }
 
 static int ieee80211_netdev_setup_tc(struct net_device *dev,
-- 
2.47.0.windows.1

