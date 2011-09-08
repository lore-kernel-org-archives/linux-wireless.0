Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f43.google.com ([209.85.212.43]:49738 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab1IHIq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 04:46:29 -0400
Received: by vws10 with SMTP id 10so844924vws.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 01:46:28 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 Sep 2011 10:46:25 +0200
Message-ID: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com> (sfid-20110908_104632_902230_0D28628B)
Subject: About the patch: "staging: brcm80211: only enable brcmsmac if bcma is
 not set"
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a question regarding the following patch:
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/75638

The commit message says:

   brcmsmac doesn't yet use bcma, but both drivers attempt to claim the same
   device.  For now, turn of brcmsmac if bcma is enabled.

I think it's not quite complete:  both driver claim the same devices
(actually that's not entirely true since b43/bcma can drive on more
card) but in the case of b43/bcma not all cards are actually working.
For example I'm using BCM4313 card with an unsupported phy
(B43_PHYTYPE_LCN) so it's basically not supported by b43/bcma.

So I'm wondering if b43/bcma should be simply disabled until it got
the same level of support as brcmsmac ?

Thanks
-- 
Francis
