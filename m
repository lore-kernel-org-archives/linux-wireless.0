Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:37904 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdGZLtx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 07:49:53 -0400
Received: by mail-wr0-f178.google.com with SMTP id f21so74090536wrf.5
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jul 2017 04:49:53 -0700 (PDT)
Message-ID: <597881DF.4050609@broadcom.com> (sfid-20170726_134957_473739_D391D922)
Date: Wed, 26 Jul 2017 13:49:51 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Daniel Roschka <danielroschka@phoenitydawn.de>
CC: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: brcmfmac: BCM43602 in Touch Bar MacBook Pros not working properly
References: <2355211.moJg6pnjHJ@buzzard>
In-Reply-To: <2355211.moJg6pnjHJ@buzzard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/25/2017 8:07 AM, Daniel Roschka wrote:
> Hi,
>
> All Apple MacBook Pro models with Touch Bar contain a BCM43602 Wi-Fi chip.
> This chip isn't working properly. While it is properly detected by brcmfmac
> and even shows wifi networks nearby, connections only succeed when being very,
> very close to the AP. Also 5Ghz networks aren't visible at all. Further
> details are written down in an issue opened half a year ago, which hasn't seen
> much activity since: https://bugzilla.kernel.org/show_bug.cgi?id=193121
>
> As previous MacBook Pros had similar problems (see
> https://bugzilla.kernel.org/show_bug.cgi?id=100201 and
> https://bugzilla.kernel.org/show_bug.cgi?id=103201), which got resolved by a
> firmware update, I suspect that could be the solution for the current problems
> as well.
>
> Is there anybody here who could take a look at that? That would be highly
> appreciated.

Seems like your email(s) end up in my spam folder. I tend to chuck away 
that folder without a glance, but today I did have a peek. Sorry for 
missing previous attempts.

In bugzilla I see you are running the latest firmware, ie. 7.35.177.61. 
The problem back then was that firmware was lacking functionality to 
read the srom on the device. We fixed that with the firmware update. So 
not sure what might be the issue this time. Also checked the debug 
output file, but it seems to be missing details during probe. So if 
possible please do:

$ insmod brcmfmac debug=0xd416

Regards,
Arend
