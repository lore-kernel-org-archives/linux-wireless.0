Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZI3UQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 16:16:27 -0400
Subject: Re: VLAN traffic appearing on the wrong iface
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Bla=C5=BE_Ba=C4=8Dnik?= <bacnik@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
References: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 22:16:27 +0200
Message-Id: <1254341787.3959.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-09-30 at 02:54 +0200, Blaž Bačnik wrote:
> I use RADIUS-assigned vlans with my AP. Hostapd reports vlan change
> during authentication and the station appears on correct vlan
> according to "iw dev ... station dump". But actual packets keep coming
> in on the default interface (wlan0), not the vlan one (eg. wlan0.2).

Actually, it looks like they come in on both :)

> I also tried taking RADIUS out of the loop, so I used hostapd's
> "accept_mac_file" with specified vlan and I think I might have found
> another bug. After applying the patch below (for I believe a rather
> obvious typo), kernel started oopsing and I gave up. If needed, I can
> provide config files for either hostapd or freeradius server, though
> it looks like this is a driver problem.

I can't reproduce that oops, but we have a fix to the issue which I'll
send separately.

johannes


