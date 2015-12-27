Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34104 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbbL0VkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2015 16:40:00 -0500
Received: by mail-lf0-f54.google.com with SMTP id y184so190302179lfc.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Dec 2015 13:39:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <567FCB67.1000101@gmx.de>
References: <567FCB67.1000101@gmx.de>
Date: Sun, 27 Dec 2015 23:39:58 +0200
Message-ID: <CANUX_P3bfcyZqcUVsD7K8_kvsevUszZviUsqbHqY_uXgug-6hw@mail.gmail.com> (sfid-20151227_224041_764595_0F17AC9A)
Subject: Re: warning at net/mac80211/driver-ops.h:647 ieee80211_sta_wmm_params
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Toralf,


On Sun, Dec 27, 2015 at 1:28 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> Yesterday I got this warning for the first time while using WLAN in a train, I'm unsure if this warning is worth to be reported or not :
>
>
> Dec 26 20:26:48 t44 kernel: [45827.647635] cfg80211:   (5490000 KHz - 5710000 KHz @ 160000 KHz), (N/A, 2700 mBm), (0 s)
> Dec 26 20:26:48 t44 kernel: [45827.647637] cfg80211:   (57000000 KHz - 66000000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
> Dec 26 20:26:48 t44 kernel: [45827.700734] ------------[ cut here ]------------
> Dec 26 20:26:48 t44 kernel: [45827.700762] WARNING: CPU: 0 PID: 1498 at net/mac80211/driver-ops.h:647 ieee80211_sta_wmm_params+0x3f7/0x410 [mac80211]()
> Dec 26 20:26:48 t44 kernel: [45827.700764] wlp3s0: invalid CW_min/CW_max: 127/3

Johannes is currently on vacation just like many people :)
Yes, this kind of WARNING can be triggered by a bad AP and since we
now know there are such APs, I think we need to not to WARN but log an
error much less noisy error message instead. Usually Johannes says he
dislike WARNINGs that can be triggered by an existing (faulty)
environment, and that WARNINGs should catch internal kernel bugs. So
this should not be a WARNING.
