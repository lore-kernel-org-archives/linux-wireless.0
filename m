Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from leo.clearchain.com ([199.73.29.74]:20304 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab0BQWhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 17:37:25 -0500
Date: Thu, 18 Feb 2010 08:34:50 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Bastien Nocera <hadess@hadess.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-input@vger.kernel.org, marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20100217223450.GC22561@barra.bne.redhat.com>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
 <20100217052247.GD7160@core.coreip.homeip.net>
 <20100217180342.GA22522@srcf.ucam.org>
 <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
 <20100217184502.GA23573@srcf.ucam.org>
 <1266432575.678.980.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266432575.678.980.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 06:49:35PM +0000, Bastien Nocera wrote:
> On Wed, 2010-02-17 at 18:45 +0000, Matthew Garrett wrote:
> > On Wed, Feb 17, 2010 at 07:43:56PM +0100, Christian Lamparter wrote:
> > 
> > > Wait wait... do you can get another KEY_?
> > > 
> > > The reason: Some new devices come with a WPS "Push Button".
> > > And there's no code for them yet.
> > 
> > What's a WPS button? There's no fundamental issue with getting new KEY_ 
> > codes defined, but bear in mind that anything greater than 255 won't be 
> > seen by X at present.
> 
> Won't be seen by most X applications. The server should definitely see
> it, so should applications that use XInput2-aware widget sets.
> 
> (Which obviously means not much at all right now).

Because XKB2 never happened we don't actually have any way of configuring
keysyms in the server for keys > 255 or getting this layout information to
the client. So XI2 applications that want to use higher keycodes are reliant
on the keycode itself which is strictly speaking random - at least the
protocol makes no guarantee that they remain fixed.

In practice that's not quite true and the keycodes are likely to remain
fixed but relying on that hurt us quite badly in the keyboard -> evdev
conversion.

Cheers,
  Peter
