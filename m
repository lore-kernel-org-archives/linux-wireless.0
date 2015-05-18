Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36422 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbERH07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 03:26:59 -0400
Received: by lagv1 with SMTP id v1so205964659lag.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 00:26:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALWn1pu8U1o=J=j8Uunf7-hLNZV2Pv2mxJx11O_psZArij-qNw@mail.gmail.com>
References: <CALWn1pu8U1o=J=j8Uunf7-hLNZV2Pv2mxJx11O_psZArij-qNw@mail.gmail.com>
Date: Mon, 18 May 2015 10:26:57 +0300
Message-ID: <CANUX_P3XPLvLhYy7pb9_LXjEynfNjgzhbW3zFYfxVCjcjGNczw@mail.gmail.com> (sfid-20150518_092702_447979_E0780C7E)
Subject: Re: Failed to capture data packets using Monitor mode with Intel 7260
 card. (Under Ubuntu 14.04)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: darklight wu <darklightwu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2015 at 10:01 AM, darklight wu <darklightwu@gmail.com> wrote:
> Hi, All:
>
> I configured the Wifi Monitor mode with Intel 7260 card under
> Ubuntu14.04 and then used Wireshark to capture packets from air. But I
> could only get management/control packets but no data packets. I tried
> different channels and also with HT20 or HT40+/-.
>
> The commands I used were:
>
> iw dev wlan0 interface add mon0 type monitor
> iw dev wlan0 del  //I googled and was told I needed to delete the
> wlan0 first. Or else I got device busy (-16) error
> ifconfig mon0 up
> iw dev mon0 set channel 1
>
> I also tried to use other ways like "airmon-ng start wlan0". All the
> observations were same, no data packets. It's weird! Anyone has a
> clue?
>

This is weird. But I recommend to add power_scheme=1 as a module
parameter to iwlmvm. Since iwlmvm is loaded automatically, you'll need
to add that to /etc/modprobe.d/iwlwifi.conf.
14.04 ships 3.13 and I remember we had issues with monitor mode at
that time. You may want to try a newer kernel.
