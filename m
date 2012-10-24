Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53012 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2JXXdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 19:33:47 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so709588pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 16:33:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121024220813.GB6723@shredder>
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
	<CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
	<20121024194547.GA19060@shredder>
	<CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
	<CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com>
	<20121024220813.GB6723@shredder>
Date: Wed, 24 Oct 2012 16:33:46 -0700
Message-ID: <CAJ-VmokGeCLY8pCpL5H0VgznXnB-ob1z_sPaSQUZn0PengSgow@mail.gmail.com> (sfid-20121025_013351_149161_8A377730)
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 October 2012 15:08, Thomas Pedersen <thomas@cozybit.com> wrote:

>> Also, we should check to see whether the MAC is paying attention to
>> any beacon frames
>
> How? For mesh mode support we currently just reuse the WDS AP firmware vif
> opmode.
>
>> and updating _its_ timestamp using that beacon frame timer.  That's
>> one of the mesh-and-sta-and-ap-at-the-same-time problems - in
>> STA mode, the TSF gets fudged based on the AP TSF. In other modes this
>> doesn't necessarily hold.
>
> OK, but the TSF for AP shouldn't be automatically updated on other
> beacons, right?

Right but look at those AP macs, there's multiple overlapping TSFs there, right?

* Each MAC AP has an incrementing TSF;
* Multiple APs have different TSF spaces, they're not synchronised at all;
* There's one RX TSF namespace - if the vif is in AP mode then it's
free-running and not synchronising against any other TSF;
* Thus the above makes sense to me.

So far the beacon frames look correct and they're increasing; you're
not obviously synchronising TSF against anything.

Going back to the original question - you fetch TSF after you receive
the packet, and sometimes the TSF in the frame is greater than the TSF
read back by the ath9k TSF get method.
The ath9k_htc tsf read is just 'tsf = ath9k_hw_gettsf64(priv->ah);',
so it's doing direct register reads. That should be immediate, but
it's USB so it may take a while.

So hm, now you've made me open the ath9k_htc firmware source. I hate you.

Let me look.



Adrian
