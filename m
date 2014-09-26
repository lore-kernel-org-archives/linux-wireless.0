Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:52607 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753803AbaIZTot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 15:44:49 -0400
Message-ID: <1411760678.18773.5.camel@dubbel> (sfid-20140926_214453_286699_4F424997)
From: Luca Coelho <luca@coelho.fi>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"bjorn@mork.no" <bjorn@mork.no>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman, Liad" <liad.kaufman@intel.com>
Date: Fri, 26 Sep 2014 22:44:38 +0300
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B526977@hasmsx107.ger.corp.intel.com>
References: <541F23D2.90600@gmail.com>
	 <1411327338-23099-13-git-send-email-egrumbach@gmail.com>
	 <87ppeoc4s0.fsf@nemi.mork.no>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com>
	 <87d2amd24t.fsf@nemi.mork.no>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B526977@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 13/17] iwlwifi: 8000: fix fw name to account for revision
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-23 at 11:38 +0000, Grumbach, Emmanuel wrote:
> > "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
> > >> Emmanuel Grumbach <egrumbach@gmail.com> writes:
> > >>
> > >> > diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c
> > >> > b/drivers/net/wireless/iwlwifi/iwl-8000.c
> > >> > index 4ae8ba6..e435148 100644
> > >> > --- a/drivers/net/wireless/iwlwifi/iwl-8000.c
> > >> > +++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
> > >> > @@ -81,7 +81,7 @@
> > >> >  #define IWL8000_NVM_VERSION		0x0a1d
> > >> >  #define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
> > >> >
> > >> > -#define IWL8000_FW_PRE "iwlwifi-8000-"
> > >> > +#define IWL8000_FW_PRE "iwlwifi-8000"
> > >> >  #define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE
> > >> __stringify(api) ".ucode"
> > >>
> > >> Isn't this going to create a misleading MODULE_FIRMWARE entry,
> > >> matching neither of the firmware variants?
> > >>
> > >>
> > > Yes probably - OTOH, this device is far from being on the shelves. By the
> > time it will hit the shelves, we will have removed all the hacks for the early
> > steps of the hardware.
> > > Ideas to make it better?
> > 
> > Not exactly elegant, but I would just have duplicated the macros for each
> > new hardware revision.  E.g:
> > 
> > #define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE "-"
> > __stringify(api) ".ucode"
> > #define IWL8000B_MODULE_FIRMWARE(api) IWL8000_FW_PRE "B-"
> > __stringify(api) ".ucode"
> > MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API
> > _OK));
> > MODULE_FIRMWARE(IWL8000B_MODULE_FIRMWARE(IWL8000_UCODE_AP
> > I_OK));
> > 
> > Or maybe make the revision part of the macro or something.
> > 
> > 
> > > Good to know that someone is actually looking at the patches I take
> > > care to send :)
> > 
> > Always looking for new goodies to try out :-)  The temperature sensor
> > readout was one this time.  Although I would have preferred it as a proper
> > hwmon device instead of a debugfs file.  Has this been discussed?
> > 
> 
> Not really - since I don't think that this is worth it.
> The WiFi device heats up when we Tx, and I think it'd be worth making this data public in the system. The temperature sensor is mostly to avoid burning things out :)

Yeah, the temperature sensor is used to avoid heating the NIC too much
and potentially damaging things.  We do things like throttle down the
data flow and, in the most dramatic cases, turn the chip entirely off.

The mean reason for the new debugfs entry is for, well, debugging. :)

Bjørn, do you have any ideas on how this information could be used in a
useful way so that it would be worth the effort of exporting it in a
more "official" way?

--
Cheers,
Luca.

