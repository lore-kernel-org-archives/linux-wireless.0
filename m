Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55843 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYJVSYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:24:12 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	reinette chatre <reinette.chatre@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810220528w6b2e4e60k7d2390328d9b5c49@mail.gmail.com>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk> <20081022100758.GA27595@infradead.org>
	 <1ba2fa240810220528w6b2e4e60k7d2390328d9b5c49@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 20:25:08 +0200
Message-Id: <1224699908.9386.145.camel@californication> (sfid-20081022_202418_825285_E8E05414)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> I do not believe our request is unreasonable. If a user runs a new
> >> kernel the log will print a message that the firmware is incorrect ...
> >> all the user needs to do is go to
> >> http://intellinuxwireless.org/?n=Downloads and download the latest
> >> firmware. This does not require any subtle changes that may affect other
> >> aspects of the system ... just the firmware file that is only used by
> >> the driver.
> >
> > with the wireless that doesn't work.  Nice.  Sorry guys, but requiring
> > a new firmware version for a new driver release is completely
> > unreasonable.  You can drop support for older firmware ABIs after a few
> > years,but not immediately.
> 
> Years.. this HW will be obsolete in year or two, hopefully recycled.
> I personally don't want people using this buggy firmware for years.

seems I have to put clearly my community hat on now.

This is not true at all. I am still using a ipw2100 in one of my
machine. So the 3945 and 4965 will be in use for a long time. The
community measurement of obsolete and companies measurement are totally
different. Also don't forget these countries where laptops and
electronics are still expensive. The old Intel wireless cards will still
be used for a long time there.

> This is development branch after all, it's not even scheduled for 2.6.28.
> 
> Ucode API for 4965 was changed to -2 without much pain, So there is a
> precedence this work quite well. This time there were some hiccups in
> handling this since the API version wasn't updated it as should be.
> really our fault. But I don't think this situation is so dramatic as
> you describe it.

Actually that is your impression. I was falling over the 4965 ucode API
change twice and it took me longer than 5 minutes to even debug and
understand what went wrong here. Since there is no real warning anywhere
and the wireless device does show up. And I do know how to handle these
things.

> The objective of the objections is not that we want to immensely hurt
> users but rather the trade off between maintain even uglier code and
> users running buggy firmware versus logging into older kernel and
> downloading new firmware in 5 minutes looks to me not proportional.
> Distro users that pull updates won't even notice. I might be wrong
> though.

There will be cases where it is too much of a burden and too complicated
to keep support for both APIs, but in all other cases we should try to
have the driver work with it. I am fully behind Johannes and Christoph
here since that is what the community expects.

So if we ran into a case where we need to abandon the support for the
old API, then we first should make sure that the modules_install will
warn loudly about the missing firmware. And with MODULE_FIRMWARE and the
firmware work from David, we do have everything in place to actually do
this. So lets do it.

An additional option would be to create drivers/deprecated/ and put a
copy of the old driver there and have some Kconfig magic to allow
selecting only one of the drivers.

Regards

Marcel


