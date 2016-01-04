Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbcADQO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 11:14:59 -0500
Message-ID: <1451924098.8568.8.camel@redhat.com> (sfid-20160104_171503_038416_37368F69)
Subject: Re: power save settings for WiFi
From: Dan Williams <dcbw@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 Jan 2016 10:14:58 -0600
In-Reply-To: <CANUX_P3Wft5YhvckAzogXy-cV8Ngf8n+Y+6jn1Je3q7r-RDe_g@mail.gmail.com>
References: <CANUX_P3Wft5YhvckAzogXy-cV8Ngf8n+Y+6jn1Je3q7r-RDe_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-01-03 at 12:17 +0200, Emmanuel Grumbach wrote:
> Hi Dan,
> 
> I wanted to debug something with power save control and saw that NM
> disables power save by default. This was a complete surprise for me.
> This probably is because Ubuntu upgraded my NM version to 1.0.4.

Note that upstream NM 1.0.x does not support powersave, that was
apparently backported from NM 1.2.x by Ubuntu (?).  So anything I'm
talking about here applies to NM 1.2...

> I tried to enabled power save with:
> 
>  nmcli c modify <MYSSID> 802-11-wireless.powersave 1
> 
> That command returns 0, but power save is still disabled. Note that

This simply modifies the saved configuration, it doesn't modify the
runtime value.  To change that, the connection must be bounced. 
 Upcoming NM versions will support live changes by reflecting what you
do with nmcli to the runtime state of the device (or IP
addresses/routes/etc).  But not in 1.2 and lower.

So 'nmcli con up <MYSSID>' *should* enable powersave on the device.

> the decision to disable power save by default is a bit surprising.
> I understand that some device may not behave well with power save
> enabled, but then, I'd expect those (bad) devices to disable power
> save in the driver level.

When adding new features to NM (like powersave) we attempt to not
horribly break existing use-cases.  Which, for users of devices where
powersave doesn't work very well, would mean breaking their connection
by enabling it by default.  However, NM could have handled this better
by leaving the driver-default value enabled unless the user explicitly
sets the 'powersave' property.  Which it should really do...

I've filed https://bugzilla.gnome.org/show_bug.cgi?id=760125 for that.

Dan
