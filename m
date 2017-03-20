Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34995 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754895AbdCTWOF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 18:14:05 -0400
Received: by mail-qk0-f177.google.com with SMTP id v127so122332424qkb.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 15:14:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHdg3xbK-_gUAs=nnPYtgQmBCSu-VfR2GNgaYaPqd3qSh1wuwg@mail.gmail.com>
References: <CAHdg3xbK-_gUAs=nnPYtgQmBCSu-VfR2GNgaYaPqd3qSh1wuwg@mail.gmail.com>
From: Alexis Green <agreen@uniumwifi.com>
Date: Mon, 20 Mar 2017 15:13:52 -0700
Message-ID: <CAAnMG+OoyEPAYTMFVUaAUusyq1-HkU8VisGS1c818kFSjJSogQ@mail.gmail.com> (sfid-20170320_231443_866621_9F6C394B)
Subject: Re: ath10k monitor mode issue
To: Matteo Grandi <iu5bdp@gmail.com>
Cc: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as I understand, only CT firmware provides per-packet
information about TX rate at the moment.
http://www.candelatech.com/ath10k-10.4.php

Best regards,

Alexis

On Mon, Mar 20, 2017 at 11:00 AM, Matteo Grandi <iu5bdp@gmail.com> wrote:
> Hello all,
>
> I have an issue to collect tx/rx bitrates using ath10k.
> I want to collect Tx/RX statistics on a mesh network using
> compexWLE900VX Wi-Fi miniPCIe adapters chipset QCA9884 (QCA988X) with
> ath10k firmware firmware-5.bin_10.2.4.70.59-2.
>
> The OS is Ubuntu 14.04 kernel 3.14.48 backports 4.4.2.
>
> I'm able to build the mesh without any problem and I already have read
> that ath10k firmware doesn't provide correct TX/RX information.
> Using "iw <iunterface> station dump" I can see the tx bitrate stuck on
> 6Mbps and the rx giving unreliable information about MCS, NSS, bitrate
> etc.
> I tried using iw version 3.4, 3.6 and 4.9.
>
> I really need to retrieve these info, and I tried also sniffing the
> airtraffic with another ath10k interface. According to
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/monitor I
> should see the right radiotap headers, since they are not in the
> knowing issue list.
> But I had the same bad results.
>
> I tried also using an ath9k wifi card.
> Each mesh link is set on 80MHz channel bandwidth, therefore I'm not
> able to capture the data traffic with the ath9k that doesn't support
> 80MHz.
>
> I'm able to sniff the traffic and see the radiotap header only using
> my laptop with an iwlwifi 11ac card.
>
> Do you know if there is a way to obtain reliable TX/RX information
> from the firmware, or if there is a way to sniff the radiotap header
> on an 80MHz channel using an ath9k interface?
>
> Thank you in advance for any hint!
>
> My best regards
>
> Matteo
