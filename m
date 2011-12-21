Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36471 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1LUPhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:37:54 -0500
Message-ID: <4EF1FD4C.3070507@qca.qualcomm.com> (sfid-20111221_163757_632283_D17C9BBA)
Date: Wed, 21 Dec 2011 21:07:48 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: fix scan state machine
References: <1324479072-8242-1-git-send-email-mohammed@qca.qualcomm.com> <CAGXE3d-Ntrz7WUXMKBHP2oyX1YBFvqyDHU96x9xGb__C=O8Mtw@mail.gmail.com>
In-Reply-To: <CAGXE3d-Ntrz7WUXMKBHP2oyX1YBFvqyDHU96x9xGb__C=O8Mtw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 December 2011 09:01 PM, Helmut Schaa wrote:
> Hi,

Hi Helmut,

>
> On Wed, Dec 21, 2011 at 3:51 PM, Mohammed Shafi Shajakhan
> <mohammed@qca.qualcomm.com>  wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> when we run high bandwidth UDP traffic and we trigger a scan, the scan
>> state machine seems to be looping in SUSPEND->RESUME->DECISION->SUSPEND
>> and SET_CHANNEL seems to be never called as 'tx_empty' is never true
>> while running UDP traffic. fix this by settting SET_CHANNEL state when
>> we get into RESUME state.
>
> Your analysis looks correct to me. Previously (before the
> simplification patches)
> the logic to always scan at least one channel was put in scan_state_decision but
> maybe it makes sense to have it in scan_state_resume.

thanks for the review.
i compared "ieee80211_scan_state_resume" with the older code's
"ieee80211_scan_state_leave_oper_channel"

>
> So, to me the patch looks good.
>
> Helmut
>


-- 
thanks,
shafi
