Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42665 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZHAUw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 16:52:26 -0400
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
From: Marcel Holtmann <marcel@holtmann.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <20090801204534.GA23642@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
	 <1249159133.3491.13.camel@localhost.localdomain>
	 <20090801204534.GA23642@srcf.ucam.org>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 13:52:22 -0700
Message-Id: <1249159942.3491.21.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthew,

> > actually I would prefer if we name this key KEY_RFKILL and not put the
> > policy of ALL into the kernel. Since we wanna get rid of rfkill-input.
> > That needs to be done in userspace and by users policy. If they wanna
> > map that key to ALL then that is fine. If they just wanna toggle WiFi,
> > then that is also fine. If the wanna have to popup some UI, that is also
> > reasonable.
> 
> My reasoning was that this conceptually maps to a key that controls all 
> of the radios in the system - whether a single press actually kills all 
> of them or not is kind of irrelevent (having the simple policy in 
> rfkill-input works fine for this, but userspace will obviously want 
> something more cunning). My concern with KEY_RFKILL is that it it's not 
> obvious that it refers to a specific type of key - ones that purely 
> control wifi should still be KEY_WLAN, for instance.

actually if the key is clearly hardwired to WLAN, then it should not
even show up as input event at all. This is one of the mis-concepts of
the old RFKILL subsystem. No need to send an input event if the platform
driver is going to rfkill that device anyway.

If a key is clearly labeled as WLAN then it should emit only KEY_WLAN.
And if it is just a generic key with some radio on it like FN-F5 on my
ThinkPad, then it better just emits KEY_RFKILL and we let userspace (or
rfkill-input do the policy).

Remember that in the end it is just a key and whatever the user does
with it is users policy. So in summary it is up to the platform driver
to emit the proper key. For some it might be still KEY_WLAN, for other
it might be KEY_RFKILL. Sounds fair?

Regards

Marcel


