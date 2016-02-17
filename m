Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32838 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115AbcBQQuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 11:50:23 -0500
Received: by mail-lb0-f174.google.com with SMTP id x4so13233422lbm.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 08:50:23 -0800 (PST)
Date: Wed, 17 Feb 2016 11:50:23 -0500
From: German <gentgerman@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Wrong wireless nick card name loaded on reboot
Message-ID: <20160217115023.1e0d0908@libertarian.asterius.net> (sfid-20160217_175028_442353_B30F2C41)
In-Reply-To: <56C499E0.3070909@lwfinger.net>
References: <20160217060909.694a9aff@libertarian.asterius.net>
	<56C499E0.3070909@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 17 Feb 2016 10:03:44 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 02/17/2016 05:09 AM, German wrote:
> > Hi list,
> >
> > A couple of days ago I asked why my pc changes the wireless card
> > name. It switches between AR9285 ( right) and AR5008 ( wrong).
> > Someone suggested  that this is because another kernel module is
> > loaded by mistake. Well, it is not the case. When system identified
> > with AR9285, it loads ath9k and I can connect to the router. When
> > system identifies my card as AR5008, no kernel module is present at
> > all ( lspci -k). The wrong card name occurs only when system
> > rebooted. If I gracefully shut down the system, it always comes up
> > with a right name for the card ( AR9285). So, how to force the
> > system identify my card right no matter if I reboot or shut down?
> > Thank you.
> 
> I would like to help you, but I do not remember your earlier message.
> Why did you not reply to the earlier one so that everything would be
> in the same thread? That would have made searching the archives
> easier. As a result, I may be duplicating some previous information.

Sorry Larry, this was my repost of Debian user mailing list. My
apologies for the confusion.


> 
> The selection of a driver for a given device comes from the PCI ID.
> If your system is showing the wrong device, then you may have
> hardware problems such that the PCI ID is reported incorrectly. To
> test this, please provide the output of the command
> 
> lspci -nn | grep Network
> 
> for the "good" and "bad" case.
> 
> Larry
> 
> 

This is the "good" case:

lspci -nn | grep Network
01:00.0 Network controller [0280]: Qualcomm Atheros AR9285 Wireless
Network Adapter (PCI-Express) [168c:002b] (rev 01)

I will reboot now to "bad" case and post the output. Thank you Larry!
