Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34370 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbbBWSAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 13:00:39 -0500
Received: by mail-wi0-f176.google.com with SMTP id h11so19721147wiw.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 10:00:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 23 Feb 2015 23:30:18 +0530
Message-ID: <CABPxzYKMi3HUY96+4Cc0LjJk=aoVbit36OBVwTDfgULT++d-tg@mail.gmail.com> (sfid-20150223_190042_225126_C2BCE001)
Subject: Re: Connection issues with BW Tracking in mac80211
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2015 at 2:58 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Fri, Feb 20, 2015 at 1:00 AM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> Hi Johannes,
>>
>> The BW tracking feature in mac80211 is causing connection problems and
>> operating mode/bw problems when switching b/w modes and bw's in AP.
>>
>> For Eg. Initially if AP is operating in VHT-80MHz, and then we changed
>> in to HT-40MHz, mac80211 cannot handle it because the VHT capability
>> is mismatched b/w stored info (ifmgd->flags).
>>
>> I have tried your DISABLE_BW_TRACK patch, that helps making the
>> connection but it doesn't update the chipset causing issues.
>>
>> Ideally we should be able to handle all the config changes right?
>
> Before that i have a basic question? Should we reset our tracking after
> the connection is lost, in my case above the connection was lost (Config
> change in A triggers a reboot), still mac80211 is tracking the BW changes?

Any ideas johannes? Currenlty we kind-of disabled BW tracking as a work around
for this issue.

mlme.c: Removed the capability checks.

if (!cfg80211_chandef_valid(&chandef)) {
sdata_info(sdata,
"AP %pM chandef invalid - disconnect\n",
ifmgd->bssid);
return -EINVAL;
}
