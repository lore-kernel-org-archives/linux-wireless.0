Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55765 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZL3St0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 13:49:26 -0500
Received: by yxe17 with SMTP id 17so11031878yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 10:49:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c775b4470912300642o2457d712m20dfb48c4c3508df@mail.gmail.com>
References: <c775b4470912300642o2457d712m20dfb48c4c3508df@mail.gmail.com>
Date: Wed, 30 Dec 2009 13:49:25 -0500
Message-ID: <b6c5339f0912301049r773e083do6afd182eb7ad993c@mail.gmail.com>
Subject: Re: [ath5k-devel] var/log/messages filling quickly
From: Bob Copeland <me@bobcopeland.com>
To: =?UTF-8?Q?Lucian_=C8=98andor?= <lucisandor@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 30, 2009 at 9:42 AM, Lucian Șandor <lucisandor@gmail.com> wrote:
> Hi all,
> I run an Ad-hoc network, using a SuSE 11.2 computer, kernel 2.6.32-5.5
> from SuSE (probably modifed by them.) If I turn off all the other
> computers in the network, the ath5k/kernel combination writes 20 times
> per second to the system log /var/log/messages:
>
> Dec 28 14:10:31 battlecruiser kernel: [  929.933020] wlan0: No active
> IBSS STAs - trying to scan for other IBSS networks with same SSID
> (merge)

Turn off CONFIG_MAC80211_IBSS_DEBUG in the kernel config
(or ask SuSE to do the same).  You can't turn it off at
runtime, but you could turn off kernel debug messages in
syslogd.

However, this is only supposed to happen every 30s if I
read the code right.  Maybe someone on linux-wireless
knows how this can happen?

-- 
Bob Copeland %% www.bobcopeland.com
