Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822Ab2HHR6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:58:08 -0400
Message-ID: <1344448792.18836.14.camel@dcbw.foobar.com> (sfid-20120808_195815_195503_CEBF28AE)
Subject: Re: Problem: BCM 4313 (brcmsmac) always hard blocked
From: Dan Williams <dcbw@redhat.com>
To: Arliton Rocha <arliton@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 08 Aug 2012 12:59:52 -0500
In-Reply-To: <CANZ_KY5yLJrHKQ4c30sNpVXPBRRTzwjyUYREcOaX8YP=OAB=Ew@mail.gmail.com>
References: <CANZ_KY5-EZ2n54G3P3wnjUdTdVknarnXFK2cj9WobnQemAr5kA@mail.gmail.com>
	 <CANZ_KY5yLJrHKQ4c30sNpVXPBRRTzwjyUYREcOaX8YP=OAB=Ew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-08 at 08:14 -0300, Arliton Rocha wrote:
> Hi devs,
> 
> The following card does not work (remains always 'hard blocked'):
>     02:00.0 Network controller [0280]: Broadcom Corporation BCM4313
> 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
> 
> There is no a physical lock on the notebook in question.
> I know windows can change only by software.
> When i do this, wireless net (and bluetooth) works fine on linux.
> Ok, install windows, unblock... But, why linux can't do this?
> I have trying a lot of tips about rfkill (unblock all, ...) but
> nothing, remains hard blocked.
> Also i tried, unsuccessfully, map Fn + F12 keys...

BIOS usually controls this sort of thing.  Check "rfkill list" and see
if you have a "platform" killswitch.  On my HP, that looks like:

0: hp-wifi: Wireless LAN

and when that is blocked, it hardblocks the internal wifi.  This switch
is provided by a small driver that talks to your laptop's BIOS.  It's
likely that either your laptops device IDs are not added to the correct
kernel driver, or your laptop does things in a different way than
previous ones, and doesn't have a kernel driver yet.  But in the end,
this is most likely a kernel rfkill driver bug, not a wifi bug.

What make and model of laptop is this?

Dan

> Someone have an idea?
> 
> Hardware information in attachment.
> 
> Thanks in advance.
> Best regards.
> 
> --
> Arliton Rocha


