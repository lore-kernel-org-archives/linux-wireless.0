Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2BMONK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 09:13:10 -0500
Subject: RTLWIFI_DEBUG bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 15:13:07 +0100
Message-ID: <1329142387.3365.6.camel@jlt3.sipsolutions.net> (sfid-20120213_151314_357491_E31444E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

config RTLWIFI_DEBUG
        tristate "Additional debugging output"
        depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
        default y

should be

config RTLWIFI_DEBUG
        bool "..."

as otherwise

+#ifdef CONFIG_RTLWIFI_DEBUG

can never be true in a modular build.

johannes

