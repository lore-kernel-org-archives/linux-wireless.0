Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43474 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762115AbdJQNHx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 09:07:53 -0400
Received: from mail-vk0-f42.google.com ([209.85.213.42])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <jesse.sung@canonical.com>)
        id 1e4Rb6-0004fM-AT
        for linux-wireless@vger.kernel.org; Tue, 17 Oct 2017 13:07:52 +0000
Received: by mail-vk0-f42.google.com with SMTP id 126so1028632vkj.9
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2017 06:07:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1508237298.10607.76.camel@sipsolutions.net>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
 <1508233890.10607.70.camel@sipsolutions.net> <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
 <1508237298.10607.76.camel@sipsolutions.net>
From: Jesse Sung <jesse.sung@canonical.com>
Date: Tue, 17 Oct 2017 21:07:50 +0800
Message-ID: <CAH10aOjmMdN2pGP8FDwZQ6BRcu2O5PiGjk+kKb6bAa7nS=ap8g@mail.gmail.com> (sfid-20171017_150802_230408_B817805D)
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

On Tue, Oct 17, 2017 at 6:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2017-10-17 at 18:18 +0800, Jesse Sung wrote:
>
>> > Does mwifiex treat this -EALREADY as *keeping* an old connection,
>> > or tearing it down entirely?
>>
>> From the call trace:
>
> Well, the call trace can't really answer that :-)
> Does mwifiex firmware stay connected?

Sorry I don't know how to tell firmware's state.  @@

>> 139.451318: nl80211_get_valid_chan <-nl80211_connect
>> 139.451321: cfg80211_connect <-nl80211_connect
>> 139.451322: cfg80211_oper_and_ht_capa <-cfg80211_connect
>> 139.451323: mwifiex_cfg80211_connect <-cfg80211_connect
>> 139.451337: nl80211_post_doit <-genl_family_rcv_msg
>> 139.451423: nl80211_pre_doit <-genl_family_rcv_msg
>> 139.451425: nl80211_disconnect <-genl_family_rcv_msg
>> 139.451426: cfg80211_disconnect <-nl80211_disconnect
>> 139.451430: mwifiex_cfg80211_disconnect <-cfg80211_disconnect
>>
>> mwifiex_cfg80211_disconnect() would be called after
>> mwifiex_cfg80211_connect(), though I'm not sure if it's triggered by
>> the error returned.
>
> I think so - it's probably wpa_supplicant trying to get back to a well-
> known state (of being disconnected).
>
>> > I think your fix is invalid because we then reset ssid_len and
>> > still
>> > keep an old connection (current_bss) which will lead to strange
>> > nl80211
>> > behaviour when getting interface data etc.
>>
>> Since this is how it works before commit 0711d638 (use current_bss
>> instead of ssid_len), so I'm guessing this would still work. But I
>> agree that this may not be a proper fix...
>
> It would probably work, but we get data inconsistencies, and at the
> very least you get no SSID data back when you query the current state.
>
> I don't see anything in nl80211 or so that would say we should accept a
> connect() while already connected, so how about this?
>
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index b347e63d7aaa..fe0037ad1f5e 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -1042,6 +1042,9 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
>
>         ASSERT_WDEV_LOCK(wdev);
>
> +       if (wdev->current_bss)
> +               return -EALREADY;
> +
>         if (WARN_ON(wdev->connect_keys)) {
>                 kzfree(wdev->connect_keys);
>                 wdev->connect_keys = NULL;
>
> Not really quite sure about it yet, but that should address the issue?

A very rough test by issuing reassociate in wpa_cli:
mwifiex works after reassociate - looks good

> reassociate
OK
<3>CTRL-EVENT-SCAN-STARTED
<3>CTRL-EVENT-SCAN-RESULTS
<3>Trying to associate with <BSSID1> (SSID=<SSID> freq=<freq1>)
<3>Association request to the driver failed
<3>CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
<3>CTRL-EVENT-SCAN-STARTED
<3>CTRL-EVENT-SCAN-RESULTS
<3>WPS-AP-AVAILABLE
<3>Trying to associate with <BSSID2> (SSID=<SSID> freq=<freq2>)
<3>Associated with <BSSID2>
<3>WPA: Key negotiation completed with <BSSID2> [PTK=CCMP GTK=CCMP]
<3>CTRL-EVENT-CONNECTED - Connection to <BSSID2> completed [id=0 id_str=]
<3>CTRL-EVENT-SCAN-STARTED
> reassociate
OK
<3>CTRL-EVENT-SCAN-RESULTS
<3>Trying to associate with <BSSID2> (SSID=<SSID> freq=<freq2>)
<3>Associated with <BSSID2>
<3>CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
<3>WPA: Key negotiation completed with <BSSID2> [PTK=CCMP GTK=CCMP]
<3>CTRL-EVENT-CONNECTED - Connection to <BSSID2> completed [id=0 id_str=]
> reassociate
OK
<3>CTRL-EVENT-SCAN-STARTED
>
<3>CTRL-EVENT-SCAN-RESULTS
<3>Trying to associate with <BSSID2> (SSID=<SSID> freq=<freq2>)
<3>Association request to the driver failed
<3>CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
<3>CTRL-EVENT-SCAN-STARTED
<3>CTRL-EVENT-SCAN-RESULTS
<3>WPS-AP-AVAILABLE
<3>Trying to associate with <BSSID3> (SSID=<SSID> freq=<freq3>)
<3>Associated with <BSSID3>
<3>WPA: Key negotiation completed with <BSSID3> [PTK=CCMP GTK=CCMP]
<3>CTRL-EVENT-CONNECTED - Connection to <BSSID3> completed [id=0 id_str=]
> reassociate
OK
<3>CTRL-EVENT-SCAN-STARTED
<3>CTRL-EVENT-SCAN-RESULTS
<3>Trying to associate with <BSSID3> (SSID=<SSID> freq=<freq3>)
<3>Association request to the driver failed
<3>CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
<3>CTRL-EVENT-SCAN-STARTED
<3>CTRL-EVENT-SCAN-RESULTS
<3>WPS-AP-AVAILABLE
<3>Trying to associate with <BSSID1> (SSID=<SSID> freq=<freq1>)
<3>Associated with <BSSID1>
<3>WPA: Key negotiation completed with <BSSID1> [PTK=CCMP GTK=CCMP]
<3>CTRL-EVENT-CONNECTED - Connection to <BSSID1> completed [id=0 id_str=]
<3>CTRL-EVENT-SCAN-STARTED
<3>CTRL-EVENT-SCAN-RESULTS
<3>Trying to associate with <BSSID2> (SSID=<SSID> freq=<freq2>)
<3>Association request to the driver failed
<3>CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
<3>CTRL-EVENT-SCAN-STARTED
<3>CTRL-EVENT-SCAN-RESULTS
<3>WPS-AP-AVAILABLE
<3>Trying to associate with <BSSID1> (SSID=<SSID> freq=<freq1>)
<3>Associated with <BSSID1>
<3>WPA: Key negotiation completed with <BSSID1> [PTK=CCMP GTK=CCMP]
<3>CTRL-EVENT-CONNECTED - Connection to <BSSID1> completed [id=0 id_str=]


Thanks,
Jesse
