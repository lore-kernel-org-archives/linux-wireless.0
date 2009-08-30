Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f188.google.com ([209.85.211.188]:63518 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZH3PQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 11:16:12 -0400
Received: by ywh26 with SMTP id 26so4979021ywh.5
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 08:16:14 -0700 (PDT)
Message-ID: <4A9A965F.8020200@lwfinger.net>
Date: Sun, 30 Aug 2009 10:10:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] b43: LP-PHY: Begin implementing calibration & software
 RFKILL support
References: <4A99C4BB.7080806@gmail.com> <200908301228.16845.mb@bu3sch.de>
In-Reply-To: <200908301228.16845.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Sunday 30 August 2009 02:15:55 Gábor Stefanik wrote:
>>  static void lpphy_pr41573_workaround(struct b43_wldev *dev)
>>  {
>>  	struct b43_phy_lp *lpphy = dev->phy.lp;
>> @@ -1357,28 +1488,440 @@ static void lpphy_pr41573_workaround(struct b43_wldev *dev)
>>  		b43_lptab_read_bulk(dev, B43_LPTAB32(7, 0x140),
>>  				    saved_tab_size, saved_tab);
>>  	}
>> +	b43_put_phy_into_reset(dev);
> 
> Are you sure you really want this?
> This function completely disables the PHY on the backplane and keeps the physical
> PHY reset pin asserted (even after return from the function).
> So the PHY will physically be powered down from this point on. The following
> PHY accesses could even hang the machine, because the PHY won't respond to
> register accesses anymore.
> 
> We currently only use this function on A/G Multi-PHY devices to permanently
> hard-disable the PHY that's not used.

The PHY reset routine in
http://bcm-v4.sipsolutions.net/802.11/PHY/Reset, which I just updated
for the latest N PHY changes, appears to be a different routine than
b43_put_phy_into_reset(). The names are confusing.

Larry
