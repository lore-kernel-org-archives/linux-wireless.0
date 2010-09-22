Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50268 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0IVK1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:27:52 -0400
Received: by fxm3 with SMTP id 3so175481fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 03:27:51 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: pull request: wireless-next-2.6 2010-09-21
Date: Wed, 22 Sep 2010 12:27:48 +0200
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20100921201705.GC2448@tuxdriver.com> <201009221158.13806.chunkeey@googlemail.com> <1285149677.3684.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285149677.3684.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201009221227.48500.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 12:01:17 Johannes Berg wrote:
> On Wed, 2010-09-22 at 11:58 +0200, Christian Lamparter wrote:
> > On Wednesday 22 September 2010 03:36:14 David Miller wrote:
> > > From: "John W. Linville" <linville@tuxdriver.com>
> > > Date: Tue, 21 Sep 2010 16:17:05 -0400
> > > 
> > > Pulled, but I suspect the 'packed' attribute usage is wrong in
> > > ath/carl9170 and can just be deleted.
> > 
> > which __packed do you think can be removed?
> 
> Well, there are bitfields in packed structs, which is either completely
> wrong (think endianness ... never use them to interface with something
> outside your own CPU), or needn't be packed.

ah,

the header files (eeprom.h, wlan.h, hw.h, version.h, phy.h, fwcmd.h, fwdesc.h)
are shared with the firmware, firmware tools and the userspace testbench.

The structs in question are all #ifdef __CARL9170FW__,
they are exclusively used by the firmware to make things
look nice:

e.g.:
super->f.hdr.mac = ((super->s.ri[super->s.rix] & CARL9170_TX_SUPER_RI_ERP_PROT) >>
	CARL9170_TX_SUPER_RI_ERP_PROT_S) << AR9170_TX_MAC_PROT_S;

super->f.hdr.mac = ((super->s.ri[super->s.rix] & CARL9170_TX_SUPER_RI_AMPDU) ?
	AR9170_TX_MAC_AGGR : 0;

becomes:
super->f.hdr.mac.erp_prot = super->s.ri[super->s.rix].erp_prot;
super->f.hdr.mac.ampdu = super->s.ri[super->s.rix].ampdu;  
