Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37153 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDYCze (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 22:55:34 -0400
Received: by mail-it0-f43.google.com with SMTP id 71-v6so17681066ith.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2018 19:55:34 -0700 (PDT)
Subject: Re: Simultaneous 2.4 GHz WiFi and Bluetooth issue on Intel Dual Band
 Wireless-AC 8260
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
References: <6e4b5e53-0a8d-978c-5cfe-f498c8b15c1a@gmail.com>
 <CANUX_P19ja=XLMs8Vvii1yMvCNAvPnMh7hs=H92M5QRJnJjRfg@mail.gmail.com>
From: Nathan Schulte <nmschulte@gmail.com>
Message-ID: <30aa1580-7913-a7f8-3f2d-be4d699d6dbc@gmail.com> (sfid-20180425_045538_478871_952DEA04)
Date: Tue, 24 Apr 2018 21:55:32 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P19ja=XLMs8Vvii1yMvCNAvPnMh7hs=H92M5QRJnJjRfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2018 01:03 AM, Emmanuel Grumbach wrote:
>> Under Windows 10, the hardware appears to work without issue.
>> Additionally, I believe I managed to warm-reboot from Windows 10 to
>> Linux (with Bluetooth connected), and was able to continue using the
>> same 2.4 GHz WiFi and Bluetooth audio sink without issue.
> 
> This was reported in the past. Please make sure you have the latest BT
> firmware files.

This seems to have resolved the issue.  Interestingly, the firmware
(version...) shipped with Debian Sid is not in the official
linux-firmware.git repository; its md5sum doesn't match any of prior
versions of the file:

> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/intel/ibt-11-5.sfi

Emmanuel, how can I determine the firmware version ("FW Build" and/or
"Release Version") from a given file (e.g. ibt-11-5.sfi/.ddc)?

> Regardless of the BT firmware version thing which is a pure Intel
> problem, I have heard
> about problems in the BT stack itself but I can't help about this.

Though I've never really used the Bluetooth stack until this hardware,
it seems the stack/blueman-* applications only behave oddly when there's
problems with the firmware: never an issue when not using simultaneous
2.4 GHz WiFi + Bluetooth, or with this latest firmware, or approx. 2
years ago when I first started using this setup.

Thanks,
Nate
