Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ranger.systems.pipex.net ([62.241.162.32]:41085 "EHLO
	ranger.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbXHOVtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 17:49:13 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
Date: Wed, 15 Aug 2007 22:49:09 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
References: <200708082324.17186.linux@baker-net.org.uk> <1187171443.3960.6.camel@johannes.berg>
In-Reply-To: <1187171443.3960.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708152249.09948.linux@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 15 August 2007 10:50, Johannes Berg wrote:
> On Wed, 2007-08-08 at 23:24 +0100, Adam Baker wrote:
> > a) If anyone can see anything obvious wrong in the trace
> > b) If anyone has recently tested ad-hoc mode with another driver and can
> > confirm it works.
>
> Neither.
>
> > The sequence of events that leads to the crash is
> > iwconfig wlan1 mode ad-hoc
> > ifconfig wlan1 192.168.0.230
> > iwconfig wlan1 channel 11
> > iwconfig wlan1 essid test
> >
> > then attempt a scan from another device.
>
> Very weird. Can you please enable verbose debugging and also add a few
> printks to various lines of the code in ieee80211_tx_h_multicast_ps_buf
> and ieee80211_tx_h_unicast_ps_buf? Both ought to be fine as far as I can
> tell and the STA scanning shouldn't be in powersave mode either so this
> is a bit strange.
>

Today the most reliable way to crash it seems to be to start a scan locally,
i.e. iwlist wlan1 scan rather than from a different machine. I've appied Ivo's
patch and enabled 
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
and I then see in syslog shortly before the crash

I guess this is indicating something is attempting to power save when it shouldn't
so that gives me a clue where to try adding printk's

Aug 15 22:28:20 gromit kernel: [  286.592323] wlan1: Creating new IBSS network, BSSID 2a:3f:11:b4:62:c9
Aug 15 22:28:20 gromit kernel: [  286.593514] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 15 22:28:20 gromit kernel: [  286.607980] wlan1: Configured IBSS beacon template based on scan results
Aug 15 22:28:40 gromit kernel: [  306.008510] wmaster0: Adding new IBSS station 00:19:4f:9e:b8:ba (dev=wlan1)
Aug 15 22:28:40 gromit kernel: [  306.008693] wmaster0: Added STA 00:19:4f:9e:b8:ba
Aug 15 22:28:40 gromit kernel: [  306.008742] wlan1: STA 00:19:4f:9e:b8:ba aid 0 enters power save mode
Aug 15 22:28:42 gromit kernel: [  308.022518] wlan1: STA 00:19:4f:9e:b8:ba aid 0 exits power save mode
Aug 15 22:28:44 gromit kernel: [  309.966798] wlan1: STA 00:19:4f:9e:b8:ba aid 0 enters power save mode
