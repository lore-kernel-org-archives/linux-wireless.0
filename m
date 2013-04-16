Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:57799 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3DPM0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 08:26:41 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm19so125532bkc.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 05:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000601ce39de$b26e2950$174a7bf0$@acksys.fr>
References: <000601ce39de$b26e2950$174a7bf0$@acksys.fr>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 16 Apr 2013 14:26:19 +0200
Message-ID: <CAG6hwVNbQ4uJynkcOGi+Pqi7c2tbExyuJENBogLwnJKOwBDtFw@mail.gmail.com> (sfid-20130416_142645_629296_00F05D58)
Subject: Re: mesh questions/suggestion about airtime metric and device
 constant in mesh_hwmp.c
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
Cc: linux-wireless@vger.kernel.org,
	open11s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ o11s-devel

On Mon, Apr 15, 2013 at 3:39 PM, Jean-Pierre Tosoni <jp.tosoni@acksys.fr> wrote:
> Hi all,
>
> The airtime_link_metric_get()  function follows closely section 13.9 of the
> standard, except for the "channel access overhead" which is said to depend
> on the PHY, headers, etc.
> Hence I understand that a complete implementation is not trivial.
>
> The 'device_constant' variable is given the constant value '1<<ARITH_SHIFT',
> which means 1 microsecond if I am correct. But the smallest possible

The airtime is in units of 0.01TU, so a device_constant of 1 is more like 10us.

> duration for the PPDU header is 20 microseconds in non-HT or 24 us in HT, as
> shown in section 20.3.2
>
> For the test frame of 8192 bits, say at 300Mbps (MCS15), Bt/r = the
> currently computed airtime is 28 instead of 51, underevaluated by -45% !
> Since the value accumulates on the mesh path, it may make a big difference
> for the path selection.

Since O (channel access overhead) is constant, changing it just scales
the metric equally across all links, so I'm not sure what difference
this would make?

Getting device_constant as a function of current protection parameters
and channel type (ie. actual channel access overhead) however, makes
sense.

> Questions:
> Even if device_constant is kept as a constant, shouldn't we set it to
> something more realistic, like 20 or 24 ?
> (I mean 20<<ARITH_SHIFT)
> Does the standard really mean to include the PPDU header ?
>
> (By the way, I understand that this value should also include the DIFS, and
> maybe the ACK, so it should be much greater than 20)

-- 
Thomas
