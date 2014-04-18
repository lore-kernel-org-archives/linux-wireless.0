Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57226 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaDRGU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 02:20:57 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so203636wgg.9
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 23:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140418061135.GA1647@redhat.com>
References: <CAGAvgFun5q1-qdqzx3nxzpZAXyqY60xycgrF56p6qz5ryAJiwQ@mail.gmail.com>
 <20140418061135.GA1647@redhat.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 18 Apr 2014 11:50:35 +0530
Message-ID: <CABPxzY+P7Z-_pzfe+9S=id0U9UGMAPRmkbbaSwaU5qu9+tQdkw@mail.gmail.com> (sfid-20140418_082100_054307_E04AA463)
Subject: Re: iwl3945
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Qian Li <qian.li@uhasselt.be>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2014 at 11:41 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Apr 17, 2014 at 08:11:03PM +0200, Qian Li wrote:
>> I run into some problems while I was using Intel Wireless 3945ABG WNIC to
>> do some routing experiments. I've been using Ubuntu 12.04. The default WNIC
>> driver is iwl3945. I could set essid, IP address, and mode of the NIC. But
>> I can't switch to all the channels. I want the computer to be able to
>> switch to any 5GHZ band channel in the Ad-Hoc mode. But the WNIC could only
>> be switched to certain channels (e.g., 40, 44, 48) after it is set to the
>> Ad-Hoc mode (it can be switched to any channel when it is in the Managed
>> mode). When I tried to switch to other channels (e.g. 42, 46, 100, 124,
>> etc.), I got errors such as "invalid argument".
>
> Use "iw phy" to check on which channels IBSS is allowed on your device.
> Most likely all 5GHz channels are disallowed.
>
> For example I have:
>
> $ iw phy | grep "no IBSS"
>                         * 2467 MHz [12] (15.0 dBm) (passive scanning, no IBSS)
>                         * 2472 MHz [13] (15.0 dBm) (passive scanning, no IBSS)
>                         * 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
>                         * 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
>                         * 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
>                         * 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
>                         * 5260 MHz [52] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5500 MHz [100] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5520 MHz [104] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5540 MHz [108] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5560 MHz [112] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5580 MHz [116] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5600 MHz [120] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5620 MHz [124] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5640 MHz [128] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5660 MHz [132] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5680 MHz [136] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>                         * 5700 MHz [140] (15.0 dBm) (passive scanning, no IBSS, radar detection)
>
I think you are using the defualt WORLD mode hence all 5GHz are
disabled for IBSS.
Can you try "iw reg set US" (Provided you have crda running), that
should enable some of them, if not all?
