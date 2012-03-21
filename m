Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34222 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2CUIJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 04:09:40 -0400
Message-ID: <4F698CBF.5080702@qca.qualcomm.com> (sfid-20120321_090958_839753_E3161623)
Date: Wed, 21 Mar 2012 10:09:35 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: shonmou li <shonmou@gmail.com>
CC: <ath6kl-devel@qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: avoiding 80211 scan does not complete before
 start scheduled scan.
References: <CADhJdvDbAORKoWUxLdcz7Jq2dt9DKEPzBwgmiNvZsj6iU2K9Kw@mail.gmail.com>	<4F683A26.7090404@qca.qualcomm.com> <CADhJdvDpdQzJHQ-hLnASyyCKc2rzG_aBMtTm0rND7d1xdkudyg@mail.gmail.com>
In-Reply-To: <CADhJdvDpdQzJHQ-hLnASyyCKc2rzG_aBMtTm0rND7d1xdkudyg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shonmou,

please include linux-wireless in CC.

On 03/20/2012 02:15 PM, shonmou li wrote:
> Hi Kalle,
> 
> Thanks for your reply. I have added descriptions and signed-off-line in
> the patch file.
> 
> When i port the ar6003 driver into android device (ICS), I used the
> following procedure to trigger this bug every time:
> 
> 1. enable wifi in android setting menu.
> 2. connect with an AP.
> 3. After device enter suspending state, power off the connected AP.
> 4. At this moment, the device would resume to deal with disconnection event.
> 5. After device suspend again, press power on button to wake the device on.
> 6. Go to setting menu wifi page, press scan button.
> 7. You will get "Scan trigger failed: ret=-16 (Device or resource
> busy)"  on android main log.
> 
> The log file is in attached file log1.txt.
> 
> If FW has the capability to check the status of normal scan and sscan, i
> think it is better. But it should add external information or API in
> order to notify user space what scan mode it is.

Thanks, I understand the issue better. I think your patch is a good fix
for now. If there are more problems still we can fix those separately.
Raja also saw the same problem and he confirmed that your patch fixes
the issue.

I have applied the patch to ath6kl.git with minor modifications to the
commit log. Thank you very much for the patch.

Kalle

commit b4d13d3b70b085ef9b8e0bf7132d502d77d9ffc6
Author: Kalle Valo <kvalo@qca.qualcomm.com>
Date:   Wed Mar 21 10:01:09 2012 +0200

    ath6kl: abort normal scan when scheduled scan is started

    If the device disconnects from an AP when it is in suspending state.
You will
    get the following message from wpa_supplicant after waking the
device up and
    sending scan request:

    "Scan trigger failed: ret=-16 (Device or resource busy)"

    Fix the issue by sending a scan complete event before starting scheduled
    scan.

    kvalo: cosmetic changes to commit log

    Signed-off-by: Isaac.li <shonmou@gmail.com>
    Tested-by: Raja Mani <rmani@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
