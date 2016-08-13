Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:56887 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbcHMD0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 23:26:17 -0400
Date: Fri, 12 Aug 2016 20:26:13 -0700 (PDT)
Message-Id: <20160812.202613.197744153887748230.davem@davemloft.net> (sfid-20160813_052625_011457_C1A4649E)
To: pgynther@google.com
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	joe@perches.com, akarwar@marvell.com
Subject: Re: [PATCH] Modify is_zero_ether_addr() to handle byte-aligned
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1471047330-8153-1-git-send-email-pgynther@google.com>
References: <1471047330-8153-1-git-send-email-pgynther@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Petri Gynther <pgynther@google.com>
Date: Fri, 12 Aug 2016 17:15:30 -0700

> Root cause:
> mwifiex driver calls is_zero_ether_addr() against byte-aligned address:

MAC addresses really must be 16-bit aligned to be used with any of the
ethernet address manipulation and test interfaces.

Therefore this driver should do whatever it takes to avoid passing
a byte-aligned MAC address anywhere.

We _SHOULD NOT_ add support for byte aligned addresses to these
interfaces, nor add routines which by-name can handle them.

Fix this driver instead of polluting out common interfaces
unnecessarily.

Thanks.
