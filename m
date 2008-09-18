Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:51881 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbYIROY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:24:58 -0400
Received: by fk-out-0910.google.com with SMTP id 18so3389386fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 07:24:56 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 16:24:52 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181519.12366.IvDoorn@gmail.com> <20080918141006.GE1583@khazad-dum.debian.net>
In-Reply-To: <20080918141006.GE1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181624.53050.IvDoorn@gmail.com> (sfid-20080918_162501_151309_C895A64C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > If it is something coming from mac80211, then you do not want
> > to send a SOFT_BLOCKED event since that will cause all other radios
> > to be switched off simply because the b43 interface has not been
> > enabled.
> 
> Drivers ARE supposed to be able to set their radio state to their heart's
> content, without messing with any other devices.  There are no constraints
> to calls to rfkill_force_state(), other than the current issue that it must
> not be done from an atomic context.

My main point was that when the radio is not enabled because the user
did something like "iwconfig wlan0 txpower off" then this is not an rfkill
SOFT_BLOCKED event. Since that command has nothing to do with the
entire rfkill layer.

When you consider such commands as rfkill events you get wrong behavior
because it would trigger a SOFT_BLOCK in rfkill which will be send to all
registered drivers who can disable their radio off as well. And that is
definately not what you want...

Ivo

