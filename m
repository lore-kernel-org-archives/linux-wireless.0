Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:43996 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYJWVVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 17:21:20 -0400
Received: by yx-out-2324.google.com with SMTP id 8so190694yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 14:21:18 -0700 (PDT)
Message-ID: <1ba2fa240810231421l3056daf8j2beed3720e499775@mail.gmail.com> (sfid-20081023_232124_382948_8F291442)
Date: Thu, 23 Oct 2008 23:21:18 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
Cc: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1224791684.9386.194.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224585110.5521.8.camel@johannes.berg>
	 <20081022122148.GF6190@tesla>
	 <8F0C2E89B9AA20448D482EB589641EB306B6390D@orsmsx507.amr.corp.intel.com>
	 <1224791684.9386.194.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 9:54 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> >Since this is only for wiphys this seems reasonable. I just keep in the
>> >back of my mind leaving open the possibility for other wireless
>> >subsystems to be able to make use of the currently set regulatory domain
>> >and its regulatory rules, but this is in keeping with that as our
>> >current requests are not changing the regulatory definitions, and just
>> >as we have a wiphy for last_request we can add later struct
>> >foo_new_wireless_type there too. I am curious if band definitions
>> >should be shared between Bluetooth and 802.11 though. I don't think
>> >BT devices have any notion of regulatory though nor are they capable of
>> >exporting it though. Marcel is this correct? Inaky -- how about uwb, or
>> >WiMax?
>>
>> UWB swipes over all the bands (from 3.1 to 10.6G), but keeping emission below FCCp15 limits (-41dBm, if memory serves) so it looks as interference to others. All the channel assignments are fixed and known, so in theory,
>> it'd be possible to coordinate.
>
> and Bluetooth uses the full 2.4 GHz band (split into 79 channels) and it
> uses the full band equally and is allowed to. The regulatory efforts of
> the Bluetooth SIG made it possible to use this world-wide. No regulatory
> stuff is needed here.
>
> Bluetooth will also use UWB in the future in the range of 6 GHz and it
> will get the same world-wide regulatory effort.
>
> The only part I am not sure is Bluetooth over 802.11 since they have
> some weird stuff in there and the specification is not final yet.
>
> Regards
>
> Marcel
>
There is a similar effort going on in WiFi but it probably will take
some time, till this regulator nonsense is removed
Tomas
