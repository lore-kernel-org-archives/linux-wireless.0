Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54066 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZEaPcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 11:32:25 -0400
Received: by bwz22 with SMTP id 22so7023443bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 08:32:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910905310720w227aa533td3ca82d96d615cb5@mail.gmail.com>
References: <3ace41890905302156t6f3e4422h5083e2926ffaa6b0@mail.gmail.com>
	 <69e28c910905310720w227aa533td3ca82d96d615cb5@mail.gmail.com>
Date: Sun, 31 May 2009 16:32:26 +0100
Message-ID: <3ace41890905310832u7adb0c7ao4fedb14c8bcd538a@mail.gmail.com>
Subject: Re: compat-wireless won't associate on 2nd load
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/31 Gábor Stefanik <netrolller.3d@gmail.com>:
> I've been experiencing something similar in vmware, though I thought
> it was vmware's fault. (I have an 8187L.) In my case, detaching and
> re-attaching the device to the VM was sufficient to reset it.
>

How long have you had this problem? Mine is integrated internally to
the laptop (although logically being on "usb") so physically detaching
the device is not possible. I sync up with compat-wireless every few
days and my problem seem to start about a week ago (during John's
travel? and lack of much commit-activity between 23th and 27th).

I just suspend'ed/resume'd with compat-wireless alright (that unloads
rtl8187, and also obviously does a lot of other things) so some
sequence of unload/reload works, just not manually modprobe -r/-v a
2nd time after make install +make unload +modprobe.

The only thing that changed recently enough is this - but the date is
still too old; unless it is the old git thing where the date is on the
local/private repository and only pushed to wireless-testing recently
- I have no idea how to check when a commit first appears in wireless
testing, vs what the date says?:

commit 16cf1f65c90cc47f6c21ca22b4accfa9749b4977
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Apr 23 16:13:26 2009 +0200

    mac80211: unify config_interface and bss_info_changed

    The config_interface method is a little strange, it contains the
    BSSID and beacon updates, while bss_info_changed contains most
    other BSS information for each interface. This patch removes
    config_interface and rolls all the information it previously
    passed to drivers into bss_info_changed.

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
