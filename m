Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:6740 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbXHTMK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 08:10:29 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1217708wxd
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2007 05:10:28 -0700 (PDT)
Message-ID: <1ba2fa240708200510o3caab2e8uf477ee2fe3da8b7f@mail.gmail.com>
Date: Mon, 20 Aug 2007 15:10:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] Add iwlwifi wireless drivers (resend)
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	"Jeff Garzik" <jgarzik@pobox.com>, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <1187608932.6090.87.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1187328536.5763.137.camel@debian.sh.intel.com>
	 <1187349981.23489.162.camel@johannes.berg>
	 <1187578610.5763.232.camel@debian.sh.intel.com>
	 <1187608932.6090.87.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/20/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-08-20 at 10:56 +0800, Zhu Yi wrote:
> > On Fri, 2007-08-17 at 13:26 +0200, Johannes Berg wrote:
> > > I was recently reviewing encryption stuff---can you comment on why you
> > > don't allow disabling hardware keys? For proper operation you really
> > > should allow that.
> >
> > I don't think there is any special reason, just haven't enabled it yet.
> > We enable the hwcrypto and find it works good, then we switched to
> > enable something else. For the end users, I think they'd always want to
> > use hwcrypto if it is supported by the hardware. For developers, I'd
> > agree it is useful. I'll add it to the TODO list.
>
> I guess the relevant thing is that if an association is lost then the
> key shouldn't be retained in the hardware because it should no longer be
> used, yet you don't allow to disable that key.

iwlwifi has notion of 'station' in driver and firmware. The whole
instance of station including keys has to be removed on association
lost. We need get at least mac address of the station that has lost
association into driver to do that. There is not comfortable interface
right now mac80211 to do that. The same goes for association process
where station has to be added we use rate scale init for that right
now.
There is some table_notification handler but it only updates driver
about number of stations.

There was a whole discussion we led about if rate scale algorithm and
notion of station should separated from the driver or not. I'm not
sure it was closed yet.

Thanks
Tomas

> johannes
>
>
