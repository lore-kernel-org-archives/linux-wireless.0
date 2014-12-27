Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58344 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaL0TRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 14:17:52 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so16301319wgh.37
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 11:17:50 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <3095419.huSVmtL0ib@xps13>
References: <3095419.huSVmtL0ib@xps13>
Date: Sat, 27 Dec 2014 20:17:50 +0100
Message-ID: <CA+icZUVsmoPE8Le4XeyBratXe23BFtgOEoyd6dBFC9x+MVaJFw@mail.gmail.com> (sfid-20141227_202234_652382_AFF9A73F)
Subject: Re: Unable to disable WiFi with 3.19-rc1 - iwlwifi 7260
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: emmanuel.grumbach@intel.com,
	Johannes Berg <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 27, 2014 at 8:08 PM, Gabriele Mazzotta
<gabriele.mzt@gmail.com> wrote:
> Hi,
>
> since v3.19-rc1 I have problems with WiFi (Intel Corporation Dual Band
> Wireless-AC 7260) on my laptop. Trying to disable all the radio devices
> (WiFi and BT) with the function key of my laptop, which should hard
> block the rfkills, causes the following message to be repeated over and
> over until I re-enable them again with the function key:
>
> [  593.746001] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> [  593.746468] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> [  593.746781] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> [  593.747091] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
>
> Sometimes my laptop hangs when I try to toggle the state of the radio
> devices and have to forcefully reboot it.
>
> Reverting 522713c81e ("iwlwifi: pcie: properly reset the device") seems
> to fix the problem. I haven't tried anything else since this was the
> first thing I tried.
>
> Does anyone know what's the problem with that specific commit?
> I will gladly provide any additional information, just tell me what
> is needed.
>

I cannot say much to the "internals" of your problem

Just two things...

There is a new firmware for 7260 around see [0].

2nd try to pull in the new wireless-drivers.git tree, the changelog
mentions a race with rfkill on iwlwifi [1].

Have fun!

- Sedat -

[0] http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/?id=a876c69f042cf4732755b325d3b709125bb51a06
[1] http://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/tag/?id=wireless-drivers-for-davem-2014-12-26
