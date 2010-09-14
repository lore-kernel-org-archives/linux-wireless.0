Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36028 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab0INOkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:40:03 -0400
Message-ID: <4C8F893A.8090203@candelatech.com>
Date: Tue, 14 Sep 2010 07:39:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@Atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
References: <4C8A8FF8.4030900@candelatech.com> <20100913121428.GA15567@vasanth-laptop> <4C8E7A31.70600@candelatech.com> <20100914134613.GB27234@vasanth-laptop>
In-Reply-To: <20100914134613.GB27234@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 06:46 AM, Vasanthakumar Thiagarajan wrote:
> On Tue, Sep 14, 2010 at 12:53:29AM +0530, Ben Greear wrote:
>> Any suggestions for fixing the bssid mask setting in ath_opmode_init?
>> My change, appears to work because it's set in ath9k_add_interface, even
>> if not in the ath_opmode_init method.
>
> checking for ah->hw in ath_opmode_init() is buggy. bssid mask
> configuration from ath9k_add_interface() may not work well when
> some of the other vifs are in down state, may be this needs to
> be in ath_opmode_init() without that incorrect check.

It seems we need the ah->hw object to get the list of interfaces, but
ah->hw is NULL in ath_opmode_init.  Is there another way to get the
list of interfaces so we can iterate over them to build the ssid mask?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
