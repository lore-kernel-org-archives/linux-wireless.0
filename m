Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbZLCLW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 06:22:59 -0500
From: Will Stephenson <wstephenson@kde.org>
To: kde-hardware-devel@kde.org
Subject: Re: [Kde-hardware-devel] [PATCH 32/33] input: add KEY_WIRELESS_CYCLE
Date: Thu, 3 Dec 2009 12:23:04 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Corentin Chary <corentin.chary@gmail.com>,
	dbus@lists.freedesktop.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-wireless@vger.kernel.org, hal@lists.freedesktop.org,
	linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
	networkmanager-list@gnome.org, Len Brown <lenb@kernel.org>
References: <1259826317-18809-28-git-send-email-corentincj@iksaif.net> <71cd59b00912030122n3d94236ajfa5e55c3b5a9efcd@mail.gmail.com> <1259833412.12843.7.camel@johannes.local>
In-Reply-To: <1259833412.12843.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200912031223.04419.wstephenson@kde.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 December 2009 10:43:32 Johannes Berg wrote:
> On Thu, 2009-12-03 at 10:22 +0100, Corentin Chary wrote:
> > Dear system infrastructure people,
> > Do you think a KEY_WIRELESS_CYCLE key would have any application ?
> 
> Not really.
> 
> The naming of the key ultimately will not matter one bit, because it'll
> be misnamed on most platforms anyway, unless we want to do DMI matching
> or something to name the key. And even then, if there's a wifi key but
> no bluetooth key, users may prefer to have the wifi key act as a cycle
> key instead.
> 
> Therefore, this ought to all be policy in the rfkill daemon.
> rfkill-input will be going away as soon as somebody writes a simple
> daemon that allows doing such things, I really don't see us adding
> support for a cycle key to the kernel code, and for the userspace code
> it doesn't matter since users will configure it independent of the key
> code anyway.

This sounds reasonable to me, as the wireless guy in the KDE camp.  I don't 
want to have to handle these keypresses in a user session anyway - I prefer 
that NetworkManager picks up on them and notifies the client of the state 
change.

Will
