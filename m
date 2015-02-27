Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64344 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbB0Qw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 11:52:29 -0500
Message-ID: <54F0A0CB.2050804@broadcom.com> (sfid-20150227_175233_665102_095B002A)
Date: Fri, 27 Feb 2015 17:52:27 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] nl80211: add notes about userspace API/ABI modifications
References: <1425047563-9988-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1425047563-9988-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/15 15:32, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> Add notes about userspace ABI/API modifications, including the
> fact that we decided that API submissions should come with a
> driver implementation.

Should we also consider Cc: to linux-api mailing list or do you think 
nl80211 api has sufficient capable reviewers. There is probably a reason 
for adding these notes now ;-)

Regards,
Arend

> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---
>   include/uapi/linux/nl80211.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 2dcf9bba317c..74492e85b04f 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -25,6 +25,19 @@
>    *
>    */
>
> +/*
> + * This header file defines the userspace API to the wireless stack. Please
> + * be careful not to break things - i.e. don't move anything around or so
> + * unless you can demonstrate that it breaks neither API nor ABI.
> + *
> + * Additions to the API should be accompanied by actual implementations in
> + * an upstream driver, so that example implementations exist in case there
> + * are ever concerns about the precise semantics of the API or changes are
> + * needed, and to ensure that code for dead (no longer implemented) API
> + * can actually be identified and removed.
> + * Nonetheless, semantics should also be documented carefully in this file.
> + */
> +
>   #include<linux/types.h>
>
>   #define NL80211_GENL_NAME "nl80211"

