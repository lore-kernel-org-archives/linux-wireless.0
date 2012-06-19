Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2FSHUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 03:20:50 -0400
Message-ID: <1340090445.4482.8.camel@jlt3.sipsolutions.net> (sfid-20120619_092054_479219_B167B438)
Subject: Re: [PATCH] iwlwifi: fix Oops on reading debugfs log_event
From: Johannes Berg <johannes@sipsolutions.net>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 19 Jun 2012 09:20:45 +0200
In-Reply-To: <7841457.8s9HYuaGXa@penguin> (sfid-20120617_225841_623189_7D659120)
References: <7841457.8s9HYuaGXa@penguin>
	 (sfid-20120617_225841_623189_7D659120)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-17 at 22:58 +0200, Lekensteyn wrote:
> Before this patch, reading log_event would print the event log to syslog and
> crash if CONFIG_IWLWIFI_DEBUG was disabled (while CONFIG_IWLWIFI_DEBUGFS was
> enabled of course). The crash was caused by (1) iwl_dbgfs_log_event_read failing
> to initialize variable buf, thereby causing the following kfree(buf) to be
> executed. (2) iwl_dump_nic_event_log does not initialize buf if
> CONFIG_IWLWIFI_DEBUG was disabled.

I've applied a different fix for this, just disabling the log_event file
when CONFIG_IWLWIFI_DEBUG is disabled. This looks like it could use some
disentangling but I'm not sure what you did is really the right
approach, some refactoring would seem to be better.

Also, is "Lekensteyn" really your full name? Not that it matters now
because I didn't apply your patch, but for patch submissions please read
the "developer's certificate of origin" in the kernel sources.

Thanks for the report!

johannes

