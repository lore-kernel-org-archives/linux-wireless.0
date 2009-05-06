Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:28547 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZEFB3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 21:29:17 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2387237rvb.5
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 18:29:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905051227n11b128bap4d250e66294a29ce@mail.gmail.com>
References: <43e72e890905042005vb96f57aid70c476e38685dfe@mail.gmail.com>
	<1241509306.25337.4.camel@johannes.local> <43e72e890905051227n11b128bap4d250e66294a29ce@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 May 2009 18:29:02 -0700
Message-ID: <43e72e890905051829k5df86692m34209f871e384127@mail.gmail.com>
Subject: Re: oops during stress test - today's wl
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 5, 2009 at 12:27 PM, Luis R. Rodriguez <mcgrof@gmail.com> w=
rote:
> On Tue, May 5, 2009 at 12:41 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2009-05-04 at 20:05 -0700, Luis R. Rodriguez wrote:
>>> mcgrof@pogo ~/wireless-testing (git::master)$ git-describe
>>> v2.6.30-rc4-22720-gb2382a4
>>>
>>> While running iperf, after about 1 hour.
>>>
>>> http://bombadil.infradead.org/~mcgrof/oops-img/09-05/oops-01-v2.6.3=
0-rc4-22720-gb2382a4.jpg
>>>
>>> Image probably doesn't help much.. but its what I got.. I'd look mo=
re
>>> but its getting late here, so I'm out. I'll use netconsole tomorrow=
=2E
>>
>> Yeah, doesn't really help... I would suspect the driver to be honest=
,
>> since the scan code is trying to TX a frame and it's already in
>> ieee80211_tx() (and probably in __ieee80211_tx which gets inlined).
>
> Right on --
>
> [57158.757990] wlan1: no probe response from AP 00:03:7f:0c:c2:5d -
> disassociating
> [57559.563565] cfg80211: Found new beacon on frequency: 5200 MHz (Ch =
40) on phy2
> [57559.669684] cfg80211: Found new beacon on frequency: 5220 MHz (Ch =
44) on phy2
> [57563.415178] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
> 149) on phy2
> [57563.478395] cfg80211: Found new beacon on frequency: 5765 MHz (Ch
> 153) on phy2
> [57563.737684] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
> [57563.754972] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
> [57563.763958] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
> [57563.765895] wlan1: authenticated
> [57563.765930] wlan1: associate with AP 00:03:7f:0c:c2:5d
> [57563.779535] wlan1: RX ReassocResp from 00:03:7f:0c:c2:5d
> (capab=3D0x421 status=3D0 aid=3D1)
> [57563.779595] wlan1: associated
> [57633.747150] wlan1: deauthenticating by local choice (reason=3D3)
> [57634.224023] wlan1: deauthenticating by local choice (reason=3D3)
> [57654.246527] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [57659.942571] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
> [57659.945696] wlan1: authenticated
> [57659.945735] wlan1: associate with AP 00:03:7f:0c:c2:5d
> [57659.951992] wlan1: RX AssocResp from 00:03:7f:0c:c2:5d (capab=3D0x=
421
> status=3D0 aid=3D1)
> [57659.952054] wlan1: associated
> [57659.962379] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [57670.356717] wlan1: no IPv6 routers present
> [58264.676456] wlan1: deauthenticated (Reason: 2)
> [58265.671832] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 1
> [58265.671832] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 1
> [58265.881845] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 2
> [58265.881845] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 2
> [58265.887928] wlan1 direct probe responded
> [58265.887966] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
> [58265.887928] wlan1 direct probe responded
> [58265.887966] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
> [58265.890837] wlan1: authenticated
> [58265.890871] wlan1: associate with AP 00:03:7f:0c:c2:5d
> [58265.890837] wlan1: authenticated
> [58265.890871] wlan1: associate with AP 00:03:7f:0c:c2:5d
> [58265.898987] wlan1: RX ReassocResp from 00:03:7f:0c:c2:5d
> (capab=3D0x421 status=3D0 aid=3D1)
> [58265.899041] wlan1: associated
> [58265.898987] wlan1: RX ReassocResp from 00:03:7f:0c:c2:5d
> (capab=3D0x421 status=3D0 aid=3D1)
> [58265.899041] wlan1: associated
> [58266.391122] ------------[ cut here ]------------
> [58266.391166] kernel BUG at drivers/net/wireless/ath/ath9k/rc.c:746!
> [58266.391202] invalid opcode: 0000 [#1] PREEMPT SMP
> [58266.391253] last sysfs file:
> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> [58266.391303] CPU 3
> [58266.391333] Modules linked in: netconsole ath9k configfs ipv6
> cpufreq_ondemand powernow_k8[58266.391122] ------------[ cut here
> ]------------
> =C2=A0freq_table binfmt_misc loop dm_multipath scsi_dh arc4 ecb mac80=
211
> rfkill af_packet led_class ath sr_mod cfg80211 e1000 evdev shpchp
> cdrom evbug[58266.391166] kernel BUG at
> drivers/net/wireless/ath/ath9k/rc.c:746!

This is this assert:

        ASSERT((rate_table->info[rate].valid &&
                (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
               (rate_table->info[rate].valid_single_stream &&
                !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));

What's this WLAN_RC_DS_FLAG? I see we set it if our hardware supports
ATH9K_CAP_DS, the current tx_chainmask is not 1 (which in turn we get
from the EEPROM), and.. if sta->ht_cap.mcs.rx_mask[1]..

I'm unable yet to find why this happens. I see rate private structure
for the sta gets updated during get rate but there is no locking for
this but I also don't see dire consequences for this yet.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
