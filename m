Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3LQII7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 03:08:59 -0500
Message-ID: <1387267730.4749.2.camel@jlt4.sipsolutions.net> (sfid-20131217_090902_196043_1F0D66D2)
Subject: Re: [RFC PATCH 1/8] mac80211: Move dynamic PS data out of common
 code
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>
Date: Tue, 17 Dec 2013 09:08:50 +0100
In-Reply-To: <1387231260-2849-2-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230107_034586_FFC8C889)
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
	 <1387231260-2849-2-git-send-email-seth.forshee@canonical.com>
	 (sfid-20131216_230107_034586_FFC8C889)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 16:00 -0600, Seth Forshee wrote:

> +void ieee80211_notify_rx(struct ieee80211_rx_data *rx)
> +{
> +	switch(rx->sdata->vif.type) {
> +	case NL80211_IFTYPE_MONITOR:
> +		ieee80211_mgd_notify_rx(rx);

This ... seems wrong.

Also, we already have ieee80211_sta_rx_notify() which you want, I think?

With this change, do you even still need local->ps_sdata?

johannes

