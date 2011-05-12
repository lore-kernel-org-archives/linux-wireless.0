Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1ELPFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 11:05:51 -0400
Date: Thu, 12 May 2011 17:05:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, eliad@wizery.com
Subject: Re: [PATCH v3 1/3] cfg80211/nl80211: add support for scheduled scans
Message-ID: <20110512150530.GB2171@redhat.com> (sfid-20110512_170554_278966_1AE17D13)
References: <1305122977-6740-1-git-send-email-coelho@ti.com>
 <1305122977-6740-2-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305122977-6740-2-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 11, 2011 at 05:09:35PM +0300, Luciano Coelho wrote:
> Implement new functionality for scheduled scan offload.  With this feature we
> can scan automatically at certain intervals.
> 
> The idea is that the hardware can perform scan automatically and filter on
> desired results without waking up the host unnecessarily.

Can you elaborate more about this?

> Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> commands to the nl80211 interface.  When results are available they are
> reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
> informed when the scheduled scan has stopped with a
> NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
> the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  include/linux/nl80211.h |   25 +++++
>  include/net/cfg80211.h  |   57 +++++++++++
>  net/wireless/core.c     |   12 ++-
>  net/wireless/core.h     |    7 ++
>  net/wireless/nl80211.c  |  250 +++++++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/nl80211.h  |    4 +
>  net/wireless/scan.c     |   70 +++++++++++++
>  7 files changed, 424 insertions(+), 1 deletions(-)

And explain, why all of this is needed, instead of modify existing scan
code and reuse existing infrastructure. This sched_scan does not seems to
be something different than normal hardware scan we have already, or I'm
wrong.

Thanks
Stanislaw
