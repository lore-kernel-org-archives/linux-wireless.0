Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:34589 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZDVWql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 18:46:41 -0400
Received: by bwz7 with SMTP id 7so241353bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 15:46:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240439975.30082.66.camel@johannes.local>
References: <1240439975.30082.66.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 00:46:24 +0200
Message-ID: <69e28c910904221546p2d568846v470deca641b26d61@mail.gmail.com> (sfid-20090423_004644_669551_45BF4FD7)
Subject: Re: on radio_enabled
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 23, 2009 at 12:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi!
>
> So I was looking through various drivers, and not all of them are abl=
e
> to handle radio_enabled gracefully.
>
> iwlwifi, for instance, turns off the radio but then is unable to fulf=
il
> any configuration requests coming in while the radio is disabled.
>
> The same is true, if I remember correctly what Ivo told me, for rt2x0=
0.
>
> It is not true for b43/legacy, for example, which leaves the MAC runn=
ing
> and thus can configure everything even if the radio is disabled.
> Similarly for Atheros hw, I think.
>
> Now, if we're going to use radio_enabled more, I wonder whether we
> should completely deconfigure the hardware when we want to turn off
> radio_enabled, and then completely reconfigure it once we enable the
> radio again.
>
> Pros:
> =A0* configures all hardware correctly without the driver needing to =
do
> =A0 everything by itself
> =A0* works with all hardware for sure
>
> Cons:
> =A0* higher latency
>
> Also, sometimes we may want to disable the radio for just short perio=
ds
> of time, I think, for regulatory compliance? 11h or so? How's that
> handled, or rather supposed to be?
>
> johannes
>

In my opinion, the driver should be able to specify whether it can
handle configuration-while-down correctly or not. Drivers that don't
report as being able to do this should be configuration-cycled.

--G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
