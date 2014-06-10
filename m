Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:38216 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFJIs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 04:48:28 -0400
Received: by mail-yh0-f41.google.com with SMTP id z6so90090yhz.28
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 01:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <539030ED.4020006@globaledgesoft.com>
References: <539030ED.4020006@globaledgesoft.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Tue, 10 Jun 2014 12:48:07 +0400
Message-ID: <CAHNKnsTUKMxmDK7H=5ndf2zyCX3BChx+Kr70TRVdXxZzj1YFtQ@mail.gmail.com> (sfid-20140610_104833_737485_15B2B08B)
Subject: Re: Physical carrier sensing (CCA)
To: Gaurav Kumar Chauhan <ck.gaurav@globaledgesoft.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2014-06-05 12:57 GMT+04:00 Gaurav Kumar Chauhan <ck.gaurav@globaledgesoft.com>:
> I am working on measuring channel load which requires knowledge of carrier
> sensing.
>
> I am comfortable with virtual carrier sensing but not with physical carrier
> sensing.
> I tried to google it but didn't get more than basics. I want to know about
> physical carrier
> sensing in detail and where code for physical sensing is present.
>
> Is it in driver or in firmware?
> I am using atheros pci-express card and ath9k driver.

Physical and virtual carrier sensing are both realized in hardware at
least in AR9xxx chips. Chip provides some knobs to control both of
them (on/off, setup levels, etc.) and allows retrieve some statistics
(see channel survey code of ath9k driver for example).

-- 
BR,
Sergey
