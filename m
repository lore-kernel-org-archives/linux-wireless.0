Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37416 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaIQFnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 01:43:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21529.8110.26388.664223@gargle.gargle.HOWL> (sfid-20140917_074344_103913_84E24AC7)
Date: Wed, 17 Sep 2014 11:14:14 +0530
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grumbach, Emmanuel wrote:
> Why are mgmt frames different from data frames with respect to that?
> You have a separated queue for mgmt frames that is common to all the contexts?
> Just like an "offchannel" queue?

No, ath9k treats them the same, but if the current, active context is
different from the incoming frame's assigned context, then it is added
to a software queue for deferred transmission. But, before a switch
to the next context can happen, mac80211 proceeds to tear down the
BSS/stations etc. and the VIF/context is also removed.

Sujith
