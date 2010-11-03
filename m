Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49006 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0KCPCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 11:02:24 -0400
Received: by gwj21 with SMTP id 21so512271gwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 08:02:24 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication (2.6.36, rt73usb)
Date: Wed, 3 Nov 2010 15:53:32 +0100
Cc: Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <4CC0D0F6.4080507@web.de> <20101102125007.GA30000@sig21.net> <20101103141413.GA5364@sig21.net>
In-Reply-To: <20101103141413.GA5364@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011031553.32817.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 03 November 2010 schrieb Johannes Stezenbach:
> On Tue, Nov 02, 2010 at 01:50:07PM +0100, Johannes Stezenbach wrote:
> > 
> > While reading through the code I noticed the following in rt2800_config_intf():
> > 
> > 		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
> > 
> > However, in Ralink source from http://www.ralinktech.com/support.php?s=2
> > in DPO_RT3370_LinuxSTA_V2.4.0.1_20100831/include/chip/rtmp_mac.h it says:
> >                 USHORT          BssIdMask:2; // 0: one BSSID, 10: 4 BSSID,  01: 2 BSSID , 11: 8BSSID
> > 
> > This is different from rt73usb where 3 means "one BSSID".
> 
> Any comments on this?

The BSSID mask in rt2800 is correct. Since we allow up to 8 AP mode interfaces
we really want to have a BSSID mask of 3.

Of course we could also create the BSSID mask dynamically but that would
complicate adding/removing interfaces. Thus we decided to stick with the
maximum value here.

Helmut
