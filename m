Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59065 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933401AbcFMJJE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 05:09:04 -0400
Message-ID: <1465808939.2434.1.camel@sipsolutions.net> (sfid-20160613_110909_149836_46A5216E)
Subject: Re: [PATCH] ath10k: fix potential null dereference bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Mon, 13 Jun 2016 11:08:59 +0200
In-Reply-To: <CA+BoTQkg+uea_YzUgrVBPhA8uRxNpd29Kd1y1tvt0a-JyOSLQw@mail.gmail.com> (sfid-20160613_074004_402825_22006851)
References: <1465563164-783-1-git-send-email-me@bobcopeland.com>
	 <CA+BoTQkg+uea_YzUgrVBPhA8uRxNpd29Kd1y1tvt0a-JyOSLQw@mail.gmail.com>
	 (sfid-20160613_074004_402825_22006851)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-13 at 07:39 +0200, Michal Kazior wrote:
> 
> FWIW all of these are false positives. I think this was already
> pointed out some time ago. The drv_priv stuff is merely an offset
> (see how ieee80211_vif and ieee80211_sta are defined) and the
> according structure is always checked beforehand.
> 

IIRC, doing something like that can (sometimes?) still get you into
undefined behaviour territory, so the compiler could potentially
"optimize" away the later NULL check.

Or am I confusing something? Seems entirely possible :)

johannes
