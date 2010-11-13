Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47580 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab0KMBYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:24:12 -0500
Received: by gwj17 with SMTP id 17so250698gwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:24:12 -0800 (PST)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org
Subject: [PATCH V2 0/6] mwl8k: add initial support for AP firmware on 8366
Date: Fri, 12 Nov 2010 17:23:46 -0800
Message-Id: <1289611433-5119-1-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Lennert,

The other contributors to this upstream effort and I understand
and share the concern you expressed about the future
interoperability of this driver with other firmware/hardware
combos.  So this V2 patchset is accompanied by an updated
firmware image that will be submitted to linux-firmware shortly*.
The changes include:

-- the unused padding in the TX descriptor has been eliminated.

-- the firmware no longer repurposes the tx_frag_cnt member of
   the common tx descriptor.

-- The GET_HW_CAPS command for the AP firmware now reports the
   API version of the firmware.

It is reasonable to expect that all future mwl8k AP firmwares
released to the linux-firmware tree will have this API version
field.  It is also reasonable to expect that future firmwares for
future mwl8k chips supported by Marvell will either a) require no
changes to the mwl8k driver that would break existing released
firmware/hw combos, or b) will have a different API version
number.  The API version number can then be used to select
different hw capabilities, different internal and external ops as
needed, etc.

* The reason for not submitting the firmware immediately is that
  other forces are at work consolidating all Marvell firmware
  images in linux-firmware under a single license.  We figured it
  would be best to submit under the new unified license.  In the
  meantime, if anybody needs the fw, just email me.

