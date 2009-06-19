Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:62338 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbZFSRmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 13:42:20 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1057696ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 10:42:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0906191019ve40014dp98af5ada875e2a24@mail.gmail.com>
References: <4A3B5B11.7060103@bitnet.be>
	 <45e8e6c40906191000i2e74e06btee7313c5c30bc6a2@mail.gmail.com>
	 <b6c5339f0906191019ve40014dp98af5ada875e2a24@mail.gmail.com>
Date: Fri, 19 Jun 2009 10:42:22 -0700
Message-ID: <45e8e6c40906191042k5c96d3a6wff85358da22a7b92@mail.gmail.com>
Subject: Re: current status of 802.11s mesh in ath5k ?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Hans Maes <Hans@bitnet.be>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 10:19 AM, Bob Copeland<me@bobcopeland.com> wrote:
> On Fri, Jun 19, 2009 at 1:00 PM, Andrey Yurovsky<andrey@cozybit.com> wrote:
>> You'll want wireless-testing (or the latest compat), after commit
>> 41ba08509.  However ath5k will not beacon until you issue a scan due
>> to a bug.
>
> By the way, I imagine this is a side effect of calling ath5k_beacon_config
> inside ath5k_reset().  If so, we probably want to call it at the
> appropriate time when the interface is brought up.

That sounds like it's on the right track, also there's a similar issue
with rt2x00.

> I have been working on a patch to rework the beaconing, namely using
> bss_conf->enable_beacon and calling beacon_config whenever the beacon
> interval or beacon changes, that might fix it but I'm not too familiar
> with mesh details to say.

'looking forward to that patch.  From the driver side, there's not
much difference between mesh beaconing and AP or IBSS beaconing.  The
mesh-specific requirements are listed on the driver API page:
http://wireless.kernel.org/en/developers/Documentation/mac80211/API --
if there's something we missed there, I'll be happy to edit it.

  -Andrey
