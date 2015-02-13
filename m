Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60875 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbbBMSHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 13:07:00 -0500
Message-ID: <1423850815.2936.4.camel@sipsolutions.net> (sfid-20150213_190705_239723_1C038CFF)
Subject: Re: [PATCH 1/3] mwifiex: add cfg80211 set_default_mgmt_key handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, huxm@marvell.com, Li Long <longli@marvell.com>
Date: Fri, 13 Feb 2015 19:06:55 +0100
In-Reply-To: <1423764954-30412-1-git-send-email-patila@marvell.com> (sfid-20150212_134627_640778_2A1810BC)
References: <1423764954-30412-1-git-send-email-patila@marvell.com>
	 (sfid-20150212_134627_640778_2A1810BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-02-12 at 23:45 +0530, Avinash Patil wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> It is observed that hostapd failed to setup with management frame
> protection mode enabled when using mwifiex.
> 
> This is because hostapd will try to install IGTK using
> cfg80211 set_default_mgmt_key handler.
> 
> we have already support IGTK install in set_key handler, so just work
> around this issue by add an empty cfg80211_set_default_mgmt_key handler.

I believe that this is incorrect since the key should only be installed
for TX after this handler, not in the set_key handler. This should make
a difference in the case of rekeying? Perhaps hostapd doesn't actually
program the key until rekeying with all stations finishes though.

johannes

