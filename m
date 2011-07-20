Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange.solarflare.com ([216.237.3.220]:35998 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1GTLiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 07:38:17 -0400
Subject: Re: [PATCH] ethtool: fix ethtool_get_regs() to work with zero
 length registers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20110720091850.32210.2059.stgit@localhost6.localdomain6>
References: <20110720091850.32210.2059.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 13:38:09 +0200
Message-ID: <1311161889.1041.11.camel@localhost> (sfid-20110720_133842_435199_1EE5CBE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-20 at 12:18 +0300, Kalle Valo wrote:
> cfg80211 exports zero length register size as it currently only uses
> struct ethtool_regs.version to export struct wiphy.hw_version.
[...]

The ethtool_regs::version field represents the version of the register
dump format.  This may or may not relate to a hardware version.

If you don't actually provide a register dump then don't implement this
operation.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

