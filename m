Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43401 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYJVXkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 19:40:31 -0400
Date: Wed, 22 Oct 2008 19:39:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@linux.intel.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New iwlwifi 3945 uCode available
Message-ID: <20081022233921.GO15808@tuxdriver.com> (sfid-20081023_014047_218267_670E33E5)
References: <1224624899.28639.17.camel@johannes.berg> <20081021213814.GM17268@tuxdriver.com> <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com> <1224627187.9386.103.camel@californication> <1224628088.10863.100.camel@rc-desk> <1224660449.28639.22.camel@johannes.berg> <1224662185.9386.131.camel@californication> <1224707446.10863.155.camel@rc-desk> <1224716347.9386.151.camel@californication> <1224717261.10863.219.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224717261.10863.219.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 04:14:21PM -0700, reinette chatre wrote:
> On Wed, 2008-10-22 at 15:59 -0700, Marcel Holtmann wrote:
> 
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

You can try to load the new firmware, and if that fails you can try
the older firmware.  Whichever one succeeds first can govern the API
you use.  In fact, I had a patch like this for Fedora back when you
first added an API version to your firmware.  Of course, at that point
there was no need to rememebr what got loaded since there really was
only one API...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
