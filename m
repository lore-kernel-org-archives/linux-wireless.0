Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40298 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753003AbdJQKSU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 06:18:20 -0400
Received: from mail-ua0-f176.google.com ([209.85.217.176])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <jesse.sung@canonical.com>)
        id 1e4Ox0-0002dq-ML
        for linux-wireless@vger.kernel.org; Tue, 17 Oct 2017 10:18:18 +0000
Received: by mail-ua0-f176.google.com with SMTP id l40so783097uah.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2017 03:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1508233890.10607.70.camel@sipsolutions.net>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
 <1508233890.10607.70.camel@sipsolutions.net>
From: Jesse Sung <jesse.sung@canonical.com>
Date: Tue, 17 Oct 2017 18:18:17 +0800
Message-ID: <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com> (sfid-20171017_121829_964441_A527310A)
Subject: Re: Commit 0711d638 breaks mwifiex
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Oct 17, 2017 at 5:51 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
>> While working on an issue that marvell module stops connecting to AP,
>> bisect reveals that the issue starts to happen from commit 0711d638,
>> which uses wdev->ssid_len instead of wdev->current_bss to determine
>> if driver's .disconnect() should be called.
>>
>> It happens because mwifiex_cfg80211_connect() returns -EALREADY
>> when it finds wdev->current_bss is valid:
>>
>> if (priv->wdev.current_bss) {
>>     [PRINT LOG]
>>     return -EALREADY;
>> }
>>
>> This would make cfg80211_connect() set wdev->ssid_len to 0, and thus
>> mwifiex_cfg80211_disconnect() won't be called by
>> cfg80211_disconnect().
>
> Hmm, none of this makes much sense to me right now.
>
> Does mwifiex treat this -EALREADY as *keeping* an old connection, or
> tearing it down entirely?

>From the call trace:

139.451318: nl80211_get_valid_chan <-nl80211_connect
139.451321: cfg80211_connect <-nl80211_connect
139.451322: cfg80211_oper_and_ht_capa <-cfg80211_connect
139.451323: mwifiex_cfg80211_connect <-cfg80211_connect
139.451337: nl80211_post_doit <-genl_family_rcv_msg
139.451423: nl80211_pre_doit <-genl_family_rcv_msg
139.451425: nl80211_disconnect <-genl_family_rcv_msg
139.451426: cfg80211_disconnect <-nl80211_disconnect
139.451430: mwifiex_cfg80211_disconnect <-cfg80211_disconnect

mwifiex_cfg80211_disconnect() would be called after
mwifiex_cfg80211_connect(), though I'm not sure if it's triggered by the
error returned.

> Because right now clearly cfg80211 assumes, on the one hand, that no
> connection is kept (resetting ssid_len), but on the other hand it got
> here with current_bss set - so perhaps we should reject that before in
> cfg80211, rather than in mwifiex?

Yes the inconsistency may be a problem.

> I think your fix is invalid because we then reset ssid_len and still
> keep an old connection (current_bss) which will lead to strange nl80211
> behaviour when getting interface data etc.

Since this is how it works before commit 0711d638 (use current_bss instead
of ssid_len), so I'm guessing this would still work. But I agree that this
may not be a proper fix...

Thanks,
Jesse
