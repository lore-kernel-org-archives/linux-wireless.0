Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50941 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab0GAAro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 20:47:44 -0400
Message-ID: <4C2BE5A8.9030003@openwrt.org>
Date: Thu, 01 Jul 2010 02:47:36 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix TSF after reset on AR913x
References: <4C2A8AD4.8070504@openwrt.org>	<1277935351.17170.1.camel@mj> <AANLkTim8NrVZfcJGi4NK_OhXBxEY0Lw9fdg1bcbzDU0X@mail.gmail.com>
In-Reply-To: <AANLkTim8NrVZfcJGi4NK_OhXBxEY0Lw9fdg1bcbzDU0X@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-01 12:38 AM, Björn Smedman wrote:
> On Thu, Jul 1, 2010 at 12:02 AM, Pavel Roskin <proski@gnu.org> wrote:
>> On Wed, 2010-06-30 at 02:07 +0200, Felix Fietkau wrote:
>>> +     if (AR_SREV_9100(ah) && (ath9k_hw_gettsf64(ah) < tsf)) {
>>> +             tsf += 1500;
>>
>> Why 1500?  Is it a magic number?  It is a result of some measurement?
>> Can we have a define for it, please?
> 
> Does the TSF always start counting from zero when the chip is reset?
> In that case maybe the "magic number" can be replaced with the return
> value from ath9k_hw_gettsf64() (which we call anyway).
No, the TSF value at this point is not accurate. It differs
semi-randomly by a few orders of magnitude from the time measured by the
CPU timer. The value I put in above is just an approximation, but since
making it completely accurate is impossible, I figured this is good
enough, especially since the value will most likely not deviate much
from what I've measured here.

- Felix
