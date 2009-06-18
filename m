Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37376 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbZFRDII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 23:08:08 -0400
Date: Thu, 18 Jun 2009 00:08:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 2/4] rfkill: don't restore software blocked state on
	persistent devices
Message-ID: <20090618030806.GE29569@khazad-dum.debian.net>
References: <4A37A3E1.8060606@tuffmail.co.uk> <1245161645.13461.3.camel@johannes.local> <4A37AEB7.6060405@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A37AEB7.6060405@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 16 Jun 2009, Alan Jenkins wrote:
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

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
