Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:23912 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIVHe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 03:34:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id CA02B3A009
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2009 09:34:59 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ESqcxEYWIwR4 for <linux-wireless@vger.kernel.org>;
	Tue, 22 Sep 2009 09:34:59 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F88BE.dip0.t-ipconnect.de [217.95.136.190])
	by mx51.mymxserver.com (Postfix) with ESMTP id 7AA4C3A004
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2009 09:34:58 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 39B7A1E0036
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2009 09:34:07 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: BUGLET? cfg80211: .dumpit methods called twice
Date: Tue, 22 Sep 2009 09:33:24 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909220933.24443.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just noticed that all functions mentioned on .dumpit in 
net/wireless/nl80211.c are actually called twice.

For example, I've added

--- linux-wl.orig/net/wireless/nl80211.c        2009-09-18 
14:44:28.000000000 +0200
+++ linux-wl/net/wireless/nl80211.c     2009-09-18 
14:45:41.000000000 +0200
@@ -2919,6 +2919,8 @@ static int nl80211_trigger_scan(struct s
        enum ieee80211_band band;
        size_t ie_len;

+       printk("##HS %s:%d\n", __func__, __LINE__);
+
        if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
                return -EINVAL;

and when I now issue one "iw eth1 scan dump" I get two logs of 
this printk in my dmesg.

AFAIK it doesn't cause any harm, but it's not that efficient and 
it might cause harm in the future if any of the .dumpit methods 
has the "right" side-effects.

-- 
http://www.holgerschurig.de
