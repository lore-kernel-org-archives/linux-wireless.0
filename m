Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32870 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966574AbdAKNbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:31:34 -0500
Message-ID: <1484141491.29931.10.camel@sipsolutions.net> (sfid-20170111_143137_244686_A3E7F3FB)
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Date: Wed, 11 Jan 2017 14:31:31 +0100
In-Reply-To: <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
         <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> + * @timeout_reason: reason for connection timeout. This is used when
> the
> + *	connection fails due to a timeout instead of an explicit
> rejection from
> + *	the AP. 0 (NL80211_CONNECT_TIMEOUT_UNSPECIFIED) is used
> for other cases.

I think this description is misleading - one could easily understand
"for other cases" to indicate for the cases that the AP did explicitly
reject it, but that's obviously not true.

Perhaps that could be reworded, to say it's used when it's not known,
or such? I'd not indicate the value (0) either, just specify the name,
and put a % in front to get better formatting for it please.

> +			     resp_ie_len, status, gfp,
> +			     NL80211_TIMEOUT_UNSPECIFIED);
>  }

NL80211_CONNECT_TIMEOUT_UNSPECIFIED in the comment is wrong then.

johannes
