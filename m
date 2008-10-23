Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57396 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbYJWBMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 21:12:03 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Marcel Holtmann <holtmann@linux.intel.com>
To: reinette chatre <reinette.chatre@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224717261.10863.219.camel@rc-desk>
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
	 <1224717261.10863.219.camel@rc-desk>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 03:12:59 +0200
Message-Id: <1224724379.9386.155.camel@californication> (sfid-20081023_031209_638234_0DE60149)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> > in some cases it might be possible with a set of quirks or special
> > functions that can be switched at runtime. Check the whole bunch of USB
> > drivers that have special handling depending on what hardware it finds.
> > We could do the same. In some cases this effort might be too much, but
> > if possible we should at least try.
> 
> I don't think we can easily apply the hardware quirk solution here. This
> is because hardware can be identified by id that does not change and the
> hardware self does not really change (unless it has firmware that
> changes ...). In this firmware case we do not have "an id" (we have one
> file that is loaded by firmware loader so we cannot know what we get
> just by "looking at it" unless we enforce a version number in the
> filename as we currently do in our driver) and the firmware can change,
> potentially frequently, with the consequence of many "quirks" that need
> to be maintained.

we have the API version of the firmware file. If the new one can't be
found, then load the old one via request_firmware() and we know that we
have to use the old API. We can program our hardware only with one
firmware at a time anyway and we know which one we loaded.

We already apply the rules that if the firmware changes the API in an
incompatible way, we have to change the firmware filename.

Regards

Marcel


