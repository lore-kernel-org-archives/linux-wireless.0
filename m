Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50377 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaFIIAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 04:00:43 -0400
Message-ID: <53956986.8070603@openwrt.org> (sfid-20140609_100046_999688_EFF6E023)
Date: Mon, 09 Jun 2014 10:00:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>	 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>	 <20140520142453.GB13981@tuxdriver.com>	 <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>	 <20140520180832.GD13981@tuxdriver.com>	 <1400610273.4474.6.camel@jlt4.sipsolutions.net>	 <CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com>	 (sfid-20140520_204832_656990_FF6AC676) <1400688233.4136.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1400688233.4136.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-21 18:03, Johannes Berg wrote:
> On Tue, 2014-05-20 at 11:48 -0700, Luis R. Rodriguez wrote:
> 
>> > I think we should, but if we can't then at least can we cut to an
>> > extensible format?
> 
> I don't see any way to extend the format right now.
> 
> There's a wrinkle with making it more extensible too though - if we do
> that then we must be extremely careful that future older crda versions
> (i.e. the next version that we're about to write) will not parse a newer
> extended file more permissively, so our extensions are limited anyway.
> 
> Looks like the format update really is needed, which probably means we
> should change the scripts to generate two databases and change the
> filename, or so?
How about making the format properly extensible by reusing what we're
already doing to keep the kernel ABI stable? For example, we could store
the database in a netlink-like attribute format, with some changes to
make it fixed endian.
I'm already doing just that for a few things in OpenWrt, so I have
working C code for writing and parsing such a format.

Another nice feature would be to indicate in the attributes if crda is
required to understand them, or if it can just continue with a warning.

If done right, I think we can probably make this the last time we change
the format version.

- Felix
