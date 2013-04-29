Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2329 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442Ab3D2NvF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 09:51:05 -0400
Message-ID: <517E7ABD.9000505@broadcom.com> (sfid-20130429_155113_474721_ABCD8F7E)
Date: Mon, 29 Apr 2013 15:50:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2013 02:26 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Android requires a "p2p0" netdev to exist for P2P Device
> functionality, and will even set it "UP" to start the P2P
> Device functionality.

You can blame Broadcom for that ;-)

> This is a hack to provide it so not only is Android happy
> but also the current version of wpa_supplicant can work
> with P2P-Device functionality without needing changes to
> support the P2P-Device commands, just a little bit to not
> attempt to change the interface type to station.

Reading the subject I was going to say it is not only Android 
workaround, but the commit message also covers non-android use-case.

I will give it another spin. What changed compared to v3.

Regards,
Arend

> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   include/net/cfg80211.h |   4 ++
>   net/wireless/Kconfig   |   7 +++
>   net/wireless/Makefile  |   1 +
>   net/wireless/android.c | 147 +++++++++++++++++++++++++++++++++++++++++++++++++
>   net/wireless/core.c    |  14 +++++
>   net/wireless/core.h    |   6 ++
>   net/wireless/nl80211.c |  63 +++++++++++++++++++++
>   7 files changed, 242 insertions(+)
>   create mode 100644 net/wireless/android.c
>


