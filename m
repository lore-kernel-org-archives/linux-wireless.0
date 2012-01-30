Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2A3Ak6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 19:40:58 -0500
Subject: Re: [PATCH] mac80211: Do not scan for IBSS merge with a fixed
 BSSID.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1327581394-15368-1-git-send-email-cavallar@lri.fr> (sfid-20120126_133659_805161_39F32A75)
References: <1327581394-15368-1-git-send-email-cavallar@lri.fr>
	 (sfid-20120126_133659_805161_39F32A75)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Jan 2012 16:40:47 -0800
Message-ID: <1327884047.4225.0.camel@jlt3.sipsolutions.net> (sfid-20120130_014101_693773_D1EECEAF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-26 at 13:36 +0100, Nicolas Cavallari wrote:
> Currently, when we are on an IBSS network with no active station,
> we would scan for other BSSID, even if fixed_bssid is on,  due to
> a bug in ibss.c,  where fixed_channel would be checked instead of
> fixed_bssid.  This would trigger useless scans where scan results
> would not be used anyway.
> 
> This patch also reverts commit 39d02a7d90602d4557ee05db2a157a4e0,
> which assumed that the ifibss->fixed_channel check was legitimate
> to disable single-channel scans.  IBSS single-channel scan should
> now be fixed.

John, please revert f1e3be1561c43b6bbe2426e34849fb1486dc313b

johannes

