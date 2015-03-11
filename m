Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35188 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbbCKGK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 02:10:57 -0400
Received: by wggy19 with SMTP id y19so6791187wgg.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 23:10:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426028412-17438-1-git-send-email-greearb@candelatech.com>
References: <1426028412-17438-1-git-send-email-greearb@candelatech.com>
Date: Wed, 11 Mar 2015 07:10:55 +0100
Message-ID: <CALhHN=q0C0KWzTrjCztxcjLUjHKN8CXfBJG7o7AyU4gZgBfGRg@mail.gmail.com> (sfid-20150311_071100_691815_038B715A)
Subject: Re: [PATCH] iw: Allow configuring empty legacy and ht ratesets.
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 March 2015 at 00:00,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> This allows one to configure exactly one rate for drivers
> such as ath10k that will only allow a single rate to be
> configured.
>

Hello,

But iw already support setting single rate with ath10k.
This is example from ath10k commit log:

    Example:
    iw wlanX set bitrates legacy-5 ht-mcs-5 vht-mcs-5 2:9
    will setup VHT, nss=2, mcs=9

    iw wlanX set bitrates legacy-5 18 ht-mcs-5 vht-mcs-5
    will setup legacy, 18Mbps

    iw wlanX set bitrates legacy-5 ht-mcs-5 3 vht-mcs-5
    will setup HT, nss=1, mcs=3

    iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9
    will setup nss=1

    iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9 2:0-9
    will setup nss=2

BR
Janusz
