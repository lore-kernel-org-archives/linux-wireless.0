Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53601 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab2K2TeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 14:34:00 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so6700597wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2012 11:33:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354108113.9345.23.camel@jlt4.sipsolutions.net>
References: <1353702198-12865-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
 <1354108113.9345.23.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 29 Nov 2012 11:33:37 -0800
Message-ID: <CAG6hwVNnfxJXQAh8=NZjqT2rU1akm_S1XY+qatHBfFE7k40e9w@mail.gmail.com> (sfid-20121129_203403_913502_5326398B)
Subject: Re: [PATCH] mac80211: fix for mesh sync to indicate TBTT adjustment
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	javier@cozybit.com, ashok@cozybit.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2012 at 5:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-11-23 at 12:23 -0800, Marco Porsch wrote:
>> Currently the mesh sync code checks, whether peers indicate TBTT adjustment,
>> but it never sets the corresponding flag itself.
>>
>> By setting ifmsh->tbtt_adjusting to true, it will set the corresponding field
>> in the mesh configuration IE of own beacons.
>> This indication will be set in the current beacon. The TBTT adjustment will be
>> performed afterwards, affecting the next beacon. Thus, the first beacon with
>> stable TBTT will not indicate adjustment anymore and peers will continue
>> tracking the new offset.
>
> Ping mesh folks, does this look sane?

Looks fine. The only effect (as Marco mentioned) is that the
"adjusting tbtt" bit is advertised correctly in the mesh config IE.

Thomas
