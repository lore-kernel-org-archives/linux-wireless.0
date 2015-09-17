Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35121 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbIQRsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 13:48:31 -0400
Received: by obbzf10 with SMTP id zf10so19264387obb.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 10:48:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150916123937.GB2051@localhost>
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	<1440673024-13696-4-git-send-email-me@bobcopeland.com>
	<CAKf6xpsaygeFJyX_LKH2r82P2Xvih1GGBTAspKtCsZbBcVO9Ug@mail.gmail.com>
	<20150829222531.GA8604@localhost>
	<CAEFj987gvasYnRq8tiFeQitbBmoXAr77hXU2cUW_TsH+viUn8g@mail.gmail.com>
	<20150916123937.GB2051@localhost>
Date: Fri, 18 Sep 2015 01:48:30 +0800
Message-ID: <CAEFj986tjgK-=eBaoR3G8m7wf0m32WLutRypPzMfjj2+MW5ybw@mail.gmail.com> (sfid-20150917_194835_066862_2739B19E)
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jason Andryuk <jandryuk@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Bob

I have also tested with nwifi mode for non-secured mesh. It seems to
be worked for me with the following two test scenarios:

Node 1 [ath10k] <---> Node 2 [ath10k] <---> Node 3 [ath10k]
Node 1 [ath10k] <---> Node 2 [ath9k]

I am using the following:
compat-wireless-2015-07-21 from OpenWRT
firmware-5.bin_10.2.4.70.6-2

I just wondering whether using raw wifi is better for encrypted mesh later?

----
Chun-Yeow

On Wed, Sep 16, 2015 at 8:39 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Aug 31, 2015 at 01:43:28AM +0800, Chun-Yeow Yeoh wrote:
>> Hi, Bob
>>
>> > Yes: you don't want to enable raw mode TX / RX decap in the normal
>> > case because it's fairly inefficient compared to "native" wifi mode,
>> > according to my understanding.  The latter doesn't support mesh framing
>> > however.
>> >
>>
>> The native WiFi mode doesn't support mesh framing. Can you elaborate
>> more on this?
>
> Sorry, missed this before -- the 'nwifi' mode which is the normal
> datapath for ath10k discards the QoS header and following mesh header
> when transmitting, if I recall correctly.  I also had some issues with the
> received frames when using nwifi RX decap with raw mode TX, but I don't
> recall exactly the problem.  I can retest with these modes if you really
> want the details.
>
> --
> Bob Copeland %% http://bobcopeland.com/
