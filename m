Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35927 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbbIHJV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 05:21:26 -0400
Received: by wicgb1 with SMTP id gb1so70079811wic.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 02:21:25 -0700 (PDT)
Subject: Re: Using ath5k/ath9k radio for constant-tx noise source.
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <55D4D406.5000603@candelatech.com>
From: Nick Kossifidis <mickflemm@gmail.com>
Message-ID: <55EEA8A5.3010809@gmail.com> (sfid-20150908_112130_284202_4AF0F9D3)
Date: Tue, 8 Sep 2015 12:21:41 +0300
MIME-Version: 1.0
In-Reply-To: <55D4D406.5000603@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/19/15 10:07 PM, Ben Greear wrote:
> I have a commercial AP that is using a CM9 ath5k radio (evidently, I
> could be wrong)
> and it has the ability to do a constant transmit of raw noise (RF
> probe shows
> noise, but a monitor-port sniffer does not see any frames from the CM9).
>
> I don't know the low-level details of how it is doing this, but I suspect
> it is using something like madwifi for a driver.
>
> Does anyone know how this can be done with modern software and
> ath5k or ath9k NICs?
>
> Thanks,
> Ben
>
Maybe TX99 mode on ath9k is what you are looking for (ath5k hw can also
do this but there is no driver support for it, madwifi and the old HAL
has support for it but there was no interest on porting it to ath5k).

Regards
Nick
