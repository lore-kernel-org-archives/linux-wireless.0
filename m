Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58033 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZKTUc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:32:27 -0500
Received: by ewy19 with SMTP id 19so175015ewy.21
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 12:32:32 -0800 (PST)
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] p54: software hot-swap eeprom image
References: <200911202027.13284.chunkeey@googlemail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 20 Nov 2009 22:24:27 +0200
In-Reply-To: <200911202027.13284.chunkeey@googlemail.com> (Christian Lamparter's message of "Fri\, 20 Nov 2009 20\:27\:13 +0100")
Message-ID: <87y6m1aqro.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> This (aggregated) patch adds a new sysfs file "eeprom_overwrite"
> which can be used to upload an customized eeprom image to the
> driver during normal operation.
>
> The old wlanX device will quickly vanish. And if the new EEPROM
> image passes all sanity checks the device will reappear.
>
> Hopefully, this proves to be an adequate solution for everyone
> with a bad/missing EEPROM data/chip.

Wasn't the concensus that request_firmware() will be used for this
kind of device specific data? stlc45xx had a similar sysfs interface
and people didn't like it. And I tend to agree with them, adding odd
sysfs files is not the best way to handle this.

-- 
Kalle Valo
