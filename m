Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:45138 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab0INOor (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:44:47 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 07:44:41 -0700
Date: Tue, 14 Sep 2010 20:14:31 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
Message-ID: <20100914144431.GC27234@vasanth-laptop>
References: <4C8A8FF8.4030900@candelatech.com> <20100913121428.GA15567@vasanth-laptop> <4C8E7A31.70600@candelatech.com> <20100914134613.GB27234@vasanth-laptop> <4C8F893A.8090203@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C8F893A.8090203@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 08:09:54PM +0530, Ben Greear wrote:
> On 09/14/2010 06:46 AM, Vasanthakumar Thiagarajan wrote:
> > On Tue, Sep 14, 2010 at 12:53:29AM +0530, Ben Greear wrote:
> >> Any suggestions for fixing the bssid mask setting in ath_opmode_init?
> >> My change, appears to work because it's set in ath9k_add_interface, even
> >> if not in the ath_opmode_init method.
> >
> > checking for ah->hw in ath_opmode_init() is buggy. bssid mask
> > configuration from ath9k_add_interface() may not work well when
> > some of the other vifs are in down state, may be this needs to
> > be in ath_opmode_init() without that incorrect check.
> 
> It seems we need the ah->hw object to get the list of interfaces, but
> ah->hw is NULL in ath_opmode_init.  Is there another way to get the
> list of interfaces so we can iterate over them to build the ssid mask?

common->hw.
