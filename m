Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33418 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbeEVUMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 16:12:50 -0400
Message-ID: <1527019967.6787.45.camel@sipsolutions.net> (sfid-20180522_221255_887973_BDE95C92)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 May 2018 22:12:47 +0200
In-Reply-To: <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com> (sfid-20180518_184754_968558_C91347C2)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         <1526631206.3805.1.camel@sipsolutions.net>
         <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
         (sfid-20180518_184754_968558_C91347C2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

Thanks for the capture file (for everyone else - Denis provided this to
Arend and myself privately).

In it, we see that there are only ever beacons with zeroed out SSID, and
probe responses with correct SSID. Nothing weird mixed.

> denkenz@iwd-test ~ $ sudo iw dev wlp2s0 scan flush
> BSS 10:c3:7b:54:74:d4(on wlp2s0)
> 	last seen: 274.815s [boottime]
> 	freq: 5765
> 	beacon interval: 100 TUs
> 	signal: -35.00 dBm
> 	last seen: 349 ms ago
> 	Information elements from Probe Response frame:
> 	SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00


I think I finally figured out what's going on. It's a mix between
strange 'iw' behaviour, and strange backward-compatibility behaviour in
cfg80211.

If you do this again and give the scan dump command explicitly with -b
added, like

sudo iw dev wlp2s0 scan passive
iw dev wlp2s0 scan dump -b

then you'll likely see

BSS 10:c3:7b:54:74:d4(on wlp2s0)
 	last seen: 274.815s [boottime]
 	freq: 5765
 	beacon interval: 100 TUs
 	signal: -35.00 dBm
 	last seen: 349 ms ago
 	Information elements from Probe Response frame:
 	SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00
	[... ht/vht ...]
 	Information elements from Beacon frame:
 	SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00
	[... ht/vht ...]

So there are two things going on:

1) In iw, we limit the amount of information printed, but in that case
still print "Information elements from Probe Response frame", if beacon
IEs are also present in the BSS information.

2) Originally, the kernel didn't distinguish between probe response and
beacon IE attributes, but only had "IEs" in general. When we later did
want to distinguish, we changed nl80211 to unconditionally put some IEs
into the "IEs", if received from beacon put them into "beacon IEs", but
to avoid further duplication didn't introduce a separate "probe response
IEs" attribute. You can see this in nl80211_send_bss():

        /* this pointer prefers to be pointed to probe response data
         * but is always valid
         */
        ies = rcu_dereference(res->ies);

        if (ies) {
                if (nla_put_u64_64bit(msg, NL80211_BSS_TSF, ies->tsf,
                                      NL80211_BSS_PAD))
                        goto fail_unlock_rcu;
                if (ies->len && nla_put(msg, NL80211_BSS_INFORMATION_ELEMENTS,
                                        ies->len, ies->data))
                        goto fail_unlock_rcu;
        }



        /* and this pointer is always (unless driver didn't know) beacon data */
        ies = rcu_dereference(res->beacon_ies);
        if (ies && ies->from_beacon) {
                if (nla_put_u64_64bit(msg, NL80211_BSS_BEACON_TSF, ies->tsf,
                                      NL80211_BSS_PAD))
                        goto fail_unlock_rcu;
                if (ies->len && nla_put(msg, NL80211_BSS_BEACON_IES,
                                        ies->len, ies->data))
                        goto fail_unlock_rcu;
        }

Ultimately, this is also lossy - so later I added NL80211_BSS_PRESP_DATA
that indicates "these were *really* received by probe response.

I guess I should change iw in the following way:

https://p.sipsolutions.net/6958d16d00f955c7.txt

which will mean it will not print "probe response IEs" in a false
positive way.

Obviously on kernels that don't set NL80211_BSS_PRESP_DATA it won't
print it out even if the beacon/probe response were both received with
different content, but it can't know if the kernel doesn't tell it.

johannes
