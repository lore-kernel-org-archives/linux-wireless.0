Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17503 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbcDFJkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:40:41 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Andrei Otcheretianski" <andrei.otcheretianski@intel.com>
Subject: Re: [PATCHv3 RESEND 06/11] cfg80211: Provide an API to report NAN
 function termination
Date: Wed, 6 Apr 2016 09:40:12 +0000
Message-ID: <20160406094011.GC10595@jouni.qca.qualcomm.com> (sfid-20160406_114053_241352_CE613B88)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
 <1459244109-16038-6-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1459244109-16038-6-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2016 at 12:35:04PM +0300, Emmanuel Grumbach wrote:
> Provide a function that reports NAN DE function termination. The function
> may be terminated due to one of the following reasons: user request,
> ttl expiration or failure.

> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h

> +/**
> + * enum nl80211_nan_func_term_reason - NAN functions termination reason
> + *
> + * Defines termination reasons of a NAN function
> + *
> + * @NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST: requested by user
> + * @NL80211_NAN_FUNC_TERM_REASON_TTL_EXPIRED: timeout
> + * @NL80211_NAN_FUNC_TERM_REASON_ERROR: errored
> + */
> +enum nl80211_nan_func_term_reason {
> +	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST,
> +	NL80211_NAN_FUNC_TERM_REASON_TTL_EXPIRED,
> +	NL80211_NAN_FUNC_TERM_REASON_ERROR,
> +};

Can you please add NL80211_NAN_FUNC_TERM_REASON_VENDOR_SPECIFIC? That
would help vendors to implement and send vendor specific reason codes if
any.

-- 
Jouni Malinen                                            PGP id EFC895FA