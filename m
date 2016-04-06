Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14290 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbcDFJeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:34:10 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Andrei Otcheretianski" <andrei.otcheretianski@intel.com>
Subject: Re: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN commands
Date: Wed, 6 Apr 2016 09:34:06 +0000
Message-ID: <20160406093402.GA10595@jouni.qca.qualcomm.com> (sfid-20160406_113414_306573_A62468DC)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2016 at 12:34:59PM +0300, Emmanuel Grumbach wrote:
> Define several attributes that may be configured by user space
> when starting NAN functionality (master preference and dual
> band operation)

> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> @@ -826,6 +826,16 @@
> + * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
> + *	%NL80211_ATTR_WDEV interface. This interface must have been previously
> + *	created with %NL80211_CMD_NEW_INTERFACE. After it has been started, the
> + *	NAN interface will create or join a cluster. This command must have a
> + *	valid %NL80211_ATTR_NAN_MASTER_PREF attribute and optional
> + *	%NL80211_ATTR_NAN_DUAL attributes.


> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c

> +static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)

> +	if (!info->attrs[NL80211_ATTR_NAN_MASTER_PREF])
> +		return -EINVAL;

Why NL80211_ATTR_NAN_MASTER_PREF is mandatory? The spec suggests to
assume master preference value of 128 if not provided. Please see quoted
text from NAN 1.0 specification:
"A NAN Device which out-of-the-box will have a Master Preference greater
than or equal to 128 with the intention of being a NAN Master Device"

-- 
Jouni Malinen                                            PGP id EFC895FA