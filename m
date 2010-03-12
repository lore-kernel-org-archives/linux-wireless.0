Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62442 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0CLDYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 22:24:50 -0500
Received: by wwb39 with SMTP id 39so535754wwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 19:24:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ec5eb5d61003081050k34cd89caycb315906498f6f7c@mail.gmail.com>
References: <ec5eb5d61003081050k34cd89caycb315906498f6f7c@mail.gmail.com>
Date: Fri, 12 Mar 2010 03:24:46 +0000
Message-ID: <3ace41891003111924o2244882ex4e244feefa4c8441@mail.gmail.com>
Subject: Re: troubles with rtl8187 in kernel 2.6.31.19
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Jorge_Mu=F1oz?= <jorgeroden@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 8, 2010 at 6:50 PM, Jorge Muñoz <jorgeroden@gmail.com> wrote:
> Hello, first of all thank you for your hard work.
> I'm a Ubuntu 9.10 based distro user and after install ubuntu backports with
> last drivers I'm in troubles with rtl8187 one. Now wifi connection is off.
> Last kernel installed in my laptop (Toshiba L300) is 2.6.31-19-generic and
> it worked fine before updating with backports.
> Source version of rtl8187 driver is now: B45F0E56BE418401885B769
> (srcversion)
> and last one worked fine was :             D965EAD7C86957A893B37BD
> (srcversion)
>
> dmesg output shows:
>
> [    8.158116] cfg80211: World regulatory domain updated:
> [    8.158119]     (start_freq - end_freq @ bandwidth), (max_antenna_gain,
> max_eirp)
> [    8.158122]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000
> mBm)
> [    8.158125]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000
> mBm)
> [    8.158128]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000
> mBm)
> [    8.158130]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000
> mBm)
> [    8.158133]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000
> mBm)
> [    8.387489]   alloc irq_desc for 22 on node -1
> [    8.387493]   alloc kstat_irqs on node -1
> [    8.387499] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) ->
> IRQ 22
> [    8.387535] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    8.402151] usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2
> vid 0x03F0 pid 0x4C11
> [    8.402185] usbcore: registered new interface driver usblp
> [    8.803353] hda_codec: Unknown model for ALC268, trying auto-probe from
> BIOS...
> [    8.803425] input: HDA Digital PCBeep as
> /devices/pci0000:00/0000:00:1b.0/input/input9
> [    9.242318] phy0: Selected rate control algorithm 'minstrel'
> [    9.243043] phy0: hwaddr 00:21:63:79:87:f6, RTL8187BvE V0 + rtl8225z2
> [    9.264486] rtl8187: Customer ID is 0x04
> [    9.264544] Registered led device: rtl8187-phy0::tx
> [    9.264580] Registered led device: rtl8187-phy0::rx
> [    9.265339] rtl8187: wireless switch is off
> [    9.265375] usbcore: registered new interface driver rtl8187
> [    9.651107] __ratelimit: 15 callbacks suppressed
> [    9.651110] type=1505 audit(1268065401.574:14):
> operation="profile_replace" pid=895
> name=/usr/share/gdm/guest-session/Xsession
> [    9.652893] type=1505 audit(1268065401.574:15):
> operation="profile_replace" pid=896 name=/sbin/dhclient3
> [    9.653644] type=1505 audit(1268065401.578:16):
> operation="profile_replace" pid=896
> name=/usr/lib/NetworkManager/nm-dhcp-client.action
>
> NOTE: Regardless of dmesg output  I can see wireless switch is ON.
>
> I would like to know whether is something wrong with new driver version.
>
> All information you can give me will be very helpful.
> Thank you for your time.
> Regards.
>
> Jorge
>
>
> --
> www.jorgeroden.blogspot.com
> FSF member 5687
>

Please CC: linux-wireless and/or the other two rtl8187 maintainers for
these sort of questions. Around 2.6.32 onwards, the driver started to
honour the rfkill switch (the little slider button underneath your
laptop in the front, and/or possibly also FN-F8). Before that the
button has no effect to the functionality of the linux rtl8187 driver.
You just have to slide the button to the on position with recent
version of the driver. (this allows one to actually disable the radio
where needed to be disabled; before 2.6.32, one needs to unload the
driver to stop the regular scanning by wpa_supplicant).
