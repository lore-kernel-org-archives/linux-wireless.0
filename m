Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2G0Lpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:45:32 -0400
Message-ID: <1343389530.4449.5.camel@jlt3.sipsolutions.net> (sfid-20120727_134536_063901_164AD21A)
Subject: Re: [PATCH v3] mac80211: add PS flag to bss_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Jul 2012 13:45:30 +0200
In-Reply-To: <1343381602-10079-1-git-send-email-eliad@wizery.com> (sfid-20120727_113323_869146_87D4393D)
References: <1343381602-10079-1-git-send-email-eliad@wizery.com>
	 (sfid-20120727_113323_869146_87D4393D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 12:33 +0300, Eliad Peller wrote:
> Currently, ps mode is indicated per device (rather than
> per interface), which doesn't make a lot of sense.
> 
> Moreover, there are subtle bugs caused by the inability
> to indicate ps change along with other changes
> (e.g. when the AP deauth us, we'd like to indicate
> CHANGED_PS | CHANGED_ASSOC, as changing PS before
> notifying about disassociation will result in null-packets
> being sent (if IEEE80211_HW_SUPPORTS_DYNAMIC_PS) while
> the sta is already disconnected.)
> 
> Keep the current per-device notifications, and add
> parallel per-vif notifications.
> 
> In order to keep it simple, the per-device ps and
> the per-vif ps are orthogonal - the per-vif ps
> configuration is determined only by the user
> configuration (enable/disable) and the connection
> state, and is not affected by other vifs state and
> (temporary) dynamic_ps/offchannel operations
> (unlike per-device ps).

Applied, thanks.

johannes

