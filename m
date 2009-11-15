Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:19755 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZKONiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 08:38:04 -0500
Received: by ey-out-2122.google.com with SMTP id 9so1614988eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 05:38:09 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Fix BUG on rt2800usb when trying to read eFuse EEPROM.
Date: Sun, 15 Nov 2009 14:09:38 +0100
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1258226436-4673-1-git-send-email-gwingerde@gmail.com> <1258226436-4673-3-git-send-email-gwingerde@gmail.com> <200911142035.02611.IvDoorn@gmail.com>
In-Reply-To: <200911142035.02611.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911151409.38444.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 14 November 2009 20:35:02 Ivo van Doorn wrote:
> On Saturday 14 November 2009, Gertjan van Wingerde wrote:
> > Current tree hits a BUG_ON in rt2x00_regbusy_read, because the eFuse EEPROM
> > reading code of rt2800lib uses the function without the csr_mutex locked.
> > 
> > Fix this by locking the csr_mutex for the of the EEPROM reading cycly and
> > using the _lock variants of the register reading and writing functions.
> > 
> > This also introcudes the register_read_lock function pointer in the
> > rt2800_ops structure.
> > 
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

FWIW both patches are in rt2800 tree now.

Thanks.
-- 
Bartlomiej Zolnierkiewicz
