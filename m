Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60393 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0GUBQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 21:16:36 -0400
Received: by qwh6 with SMTP id 6so2252952qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 18:16:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100720112041.GA7049@hash.localnet>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
	<AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
	<AANLkTimgt_HdXyGneQMOz7wR7Xs7BBrDUCGoxP1qDcYg@mail.gmail.com>
	<20100720112041.GA7049@hash.localnet>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 21 Jul 2010 11:16:14 +1000
Message-ID: <AANLkTinr0RbmNLgM_pRsa0WrSqQ_Mr9aQhKGuK63xIJ6@mail.gmail.com>
Subject: Re: ath5k Ad Hoc Association
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 20, 2010 at 9:20 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> Yes, I've checked the channel (36, 5180) allows beaconing. I've tried
>> the commands you mentioned, but no luck. If I monitor the interface
>> from another station, the ath5k drive never appears to beacon.
>
> What does "iw phy phy0 info" show?

iw phy phy0 info
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Band 2:
                Frequencies:
                        * 5180 MHz [36] (17.0 dBm)
                        * 5200 MHz [40] (17.0 dBm)
                        * 5220 MHz [44] (17.0 dBm)
                        * 5240 MHz [48] (17.0 dBm)
                        * 5260 MHz [52] (20.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5280 MHz [56] (20.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5300 MHz [60] (20.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5320 MHz [64] (20.0 dBm) (passive scanning,
no IBSS, radar detection)
                        * 5500 MHz [100] (disabled)
                        * 5520 MHz [104] (disabled)
                        * 5540 MHz [108] (disabled)
                        * 5560 MHz [112] (disabled)
                        * 5580 MHz [116] (disabled)
                        * 5600 MHz [120] (disabled)
                        * 5620 MHz [124] (disabled)
                        * 5640 MHz [128] (disabled)
                        * 5660 MHz [132] (disabled)
                        * 5680 MHz [136] (disabled)
                        * 5700 MHz [140] (disabled)
                        * 5745 MHz [149] (30.0 dBm)
                        * 5765 MHz [153] (30.0 dBm)
                        * 5785 MHz [157] (30.0 dBm)
                        * 5805 MHz [161] (30.0 dBm)
                        * 5825 MHz [165] (30.0 dBm)
                Bitrates (non-HT):
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * mesh point
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * new_beacon
                 * new_station
                 * new_mpath
                 * set_mesh_params
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * set_wiphy_netns
                 * connect
                 * disconnect

 iw reg get
country AU:
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ 40), (3, 23)
        (5250 - 5330 @ 40), (3, 23), DFS
        (5735 - 5835 @ 40), (3, 30)

Cheers,

Jonathan
