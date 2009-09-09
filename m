Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:46311 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZIINAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 09:00:32 -0400
Received: by yxe5 with SMTP id 5so7340877yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 06:00:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA69A0D.3040608@redfish-solutions.com>
References: <4AA69A0D.3040608@redfish-solutions.com>
Date: Wed, 9 Sep 2009 09:00:34 -0400
Message-ID: <b6c5339f0909090600o267ae376o432cb36b912b7c2a@mail.gmail.com>
Subject: Re: AP: ath5k + hostapd occasionally sulks
From: Bob Copeland <me@bobcopeland.com>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>,
	jon.fairbairn@cl.cam.ac.uk
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 8, 2009 at 1:53 PM, Philip Prindeville
<philipp_subx@redfish-solutions.com> wrote:
> I pulled compat-wireless from GIT last night (or about 1:30am mountain,
> really) and rebuilt a 2.6.27.29 kernel.
>
> I'm seeing a lot of:
>
> Sep  8 11:44:09 pbx user.err kernel: ath5k phy0: no further txbuf available, dropping packet
>
>
> one every 10 seconds, in fact.  This is with an Engenius EMP-8062+ card:

Ok, the timing information is useful.  This is probably something (beacon
sending?) racing with the periodic calibration, which temporarily stops
all of the tx traffic and frees the tx buffers, then starts it all up
again.  In short, apart from the logging this shouldn't cause any
problems, but we should probably disable the beacon tasklet during this
time.

If this only appeared all of a sudden in recent compat snapshots, it
would be useful to know the last one that worked normally.

> I'll probably have to reboot regularly, since this is on an embedded box
> with limited CF filesystem, and I can't overflow my /var partition...

Ouch.  For now, just take it out or demote it to debug.

As for the original problem, I don't know offhand why a large download
would trigger a cascade of these errors.  The best way to track it down
is to try to come up with a case that reproduces it and sprinkle printks
throughout the driver, especially when we free and allocate the tx
buffers.

-- 
Bob Copeland %% www.bobcopeland.com
