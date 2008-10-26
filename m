Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:38537 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYJZQvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 12:51:06 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1670748wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 09:51:05 -0700 (PDT)
Message-ID: <40f31dec0810260951h1f9ec844xf3c7eb520a4dcddd@mail.gmail.com> (sfid-20081026_175120_593432_9AC6409D)
Date: Sun, 26 Oct 2008 18:51:05 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Update interrupt masking code
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
In-Reply-To: <20081026163125.GA15292@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081026031957.GA3090@makis>
	 <20081026163125.GA15292@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/26 Bob Copeland <me@bobcopeland.com>:
> On Sun, Oct 26, 2008 at 05:19:57AM +0200, Nick Kossifidis wrote:
>> +     AR5K_INT_QCBRURN =      0x20000000, /* Non common */
>
> Are you sure about the values? ar5212reg.h from legacy-hal has:
>
> #define AR_ISR_QCBRURN                  0x04000000 /* QCU CBR underrun
> interrupt */
> [...]
> #define AR_IMR_QCBRURN                  0x04000000 /* QCU CBR underrun
> interrupt */
>

Check out set_imr/get_isr AR5K_INT_* are for the driver part (ath5k.h)
and values marked as "non common" are mapped to chip-specific values
(AR5K_IMR_*/AR5K_ISR_*) (reg.h).

>>  #define      AR5K_TXNOFRM_QCU        0x000ffc00
>> +#define      AR5K_TXNOFRM_QCU_S      9
>
> 10? :)
>

Yup, i missed that one ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
