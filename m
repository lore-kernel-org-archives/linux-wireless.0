Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:49962 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab1ITFu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 01:50:58 -0400
Received: from [192.168.4.203] (unknown [193.140.74.51])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ozan)
	by lider.pardus.org.tr (Postfix) with ESMTPSA id F0E5BA7AB03
	for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 08:38:56 +0300 (EEST)
Message-ID: <4E7827EC.2030302@pardus.org.tr> (sfid-20110920_075102_957844_5C2AD477)
Date: Tue, 20 Sep 2011 08:43:08 +0300
From: =?ISO-8859-9?Q?Ozan_=C7a=F0layan?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Fix compat-wireless build on 2.6.37
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following fix should be applied to the compat tree to fix a build 
error in wl12xx. Since kernel.org is down, I couldn't fetch the compat 
tree to post a patch with git send-email.

Index: compat-wireless-2011-08-27-p/include/linux/compat-2.6.38.h
===================================================================
--- compat-wireless-2011-08-27-p.orig/include/linux/compat-2.6.38.h
+++ compat-wireless-2011-08-27-p/include/linux/compat-2.6.38.h
@@ -11,6 +11,10 @@
  /* rename member in struct mmc_host in include/linux/mmc/host.h */
  #define max_segs·  max_hw_segs
·
+static inline bool pm_runtime_enabled(struct device *dev)
+{
+·  return !dev->power.disable_depth;
+}
·
  /* Exponentially weighted moving average (EWMA) */
