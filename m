Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36068 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbeDQVtQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 17:49:16 -0400
Received: by mail-wr0-f193.google.com with SMTP id q13so36011862wre.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 14:49:15 -0700 (PDT)
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
To: Brian Norris <briannorris@chromium.org>
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
 <e16557d0891352ae0b83902faee97023@codeaurora.org>
 <877epbs5v7.fsf@kamboji.qca.qualcomm.com> <5AD11D7C.1030603@broadcom.com>
 <242be71eb87140c9560163c4000255b2@codeaurora.org>
 <8736zvqtcw.fsf@kamboji.qca.qualcomm.com>
 <20180417002854.GA186697@rodete-desktop-imager.corp.google.com>
 <5AD5AEB5.1040808@broadcom.com>
 <20180417160715.GA255263@rodete-desktop-imager.corp.google.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, cjhuang@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AD66BD9.4000706@broadcom.com> (sfid-20180417_234927_986247_705E1FDB)
Date: Tue, 17 Apr 2018 23:49:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180417160715.GA255263@rodete-desktop-imager.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/17/2018 6:07 PM, Brian Norris wrote:
> On Tue, Apr 17, 2018 at 10:22:13AM +0200, Arend van Spriel wrote:
>> On 4/17/2018 2:28 AM, Brian Norris wrote:
>>> It looks like the status quo for looking for SCHED_SCAN support is to
>>> check if NL80211_CMD_START_SCHED_SCAN shows up in the command support
>>> list. (IOW, that's what wpa_supplicant does.) We'll probably need to
>>> imitate that.
>>
>> I believe checking command support is not really recommended. Instead, you
>> better check NL80211_ATTR_SCHED_SCAN_MAX_REQS being non-zero (since kernel
>> 4.12 that is).
>
> Why not? Command support checking is what wpa_supplicant is doing.

That's not really a good argument. A couple (or more) years ago 
wpa_supplicant was not doing nl80211 but wext and some other using 
driver private ioctls, but that did not make it the best approach.

The START_SCHED_SCAN command is indeed still provided to user-space:

@@ -1376,7 +1377,7 @@ static int nl80211_add_commands_unsplit(struct 
cfg80211_r
                 CMD(tdls_mgmt, TDLS_MGMT);
                 CMD(tdls_oper, TDLS_OPER);
         }
-       if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+       if (rdev->wiphy.max_sched_scan_reqs)
                 CMD(sched_scan_start, START_SCHED_SCAN);
         CMD(probe_client, PROBE_CLIENT);
         CMD(set_noack_map, SET_NOACK_MAP);

It was left in because existing user-space apps might depend on it.

> I noticed NL80211_ATTR_SCHED_SCAN_MAX_REQS, but unfortunately, we have
> to support older kernels. It looks like randomization was added in
> v3.19, and as you point out, that's only available in v4.12.

I figured that would be the issue so I dug up the kernel version.

> I welcome other alternatives if you have them to offer.

Nope. Not if you want to be kernel version agnostic.

Regards,
Arend
