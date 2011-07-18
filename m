Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60881 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab1GRHSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 03:18:39 -0400
To: "Kahn\, Gery" <geryk@ti.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
	<874o2nx16b.fsf@purkki.adurom.net>
	<CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com>
	<CABB-i1eXpgA7iiHmrstFBnNjGntUtydQFBL17SJELqt5HU8g3A@mail.gmail.com>
	<87aaccvaxr.fsf@purkki.adurom.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 18 Jul 2011 10:18:37 +0300
In-Reply-To: <87aaccvaxr.fsf@purkki.adurom.net> (Kalle Valo's message of "Mon\, 18 Jul 2011 00\:45\:04 +0300")
Message-ID: <8762n0ukdu.fsf@purkki.adurom.net> (sfid-20110718_091843_001229_02282B43)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@adurom.com> writes:

>> After some investigation, found that ethtool's ioctl interface doesn't work
>> at this case.
>
> This reminds me: I have patches for these issues but I never sent them
> upstream. It's too late for me now, but I'll search them tomorrow (or
> today to be exact..) and send them for testing purposes.

Here's the patch I used:

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 74ead9e..0836aa3 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1185,7 +1185,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 {
 	struct ethtool_regs regs;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
-	void *regbuf;
+	void *regbuf = NULL;
 	int reglen, ret;
 
 	if (!ops->get_regs || !ops->get_regs_len)
@@ -1198,18 +1198,24 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = vzalloc(reglen);
-	if (!regbuf)
-		return -ENOMEM;
+	if (reglen > 0) {
+		regbuf = vzalloc(reglen);
+		if (!regbuf)
+			return -ENOMEM;
+	}
 
 	ops->get_regs(dev, &regs, regbuf);
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &regs, sizeof(regs)))
 		goto out;
-	useraddr += offsetof(struct ethtool_regs, data);
-	if (copy_to_user(useraddr, regbuf, regs.len))
-		goto out;
+
+	if (regs.len > 0) {
+		useraddr += offsetof(struct ethtool_regs, data);
+		if (copy_to_user(useraddr, regbuf, regs.len))
+			goto out;
+	}
+
 	ret = 0;
 
  out:
