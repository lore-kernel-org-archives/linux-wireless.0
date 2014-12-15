Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56769 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaLOSlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 13:41:10 -0500
Message-ID: <1418668867.5731.8.camel@sipsolutions.net> (sfid-20141215_194124_055984_B289E5F5)
Subject: Re: [PATCH v8 2/4] cfg80211: allow wiphy specific regdomain
 management
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Date: Mon, 15 Dec 2014 19:41:07 +0100
In-Reply-To: <CA+XVXffHzjVg_KiaFz+sdQPsV+2iTmPGGoLHE7K9dhs7mYDhWg@mail.gmail.com> (sfid-20141215_181305_579984_21253B72)
References: <1417622897-30768-1-git-send-email-arik@wizery.com>
	 <1417622897-30768-2-git-send-email-arik@wizery.com>
	 <1418387963.2470.32.camel@sipsolutions.net>
	 <CA+XVXffHzjVg_KiaFz+sdQPsV+2iTmPGGoLHE7K9dhs7mYDhWg@mail.gmail.com>
	 (sfid-20141215_181305_579984_21253B72)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-15 at 19:12 +0200, Arik Nemtsov wrote:
> On Fri, Dec 12, 2014 at 2:39 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-12-03 at 18:08 +0200, Arik Nemtsov wrote:
> >
> >> +void nl80211_send_reg_change_event(struct regulatory_request *request)
> >> +{
> >> +     nl80211_common_reg_change_event(NL80211_CMD_REG_CHANGE, request);
> >> +}
> >> +
> >> +void nl80211_send_wiphy_reg_change_event(struct regulatory_request *request)
> >> +{
> >> +     nl80211_common_reg_change_event(NL80211_CMD_WIPHY_REG_CHANGE, request);
> >> +}
> >
> > These are trivial wrappers, I'd make them inlines.
> 
> You mean inline here or in the header header? I'll do it here..

Inline here makes no sense since it's declared in the header - it'd have
to be in the header.

johannes

