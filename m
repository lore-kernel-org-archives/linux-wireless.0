Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43937 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab2HXItE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 04:49:04 -0400
Received: by bkwj10 with SMTP id j10so500814bkw.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2012 01:49:02 -0700 (PDT)
Message-ID: <1345798314.1478.12.camel@localhost.localdomain> (sfid-20120824_104954_107537_84A2E8B2)
Subject: [BUG] brcmsmac: Invalid killswitch handling
From: Sebastian Poehn <sebastian.poehn@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com
Date: Fri, 24 Aug 2012 10:51:54 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had a discussion with Matthew Garrett about handling of a wifi
killswitch on a Dell laptop.

Some (rfkill) code was removed from platform/dell-laptop. On my machine
a bug now occurs which is caused by brcmsmac in the view of Matthew.

So is this a bug, or do you have no killsitch handling, so far?

Bug description:
> physical switch is OFF
> rfkill state is ON
> => Laptop hangs on boot (maybe because a physical ascent device is
> used by network subsystem)
> 
> physical switch is OFF
> rfkill state is OFF
> => Activate interface in Gnome Connection Manager => System hang
> 
> test setup:
> Dell Vostro 3300
> Broadcom 4313 Wifi
> Kernel 3.5.[0-2] & 3.6
> Fedora 17


What Matthew wrote to me:
> > With the old dell-laptop code included everything was fine with
> > brcmsmac. So either generic platform code does not handle the switch
> > correct or there is no handling at all?
> 
> brcmsmac is broken. I suspect it was happily claiming to be
> unblocked, 
> but was ignored because dell-laptop claimed to be blocked.

Full discussion thread:
https://lkml.org/lkml/2012/8/23/234


