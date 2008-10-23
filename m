Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:33460 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYJWTvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 15:51:14 -0400
Received: by rn-out-0910.google.com with SMTP id k40so331026rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 12:51:09 -0700 (PDT)
Message-ID: <43e72e890810231251s27f2c014y6f4db8e8f1c5b840@mail.gmail.com> (sfid-20081023_215119_217681_606876ED)
Date: Thu, 23 Oct 2008 12:51:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <8F0C2E89B9AA20448D482EB589641EB306B6390D@orsmsx507.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1224585110.5521.8.camel@johannes.berg>
	 <20081022122148.GF6190@tesla>
	 <8F0C2E89B9AA20448D482EB589641EB306B6390D@orsmsx507.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 12:40 PM, Perez-Gonzalez, Inaky
<inaky.perez-gonzalez@intel.com> wrote:
>>From: Luis R. Rodriguez [mailto:lrodriguez@atheros.com]
>>
>>Since this is only for wiphys this seems reasonable. I just keep in the
>>back of my mind leaving open the possibility for other wireless
>>subsystems to be able to make use of the currently set regulatory domain
>>and its regulatory rules, but this is in keeping with that as our
>>current requests are not changing the regulatory definitions, and just
>>as we have a wiphy for last_request we can add later struct
>>foo_new_wireless_type there too. I am curious if band definitions
>>should be shared between Bluetooth and 802.11 though. I don't think
>>BT devices have any notion of regulatory though nor are they capable of
>>exporting it though. Marcel is this correct? Inaky -- how about uwb, or
>>WiMax?
>
> UWB swipes over all the bands (from 3.1 to 10.6G), but keeping emission below FCCp15 limits (-41dBm, if memory serves) so it looks as interference to others. All the channel assignments are fixed and known, so in theory,
> it'd be possible to coordinate.
>
> On WiMAX the bands are allocated per country and per operator, so if the
> device can tell us what it supports or what the operator is telling it to
> use, it should be possible for it to report it to some band controller for coordination, but I don't know if it'll make any sense to ask the device to use only bands so and so, because the knowledge of what's allowed is in the network side.
>
> I might be missing the crux of the question though :)

Actually that helps a lot. As you had mentioned before though we are
not sure if *all* WiMAX devices will operate in the same way but its
good to know what yours are doing. I was wondering specifically if
other wireless technology can contribute to the regulatory rules
collection we have in the future. It seems it *might* be more than
anything we need coexistence technology.

  Luis
