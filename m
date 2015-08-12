Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798AbbHLJBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 05:01:10 -0400
Date: Wed, 12 Aug 2015 11:00:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: helmut.schaa@googlemail.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: adjust EEPROM_SIZE for rt2500usb
Message-ID: <20150812090023.GA1862@redhat.com> (sfid-20150812_110118_222758_DD741A68)
References: <1439245553-2840-1-git-send-email-adrien+dev@schischi.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439245553-2840-1-git-send-email-adrien+dev@schischi.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 11, 2015 at 12:25:53AM +0200, Adrien Schildknecht wrote:
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

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
