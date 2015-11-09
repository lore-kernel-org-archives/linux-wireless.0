Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33369 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbbKIKOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 05:14:35 -0500
Message-ID: <1447064069.2428.1.camel@sipsolutions.net> (sfid-20151109_111522_061401_7CFBA6DF)
Subject: Re: [PATCH] nl80211: clarify NL80211_ATTR_SCHED_SCAN_DELAY usage
 with net-detect
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: samueltan@google.com, linux-wireless@vger.kernel.org
Date: Mon, 09 Nov 2015 11:14:29 +0100
In-Reply-To: <1447063916-338-1-git-send-email-luca@coelho.fi>
References: <1447063916-338-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-09 at 12:11 +0200, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> In this attribute's documentation, it was not clear whether the delay
> started counting when WoWLAN net-detect was enabled or when the
> system
> was suspended.  The correct answer is that it starts when the system
> suspends (which is when, in practice, the scan is
> scheduled).  Clarify
> that in the nl80211.h documentation.
> 
> Suggested-by: Samuel Tan <samueltan@google.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  include/uapi/linux/nl80211.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h
> b/include/uapi/linux/nl80211.h
> index 1f0b4cf..ea24d66 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1764,8 +1764,9 @@ enum nl80211_commands {
>   *	over all channels.
>   *
>   * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before the first cycle of a
> - *	scheduled scan (or a WoWLAN net-detect scan) is started,
> u32
> - *	in seconds.
> + *	scheduled scan is started.  Or the dealy before a WoWLAN
> + *	net-detect scan is started, counting from the moment the
> + *	system is suspended.  This value is a u32, in seconds.
> 
delay :)

johannes
