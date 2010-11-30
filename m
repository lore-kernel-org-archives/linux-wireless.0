Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35978 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0K3TVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 14:21:06 -0500
Received: by qyk11 with SMTP id 11so1599440qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 11:21:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF54A03.2090104@ti.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
 <1290079951-16793-18-git-send-email-arik@wizery.com> <4CF51CE8.9090809@ti.com>
 <AANLkTimtk2qXYOVPo+WRyV1Jhe-Fk-7hvoctuAF35ik7@mail.gmail.com> <4CF54A03.2090104@ti.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 30 Nov 2010 21:20:49 +0200
Message-ID: <AANLkTinbFBXi9J5up65tV2Hp-5-0jDbbLuuCEn6ts2nJ@mail.gmail.com>
Subject: Re: [PATCH 17/18] wl1271: Read MAC address from NVS file on HW startup
To: Gery Kahn <geryk@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The idea is to eliminate the situation where anyone "should be careful to
> not set the
> MAC twice".
> If there is MAC from NVS, make it system wide, w/o need to care about it. On
> the other hand,
> if MAC set by `ifconfig' same story, make it system wide.

No one has to set the MAC address twice. This patch degrades
gracefully - if there is no NVS file on disk, no harm done.
This means a solution that only uses ifconfig or TESTMODE commands
before adding an interface will also work.

This patch only gives one the option to set the MAC address right when
the HW is initialized, without resorting to scripts or usermode
daemons. One has to simply put the NVS file on the filesystem and the
MAC will be read from there. I found this easier from an engineering
perspective.

Note that even without this patch its possible to set the MAC address
twice - use ifconfig, add a monitor interface and then use ifconfig
again to change the MAC.

Regards,
Arik
