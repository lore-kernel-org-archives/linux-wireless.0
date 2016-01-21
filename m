Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34660 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587AbcAUIxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 03:53:34 -0500
Date: Thu, 21 Jan 2016 09:53:31 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arend van Spriel <arend@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2] wl1251: add sysfs interface for bluetooth coexistence
 mode configuration
Message-ID: <20160121085331.GO7192@pali> (sfid-20160121_095338_201713_121B687E)
References: <1451130310-16666-1-git-send-email-pali.rohar@gmail.com>
 <5696D08F.9030906@broadcom.com>
 <20160114091654.GA15380@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160114091654.GA15380@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 January 2016 10:16:54 Pavel Machek wrote:
> On Wed 2016-01-13 23:32:47, Arend van Spriel wrote:
> > On 12/26/2015 12:45 PM, Pali Rohár wrote:
> > >Port the bt_coex_mode sysfs interface from wl1251 driver version included
> > >in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> > >This enables userspace applications to set one of the modes
> > >WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> > >The default mode is WL1251_BT_COEX_OFF.
> > >It should be noted that this driver always enabled bt-coexistence before
> > >and enabled bt-coexistence directly affects the receiving performance,
> > >rendering it unusable in some low-signal situations. Especially monitor
> > >mode is affected very badly with bt-coexistence enabled.
> > 
> > So what user-space process will be using this interface. Did you consider
> > adding debugfs interface? In case of monitor mode you could consider
> > disabling bt-coex from within the driver itself.
> 
> This aint no debugging feature.
> 									Pavel

Right, bt-coex is not for debugging purpose, but for normal usage, when
user want to use together bluetooth and wifi or just one of those.

Are there any other objections for this patch?

-- 
Pali Rohár
pali.rohar@gmail.com
