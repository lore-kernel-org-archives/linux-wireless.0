Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4957 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933234Ab0DHU5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:57:10 -0400
Subject: Re: [PATCH 002/102] ath9k_hw: add silicon revision macros for
 AR9300
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1270754858-26266-3-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
	 <1270754858-26266-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Thu, 08 Apr 2010 16:57:08 -0400
Message-Id: <1270760228.16012.8.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 15:25 -0400, Luis R. Rodriguez wrote:
> +#define AR_SREV_9300_20_OR_LATER(_ah) \
> +	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9300) || \
> +	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300) && \
> +	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9300_20)))

I wonder if AR_SREV_9300_OR_LATER would be a better name, considering
that AR9300 1.0 won't ever be supported.  For the same reason, the
revision check seems excessive.

Someone seeing AR_SREV_9300_20_OR_LATER in the code could assume that it
won't match devices that come after AR9300, but only devices of version
AR9300 and revision 2.0 and newer.  AR_SREV_9300_OR_LATER won't have
that ambiguity.

-- 
Regards,
Pavel Roskin
