Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57854 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaIQGRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 02:17:12 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21529.10109.308613.563543@gargle.gargle.HOWL> (sfid-20140917_081715_325214_2637DD26)
Date: Wed, 17 Sep 2014 11:47:33 +0530
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	<21529.8110.26388.664223@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
	<21529.9155.323515.987489@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grumbach, Emmanuel wrote:
> It can wait until a context switch will occur in ath9k - you should switch
> from time to time anyway to avoid starvation, and this is not under the radar
> of mac80211.

But mac80211 doesn't wait for a switch to happen. It removes the BSS and station
info immediately after sending the deauth frame to the driver and the driver doesn't
get a chance to process the pending frames for the other context. I think
this race could be avoided by making sure the driver switches to the
required context before sending deauth.

Sujith


