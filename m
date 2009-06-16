Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57763 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZFPPhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 11:37:14 -0400
Subject: Re: [PATCHv2 2/4] rfkill: don't restore software blocked state on
 persistent devices
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A37AEB7.6060405@tuffmail.co.uk>
References: <4A37A3E1.8060606@tuffmail.co.uk>
	 <1245161645.13461.3.camel@johannes.local> <4A37AEB7.6060405@tuffmail.co.uk>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 17:37:04 +0200
Message-Id: <1245166624.15367.24.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alan,

> The setting of the "persistent" flag is also made more explicit using
> a new rfkill_init_sw_state() function, instead of special-casing
> rfkill_set_sw_state() when it is called before registration.
> 
> Suspend is a bit of a corner case so we try to get away without adding
> another hack to rfkill-input - it's going to be removed soon.
> If the state does change over suspend, users will simply have to prod
> rfkill-input twice in order to toggle the state.
> 
> Userspace policy agents will be able to implement a more consistent user
> experience.  For example, they can avoid the above problem if they
> toggle devices individually.  Then there would be no "global state"
> to get out of sync.
> 
> Currently there are only two rfkill drivers with persistent soft-blocked
> state.  thinkpad-acpi already checks the software state on resume.
> eeepc-laptop will require modification.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> CC: Marcel Holtmann <marcel@holtmann.org>

looks good to me and is way better than using a complicated API for this
non-volatile storage details.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


