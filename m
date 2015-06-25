Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f44.google.com ([209.85.216.44]:40721 "EHLO
	mail-vn0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbFYTfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 15:35:10 -0400
Received: by vnbf7 with SMTP id f7so12582604vnb.7
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 12:35:09 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
In-Reply-To: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 25 Jun 2015 12:35:09 -0700
Message-ID: <875882b849168899bd0012dc40da7b79@mail.gmail.com> (sfid-20150625_213515_205174_6774C769)
Subject: RE: [PATCH] mac80211: mesh - don't special case routing to transmitter
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Updating the path to the transmitter of a path message is optional
> > according to section 13.10.8.4 of the standard. Doing so can lead to
> > better performance since we can adjust the route to the transmitter
> > based on the freshest possible information. However it can also cause
> > routing loops with more than four or five nodes.
>
> Do you have the test scenario on how routing loops happen in this case?
>
> Thanks
>
> ----
> Chun-Yeow

We did this over a year ago and I don't think we saw routing loops though
iirc we saw better performance when we made the change. Most likely because
of the other problem with the original code: it creates a path to the ta if
none exists but does not go through discovery to do so. So if the direct hop
is not the best path you're going to be stuck with a crappy path until the
next refresh.

In any case updating metrics without doing an SN feasibility check is highly
suspect. I'm not 100% sure this instance will cause routing loops but I do
know that every time I have tried to be clever and optimize routing without
looking at both the SN and metric I have wound up with routing loops.

  -- Jesse
