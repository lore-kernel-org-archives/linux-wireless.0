Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62788 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbcFDUZf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 16:25:35 -0400
Subject: Re: ath9k_htc firmware
To: bruce m beach <brucembeach@gmail.com>
References: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
 <57526D1D.9000305@gmx.net>
 <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com>
Cc: ath9k-devel@lists.ath9k.org, ath9k_htc_fw@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: Oleksij Rempel <fishor@gmx.net>
Message-ID: <5753391F.7030200@gmx.net> (sfid-20160604_222539_254694_05A689B2)
Date: Sat, 4 Jun 2016 22:25:03 +0200
MIME-Version: 1.0
In-Reply-To: <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 04.06.2016 um 21:44 schrieb bruce m beach:
>>> I'm looking for some kind of simple request in the ath9k_htc driver, through
>>> the usb ep0, like a memory read on the card, where a urb is sent with
>>> the resulting chain of events. The simpler the better. The simplest.
> 
>> For EP0 on drivers site:
>> static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>> {
>> int transfer, err;
>> const void *data = hif_dev->fw_data;
>> size_t len = hif_dev->fw_size;
>> u32 addr = AR9271_FIRMWARE;
>> u8 *buf = kzalloc(4096, GFP_KERNEL);
>> u32 firm_offset;
>> ...
> 
>   What about the code for setting and resetting leds ???
> 
> Bruce
> 


It is EP3/EP4 and it is not working without firmware.
Here is one example how you can add new command to firmware:
https://github.com/olerem/open-ath9k-htc-firmware/commit/c73c159303e30a28e2d3dc05ba0d2d15504e5fad


And for kernel driver:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8badb50cfab6d433622dbfd5a90b6adf27333107

