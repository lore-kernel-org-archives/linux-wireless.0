Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19951 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2CAG2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:28:40 -0500
Message-ID: <4F4F1712.4070108@qca.qualcomm.com> (sfid-20120301_072843_852651_EE9204D1)
Date: Thu, 1 Mar 2012 08:28:34 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Maintain the listen interval per VIF specific
References: <1329745088-23800-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1329745088-23800-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2012 03:38 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Firmware has the option to support the listen interval
> per vif specific. Fix this.
> 
> Listen interval can be set by the TUs or by the number
> of beacons. Current code enables the user to configure
> the listen interval in the unit of 'number of beacons'
> using debugfs entry "listen_interval". Going forward,
> we need to alter the listen interval in the unit of TUs
> to get good power numbers while going to WOW suspend/resume.
> 
> Allowing the user to change the listen interval in
> the unit of "number of beacons"  in debugfs and changing
> listen interval in wow suspend/resume in the unit of
> time (TUs) would lead us to confuse.
> 
> This patch make sures the listen interval is changed only
> in the unit of time (TUs).
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

I think these two patches depend on your 'ath6kl: Check wow state before
sending control and data pkt'? At least I got conflicts and they seem to
point to that patch.

If that's the case, I'll put these two patches on hold until the other
patch is applied.

Kalle
