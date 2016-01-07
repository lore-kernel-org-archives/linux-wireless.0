Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35678 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbcAGVPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 16:15:41 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, <stable@vger.kernel.org>
Subject: Re: [PATCH 01/21] iwlwifi: dvm: fix WoWLAN
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
	<1452170861-10060-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Thu, 07 Jan 2016 23:15:35 +0200
In-Reply-To: <1452170861-10060-1-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Thu, 7 Jan 2016 14:47:21 +0200")
Message-ID: <87k2nljdl4.fsf@kamboji.qca.qualcomm.com> (sfid-20160107_221545_144820_E4103F1D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> My commit below introduced a mutex in the transport to
> prevent concurrent operations. To do so, it added a flag
> (is_down) to make sure the transport is in the right state.
> This uncoverred an bug that didn't cause any harm until
> now: iwldvm calls stop_device and then starts the firmware
> without calling start_hw in between. While this flow is
> fine from the device configuration point of view (register,
> etc...), it is now forbidden by the new is_down flag.
> This led to this error to appear:
> iwlwifi 0000:05:00.0: Can't start_fw since the HW hasn't been started
> and the suspend would fail.
>
> This fixes:
> https://bugzilla.kernel.org/show_bug.cgi?id=109591
>
> CC: <stable@vger.kernel.org> [4.3+]
> Reported-by: Bogdan Bogush <bogdan.s.bogush@gmail.com>
> Fixes=fa9f3281cbb1 ("iwlwifi: pcie: lock start_hw / start_fw / stop_device")

No need to change this anymore, but this should be:

Fixes: fa9f3281cbb1 ("iwlwifi: pcie: lock start_hw / start_fw / stop_device")

-- 
Kalle Valo
