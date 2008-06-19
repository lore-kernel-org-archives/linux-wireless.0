Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56058
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbYFSWEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 18:04:48 -0400
Date: Thu, 19 Jun 2008 15:04:48 -0700 (PDT)
Message-Id: <20080619.150448.24028711.davem@davemloft.net> (sfid-20080620_000457_026836_519B1B24)
To: tomasw@gmail.com
Cc: johannes@sipsolutions.net, mcgrof@gmail.com,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, assaf.krauss@intel.com
Subject: Re: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information
 Element
From: David Miller <davem@davemloft.net>
In-Reply-To: <1ba2fa240806191329w7aef4ccaq587915d41d999edd@mail.gmail.com>
References: <1ba2fa240806191316h3ca2044o407d094415fa5bf2@mail.gmail.com>
	<1213906688.8967.112.camel@johannes.berg>
	<1ba2fa240806191329w7aef4ccaq587915d41d999edd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Tomas Winkler" <tomasw@gmail.com>
Date: Thu, 19 Jun 2008 23:29:55 +0300

> On Thu, Jun 19, 2008 at 11:18 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> >> +     if (country_ie_len < 6) {
> >> >> +             printk(KERN_ERR "%s: country information element shorter (%d)"
> >> >> +                     " than expected.\n", __func__, country_ie_len);
> >> >
> >> > Remotely exploitable security bug.
> >
> >> Please explain,
> >
> > Sending broken frames will fill the disk.
> 
> I see thanks (yeah, distors doesn't make separate log partitions as default)

How distros do their partitioning is neither here not there.  And even
if they make a seperate log partition, that means it's still exploitable
in that you will no longer get the other non-spam log messages that might
be important to know about.

Any kernel log message triggerable remotely without any kind of rate
limiting is a bug.
