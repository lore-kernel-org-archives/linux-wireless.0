Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33140 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab0F3WiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 18:38:13 -0400
Received: by iwn7 with SMTP id 7so1342605iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jun 2010 15:38:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277935351.17170.1.camel@mj>
References: <4C2A8AD4.8070504@openwrt.org>
	<1277935351.17170.1.camel@mj>
Date: Thu, 1 Jul 2010 00:38:12 +0200
Message-ID: <AANLkTim8NrVZfcJGi4NK_OhXBxEY0Lw9fdg1bcbzDU0X@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix TSF after reset on AR913x
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Pavel Roskin <proski@gnu.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 1, 2010 at 12:02 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2010-06-30 at 02:07 +0200, Felix Fietkau wrote:
>> +     if (AR_SREV_9100(ah) && (ath9k_hw_gettsf64(ah) < tsf)) {
>> +             tsf += 1500;
>
> Why 1500?  Is it a magic number?  It is a result of some measurement?
> Can we have a define for it, please?

Does the TSF always start counting from zero when the chip is reset?
In that case maybe the "magic number" can be replaced with the return
value from ath9k_hw_gettsf64() (which we call anyway).

/Björn
