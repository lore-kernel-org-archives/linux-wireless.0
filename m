Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2DEMMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 08:12:39 -0400
Message-ID: <1333627956.3494.8.camel@jlt3.sipsolutions.net> (sfid-20120405_141241_975986_DFA5A6A5)
Subject: warnings/errors compiling compat
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Date: Thu, 05 Apr 2012 14:12:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm on 3.1.0 on this machine.

First I get this:

/tmp/compat-wireless-2012-04-04/config.mk:73: "WARNING: You are running a kernel >= 2.6.23, you should enable in it CONFIG_NET_SCHED for 802.11[ne] support"

which doesn't make a lot of sense? We don't need CONFIG_NET_SCHED I
believe since we always have the FIFO qdisc?

Then a few warnings:

/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:47:1: warning: "__enabled_CONFIG_IP_VS" is not defined [-Wundef]
/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:47:1: warning: "__enabled_CONFIG_IP_VS_MODULE" is not defined [-Wundef]
/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:56:1: warning: "__enabled_CONFIG_NETFILTER_XT_TARGET_TRACE" is not defined [-Wundef]
/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:56:1: warning: "__enabled_CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE" is not defined [-Wundef]
/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:47:1: warning: "__enabled_CONFIG_IP_VS" is not defined [-Wundef]
/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:47:1: warning: "__enabled_CONFIG_IP_VS_MODULE" is not defined [-Wundef]
/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:56:1: warning: "__enabled_CONFIG_NETFILTER_XT_TARGET_TRACE" is not defined [-Wundef]
/tmp/compat-wireless-2012-04-04/compat/compat-3.3.c:56:1: warning: "__enabled_CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE" is not defined [-Wundef]


b44 fails to compile for reasons I don't understand -- shouldn't SSB be
part of compat? I don't have SSB in the base kernel.

/tmp/compat-wireless-2012-04-04/drivers/net/ethernet/broadcom/b44.c: In function ‘b44_pci_init’:
/tmp/compat-wireless-2012-04-04/drivers/net/ethernet/broadcom/b44.c:2342:2: error: implicit declaration of function ‘ssb_pcihost_register’ [-Werror=implicit-function-declaration]

johannes

