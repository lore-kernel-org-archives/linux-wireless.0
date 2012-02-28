Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2B1J2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 04:28:36 -0500
Subject: Re: [PATCH 6/6] mwifiex: remove BSS entry before specific SSID scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1330409056-4399-7-git-send-email-bzhao@marvell.com> (sfid-20120228_070558_572954_B2EED4D1)
References: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
	 <1330409056-4399-7-git-send-email-bzhao@marvell.com>
	 (sfid-20120228_070558_572954_B2EED4D1)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Feb 2012 10:28:30 +0100
Message-ID: <1330421310.3368.0.camel@jlt3.sipsolutions.net> (sfid-20120228_102841_594122_DDA1BE2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 22:04 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Driver performs specific SSID scan operation when "iw dev <devname>
> scan ssid <ssid>" command is fired.
> Sometimes even if driver could not find the AP with requested SSID
> in scanning, it is displayed in scan results based on history,
> because scan table entries are valid in cfg80211 stack for 15 seconds.
> 
> This patch adds code to remove respective scan table entry before
> performing specific SSID scan to make sure that correct scan results
> are displayed to user.

NACK. This isn't the intended behaviour here. If any such behaviour is
desired it should probably be implemented in wpa_s, or maybe in
cfg80211, but certainly not in the driver where all it does is make
different drivers behave differently.

johannes

