Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39010 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZCYUIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 16:08:35 -0400
Received: by bwz17 with SMTP id 17so216553bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 13:08:32 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
References: <20090322195619.26460.48292.stgit@tikku>
	<1237900276.4320.86.camel@johannes.local>
	<87iqly0ydm.fsf@litku.valot.fi>
	<1237973445.4320.135.camel@johannes.local>
	<87eiwl1jo2.fsf@litku.valot.fi>
	<1238010031.4320.164.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Mar 2009 22:08:29 +0200
In-Reply-To: <1238010031.4320.164.camel@johannes.local> (Johannes Berg's message of "Wed\, 25 Mar 2009 20\:40\:31 +0100")
Message-ID: <871vsl1i2q.fsf@litku.valot.fi> (sfid-20090325_210839_150490_ED6C86DA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-03-25 at 21:34 +0200, Kalle Valo wrote:
>
>> > It has to be dynamic, no? Much of the information in there would be
>> > things wpa_supplicant is only interested in. If it was just the kernel
>> > code -- yes, we could just have a static list somewhere -- but much of
>> > the 11k things for instance are only useful for wpa_supplicant.
>> 
>> But if we already know what wpa_supplicant needs, can't we do the
>> first implementation with a static list? Sure, the dynamic list is
>> something we should aim for.
>
> True. The userspace part is easy to add though, just make it part of the
> assoc() nl80211 command. So we just need the static list for the
> mac80211 part.

Sounds easy enough.

>> Do we have any knowledge how different hardware support beacon
>> checksumming? I only know how stlc45xx does it.
>
> Not really... how about wl12xx?

Heh, I'm so focused on my thesis right now that forgot wl12xx
altogether :)

I haven't investigate wl12xx beacon filtering in detail yet, but below
is what I quickly found from the firmware interface header files.
Looks like just what we would have expected.


Name:       ACX_BEACON_FILTER_TABLE

Desc: This information element configures beacon filtering handling
      for the set of information elements. An information element in a
      beacon can be set to be: ignored (never compared, and changes
      will not cause beacon transfer), checked (compared, and
      transferred in case of a change), or transferred (transferred to
      the host for each appearance or disappearance).

      The table contains all information elements that are subject to
      monitoring for host transfer.

      All information elements that are not in the table should be
      ignored for monitoring.

      This functionality is only enabled when beacon filtering is enabled by 
      ACX_BEACON_FILTER_OPT.

         Type:   Filtering Configuration

         Access: Write Only

         Length: 101

         Notes:  the field measuring the value of received beacons for
                 which the device wakes up the host in
                 ACX_BEACON_FILTER_OPT does not affect this
                 information element.

http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=blob;f=sta_dk_4_0_4_32/common/src/hal/FirmwareApi/public_infoele.h;h=9a7d1c1203de4db83f700d8cc961cee04e7e5de9;hb=HEAD#l720

-- 
Kalle Valo
