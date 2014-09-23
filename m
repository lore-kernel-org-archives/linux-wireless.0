Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:49800 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbaIWLJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 07:09:47 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman\, Liad" <liad.kaufman@intel.com>
Subject: Re: [PATCH 13/17] iwlwifi: 8000: fix fw name to account for revision
References: <541F23D2.90600@gmail.com>
	<1411327338-23099-13-git-send-email-egrumbach@gmail.com>
	<87ppeoc4s0.fsf@nemi.mork.no>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com>
Date: Tue, 23 Sep 2014 13:09:38 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Mon, 22 Sep 2014 17:28:31 +0000")
Message-ID: <87d2amd24t.fsf@nemi.mork.no> (sfid-20140923_130951_285097_48DB77A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
>> Emmanuel Grumbach <egrumbach@gmail.com> writes:
>> 
>> > diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c
>> > b/drivers/net/wireless/iwlwifi/iwl-8000.c
>> > index 4ae8ba6..e435148 100644
>> > --- a/drivers/net/wireless/iwlwifi/iwl-8000.c
>> > +++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
>> > @@ -81,7 +81,7 @@
>> >  #define IWL8000_NVM_VERSION		0x0a1d
>> >  #define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
>> >
>> > -#define IWL8000_FW_PRE "iwlwifi-8000-"
>> > +#define IWL8000_FW_PRE "iwlwifi-8000"
>> >  #define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE
>> __stringify(api) ".ucode"
>> 
>> Isn't this going to create a misleading MODULE_FIRMWARE entry, matching
>> neither of the firmware variants?
>> 
>>
> Yes probably - OTOH, this device is far from being on the shelves. By the time it will hit the shelves, we will have removed all the hacks for the early steps of the hardware.
> Ideas to make it better?

Not exactly elegant, but I would just have duplicated the macros for
each new hardware revision.  E.g:

#define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE "-" __stringify(api) ".ucode"
#define IWL8000B_MODULE_FIRMWARE(api) IWL8000_FW_PRE "B-" __stringify(api) ".ucode"
MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
MODULE_FIRMWARE(IWL8000B_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));

Or maybe make the revision part of the macro or something.


> Good to know that someone is actually looking at the patches I take care to send :)

Always looking for new goodies to try out :-)  The temperature sensor
readout was one this time.  Although I would have preferred it as a
proper hwmon device instead of a debugfs file.  Has this been discussed?




Bjørn
