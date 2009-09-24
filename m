Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:10730 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbZIXSO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:14:27 -0400
Date: Thu, 24 Sep 2009 19:14:25 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
In-Reply-To: <1253813740.3868.324.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
 <1253813740.3868.324.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many thanks for your rapid response.

On Thu, 24 Sep 2009, Johannes Berg wrote:
> On Thu, 2009-09-24 at 18:18 +0100, Hugh Dickins wrote:
> > 
> > I expect you'll need a lot more info from me: please do ask
> > (but bear in mind that I'm wireless and network ignorant).
> 
> Thanks. I'm not sure why you'd get the warning there every few seconds,
> but I suppose we don't really care all that much.
> 
> I think you're probably running afoul of a bugfix that I did while at
> the wireless summit, and then the fix to it made it in, but not yet the
> fix to the fix :(
> 
> Are you using an encrypted network, or an open one?

I've been working under the belief that it's WPA encrypted.

> If it's open, can you try this patch?

But I could try the patch, in case I've been fooled.

> http://johannes.sipsolutions.net/patches/kernel/all/2009-09-24-17%3a32/010-cfg80211-fix-wpas-open.patch

However, all the trees I'm working with (Linus latest, or the bisect
result, or a week old mmotm) have cfg80211_mgd_wext_connect saying:

	if (!netif_running(wdev->netdev))
		return 0;

	wdev->wext.connect.ie = wdev->wext.ie;
	wdev->wext.connect.ie_len = wdev->wext.ie_len;
	wdev->wext.connect.privacy = wdev->wext.default_key != -1;

	if (wdev->wext.keys) {
		wdev->wext.keys->def = wdev->wext.default_key;
		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
	}

	if (!wdev->wext.connect.ssid_len)
		return 0;

which is not consistent with the fix your patch is making.

But I do believe I'm encrypted anyway.

Hugh
