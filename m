Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34795 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbHRGFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 02:05:24 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rt2x00: adjust EEPROM_SIZE for rt2500usb
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1439245553-2840-1-git-send-email-adrien+dev@schischi.me>
To: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adrien Schildknecht <adrien+dev@schischi.me>
Message-Id: <20150818060523.707B1140394@smtp.codeaurora.org> (sfid-20150818_080544_315914_4CA382E8)
Date: Tue, 18 Aug 2015 06:05:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> rt2500usb_validate_eeprom() read data up to 0x6e (EEPROM_CALIBRATE_OFFSET)
> but only 0x6a bytes has been allocated and read from the eeprom.
> 
> This lead to out-of-bound accesses and invalid values for
> EEPROM_BBPTUNE_R17 and EEPROM_CALIBRATE_OFFSET.
> 
> Change the EEPROM_SIZE to 0x6e in order to retrieve all the fields.
> 
> Tested with a rt2570 device.
> 
> Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
