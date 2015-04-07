Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38860 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbbDGSMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 14:12:15 -0400
Received: by wiun10 with SMTP id n10so28956748wiu.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2015 11:12:14 -0700 (PDT)
Message-ID: <55241DFB.5080008@gmail.com> (sfid-20150407_201221_977322_05BF629B)
Date: Tue, 07 Apr 2015 20:12:11 +0200
From: ferran <ranker72@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Unable to operate a rt2770 device at 5GHz in mesh mode
References: <551AE9AD.4050102@gmail.com> <551AEB27.1020003@gmail.com> <20150331204933.GC11601@localhost>
In-Reply-To: <20150331204933.GC11601@localhost>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Bob,

Thank you for your fast reply. I did a little more research the day
after your reply and I succeeded on it.

The issue was that the kernel's regulatory domain isn't set by default.

# iw reg get
country 00: DFS-UNSET
    (2402 - 2472 @ 40), (N/A, 20), (N/A)
    (2457 - 2482 @ 40), (N/A, 20), (N/A), NO-IR
    (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
    (5170 - 5250 @ 80), (N/A, 20), (N/A), NO-IR
    (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, NO-IR
    (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
    (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
    (57240 - 63720 @ 2160), (N/A, 0), (N/A)

However, if I set it to a specific country, then it works.

# iw reg set ES
# iw reg get
country ES: DFS-ETSI
    (2400 - 2483 @ 40), (N/A, 20), (N/A)
    (5150 - 5250 @ 80), (N/A, 23), (N/A), NO-OUTDOOR
    (5250 - 5350 @ 80), (N/A, 20), (0 ms), NO-OUTDOOR, DFS
    (5470 - 5725 @ 160), (N/A, 26), (0 ms), DFS
    (57000 - 66000 @ 2160), (N/A, 40), (N/A)

>From the "rules" listed at the right, the one that was blocking the mesh
is "NO-IR", meaning "no initiating radiation"[1].

In short, by default Linux doesn't know where it is, so that it remains
conservative and doesn't let me start conversations.


Best regards,
Ferran

1:
https://wireless.wiki.kernel.org/en/developers/regulatory/processing_rules#beacon_hints

On 31/03/15 22:49, Bob Copeland wrote:
> On Tue, Mar 31, 2015 at 08:44:55PM +0200, ferran wrote:
>>   * Channels 12,13,14 and 36 to 48 and 149 to 165
>>
>>     ffff MHz [cc] (20.0 dBm) (passive scanning, no IBSS)
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^
>
> In other words you cannot send beacons or other frames on this
> channel.
>
>> Does
>> it have anything to do with regulation restrictions? I have succeeded at
>> connecting to an AP at 5 GHz in managed mode.
> Yes.
>
> Once you start a mesh, it will create the mesh and start beaconing
> immediately, so the regulatory domain of your device and/or CRDA may prevent
> you from doing this.
>
> In managed mode, the device is not beaconing so it doesn't have this
> limitation, although it will not be able to send probe requests.
>

