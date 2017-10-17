Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33722 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935225AbdJQKsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 06:48:24 -0400
Message-ID: <1508237298.10607.76.camel@sipsolutions.net> (sfid-20171017_124828_190832_0967FE26)
Subject: Re: Commit 0711d638 breaks mwifiex
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesse Sung <jesse.sung@canonical.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Oct 2017 12:48:18 +0200
In-Reply-To: <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
         <1508233890.10607.70.camel@sipsolutions.net>
         <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-17 at 18:18 +0800, Jesse Sung wrote:

> > Does mwifiex treat this -EALREADY as *keeping* an old connection,
> > or tearing it down entirely?
> 
> From the call trace:

Well, the call trace can't really answer that :-)
Does mwifiex firmware stay connected?


> 139.451318: nl80211_get_valid_chan <-nl80211_connect
> 139.451321: cfg80211_connect <-nl80211_connect
> 139.451322: cfg80211_oper_and_ht_capa <-cfg80211_connect
> 139.451323: mwifiex_cfg80211_connect <-cfg80211_connect
> 139.451337: nl80211_post_doit <-genl_family_rcv_msg
> 139.451423: nl80211_pre_doit <-genl_family_rcv_msg
> 139.451425: nl80211_disconnect <-genl_family_rcv_msg
> 139.451426: cfg80211_disconnect <-nl80211_disconnect
> 139.451430: mwifiex_cfg80211_disconnect <-cfg80211_disconnect
> 
> mwifiex_cfg80211_disconnect() would be called after
> mwifiex_cfg80211_connect(), though I'm not sure if it's triggered by
> the error returned.

I think so - it's probably wpa_supplicant trying to get back to a well-
known state (of being disconnected).

> > I think your fix is invalid because we then reset ssid_len and
> > still
> > keep an old connection (current_bss) which will lead to strange
> > nl80211
> > behaviour when getting interface data etc.
> 
> Since this is how it works before commit 0711d638 (use current_bss
> instead of ssid_len), so I'm guessing this would still work. But I
> agree that this may not be a proper fix...

It would probably work, but we get data inconsistencies, and at the
very least you get no SSID data back when you query the current state.

I don't see anything in nl80211 or so that would say we should accept a
connect() while already connected, so how about this?

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b347e63d7aaa..fe0037ad1f5e 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1042,6 +1042,9 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 
 	ASSERT_WDEV_LOCK(wdev);
 
+	if (wdev->current_bss)
+		return -EALREADY;
+
 	if (WARN_ON(wdev->connect_keys)) {
 		kzfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;

Not really quite sure about it yet, but that should address the issue?

johannes
