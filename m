Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:48362 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYJUXeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 19:34:09 -0400
Received: by yx-out-2324.google.com with SMTP id 8so487947yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 16:34:08 -0700 (PDT)
Message-ID: <1ba2fa240810211634k74979933mf9364d405ae6e33a@mail.gmail.com> (sfid-20081022_013414_928457_7605EF54)
Date: Wed, 22 Oct 2008 01:34:07 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "reinette chatre" <reinette.chatre@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224630394.9386.114.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224630394.9386.114.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 1:06 AM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Reinette,
>
>> > > >> > >> Two new versions of 3945 uCode is now available for download from
>> > > >> > >> http://intellinuxwireless.org/?n=Downloads. Two versions are available
>> > > >> > >> as we have updated the API version of the uCode and included pending
>> > > >> > >> fixes in both API versions.
>> > > >> > >>
>> > > >> > >> Version 15.28.1.8 supports API v1 and can be used with most current 3945
>> > > >> > >> drivers. Version 15.28.2.8 (API v2) is required when you start using the
>> > > >> > >> latest 3945 driver from wireless-testing at the time it includes the
>> > > >> > >> patch "iwl3945 : Fix a-band association for passive channels".
>> > > >> > >
>> > > >> > > Can you make the driver work with the old ucode? We even do that for
>> > > >> > > drivers where we don't control the ucode like b43...
>> > > >> >
>> > > >> > What for?
>> > > >>
>> > > >> Well, so that installing a new kernel doesn't suddenly break your
>> > > >> network connection and ability to download the firmware, for instance.
>> > > >> If you want more arguments you can go read all the "b43 sucks" threads
>> > > >> about it.
>> > > >
>> > > > Johnannes has a point, that is a lot nicer to users...
>> > >
>> > > Maybe, but it will complicate the code beyond good taste to just
>> > > satisfy the single moment when kernel is upgraded. I don't mean in
>> > > general I mean in this particular case when API changes.
>> > > Anyhow a good distro shell deal with this in packaging dependencies
>> > > and normal person will keep old kernel around when compiling new one.
>> > > Both ucodes can be present on the file system at the same time  so I
>> > > hope the risk is low.
>> >
>> > it is the same argument as for everything else. We should be able to run
>> > a new kernel with old userspace.
>>
>> I do not believe our request is unreasonable. If a user runs a new
>> kernel the log will print a message that the firmware is incorrect ...
>> all the user needs to do is go to
>> http://intellinuxwireless.org/?n=Downloads and download the latest
>> firmware. This does not require any subtle changes that may affect other
>> aspects of the system ... just the firmware file that is only used by
>> the driver.
>>
>> We are focused on upstream development. If there is a need to support
>> older ucode then we face a similar challenge as was solved through the
>> compat-wireless project for the driver self.
>
> I haven't checked this particular case, but in some cases it is simple
> to keep backward compatible code around that would let us support the
> old firmware for a few releases. In other cases the driver and firmware
> interface might have evolved too much to do so. In these cases we might
> wanna keep the old drivers around so users can have a choice.

If it wasn't so awkward in this case I wouldn't mind to support old firmware.
Second when we touch  firmware especially for old HW it means that it
solves a bug so why ones would use old driver for something else then
to download the new firmware.

> We do have something like drivers/staging/ now. It might make sense to
> have introduce drivers/deprecated/ for old drivers that we just keep
> around for a few releases to ease a transition. Just thinking out loud.

Sounds like good idea... need some configuration tricks tough unlike
staging here we have 2 drivers for the same hw

> And I have been bitten by ucode API changes in the past. It is just not
> clear when actually compiling the new kernel. We could also have compile
> time checks that check the new firmware file is actually present at the
> compile time of the new kernel. The driver should have a MODULE_FIRMWARE
> tag and we could process it and match it to /lib/firmware.

It has MODULE_FIRMWARE already
Tomas
