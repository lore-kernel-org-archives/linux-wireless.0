Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:57466 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbZEXPl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 11:41:56 -0400
Received: by ewy24 with SMTP id 24so2668379ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 24 May 2009 08:41:56 -0700 (PDT)
Message-ID: <4A196ABE.4080806@tuffmail.co.uk>
Date: Sun, 24 May 2009 16:41:50 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
Subject: Re: deadlock triggered by buggy hardware (EEE PC) in wireless-testing+rfkill-rewrite
 v11
References: <4A192017.3060508@tuffmail.co.uk>
In-Reply-To: <4A192017.3060508@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Jenkins wrote:
> Hi, today I tested wireless-testing +rfkill rewrite v11, +2.6.30-rc7
> for some recent eeepc-laptop updates.  See attached dmesg.

It boils down to this (during/immediately after resume, following a
couple of rfkill initiated "hotplug" cycles):

[  327.859777] ath5k phy5: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[  328.208630] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  329.144320] ath5k phy5: failed to wakeup the MAC Chip
[  329.144339] ath5k phy5: can't reset hardware (-5)
[  329.144619] BUG: workqueue leaked lock or atomic: phy5/0x00000000/3467
[  329.144628]     last function: ieee80211_scan_work+0x0/0x186 [mac80211]
[  329.144688] 1 lock held by phy5/3467:
[  329.144694]  #0:  (&sc->lock){+.+.+.}, at: [<e06f04bd>]
ath5k_config+0x24/0x92 [ath5k]
[  329.144745] Pid: 3467, comm: phy5 Not tainted 2.6.30-rc7-wleeepc #50
[  329.144753] Call Trace:
[  329.144774]  [<c013917c>] ? __debug_show_held_locks+0x1e/0x20
[  329.144791]  [<c012bc94>] worker_thread+0x201/0x234
[  329.144837]  [<e042e1b3>] ? ieee80211_scan_work+0x0/0x186 [mac80211]
[  329.144853]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  329.144867]  [<c012ba93>] ? worker_thread+0x0/0x234
[  329.144880]  [<c012e2a8>] kthread+0x42/0x6a
[  329.144893]  [<c012e266>] ? kthread+0x0/0x6a
[  329.144909]  [<c01030f7>] kernel_thread_helper+0x7/0x10

It snowballs from there, leaving the phy5 workqueue and networkmanager
hanging.  But it makes no sense.

static int
ath5k_config(struct ieee80211_hw *hw, u32 changed)
{
    struct ath5k_softc *sc = hw->priv;
    struct ieee80211_conf *conf = &hw->conf;
    int ret;

    mutex_lock(&sc->lock);

    sc->bintval = conf->beacon_int;
    sc->power_level = conf->power_level;

    ret = ath5k_chan_set(sc, conf->channel);

    mutex_unlock(&sc->lock);
    return ret;
}


All I can think is that it's a weird memory corruption bug.  I was
hoping this showed a potential driver bug, but I can't see any way to
track down the problem.  Oh well.
