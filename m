Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37409 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaGAOpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 10:45:14 -0400
Date: Tue, 1 Jul 2014 10:41:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felix Fietkau <nbd@openwrt.org>, John Walker <john@x109.net>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Richard Fontana <fontana@sharpeleven.org>
Subject: Re: Parser stable fix question for CFG80211_INTERNAL_REGDB
Message-ID: <20140701144149.GB6358@tuxdriver.com> (sfid-20140701_164519_089297_8980C196)
References: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
 <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2014 at 12:19:08PM -0700, Luis R. Rodriguez wrote:
> On Mon, Jun 30, 2014 at 11:55 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > For the current kernel we
> > could intake the patch below, and I can port the change to no use
> > dfs_cac, that would enable older kernels to use new and older versions
> > of the ASCII database file.
> 
> Personally I actually rather avoid us accept a patch upstream for a
> userspace change. The problem here is that we failed to realize the
> impact of CFG80211_INTERNAL_REGDB at build time with a userspace tool,
> in this case the db.txt file wireless-regdb provides and its format.
> 
> If we wanted to avoid a stable patch we could require a match between
> wireless-regdb input file used for a kernel when
> CFG80211_INTERNAL_REGDB is used at build time. That would require
> different ASCII files on wireless-regdb or having the users of
> CFG80211_INTERNAL_REGDB do the conversion themselves. Upstream would
> just follow the wireless-regdb latest format. This then would just
> require upstream a Kconfig update to clarify the requirements.
> 
> This seems like a rather lazy option but also one that would be rather
> more fair and honest for upstream, we could deal with a proper fix by
> reconsidering the implementation of CFG80211_INTERNAL_REGDB completely
> for future kernels.

I'm shocked that anyone actually uses CFG80211_INTERNAL_REGDB...

Anyway, I don't see the big deal.  We should keep
CFG80211_INTERNAL_REGDB (whether implemented in awk or C) up-to-date
with current kernels.  Anyone wanting to use an old kernel with an
updated wireless-regdb file is responsible for ensuring compatibility.
If they can't do that, then they should seek support from a vendor.
How is this any different from any other kernel support issue?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
