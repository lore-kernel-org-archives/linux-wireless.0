Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43058 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab3FVIn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 04:43:29 -0400
From: Kalle Valo <kvalo@adurom.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] wireless:  Add memory usage debugging.
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
Date: Sat, 22 Jun 2013 11:43:26 +0300
In-Reply-To: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 18 Jun 2013 15:03:32
	-0700")
Message-ID: <87fvwa1qoh.fsf@purkki.adurom.net> (sfid-20130622_104335_873483_267CFE83)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> The bss objects are reference counted, and the ies
> are also tricky to keep track of.  Add option to
> track allocation and freeing of the ies and bss objects,
> and add debugfs files to show the current objects.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> +config CFG80211_MEM_DEBUGGING
> +	bool "cfg80211 memory debugging logic"
> +	default n
> +	depends on CFG80211_DEBUGFS
> +	---help---
> +	  Enable this if you want to debug memory handling for bss and ies
> +	  objects.  New debugfs files: ieee80211/all_ies and all_bss will
> +	  be created to display these objects.  This has a moderate CPU cost
> +	  and uses a bit more memory than normal, but otherwise is not very
> +	  expensive.
> +
> +	  If unsure, say N.

IMHO having a new Kconfig option is overkill. Can we use something more
generic, like CFG80211_DEVELOPER_WARNINGS, for this?

-- 
Kalle Valo
