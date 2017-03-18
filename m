Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35962 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdCRRls (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 13:41:48 -0400
Received: by mail-ot0-f196.google.com with SMTP id i1so15820958ota.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Mar 2017 10:41:47 -0700 (PDT)
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net> (sfid-20170318_184151_809388_46B51F9A)
Date: Sat, 18 Mar 2017 12:41:45 -0500
MIME-Version: 1.0
In-Reply-To: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/2017 08:14 PM, Xose Vazquez Perez wrote:
> Hi,
>
> Can anyone with a 4.10.x kernel run "iw reg get" to
> verified it?
>
> I get with different wireless devices and platforms:
> global
> country 00: DFS-UNSET
>         (2402 - 2472 @ 40), (6, 20), (N/A)
>         (2457 - 2482 @ 20), (6, 20), (N/A), AUTO-BW, PASSIVE-SCAN
>         (2474 - 2494 @ 20), (6, 20), (N/A), NO-OFDM, PASSIVE-SCAN
>         (5170 - 5250 @ 80), (6, 20), (N/A), AUTO-BW, PASSIVE-SCAN
>         (5250 - 5330 @ 80), (6, 20), (0 ms), DFS, AUTO-BW, PASSIVE-SCAN
>         (5490 - 5730 @ 160), (6, 20), (0 ms), DFS, PASSIVE-SCAN
>         (5735 - 5835 @ 80), (6, 20), (N/A), PASSIVE-SCAN
>         (57240 - 63720 @ 2160), (N/A, 0), (N/A)
>
>
> It works flawlessly with 4.9.13:
> global
> country ES: DFS-ETSI
>         (2400 - 2483 @ 40), (N/A, 20), (N/A)
>         (5150 - 5250 @ 80), (N/A, 23), (N/A), NO-OUTDOOR, AUTO-BW
>         (5250 - 5350 @ 80), (N/A, 20), (0 ms), NO-OUTDOOR, DFS, AUTO-BW
>         (5470 - 5725 @ 160), (N/A, 26), (0 ms), DFS
>         (57000 - 66000 @ 2160), (N/A, 40), (N/A)
>
> phy#0
> country AW: DFS-ETSI
>         (2402 - 2482 @ 40), (N/A, 20), (N/A)
>         (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
>         (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
>         (5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS

I have duplicated your bug and I have bisected it to

commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Mon Oct 24 14:40:04 2016 +0200

     genetlink: use idr to track families

This patch is quite extensive and I have no idea which part is failing, thus all 
I can do is report this confirmation.

Larry
