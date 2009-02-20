Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60513 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbZBTCko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 21:40:44 -0500
Message-ID: <499E1826.8040903@lwfinger.net> (sfid-20090220_034048_241031_253B0CB2)
Date: Thu, 19 Feb 2009 20:40:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 cannot fix rate
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>    <499B27A4.30708@lwfinger.net>    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>    <499B4526.1030705@lwfinger.net> <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> Hi Larry,
> 
> Been experimenting over last couple of days to enable this. Have
> successfully recompiled the kernel and installed with above config option
> enabled. This may have been unnecessary but could not compile without
> doing it.
> 
> Anyway, now running the custom kernel and installed compart-wireless
> snapshot from 09/02/2009 and still nothing has appeared using
> find /sys -name rc_stats
> 
> I must be missing some vital step. Any thoughts please.

The configuration needs to be in compat-wireless. Please apply the following
patch and rebuild the compat-wireless package.

Index: compat-wireless-2009-02-19/config.mk
===================================================================
--- compat-wireless-2009-02-19.orig/config.mk
+++ compat-wireless-2009-02-19/config.mk
@@ -74,6 +74,7 @@ endif # kernel Makefile check

 # Wireless subsystem stuff
 CONFIG_MAC80211=m
+CONFIG_MAC80211_DEBUGFS=y

 # choose between pid and minstrel as default rate control algorithm
 CONFIG_MAC80211_RC_DEFAULT=minstrel


Larry
