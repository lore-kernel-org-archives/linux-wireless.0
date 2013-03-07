Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3CGKWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:22:07 -0500
Message-ID: <1362651722.8694.25.camel@jlt4.sipsolutions.net> (sfid-20130307_112211_386880_FE5F28E2)
Subject: Re: [PATCH 3.9] mac80211: always synchronize_net() during station
 removal
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com
Date: Thu, 07 Mar 2013 11:22:02 +0100
In-Reply-To: <1362608366-10771-1-git-send-email-johannes@sipsolutions.net> (sfid-20130306_231940_133902_988CCAB9)
References: <1362608366-10771-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130306_231940_133902_988CCAB9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-06 at 23:19 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If there are keys left during station removal, then a
> synchronize_net() will be done (for each key, I have a
> patch to address this for 3.10), otherwise it won't be
> done at all which causes issues because the station
> could be used for TX while it's being removed from the
> driver -- that might confuse the driver.
> 
> Fix this by always doing synchronize_net() if no key
> was present any more.

Applied.

johannes

