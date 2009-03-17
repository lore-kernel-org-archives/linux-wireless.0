Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:2257 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZCQVFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:05:39 -0400
Received: by qw-out-2122.google.com with SMTP id 8so249510qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 14:05:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237275967.18086.6.camel@johannes.local>
References: <49BED464.2010904@erley.org>
	 <1237275967.18086.6.camel@johannes.local>
Date: Tue, 17 Mar 2009 14:05:36 -0700
Message-ID: <45e8e6c40903171405t5d8a6f96o39ecc00dce1be759@mail.gmail.com> (sfid-20090317_220542_475127_9B44C67F)
Subject: Re: [rfc] Implement ath9k mesh point operation
From: Andrey Yurovsky <andrey@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pat Erley <pat-lkml@erley.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_start_mesh() does this:

ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
                                   IEEE80211_IFCC_BEACON_ENABLED);

and it's called by ieee80211_open()

On Tue, Mar 17, 2009 at 12:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-03-16 at 18:36 -0400, Pat Erley wrote:
>
>> Currently, you need to trigger a scan on the mesh point interface to
>> enable beaconing. =A0This is the same behavior the ath5k, rt2500usb =
and
>> rt61pci drivers exhibit. =A0Is this a mac80211 design flaw, or somet=
hing
>> in all of these drivers?
>
> It's mac80211. We never call ieee80211_if_config() when we enable a m=
esh
> interface, and thus conf.enable_beacon with
> IEEE80211_IFCC_BEACON_ENABLED isn't ever set correctly.
>
> johannes
>



--=20
Andrey Yurovsky
cozybit Inc.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
