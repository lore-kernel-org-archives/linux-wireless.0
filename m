Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:35513 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbZKRWF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 17:05:58 -0500
Received: by gv-out-0910.google.com with SMTP id r4so349841gve.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 14:06:03 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: request TX status where needed
Date: Wed, 18 Nov 2009 23:06:00 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1258580330.30511.85.camel@johannes.local>
In-Reply-To: <1258580330.30511.85.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911182306.01101.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 18 November 2009, Johannes Berg wrote:
> Right now all frames mac80211 hands to the driver
> have the IEEE80211_TX_CTL_REQ_TX_STATUS flag set to
> request TX status. This isn't really necessary, only
> the injected frames need TX status (the latter for
> hostapd) so move setting this flag.
> 
> The rate control algorithms also need TX status, but
> they don't require it.
> 
> Also, rt2x00 uses that bit for its own purposes and
> seems to require it being set for all frames, but
> that can be fixed in rt2x00.
> 
> This doesn't really change anything for any drivers
> but in the future drivers using hw-rate control may
> opt to not report TX status for frames that don't
> have the IEEE80211_TX_CTL_REQ_TX_STATUS flag set.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Looks good. Thanks.

For the rt2x00 part:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>




