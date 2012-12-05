Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52257 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab2LEUpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:45:31 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so3266255wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 12:45:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354612418-6644-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1354612418-6644-1-git-send-email-rmanohar@qca.qualcomm.com>
Date: Wed, 5 Dec 2012 12:39:00 -0800
Message-ID: <CAJ-VmonMu=98Viwk1qvR-NGrO-qBx2KYT551xaO1KjHEz4Kt3A@mail.gmail.com> (sfid-20121205_214535_449957_6B5CE15E)
Subject: Re: [PATCH] qca-swiss-army-knife: Add support to dump AR9003 chips EEPROM
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: rodrigue@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a general comment - wouldn't it be cleaner to have the PCI IDs
and the EEPROM definitions pulled from the ath9k driver source or a
separate header file, so you don't run the risk of having definitions
"drift" slightly?

I doubt that anyone is going to change the cal data format or the
default templates very often (or at all!), but .. just having those
definitions duplicated feels wrong to me.

I have EEPROM dump/parse utilities in FreeBSD, but I pull the EEPROM
structure definitions out of the HAL code so I only have them defined
in one place.

2c,


Adrian
