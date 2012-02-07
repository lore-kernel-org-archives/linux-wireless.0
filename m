Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2BGPA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 10:00:28 -0500
Message-ID: <4F313C53.2040604@sipsolutions.net> (sfid-20120207_160034_234112_8A223C9E)
Date: Tue, 07 Feb 2012 15:59:31 +0100
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: REGRESSION: crash in wireless-testing smoketest
References: <4F313815.3020107@broadcom.com> (sfid-20120207_154219_853529_011888C8)
In-Reply-To: <4F313815.3020107@broadcom.com> (sfid-20120207_154219_853529_011888C8)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/7/2012 3:41 PM, Arend van Spriel wrote:
> Hi Johannes,
>
> For the brcm80211 drivers we have nightly tests running on both internal
> repo and wireless-testing. Last nights test failed for wireless-testing
> and it occurred during AUTH/ASSOC. I bisected the issue to following commit:
>
> commit 7852e36186d2a1983c215836d7e3d7b8927c930d
> Author: Johannes Berg<johannes.berg@intel.com>
> Date:   Fri Jan 20 13:55:24 2012 +0100
>
>      mac80211: remove dummy STA support
>
>      The dummy STA support was added because I didn't
>      want to change the driver API at the time. Now
>      that we have state transitions triggering station
>      add/remove in the driver, we only call add once a
>      station reaches ASSOCIATED, so we can remove the
>      dummy station stuff again.
>
>      While at it, tighten the RX check and accept only
>      port control (EAP) frames from the AP station if
>      it's not associated yet -- in other cases there's
>      no race.
>
>      Signed-off-by: Johannes Berg<johannes.berg@intel.com>
>      Signed-off-by: John W. Linville<linville@tuxdriver.com>
>
> The brcmsmac driver does not provide a sta_remove callback. I suspect
> that is causing the issue here. Can you confirm?

I'm on a business trip right now, but I can take a look. Did it really 
*crash*? You said so in the subject but have no crash data.

johannes
