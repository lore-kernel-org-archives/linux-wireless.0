Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39503 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab1GNNSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 09:18:17 -0400
Received: by ewy4 with SMTP id 4so133319ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 06:18:16 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: carl9170 firmware: WoWLAN and adding fields to carl9170_tx_superdesc
Date: Thu, 14 Jul 2011 15:18:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <20110714122803.GA31692@zenon.in.qult.net>
In-Reply-To: <20110714122803.GA31692@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107141518.03757.chunkeey@googlemail.com> (sfid-20110714_151821_209666_572B4D69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, July 14, 2011 02:28:03 PM Ignacy Gawedzki wrote:
> Hi,
> 
> I'm still working on an extension of the carl9170 firmware to enable TX
> service time measurements.  This implies the addition of a u32 field to
> carl9170_tx_superdesc to record the TSF value at the time the frame is
> received by the firmware.
> 
> The problem with WoWLAN, more specifically with changes introduced by
> af915846d44d23adc02c7ded807282d607b46faa, is that adding that field makes
> carl9170_sram_reserved::cmd larger than CARL9170_MAX_CMD_LEN.
> 
> I still don't see an easy way out other than disabling WoWLAN altogether.
> If anyone has any suggestion, I'd be happy to read it.
Well, I think there's enough space in the rsp [fw->driver] buffer.
After all in WoWLAN mode, this buffer will be unused as well?

> BTW, I noticed something that may be a bug in wlan.c, in
> wlan_wol_connection_monitor(void)'s definition:
> 
>   memset(nullf, 0, sizeof(nullf));
> 
> Shouldn't that be
> 
>   memset(nullf, 0, sizeof *nullf);
> 
> instead?
Yes it should be. Thanks [fix pushed].

Regards,
	Chr
