Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18709 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaIQFvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 01:51:06 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
Date: Wed, 17 Sep 2014 05:50:59 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com> (sfid-20140917_075119_991369_8D98CA80)
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
 <21529.8110.26388.664223@gargle.gargle.HOWL>
In-Reply-To: <21529.8110.26388.664223@gargle.gargle.HOWL>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Grumbach, Emmanuel wrote:
> > Why are mgmt frames different from data frames with respect to that?
> > You have a separated queue for mgmt frames that is common to all the
> contexts?
> > Just like an "offchannel" queue?
> 
> No, ath9k treats them the same, but if the current, active context is different
> from the incoming frame's assigned context, then it is added to a software
> queue for deferred transmission. But, before a switch to the next context
> can happen, mac80211 proceeds to tear down the BSS/stations etc. and the
> VIF/context is also removed.
> 

I see - we also had this problem and because of this, we implemented the flush callback that allows to wait until all the queues are empty.
So mac80211 will send the deauth, flush and only then it'd remove the VIF. This should allow the frame to make it to the air.
Note that API explicitly states that mgd_prepare_tx is before assoc only.
