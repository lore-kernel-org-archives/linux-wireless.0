Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49271 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaC0SQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 14:16:05 -0400
Message-ID: <53346ABB.1060907@broadcom.com> (sfid-20140327_191611_501871_64332057)
Date: Thu, 27 Mar 2014 19:15:23 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH] mac80211: add vif to flush call
References: <1395912629-1458-1-git-send-email-egrumbach@gmail.com>
In-Reply-To: <1395912629-1458-1-git-send-email-egrumbach@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/14 10:30, Emmanuel Grumbach wrote:
> From: Emmanuel Grumbach<emmanuel.grumbach@intel.com>
>
> This will allow the low level driver to make decision based
> on the vif such as queues etc...
> Since the vif might be NULL, we can't add it to the tracing
> functions.

Although this argument sound fair my rule about interfaces is that a 
change should be needed, ie. a low-level driver that needs the info, 
instead of hypothetical use. You have one up your sleeve ? ;-)

Regards,
Arend

> Signed-off-by: Emmanuel Grumbach<emmanuel.grumbach@intel.com>
> ---
>   drivers/net/wireless/ath/ar5523/ar5523.c              | 3 ++-
>   drivers/net/wireless/ath/ath10k/mac.c                 | 3 ++-
>   drivers/net/wireless/ath/ath9k/main.c                 | 3 ++-
>   drivers/net/wireless/ath/carl9170/main.c              | 4 +++-
>   drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 3 ++-
>   drivers/net/wireless/cw1200/sta.c                     | 3 ++-
>   drivers/net/wireless/cw1200/sta.h                     | 3 ++-
>   drivers/net/wireless/iwlegacy/common.c                | 3 ++-
>   drivers/net/wireless/iwlegacy/common.h                | 3 ++-
>   drivers/net/wireless/iwlwifi/dvm/mac80211.c           | 3 ++-
>   drivers/net/wireless/mac80211_hwsim.c                 | 4 +++-
>   drivers/net/wireless/p54/main.c                       | 3 ++-
>   drivers/net/wireless/rt2x00/rt2x00.h                  | 3 ++-
>   drivers/net/wireless/rt2x00/rt2x00mac.c               | 3 ++-
>   drivers/net/wireless/rtlwifi/core.c                   | 3 ++-
>   drivers/net/wireless/ti/wlcore/main.c                 | 3 ++-
>   include/net/mac80211.h                                | 4 +++-
>   net/mac80211/driver-ops.h                             | 8 +++++++-
>   net/mac80211/util.c                                   | 2 +-
>   19 files changed, 45 insertions(+), 19 deletions(-)
