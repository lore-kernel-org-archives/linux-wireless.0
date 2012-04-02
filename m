Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2DBUWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 16:22:48 -0400
Received: by bkcik5 with SMTP id ik5so2932991bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 13:22:46 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: carl9170 driver - network connection breaks
Date: Mon, 2 Apr 2012 22:22:32 +0200
Cc: "Per-Erik Westerberg" <per-erik.westerberg@bredband.net>,
	=?utf-8?q?Miko=C5=82aj_Kuligowski?= <mikolaj.q@wp.pl>
References: <4f79e539d908b3.59415590@wp.pl> <1333394617.2725.11.camel@tux.homenetwork>
In-Reply-To: <1333394617.2725.11.camel@tux.homenetwork>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201204022222.32857.chunkeey@googlemail.com> (sfid-20120402_222252_755887_DA432E43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, April 02, 2012 09:23:37 PM Per-Erik Westerberg wrote:
> mån 2012-04-02 klockan 19:43 +0200 skrev Mikołaj Kuligowski:
> > carl9170 driver - network connection "hangs". It happens if some bigger file is being
> > downloaded (few MB or bigger). It doesn't happen on kernels less then 3.2 (works well
> > with 3.1 and previous) and doesn't depend on firmware - it happens with all available
> > firmware versions: 1.9.3, 1.9.4, 1.9.5.  I use USB wireless card TP-LINK TL-WN821N.
> > Ubuntu 12.04. The device works perfect with Oneiric, breaks with Precise. Please help.
> > 
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/971728
> > 
> > __________________
> 
> Hi,
> 
> I am seeing exactly the same issues using an Netgear WNDA3100 when using
> anything newer that 3.1 kernel with the carl9170 driver and the firmware
> from http://linuxwireless.org/.
> 
> I am using Gentoo Linux and have tried using both the gentoo-sources
> 3.3.0, the vanilla kernel 3.3.0 and the git-sources (3.3-rc7). I have
> not yet tried 3.4-rc1 but will try that also.
> 
> I have tried to enable debugfs and all the debugging options that I can
> find in the kernel-config and have googled for information on how to
> actually use debugfs but have failed to understand how to use it, any
> ideas on what to look for?

Acutally, somebody else has already reported something like this last saturday.
But to my surprise, the reporter verified that the connection is NOT dead...
It looks like the BA session contexts are getting out of sync and the data is
simply "dropped" on one side. E.g.: a simple 'ping -Q 224 $APIP' will still go
through (until the ARPs are flushed, so one has to be quick).
[also nulldata & mgmt frames are not affected by this and therefore the
driver/stack/supplicant won't timeout the stale connection/session on its own].

The original reported hasn't said anyhting since and I can't reproduce the issue
on my side, my carl9170 station works fine with mac80211-based AP I got.

Regards,
	Christian
