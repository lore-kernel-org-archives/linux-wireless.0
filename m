Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2HBNEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 09:04:42 -0400
Date: Thu, 2 Aug 2012 08:04:31 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 1/2] cfg80211: add channel flag to prohibit OFDM operation
Message-ID: <20120802130431.GA32395@thinkpad-t410> (sfid-20120802_150446_735992_8F5E5A83)
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
 <1343854723-21987-2-git-send-email-seth.forshee@canonical.com>
 <1343888660.4458.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343888660.4458.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 02, 2012 at 08:24:20AM +0200, Johannes Berg wrote:
> On Wed, 2012-08-01 at 15:58 -0500, Seth Forshee wrote:
> > Currently the only way for wireless drivers to tell whether or not OFDM
> > is allowed on the current channel is to check the regulatory
> > information. However, this requires hodling cfg80211_mutex, which is not
> > visible to the drivers.
> > 
> > Other regulatory restrictions are provided as flags in the channel
> > definition, so let's do similarly with OFDM. This patch adds a new flag,
> > IEEE80211_CHAN_NO_OFDM, to tell drivers that OFDM on a channel is not
> > allowed. This flag is set on any channels for which regulatory indicates
> > that OFDM is prohibited.
> 
> Looks good, this needs to go into 3.6, right?

Yes, it should go into 3.6.

