Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33312 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbcAGQcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:32:51 -0500
Received: by mail-qk0-f172.google.com with SMTP id p186so105710547qke.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 08:32:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
 <568E913D.7050301@candelatech.com> <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Jan 2016 22:02:31 +0530
Message-ID: <CABPxzYKaMPY6bz=Nr+W2wG5y_bV_wFN=7AMNUNcZNJBeVyYVJA@mail.gmail.com> (sfid-20160107_173254_117356_419EBB11)
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
To: David Mosberger <davidm@egauge.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2016 at 9:59 PM, David Mosberger <davidm@egauge.net> wrote:
>
> Ben,
>
> On Thu, Jan 7, 2016 at 9:24 AM, Ben Greear <greearb@candelatech.com> wrote:
> > On 01/07/2016 08:19 AM, David Mosberger wrote:
> >>
> >> We are seeing a curious issue where WLAN connectivity sometimes
> >> gets stuck until a "wpa_cli reassociate" command is issued.
> >>
> >> At the WPA level, everything appears to be working fine)
> >> (see thread starting at
> >> http://lists.infradead.org/pipermail/hostap/2016-January/034454.html).
> >
> > I don't remember seeing you mention the driver and NIC you are using.
> >
> > I think this is likely a driver bug, so please provide that info.
>
> Sure, we're using rtl8192cu.  I started out suspecting a driver bug as
> well, but since we're processing management frames during those
> "stuck" periods just fine (see
> debug output in
> http://lists.infradead.org/pipermail/hostap/2016-January/034459.html),
> I'm not so sure anymore.  Like mac80211, we have patched rtl8192cu
> driver with current
> bug-fixes already.

Management frames use a different queue (VO)
from the logs it looks like a data path issue in driver/FW.

The re-association might be clearing/triggering TX in driver
solving the issue.
