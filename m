Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53931 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbZKLTex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:34:53 -0500
Received: by bwz27 with SMTP id 27so2613056bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 11:34:58 -0800 (PST)
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix rt2800lib RF chip programming selection.
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 12 Nov 2009 20:25:55 +0100
MIME-Version: 1.0
Message-Id: <200911122025.55944.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 November 2009 22:59:58 Gertjan van Wingerde wrote:
> Mirror the legacy Ralink driver with respect to rt2800 RF register programming. Execute
> rt2800_config_channel_rt3x for all RF2020, RF3020, RF3021 & RF3022 chipsets when operating on RT3070
> devices.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

checkpatch.pl complains about:

ERROR: trailing whitespace
#27: FILE: drivers/net/wireless/rt2x00/rt2800lib.c:809:
+^Iif (rt2x00_rt(&rt2x00dev->chip, RT3070) &&^I$

ERROR: code indent should use tabs where possible
#28: FILE: drivers/net/wireless/rt2x00/rt2800lib.c:810:
+           (rt2x00_rf(&rt2x00dev->chip, RF2020) ||$

I fixed those while applying patch to rt2800 tree..

[ This was fixed later in "[PATCH v2] rt2x00: Initialize rf302x RF values
  properly for rt2800pci." but we want all patches to be checkpatch.pl
  clean as otherwise it is confusing for people doing automated checking ]
