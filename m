Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2HBGY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 02:24:27 -0400
Message-ID: <1343888660.4458.1.camel@jlt3.sipsolutions.net> (sfid-20120802_082439_831923_C9BCD8E8)
Subject: Re: [PATCH 1/2] cfg80211: add channel flag to prohibit OFDM
 operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Date: Thu, 02 Aug 2012 08:24:20 +0200
In-Reply-To: <1343854723-21987-2-git-send-email-seth.forshee@canonical.com>
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
	 <1343854723-21987-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 15:58 -0500, Seth Forshee wrote:
> Currently the only way for wireless drivers to tell whether or not OFDM
> is allowed on the current channel is to check the regulatory
> information. However, this requires hodling cfg80211_mutex, which is not
> visible to the drivers.
> 
> Other regulatory restrictions are provided as flags in the channel
> definition, so let's do similarly with OFDM. This patch adds a new flag,
> IEEE80211_CHAN_NO_OFDM, to tell drivers that OFDM on a channel is not
> allowed. This flag is set on any channels for which regulatory indicates
> that OFDM is prohibited.

Looks good, this needs to go into 3.6, right?

johannes

