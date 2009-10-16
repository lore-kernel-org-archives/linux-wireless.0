Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:38229 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056AbZJPM1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:27:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 8D2E94B004
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 14:26:41 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AubD+Aq9UjxP for <linux-wireless@vger.kernel.org>;
	Fri, 16 Oct 2009 14:26:41 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA148.dip0.t-ipconnect.de [217.95.161.72])
	by mx51.mymxserver.com (Postfix) with ESMTP id 3BDDE4B003
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 14:26:38 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 86EC61E0010
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 14:26:29 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: libertas + cfg80211: road for kernel inclusion?
Date: Fri, 16 Oct 2009 14:26:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910161426.22206.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all !

Today I got a connection of libertas + cfg80211 to an AP in the 
modes WEP40, WEP104, WPA, WPA2 and also with no encryption at 
all.

I still have some loose odds and ends, but the initial work is 
done and we can consider if we want this feature included in the 
linux kernel --- or not.


However, an cfg80211-converted libertas has some missing 
features, that others migth think are important: no 
libertas-mesh, no monitor mode, no ad-hoc mode. Nothing of this 
is per-se impossible with cfg80211, it just needs to be 
implemented.

I see several possibilities:


1. Let it mature outside
   ---------------------
Keep libertas+cfg80211 out-of-tree until it supports some minimal 
functionality.

Pro: no one misses a feature
Cons: no widespread testing of the cfg80211 features


2. Take it as it is
   ----------------
Nah, not exactly at it is today, but let us stop by missing 
monitor-mode, adhoc etc --- for now. Implement that later, once 
libertas is in-kernel and people need it.

Pro: widespread testing of the cfg80211 features
Cons: people miss some functions when they upgrade the kernel


3. Make things configurable
   ------------------------
I could create a Kconfig "choice" entry, where one can select 
CONFIG_LIBERTAS_WEXT or CONFIG_LIBERTAS_CFG80211. I would then 
provide a bunch of cleanup patches, e.g. to move all things in 
struct "libertas_private" into one place that are WEXT-related.

Pro: no one misses his beloved feature (because it's in 
CONFIG_LIBERTAS_WEXT)
Pro: some people can test the cfg80211-features (with 
CONFIG_LIBERTAS_CFG80211)
Cons: we have a higher amount of #ifdef in Libertas code until 
either libertas-cfg80211 got all the features added OR until 
WEXT get's removed from the kernel.


-- 
http://www.holgerschurig.de
