Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33987 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcAGQpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:45:41 -0500
Received: by mail-io0-f171.google.com with SMTP id 1so211134572ion.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 08:45:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568E9360.3060906@candelatech.com>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
	<568E913D.7050301@candelatech.com>
	<CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
	<568E9360.3060906@candelatech.com>
Date: Thu, 7 Jan 2016 09:45:40 -0700
Message-ID: <CALnQHM3-R+g+4o2qKyBbRM2VDcyhXqx6YpJLNHS3TKeLh7T6DA@mail.gmail.com> (sfid-20160107_174544_725267_63770154)
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
From: David Mosberger <davidm@egauge.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben,

On Thu, Jan 7, 2016 at 9:33 AM, Ben Greear <greearb@candelatech.com> wrote:

> Could be
> a power-save issue perhaps.

That was our thought, too.  Particularly, since if there is steady
traffic (at least a ping every 8 seconds), the problem does not appear
to occur.

However, the rtl8192cu doesn't support power-saving mode and in any
case, we made sure it's off:

  # iw wlan0 get power_save
  Power save: off

> I assume you have sniffed to see if any frames are going out on the air during the time of trouble?

No, I'm not actually sure how I'd do that.  The site we see this most
frequently with is
remote and we don't have any special WiFi packet sniffer.

> If correct packets go out on the air and AP doesn't answer, then likely AP
> problem.

Not likely an AP problem, since we're seeing this with multiple APs of
different brands etc.

> If pkts don't get on the air, then check to see if they at least get to
> the driver.

Yeah, that should be easy to do, I suppose.  We had rtl8192cu
debugging turned on
before but at that time it didn't help.

> If they don't get to the driver, then probably it is a kernel/stack issue.
>
> If they get to the driver but not on the air, then NIC and/or it's firmware
> and/or the driver is likely the culprit.

Thanks for your thoughts!

  --david
-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
