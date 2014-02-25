Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaBYQed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 11:34:33 -0500
Message-ID: <1393346070.4170.21.camel@jlt4.sipsolutions.net> (sfid-20140225_173435_625755_6C366809)
Subject: Re: [PATCH] cfg80211: send stop AP event only due to internal reason
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Date: Tue, 25 Feb 2014 17:34:30 +0100
In-Reply-To: <1393335218-2449-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1393335218-2449-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 15:33 +0200, Emmanuel Grumbach wrote:
> From: Ilan Peer <ilan.peer@intel.com>
> 
> Commit "nl80211: send event when AP operation is stopped" added an
> event to notify user space that an AP interface has been stopped, to
> handle cases such as suspend etc. The event is sent regardless
> if the stop AP flow was triggered by user space or due to internal state
> change.
> 
> This might cause issues with wpa_supplicant/hostapd flows that consider
> stop AP flow as a synchronous one, e.g., AP/GO channel change in the
> absence of CSA support. In such cases, the flow will restart the AP
> immediately after the stop AP flow is done, and only handle the stop
> AP event after the current flow is done, and as a result stop the AP
> again.

Applied.

johannes

