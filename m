Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64543 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZEUPFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 11:05:20 -0400
Received: by bwz22 with SMTP id 22so1070420bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 08:05:21 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [WIP PATCH] sdio support for wl12xx
References: <20090518180957.GD2580@hash.localnet>
	<20090519040239.GA12911@hash.localnet> <877i0begt7.fsf@litku.valot.fi>
	<b6c5339f0905201223n4c8c4811h25a397e69a642c2a@mail.gmail.com>
	<87d4a2wli2.fsf@litku.valot.fi>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 21 May 2009 18:05:19 +0300
In-Reply-To: <87d4a2wli2.fsf@litku.valot.fi> (Kalle Valo's message of "Thu\, 21 May 2009 17\:58\:45 +0300")
Message-ID: <878wkqwl74.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

>> I get all zeros from spad2 and spad3 so it's not working with just the
>> above...
>
> Not good. Can you somehow check if Google stores the NVS file to the
> chip or somewhere else?

I'm guessing that the struct below is used for providing the NVS file
from user space. Not sure, though.

/* TIWLN_SET_INIT_INFO request parameter
 */
typedef struct
{
  tiUINT32 eeprom_image_length;
  tiUINT32 firmware_image_length;
  tiUINT32 init_file_length;
  /* eeprom image follows */
  char data[1];
  /* firmware image follows */
  /* init file follows */
} tiwlan_dev_init_t;

http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=blob;f=sta_dk_4_0_4_32/pform/common/inc/linux_ioctl_common.h;h=8194f9e234a26591e87e65f5606cb934d53fd117;hb=HEAD#l65

-- 
Kalle Valo
