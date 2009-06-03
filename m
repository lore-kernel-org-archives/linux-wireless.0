Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39204 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFCF55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 01:57:57 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090603040315.GA10464@khazad-dum.debian.net>
References: <1243841639.5299.8.camel@johannes.local>
	 <4A238EA2.4040106@tuffmail.co.uk> <1243858256.5299.14.camel@johannes.local>
	 <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 07:57:32 +0200
Message-Id: <1244008652.4145.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > We just need to fix the platform drivers then. They should not set
> > global states since that is not what they are controlling. They control
> 
> We should change things, yes.  So that the platform stores the global
> state.  That was half-broken on the old core (the platform stored the
> state of its own device, which could be out of sync with the global
> state), but the part of it setting the global state is correct.
> 
> That needs a new in-kernel API to tie the core to platform drivers
> capable of storing global states without causing problems when drivers
> are unloaded, but it is not hard.
> 
> As for NVS events, they have a clear use case: to let rfkilld know which
> global states it could leave alone the first time it loads, and which
> ones have to be restored...

show me an example of a platform device that stores the global state. I
think you are confusing the word platform as in system with a platform
device. The ThinkPad Bluetooth and WWAN switches are platform devices
and control each one specific device. Same goes for the EeePC. They are
not controlling a global state.

Regards

Marcel


