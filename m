Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56220 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaIQGFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 02:05:11 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
Date: Wed, 17 Sep 2014 06:04:19 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com> (sfid-20140917_080516_470824_732D928A)
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	<21529.8110.26388.664223@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
 <21529.9155.323515.987489@gargle.gargle.HOWL>
In-Reply-To: <21529.9155.323515.987489@gargle.gargle.HOWL>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Grumbach, Emmanuel wrote:
> > I see - we also had this problem and because of this, we implemented
> > the flush callback that allows to wait until all the queues are empty.
> > So mac80211 will send the deauth, flush and only then it'd remove the
> > VIF. This should allow the frame to make it to the air.  Note that API
> > explicitly states that mgd_prepare_tx is before assoc only.
> 
> flush() doesn't force a context switch, no ?

No it doesn't.

> 
> For example, consider a P2P-GO in freq 2412 and STA in 5180 and both are
> active.
> The current context is GO (2412) and at this time if a local deauth for the STA
> comes from userspace, mac80211 sends a deauth frame to the driver and
> calls flush(), but the context in the driver is still in channel 2412, so how will
> this work ?
> 

It can wait until a context switch will occur in ath9k - you should switch from time
to time anyway to avoid starvation, and this is not under the radar of mac80211.

