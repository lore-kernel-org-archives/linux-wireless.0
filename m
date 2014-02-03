Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBCMq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 07:46:57 -0500
Message-ID: <1391431612.4488.13.camel@jlt4.sipsolutions.net> (sfid-20140203_134700_326405_E64232FD)
Subject: Re: [PATCH v3 3/6] cfg80211: Enable GO operation on additional
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Date: Mon, 03 Feb 2014 13:46:52 +0100
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A0333705C1@HASMSX106.ger.corp.intel.com>
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
	 <1390818118-27261-4-git-send-email-ilan.peer@intel.com>
	 (sfid-20140127_112147_514798_01405A03) <1391177479.4141.23.camel@jlt4.sipsolutions.net>
	 <CB3B3D4774441E42AA3EA0E1BA8230A0333705C1@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-02 at 19:20 +0000, Peer, Ilan wrote:

> I do not think that this will be needed, as current wpa_supplicant
> logic is not aware of the GO_CONCURRENT and INDOOR_ONLY flags (leaving
> them ignored) and does not allow instantiating an AP/GO on channels
> marked with NO_IR. In addition as this feature must be enabled under
> CONFIG_ONUS, I expect that whoever uses it uses know what's is doing.

Ok, thanks for the clarification. I wasn't sure how existing wpa_s
versions would treat this.

> Such logic might be needed if kernel enforces regulatory compliance
> after the GO_CONCURRENT relaxation conditions are no longer met
> (station interface leaves the channel), where if such a case is true,
> it would be appropriate to add an indication to the kernel telling it
> that user space knows what it's doing, so the kernel will not do any
> quiescing logic (similar to what Luis suggested).

I'm not convinced that is necessary - the "quiescing" would be good I
suppose, but there should be plenty of time before it for userspace to
request an appropriate CSA so I don't think any additional flag is
needed.

Assuming we're talking about the same scenario? I guess it should be
like this:

 - STA connected to AP on an "additional" channel
 - GO operating on the same channel
 - AP starts to advertise CSA
 - wpa_s will request CSA for GO as well
 - all will be fine

If wpa_s is broken, then at the time that the CSA actually kicks in the
GO would be stopped, since it didn't switch channel, but I don't think
there's a need for any additional flags.

johannes

