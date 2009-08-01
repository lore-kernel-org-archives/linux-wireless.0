Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55451 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZHAUlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 16:41:21 -0400
Subject: Re: [PATCH 2/2] rfkill: Add support for KEY_RFKILL_ALL
From: Marcel Holtmann <marcel@holtmann.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Matthew Garrett <mjg@redhat.com>, linux-input@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	dmitry.torokhov@gmail.com
In-Reply-To: <1249158328.28327.10654.camel@localhost.localdomain>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
	 <1249152859-14769-2-git-send-email-mjg@redhat.com>
	 <1249158328.28327.10654.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 13:41:16 -0700
Message-Id: <1249159276.3491.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bastien,

> > +               case KEY_RFKILL_ALL:
> > +                       rfkill_schedule_toggle(RFKILL_TYPE_WLAN);
> > +                       rfkill_schedule_toggle(RFKILL_TYPE_BLUETOOTH);
> > +                       rfkill_schedule_toggle(RFKILL_TYPE_UWB);
> > +                       rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
> > +                       break;
> 
> RFKILL_TYPE_ALL?

this should be RFKILL_TYPE_ALL indeed. Even if rfkill-input is going to
be removed. For the time being it needs to toggle all. Especially since
the example above already forgets RFKILL_TYPE_WWAN.

Regards

Marcel


