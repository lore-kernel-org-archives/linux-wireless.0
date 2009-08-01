Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:40363 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZHAUyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 16:54:45 -0400
Date: Sat, 1 Aug 2009 21:54:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
Message-ID: <20090801205445.GA23751@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com> <1249159133.3491.13.camel@localhost.localdomain> <20090801204534.GA23642@srcf.ucam.org> <1249159942.3491.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249159942.3491.21.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 01, 2009 at 01:52:22PM -0700, Marcel Holtmann wrote:

> actually if the key is clearly hardwired to WLAN, then it should not
> even show up as input event at all. This is one of the mis-concepts of
> the old RFKILL subsystem. No need to send an input event if the platform
> driver is going to rfkill that device anyway.

There's still a policy decision. Does it kill internal devices, or does 
it kill all attached wlan devices?

> Remember that in the end it is just a key and whatever the user does
> with it is users policy. So in summary it is up to the platform driver
> to emit the proper key. For some it might be still KEY_WLAN, for other
> it might be KEY_RFKILL. Sounds fair?

I agree on the technical side, but not the naming. KEY_WLAN is an 
rfkill-related key, so introducing KEY_RFKILL is potentially confusing. 
KEY_RFKILL_ALL isn't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
