Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35540 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbIPMkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 08:40:05 -0400
Received: by igbkq10 with SMTP id kq10so33706374igb.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 05:40:03 -0700 (PDT)
Date: Wed, 16 Sep 2015 08:39:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Jason Andryuk <jandryuk@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
Message-ID: <20150916123937.GB2051@localhost> (sfid-20150916_144010_163103_D0C0F31D)
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
 <1440673024-13696-4-git-send-email-me@bobcopeland.com>
 <CAKf6xpsaygeFJyX_LKH2r82P2Xvih1GGBTAspKtCsZbBcVO9Ug@mail.gmail.com>
 <20150829222531.GA8604@localhost>
 <CAEFj987gvasYnRq8tiFeQitbBmoXAr77hXU2cUW_TsH+viUn8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEFj987gvasYnRq8tiFeQitbBmoXAr77hXU2cUW_TsH+viUn8g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2015 at 01:43:28AM +0800, Chun-Yeow Yeoh wrote:
> Hi, Bob
> 
> > Yes: you don't want to enable raw mode TX / RX decap in the normal
> > case because it's fairly inefficient compared to "native" wifi mode,
> > according to my understanding.  The latter doesn't support mesh framing
> > however.
> >
> 
> The native WiFi mode doesn't support mesh framing. Can you elaborate
> more on this?

Sorry, missed this before -- the 'nwifi' mode which is the normal
datapath for ath10k discards the QoS header and following mesh header
when transmitting, if I recall correctly.  I also had some issues with the
received frames when using nwifi RX decap with raw mode TX, but I don't
recall exactly the problem.  I can retest with these modes if you really
want the details.

-- 
Bob Copeland %% http://bobcopeland.com/
