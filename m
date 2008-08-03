Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:25418 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYHCHsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 03:48:45 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2000865ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 00:48:43 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Date: Sun, 3 Aug 2008 10:12:06 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net>
In-Reply-To: <20080802192704.GB24253@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808031012.06554.IvDoorn@gmail.com> (sfid-20080803_094847_652388_C4F6C94B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> Hi Johannes!
> 
> On Sat, 02 Aug 2008, Johannes Berg wrote:
> 
> > On Sat, 2008-08-02 at 15:11 -0300, Henrique de Moraes Holschuh wrote:
> > > Currently, rfkill would stand in the way of properly supporting wireless
> > > devices that are capable of waking the system up from sleep or hibernation
> > > when they receive a special wireless message.
> > > 
> > > Since rfkill attempts to soft-block any transmitters during class suspend,
> > 
> > why does it interfere with suspend anyway?
> 
> The class makes sure that all transmitters are blocked on suspend.  You'd
> have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
> conserve power.

I think that handler was added by Dmitry, but I see no real reason for
issuing the BLOCK event during suspend. However the handlers should
be used to prevent state changes to drivers after they have been suspended.

Ivo
