Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6290 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2HNOLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 10:11:41 -0400
Message-ID: <502A5C97.8070107@qca.qualcomm.com> (sfid-20120814_161146_197123_E9911553)
Date: Tue, 14 Aug 2012 17:11:35 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
References: <20120712091311.9751.60082.stgit@localhost6.localdomain6>
In-Reply-To: <20120712091311.9751.60082.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2012 12:13 PM, Kalle Valo wrote:
> ath6kl was incorrectly assuming that IEEE80211_NUM_BANDS will always be 2
> and used that also in the firmware WMI interface definitions. But after
> the support for 60 GHz was added to cfg80211 IEEE80211_NUM_BANDS changed to 3
> and this can cause all sort of problems, possibly even memory corruption.
> I only found this during code review and didn't notice any bugs, but I'm
> sure there are a few lurking somewhere.
> 
> To fix this rename unused A_NUM_BANDS to ATH6KL_NUM_BANDS, which is
> always defined to be 2, and use that in WMI.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied to ath6kl.git.

Kalle

