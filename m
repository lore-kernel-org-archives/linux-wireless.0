Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fml.cs.pub.ro ([141.85.227.188]:41935 "EHLO vmail.cs.pub.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933424AbbHLH2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 03:28:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by vmail.cs.pub.ro (Postfix) with ESMTP id D33D41A600BF
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 10:18:47 +0300 (EEST)
Received: from vmail.cs.pub.ro ([127.0.0.1])
	by localhost (vmail.cs.pub.ro [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SBYTkY_9Smok for <linux-wireless@vger.kernel.org>;
	Wed, 12 Aug 2015 10:18:47 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by vmail.cs.pub.ro (Postfix) with ESMTP id A8DD21A600C0
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 10:18:47 +0300 (EEST)
Received: from vmail.cs.pub.ro ([127.0.0.1])
	by localhost (vmail.cs.pub.ro [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MgfVnX3b3u4V for <linux-wireless@vger.kernel.org>;
	Wed, 12 Aug 2015 10:18:47 +0300 (EEST)
Received: from vmail.cs.pub.ro (vmail.cs.pub.ro [141.85.227.3])
	by vmail.cs.pub.ro (Postfix) with ESMTP id 8ED161A600BF
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 10:18:47 +0300 (EEST)
Date: Wed, 12 Aug 2015 10:18:47 +0300 (EEST)
From: Vladimir Diaconescu <vladimir.diaconescu@cs.pub.ro>
To: linux-wireless@vger.kernel.org
Message-ID: <1402134600.51682.1439363927472.JavaMail.zimbra@cs.pub.ro> (sfid-20150812_092850_121067_5E5739B3)
In-Reply-To: <1272385718.51672.1439363698417.JavaMail.zimbra@cs.pub.ro>
Subject: [mac80211] Stopping and waking tx queues per vif without
 IEEE80211_HW_QUEUE_CONTROL
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am currently trying to stop packets for specific vifs.

This can easily be done if the IEEE80211_HW_QUEUE_CONTROL flag is set and using ieee80211_stop_vif_queues and ieee80211_wake_vif_queues from util.c. But some drivers/cards do not have this capability.

Currently, all vif queues map to the same hardware queues (since there's a single wireless device). Therefore, stopping and waking queues is a "global" action.

What are my options? Do I "manually" stop the outgoing packets at the mac80211 level?

Specifications:
- kernel version 3.14
- ath9k

Regards,
Vladimir
