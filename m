Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:4143 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYKEQcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 11:32:41 -0500
Received: by yw-out-2324.google.com with SMTP id 9so44704ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 08:32:39 -0800 (PST)
Message-ID: <40f31dec0811050832m522c57d1vc2b16fcbceff18dc@mail.gmail.com> (sfid-20081105_173246_101507_D2A1A997)
Date: Wed, 5 Nov 2008 18:32:39 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: enable RXing beacons
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0811021810w229d1d9al2b27bdf4144cde69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
	 <1225676353.13684.2.camel@localhost.localdomain>
	 <b6c5339f0811021810w229d1d9al2b27bdf4144cde69@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/3 Bob Copeland <me@bobcopeland.com>:
>
> Sorry, my fault, this was a direct result of
> 60c7e22196fb4230b76db1f5fb283e811b8f3fb3 "ath5k: honor
> FIF_BCN_PRBRESP_PROMISC."  The problem remains that we have too many
> interrupts though if PRBRESP_PROMISC is not set.  IIRC my patch made
> ath5k behave same as ath9k.  Any ideas on a proper fix?
>

How about setting enhanced sleep timers on AR5212+ chips ?
Right now we don't handle this on beacon_init...

1602 /*
1603  * First enhanced sleep register
1604  */
1605 #define AR5K_SLEEP0                     0x80d4
/* Register Address */
1606 #define AR5K_SLEEP0_NEXT_DTIM           0x0007ffff      /* Mask
for next DTIM (?) */
1607 #define AR5K_SLEEP0_NEXT_DTIM_S         0
1608 #define AR5K_SLEEP0_ASSUME_DTIM         0x00080000      /* Assume DTIM */
1609 #define AR5K_SLEEP0_ENH_SLEEP_EN        0x00100000      /* Enable
enchanced sleep control */
1610 #define AR5K_SLEEP0_CABTO               0xff000000      /* Mask
for CAB Time Out */
1611 #define AR5K_SLEEP0_CABTO_S             24
1612
1613 /*
1614  * Second enhanced sleep register
1615  */
1616 #define AR5K_SLEEP1                     0x80d8
/* Register Address */
1617 #define AR5K_SLEEP1_NEXT_TIM            0x0007ffff      /* Mask
for next TIM (?) */
1618 #define AR5K_SLEEP1_NEXT_TIM_S          0
1619 #define AR5K_SLEEP1_BEACON_TO           0xff000000      /* Mask
for Beacon Time Out */
1620 #define AR5K_SLEEP1_BEACON_TO_S         24
1621
1622 /*
1623  * Third enhanced sleep register
1624  */
1625 #define AR5K_SLEEP2                     0x80dc
/* Register Address */
1626 #define AR5K_SLEEP2_TIM_PER             0x0000ffff      /* Mask
for TIM period (?) */
1627 #define AR5K_SLEEP2_TIM_PER_S           0
1628 #define AR5K_SLEEP2_DTIM_PER            0xffff0000      /* Mask
for DTIM period (?) */
1629 #define AR5K_SLEEP2_DTIM_PER_S          16

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
