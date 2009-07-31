Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35606 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGaSZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:25:31 -0400
Received: by ewy10 with SMTP id 10so1710506ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:25:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com>
References: <20090731181020.GE7963@makis>
	 <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com>
Date: Fri, 31 Jul 2009 21:25:31 +0300
Message-ID: <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/31 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Fri, Jul 31, 2009 at 11:10 AM, Nick
> Kossifidis<mick@madwifi-project.org> wrote:
>>  * Get rid of calibration timer, instead use a software interrupt
>>   to schedule the calibration tasklet.
>
> An example of itemizing one change. Explain the why, not the how.
>

We 've discussed this with various people on wireless summit.

a) We don't need a timer for this, there is no need for accuracy
    even with round_jiffies i think this is a waste of resources.
    Also we don't need to run calibration if we are idle (no interrupts).

b) When we add ANI support we 'll just extend the poll function
    and calibration tasklet and handle all periodic phy calibration
    on one place (much cleaner).

c) Having calibration on a tasklet is better since during calibration
    we can't transmit or receive (antennas are detached to measure
    noise floor), previously calibration could run in parallel with tx/rx
    and interfere (packet loss).

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
