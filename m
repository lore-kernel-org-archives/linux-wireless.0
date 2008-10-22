Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:32197 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751941AbYJVXOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 19:14:04 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: reinette chatre <reinette.chatre@linux.intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224716347.9386.151.camel@californication>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224660449.28639.22.camel@johannes.berg>
	 <1224662185.9386.131.camel@californication>
	 <1224707446.10863.155.camel@rc-desk>
	 <1224716347.9386.151.camel@californication>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 16:14:21 -0700
Message-Id: <1224717261.10863.219.camel@rc-desk> (sfid-20081023_011410_379329_A6413B7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-22 at 15:59 -0700, Marcel Holtmann wrote:

> in some cases it might be possible with a set of quirks or special
> functions that can be switched at runtime. Check the whole bunch of USB
> drivers that have special handling depending on what hardware it finds.
> We could do the same. In some cases this effort might be too much, but
> if possible we should at least try.

I don't think we can easily apply the hardware quirk solution here. This
is because hardware can be identified by id that does not change and the
hardware self does not really change (unless it has firmware that
changes ...). In this firmware case we do not have "an id" (we have one
file that is loaded by firmware loader so we cannot know what we get
just by "looking at it" unless we enforce a version number in the
filename as we currently do in our driver) and the firmware can change,
potentially frequently, with the consequence of many "quirks" that need
to be maintained.

> It all depends on how much the ucode API changes and sometimes we really
> wanna cleanup the driver and remove the old code, but in that case we
> have to tell the users via modules_install that this kernel will break
> or we have to keep the old driver around. Breaking it from one kernel
> version to the next one without the user noticing only after reboot is
> just not good enough.

I agree with you and Johannes in this regard and look forward to the
modules_install solution. I do hope this will be acceptable to
everybody.

Reinette


