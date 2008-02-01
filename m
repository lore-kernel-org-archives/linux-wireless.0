Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:15335 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966AbYBAMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:27 -0500
Received: by an-out-0708.google.com with SMTP id d31so261593and.103
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 04:09:26 -0800 (PST)
Message-ID: <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com> (sfid-20080201_120934_448863_13CB4E5D)
Date: Fri, 1 Feb 2008 14:09:26 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: ath5k: reset for 5424-based card
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080201040358.GA13428@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080131155901.GA7997@hash.localnet>
	 <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com>
	 <20080201040358.GA13428@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/1, Bob Copeland <me@bobcopeland.com>:
> On Thu, Jan 31, 2008 at 06:56:51PM +0200, Nick Kossifidis wrote:
> > Can you plz run ath_info tool found on madwifi-trace branch and post
> > the output (mac/phy revision) ?
>
> Sure -- full output is at http://bobcopeland.com/ath5k/ along with
> EEPROM dump and a scan of my neighborhood.
>
> MAC Version:  2424  (0xa0)
> MAC Revision: 5424  (0xa3)
> Warning: Invalid EEPROM Magic number!
> Device type:  3
> 5Ghz PHY Revision: SChip (0xa2)
> 2Ghz PHY Revision: SChip (0xa2)
>
> > so i left it for the patch series i'm working on). If you got your
> > card scanning then we are really close on fixing it !
>
> Excellent news!
>
> > Another important question, what band was the ap on ?
>
> Good question - it was a Starbucks hotspot so I'm guessing 802.11b?
>

Wow that's the first 5424 report we have ;-)

Do you have an AP so you can run the testbed-trace as described here ?
http://madwifi.org/wiki/DevDocs/MadwifiTrace

b/g modes are ok for start (you can force mode from the sta using
iwpriv ath0 mode X, x=1(a) 2(b) 3(g)) but if you can also provide
dumps for a and turbo modes it would be really cool (you 'll need an
atheros-based ap for the turbo mode to run testbed-trace, if you don't
have such ap then you can try to setup your card as AP for a and
turboa modes -static turbo-, dumps from ap operation will also do,
just make sure you force the mode through iwpriv).

If you provide me with the needed dumps i'll work on it and give you a
tarball to test asap (asap > 10days due to exams ;-( ) !!!

One more question: can you plz describe card's behaviour with ath5k ?
What error message does it return on reset-failure ?

Thanx a lot for the feedback ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
