Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41666 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbcEaNT6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 09:19:58 -0400
Message-ID: <1464700795.3076.29.camel@sipsolutions.net> (sfid-20160531_152002_450476_C76D9D61)
Subject: Re: [PATCH] cfg80211: Allow cfg80211_connect_result() errors to be
 distinguished
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 31 May 2016 15:19:55 +0200
In-Reply-To: <1464643010-29225-1-git-send-email-jouni@qca.qualcomm.com>
References: <1464643010-29225-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-31 at 00:16 +0300, Jouni Malinen wrote:
> Previously, the status parameter to cfg80211_connect_result() was
> documented as using WLAN_STATUS_UNSPECIFIED_FAILURE (1) when the real
> status code for the failure is not known. This value can be used by
> an
> AP (and often is) and as such, user space cannot distinguish between
> explicitly rejected authentication/association and not being able to
> even try to associate or not receiving a response from the AP.
> 
> Add a new inline function, cfg80211_connect_timeout(), to be used
> when
> the driver knows that the connection attempt failed due to a reason
> where connection could not be attempt or no response was received
> from
> the AP. The internal functions now allow a negative status value (-1) 
> to
> be used as an indication of this special case. This results in the
> NL80211_ATTR_TIMED_OUT to be added to the NL80211_CMD_CONNECT event
> to
> allow user space to determine this case was hit. For backwards
> compatibility, NL80211_STATUS_CODE with the value
> WLAN_STATUS_UNSPECIFIED_FAILURE is still indicated in the event in
> such
> a case.
> 
Applied, with a fix to the cfg80211_connect_bss() prototype.

I also added cfg80211_connect_timeout to the docbook.

johannes
