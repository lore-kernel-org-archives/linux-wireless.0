Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39986 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZHANb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 09:31:28 -0400
Received: by ewy10 with SMTP id 10so2074266ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 06:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090801132253.GB15971@hash.localnet>
References: <20090731181020.GE7963@makis>
	 <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com>
	 <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com>
	 <b6c5339f0907311211w4d810b23uc6ec8027924da647@mail.gmail.com>
	 <40f31dec0907311252n76adfde7kb9f34bf8c6baf34c@mail.gmail.com>
	 <20090801132253.GB15971@hash.localnet>
Date: Sat, 1 Aug 2009 16:31:27 +0300
Message-ID: <40f31dec0908010631x84ddfcap99a871f3513cf22b@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/1 Bob Copeland <me@bobcopeland.com>:
> On Fri, Jul 31, 2009 at 10:52:42PM +0300, Nick Kossifidis wrote:
>> > make the above true it needs to stop the queues etc when doing
>> > calibration.
>>
>> ACK, how do we do that ?
>> ieee80211_stop_queues / ieee80211_wake_queues
>
> Yup.  And disabling (at least rx and swba) interrupts on the device
> is also probably a good idea.
>

I thought about calling ath5k_hw_stop_rx_pcu but i don't think it's
necessary i mean it won't receive anyway, why mess with pcu ?



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
