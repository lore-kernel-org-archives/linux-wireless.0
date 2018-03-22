Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.44.157]:37234 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbeCVVUc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 17:20:32 -0400
Date: Fri, 23 Mar 2018 08:20:26 +1100
From: James Cameron <quozl@laptop.org>
To: Tyler Gray <graytfg@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi intermittent beacon capture in monitor mode?
Message-ID: <20180322212026.GE27398@us.netrek.org> (sfid-20180322_222035_887545_DECA62C9)
References: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

G'day Tyler,

I've seen that kind of behaviour when there are multiple APs with the
same beacon timing, and one or more APs are not backing off.  In my
case the beacons were colliding.  The times without beacons followed a
regular pattern; based on the variance in CPU oscillator clocks of the
APs.  Cooling or heating an AP changed the pattern.  Behaviour also
varied across cards; RF sensitivity of a batch of cards follows a
statistical normal distribution, with a bit of warping caused by
manufacturing test rejects.

Have you access to a spectrum analyser?  You might check what
transmissions are happening at the same time, on or near 2.457 MHz.

Can you exclude all other APs, e.g. by placing the devices inside a
disconnected microwave oven?

Can you monitor the current of the card with a digital storage
oscilloscope?

Can you watch the beacons with an RF probe and an oscilloscope?

Simplest probe is a diode (axial, bandoleer) with leads cut for a
multiple of 2.457 MHz held in oscilloscope probes within an inch or so
of the card antenna.

With both these last two tests, you may see dips corresponding to
beacon transmissions.  If they stop, you know you have a firmware or
software problem.

-- 
James Cameron
http://quozl.netrek.org/
