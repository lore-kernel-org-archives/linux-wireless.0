Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62660 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab0INWsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 18:48:31 -0400
Received: by iwn5 with SMTP id 5so6435964iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 15:48:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
Date: Wed, 15 Sep 2010 01:48:30 +0300
Message-ID: <AANLkTi==HEkmY4TR=r+4Ymk_55fBORmRgF+SFGQzK750@mail.gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Steve Glass <stevie.glass@gmail.com>,
	Wee Lum Tan <weelum.tan@nicta.com.au>,
	Marius Portmann <marius@itee.uq.edu.au>,
	Konstanty Bialkowski <konstanty@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/14 Jonathan Guerin <jonathan@guerin.id.au>:
> Hi all,
>
> I have some behaviour I'm observing with some Atheros cards we use that
> doesn't seem to match what the initvals of ath5k are set up to. These are
> the cards I used:
> http://www.mini-box.com/s.nl/it.A/id.387/.f
>
> I have run a saturated iPerf flow on a conducted testbed with both stations
> being inside RF-shielding boxes. They are set to 802.11a mode, on channel 1.
> I then parse the trace, looking for ACK-DATA pairs, and calculating the time
> difference between them. From this, I remove the TX_TIME of the DATA frame,
> as well as a DIFS:
>
> ACK_TIMESTAMP + DIFS + CONTENTION_TIME + DATA_TX_TIME = DATA_TIMESTAMP
>
> which will leave me with the CONTENTION_TIME. Dividing this time by a
> SLOT_TIME will give me the slot which was chosen by the hardware.
>
>
> According to the driver, in ath5k.h:
>
> #define AR5K_TUNE_CWMIN                15
>
> CWMIN is initialised to 15.
>
> The actual distribution of contention slots I'm observing resembles this:
>
> Slot Number,Count
> 0,1315
> 1,1302
> 2,1249
> 3,1291
> 4,1347
> 5,1219
> 6,1249
> 7,0
> 8,0
> 9,0
> <truncated>
>
> as well as 1360 frames which came in with a negative CONTENTION_TIME.
>
> Ignoring the fact that some frames are coming up with a negative
> CONTENTION_TIME (which potentially points to another problem), what is being
> observed here is that CW_MIN appears to start at 7, rather than the 15 which
> it should be.
>
> I'm just wondering if anyone would have any idea why this is occurring?
>
> Thanks,
>
> --
> Jonathan Guerin
>

What is your time refference ? Are the 2 stations synced to a point
you can have such great accuracy ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
