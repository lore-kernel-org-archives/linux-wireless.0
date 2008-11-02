Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:48837 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYKBBpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 21:45:55 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT PATCH 0/2] rtl8187: implement conf_tx callback/correctly ack tx pkts
Date: Sat, 1 Nov 2008 23:27:08 -0200
Cc: linux-wireless@vger.kernel.org,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <1225467722-31684-1-git-send-email-herton@mandriva.com.br> <490B957E.8020406@lwfinger.net>
In-Reply-To: <490B957E.8020406@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811012327.09178.herton@mandriva.com.br> (sfid-20081102_024618_080581_1C816F09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 October 2008 21:32:14 Larry Finger wrote:
> Herton Ronaldo Krzesinski wrote:
> > Two patches for two current issues in rtl8187:
> > - First it should implement conf_tx callback, instead of hardcoding some
> > tx queue values.
> > - The second one should make rate control work for 8187B sending correct
> >   feedback about transmitted packet status, using one of the Bulk In
> > endpoints that provides this info. Unfortunately after recently rate
> > control api rewrite in my testing here I don't get anymore greater than
> > 1M rate with pid, before I would still get until 9M (and after some time
> > falling to 1M, then going back up in steps, and so on) on same
> > environment, don't know if it's expected to the new rate control api be
> > more strict/have different behaviour, or if something additional must be
> > done in rtl8187 (the link/signal quality may be too low and may be new
> > rate control changes are more sensitive).
> >
> > Please test and check if there are any additional issues.
>
> With these patches installed, my RTL8187B device was stuck at 1 Mbs using
> the 'pid' algorithm. Without them, the rate rapidly increases to 54 Mbs.
> I'm roughly 2 m from my AP, and get an indicated signal of -22 dBm and a
> link quality of 98/100. My kernel is from wireless-testing
> (v2.6.28-rc2-4159-g6c11cd2) with the rtl8187 power control and timing
> patches submitted earlier. There are no changes to any of the mac80211
> components.

I'll look why this behaviour of being stuck at 1M, I saw this too, but posted 
the patch to confirm and if meanwhile may be someone sees something missing 
or wrong with current version or in new rate api. While testing when 
wireless-testing was still at 2.6.27, it didn't have this behaviour. Then I 
updated to latest wireless-testing and had to fix the patch to build for new 
rate control api, that I guess is the cause of being stuck at 1M, I have to 
investigate more what is happening now. The first patch is another issue and 
shouldn't affect rate control.

>
> Larry

-- 
[]'s
Herton
