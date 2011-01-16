Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62097 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1APT2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 14:28:00 -0500
Received: by qwa26 with SMTP id 26so4157072qwa.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 11:28:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110114182345.GB11920@vmraj-lnx.users.atheros.com>
References: <loom.20110113T233025-142@post.gmane.org>
	<20110114182345.GB11920@vmraj-lnx.users.atheros.com>
Date: Sun, 16 Jan 2011 20:27:59 +0100
Message-ID: <AANLkTikYV_HigdwHRocB2p2QPSducnLqP+PQc+EgTOJy@mail.gmail.com>
Subject: Re: ath9k - cannot reconnect few meters from the antenna
From: Tomek <dot@poczta.fm>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
Thank you for the support.

I did as you told me - there are a lot of following messages:
ath: ffff880001c03d70

I think the problem may be power save mode. There is something like
this in the logs - it seems that the card after going into some kind
of sleep (no clients active). The problem does not occur if there is a
wireless client associated all the time.
This is what is happening if the wireless network card tries to reconnect:
Jan 16 19:53:42 tomasz-htpc kernel: [1245668.441903] ieee80211 phy0:
Allocated STA 00:1e:64:7d:b3:ee
Jan 16 19:53:42 tomasz-htpc kernel: [1245668.442019] ieee80211 phy0:
Inserted STA 00:1e:64:7d:b3:ee
Jan 16 19:54:34 tomasz-htpc kernel: [1245721.374459] wlan0: STA
00:1e:64:7d:b3:ee aid 1 enters power save mode
Jan 16 19:54:35 tomasz-htpc kernel: [1245721.560981] wlan0: STA
00:1e:64:7d:b3:ee aid 1 exits power save mode
Jan 16 19:54:35 tomasz-htpc kernel: [1245721.561000] wlan0: STA
00:1e:64:7d:b3:ee aid 1 sending 1 filtered/0 PS frames since STA not
sleeping anymore
Jan 16 19:54:35 tomasz-htpc kernel: [1245722.012452] wlan0: STA
00:1e:64:7d:b3:ee aid 1 enters power save mode
Jan 16 19:54:35 tomasz-htpc kernel: [1245722.045244] wlan0: STA
00:1e:64:7d:b3:ee aid 1 exits power save mode
Jan 16 19:54:35 tomasz-htpc kernel: [1245722.045263] wlan0: STA
00:1e:64:7d:b3:ee aid 1 sending 0 filtered/0 PS frames since STA not
sleeping anymore
Jan 16 19:54:36 tomasz-htpc kernel: [1245723.070050] ieee80211 phy0:
Removed STA 00:1e:64:7d:b3:ee
Jan 16 19:54:36 tomasz-htpc kernel: [1245723.070139] ieee80211 phy0:
Destroyed STA 00:1e:64:7d:b3:ee
Jan 16 19:54:37 tomasz-htpc kernel: [1245723.660913] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:38 tomasz-htpc kernel: [1245724.797561] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:38 tomasz-htpc kernel: [1245724.801741] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:38 tomasz-htpc kernel: [1245725.208031] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:38 tomasz-htpc kernel: [1245725.209209] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:39 tomasz-htpc kernel: [1245725.808240] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:39 tomasz-htpc kernel: [1245726.007755] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:39 tomasz-htpc kernel: [1245726.007799] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:39 tomasz-htpc kernel: [1245726.028789] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:39 tomasz-htpc kernel: [1245726.208536] wlan0: dropped
frame to 00:1e:64:7d:b3:ee (unauthorized port)
Jan 16 19:54:44 tomasz-htpc kernel: [1245730.601089] __ratelimit: 10
callbacks suppressed

And again and again - but if I go closer to AP it works, even if I walk away.
Regards
Tomasz

2011/1/14 Rajkumar Manoharan <rmanoharan@atheros.com>
>
> On Fri, Jan 14, 2011 at 04:16:37AM +0530, Tomasz wrote:
> > Hi All
> > I've spend a lot of time on this issue and I cannot fix it, thus I am asking for
> > help
> > It looks like that:
> >
> > I am running wireless access point based on:
> > Ubuntu 10.04  vmlinuz-2.6.32-27-generic
> > compat-wireless-2010-12-26
> > hostapd 0.7.3 (wpa/wpa2)
> > Dnsmasq version 2.52
> > Zotac Ion board
> > Minipcie card: ieee80211 phy0: Atheros AR9285 Rev:2
> > ath9k driver
> > Single antenna (but the behaviour with two antenna is similar)
> >
> > Everything works perfectly fine when I am within the few meters from the antenna.
> > So the clients are connecting and I get 25 mbps data rates.
> > But if more then 10 meters from the antenna strange things are happening.
> > - If I am connected to the network and will walk away everything works perfect.
> > - But if i disconnect (disassociate) when I am away I cannot connect back. -
> > this also means I cannot connect when turning the notebook on :)
> > - if I go closer to antenna I am able to connect and while walking away the
> > connection seems perfectly stable ...
> Hi Tomasz,
>
> Do you have any interference with the oper channel? Please enable debug option
> CONFIG_ATH_DEBUG=y in config.mk and modprobe ath9k debug=0x701 and
> post dmesg/kern.log
>
> --
> Rajkumar
