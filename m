Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2KLJbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 04:31:05 -0500
Message-ID: <1352712697.9525.4.camel@jlt4.sipsolutions.net> (sfid-20121112_103114_101390_EB18E405)
Subject: Re: [PATCH v2] nl/cfg80211: advertise OBSS scan offload capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 12 Nov 2012 10:31:37 +0100
In-Reply-To: <1352512290-7316-1-git-send-email-bzhao@marvell.com>
References: <1352512290-7316-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-09 at 17:51 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> wpa_supplicant will do OBSS scan for drivers that implement
> auth/assoc API. Drivers that implement nl80211 connect API
> (rather than auth/assoc) may need wpa_supplicant to do this
> as well.
> 
> New flag is added to inform userspace that this driver will
> make use of wpa_supplicant's OBSS scan feature.

> + * @NL80211_FEATURE_OBSS_SCAN_OFFLOAD: The driver expects user space to
> + *	perform OBSS scan and generate 20/40 BSS coex reports. This flag is
> + *	interested in only in the case of a driver that has connect API.

Applied, but I changed a lot ;-)

Notably, I reworded the constant name to be
NL80211_FEATURE_NEED_OBSS_SCAN, since we typically use the term
"offload" to mean that the *device* does something, not to mean that
*userspace* does something.

johannes

