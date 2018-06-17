Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932679AbeFQKYr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 06:24:47 -0400
Date: Sun, 17 Jun 2018 12:24:24 +0200
From: Greg KH <greg@kroah.com>
To: Omer Efrat <omer.efrat@tandemg.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 5/5] staging: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
Message-ID: <20180617102424.GA5705@kroah.com> (sfid-20180617_122823_030677_DD3A910E)
References: <1529230056-18004-1-git-send-email-omer.efrat@tandemg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529230056-18004-1-git-send-email-omer.efrat@tandemg.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 17, 2018 at 01:07:36PM +0300, Omer Efrat wrote:
> The BIT macro uses unsigned long which some architectures handle as 32 bit
> and therefore might cause macro's shift to overflow when used on a value
> equals or larger than 32 (NL80211_STA_INFO_RX_DURATION and afterwards).
> 
> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> should be used with all NL80211_STA_INFO_* attribute types instead of BIT
> to prevent future possible bugs when one will use BIT macro for higher
> attributes by mistake.
> 
> This commit cleans up all usages of BIT macro with the above field
> in cfg80211 by changing it to BIT_ULL instead.
> 
> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
