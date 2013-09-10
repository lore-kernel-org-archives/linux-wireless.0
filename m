Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:36754 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3IJHeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 03:34:11 -0400
Received: by mail-bk0-f49.google.com with SMTP id r7so2682987bkg.8
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 00:34:09 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Brian O'Connor" <bocon13@gmail.com>
Subject: Re: beginner build question
Date: Tue, 10 Sep 2013 09:34:05 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAHhaCVjomgED0WW1fyUQbePNS0DnPEfKb5uE-+rEMhx6zgO1ZA@mail.gmail.com> <1781136.IRflOffuSs@blech> <CAHhaCVh_etgA1aoSur5shtduCbk9R-zuya8sBKu90A9M_Kj6qg@mail.gmail.com>
In-Reply-To: <CAHhaCVh_etgA1aoSur5shtduCbk9R-zuya8sBKu90A9M_Kj6qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201309100934.06228.chunkeey@googlemail.com> (sfid-20130910_093414_719326_3800B3B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Brain,

On Tuesday 10 September 2013 07:27:39 Brian O'Connor wrote:
> Thanks for getting back to me. I've run into another issue:
> 
> # note the extra / before r92su
> $ sudo make load
> insmod /r92su/r92su.ko
> Error: could not load module /r92su/r92su.ko: No such file or directory
> make: *** [load] Error 1

Ok, apparently $(PWD) is not available on all shells?
<http://patchwork.coreboot.org/patch/2002/>

[Should be fixed now]
 
> # so I manually run
> $ sudo insmod r92su/r92su.ko
> Error: could not insert module r92su/r92su.ko: Unknown symbol in module
> 
> $ dmesg
> ...
> [ 2066.923259] r92su: module verification failed: signature and/or required key missing - tainting kernel
Well, there's not much I can do for now. r92su is a unofficial module.

> [ 2066.923332] r92su: Unknown symbol cfg80211_scan_done (err 0)
> [ 2066.923362] r92su: Unknown symbol ieee80211_amsdu_to_8023s (err 0)
> [ 2066.923386] r92su: Unknown symbol ieee80211_data_from_8023 (err 0)
> [ 2066.923403] r92su: Unknown symbol cfg80211_disconnected (err 0)
> [ 2066.923432] r92su: Unknown symbol wiphy_register (err 0)
> [ 2066.923442] r92su: Unknown symbol wiphy_new (err 0)
> [ 2066.923451] r92su: Unknown symbol cfg80211_put_bss (err 0)
> [ 2066.923461] r92su: Unknown symbol cfg80211_inform_bss (err 0)
> [ 2066.923478] r92su: Unknown symbol cfg80211_ibss_joined (err 0)
> [ 2066.923496] r92su: Unknown symbol cfg80211_michael_mic_failure (err 0)
> [ 2066.923508] r92su: Unknown symbol cfg80211_connect_result (err 0)
> [ 2066.923527] r92su: Unknown symbol wiphy_unregister (err 0)
> [ 2066.923546] r92su: Unknown symbol cfg80211_get_bss (err 0)
> [ 2066.923576] r92su: Unknown symbol ieee80211_data_to_8023 (err 0)
> [ 2066.923597] r92su: Unknown symbol ieee80211_hdrlen (err 0)
> [ 2066.923615] r92su: Unknown symbol ieee80211_frequency_to_channel (err 0)
> [ 2066.923634] r92su: Unknown symbol cfg80211_unlink_bss (err 0)
> [ 2066.923644] r92su: Unknown symbol wiphy_free (err 0)
insmod doesn't load any dependent modules.
(In this case all that's missing is: cfg80211 - the new
makefile should take care of that) 

> [ 2233.171269] r8712u 2-4:1.0 wlan0: r8712_got_addbareq_event_callback: mac = c8:d7:19:xx:xx:xx, seq = 10528, tid = 2
Ah, unload r8712u before loading r92su [else, r92su won't control the device]. 

modprobe -r r8712u

If r92su works and you want to stick with it for the time, you can
blacklist r8712u. AFAICT, you just have to follow the instruction at
<https://docs.fedoraproject.org/en-US/Fedora/16/html/Installation_Guide/rescuemode_drivers-blacklisting.html>

Regards

Christian
