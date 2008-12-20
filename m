Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56569 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYLTNQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 08:16:08 -0500
Received: by bwz14 with SMTP id 14so5295282bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 05:16:05 -0800 (PST)
Message-ID: <1ba2fa240812200516x565a9e24u2399f53247aa6124@mail.gmail.com> (sfid-20081220_141614_588254_11050F2A)
Date: Sat, 20 Dec 2008 15:16:05 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Daniel Wu" <dyqith@gmail.com>
Subject: Re: iwlagn and Intel 5300 card mimo3 poor performance?
Cc: linux-wireless@vger.kernel.org,
	"reinette chatre" <reinette.chatre@intel.com>
In-Reply-To: <cef1c9520812192342s5a2caf4cm4a0c1662fb1d4bf2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <cef1c9520812192342s5a2caf4cm4a0c1662fb1d4bf2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 20, 2008 at 9:42 AM, Daniel Wu <dyqith@gmail.com> wrote:
>
> Hi,
>
> We are running into some unexpected results in performance tests of an
> Intel 5300 abgn against a Linksys wrt310n. Any help would be greatly
> appreciated.
>
> Using the debugfs and writing a fixed rate hex into the
> rate_scale_table, we tested the throughput (with iperf UDP mode)
> between the Intel 5300 card to another wired laptop through the
> wrt310n.
>
> As far as we can tell, legacy cck, ofdm and siso performance are fine.
> We're running into problems when trying to set up triple streams and
> three antennas (mimo3).
>
> We're using these hex rates for mimo3:
> 0x1C110
> 0x1C111
> 0x1C112
> 0x1C113
> 0x1C114
> 0x1C115
> 0x1C116
> 0x1C117
> For each of the rates, we're getting approximately 160Kbps which is far too low.
> These rates also seem to cause a "Invalid HT rate index 236" in  dmesg.

iwl-agn-rs.c doesn't support actively  MIMO3 yet, the algorithm need
to be enhanced in one more dimension.

>
> At first we thought the 5300 may not be able to do 3 streams at once,
> but that's not true, since the device can receive from the AP at much
> higher rates (~64.5Mbps)

RX is relatively passive element so this should work.

>
>
> Also, in iwl-commands.h, there might be a typo on line 258, instead of
> bits "3-0", it should be at least bits "6-0"

Right, You can post directly  a patch that fixes this.
Tomas
