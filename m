Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55766 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753478AbeBGK4A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 05:56:00 -0500
Message-ID: <1518000956.3124.7.camel@sipsolutions.net> (sfid-20180207_115605_475824_AD589D79)
Subject: Re: [PATCH] ath9k: break out of irq handler after 5 jiffies
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, greearb@candelatech.com,
        linux-wireless@vger.kernel.org
Date: Wed, 07 Feb 2018 11:55:56 +0100
In-Reply-To: <2129dcdd-5963-c4da-600e-83f8c394d05c@nbd.name> (sfid-20180207_101620_619144_72639A58)
References: <1517958324-13536-1-git-send-email-greearb@candelatech.com>
         <2129dcdd-5963-c4da-600e-83f8c394d05c@nbd.name>
         (sfid-20180207_101620_619144_72639A58)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-02-07 at 10:16 +0100, Felix Fietkau wrote:
> On 2018-02-07 00:05, greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > In case where the system is sluggish, we should probably break out
> > early.  Maybe this will fix issues where the OS thinks the IRQ handler
> > is not responding and disables the IRQ because 'nobody cared'
> > 
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> 5 jiffies as a hardcoded value is a bad idea, since it produces
> different behavior based on CONFIG_HZ.

Also, err, NAPI? Or is something else is going on here?

johannes
