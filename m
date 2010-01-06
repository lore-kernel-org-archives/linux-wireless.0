Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:50459 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab0AFQgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 11:36:37 -0500
Received: by ywh6 with SMTP id 6so17568437ywh.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 08:36:37 -0800 (PST)
Message-ID: <4B44BC10.1050308@lwfinger.net>
Date: Wed, 06 Jan 2010 10:36:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_carrier_search
 and it's calls
References: <op.u54a5ufy9lhzdc@linux-g0th.site> <201001061650.52062.mb@bu3sch.de>
In-Reply-To: <201001061650.52062.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2010 09:50 AM, Michael Buesch wrote:
> On Wednesday 06 January 2010 16:40:32 Rafał Miłecki wrote:
>> b43: N-PHY: implement b43_nphy_stay_carrier_search and it's calls
> 
> Hm, The phrase "stay carrier earch" doesn't make a lot of sense to me.
> Is "stray carrier search" or something like that meant?
> Not that I care much, but I'm just wondering if this is just a typo.

"stay in carrier search"

> 
>> +static void b43_nphy_write_clip_detection(struct b43_wldev *dev, u16 *vals)
> 
> We know that these values are the clip thresholds, so use a better variable name, please.
> 
>> +{
>> +	b43_phy_write(dev, B43_NPHY_C1_CLIP1THRES, vals[0]);
>> +	b43_phy_write(dev, B43_NPHY_C2_CLIP1THRES, vals[1]);
>> +}
>> +
>> +static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *vals)
>> +{
>> +	vals[0] = b43_phy_read(dev, B43_NPHY_C1_CLIP1THRES);
>> +	vals[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
>> +}
>> +
>> +static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
>> +{
>> +	u16 tmp;
>> +	bool suspended = false;
>> +
>> +	if (dev->dev->id.revision == 16 && dev->mac_suspended == 0) {
> 
> Do not check for mac_suspended==0 here. b43_mac_suspended does this internally.
> 
>> +		b43_mac_suspend(dev);
>> +		suspended = true;
>> +	}
>> +
>> +	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
>> +	tmp &= (B43_NPHY_CLASSCTL_CCKEN | B43_NPHY_CLASSCTL_OFDMEN |
>> +		B43_NPHY_CLASSCTL_WAITEDEN);
>> +	tmp &= ~mask;
>> +	tmp |= (val & mask);
>> +	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
>> +
>> +	if (suspended)
>> +		b43_mac_enable(dev);
>> +
>> +	return tmp;
>> +}
>> +
>> +static void b43_nphy_stay_carrier_search(struct b43_wldev *dev, bool enable)
>> +{
>> +	struct b43_phy *phy = &dev->phy;
>> +	struct b43_phy_n *nphy = phy->n;
>> +
>> +	if (enable) {
>> +		u16 clip[] = { 0xFFFF, 0xFFFF };
>> +		if (nphy->deaf_count++ == 0) {
>> +			nphy->classifier_state = b43_nphy_classifier(dev, 0, 0);
>> +			b43_nphy_classifier(dev, 0x7, 0);
>> +			b43_nphy_read_clip_detection(dev, nphy->clip_state);
>> +			b43_nphy_write_clip_detection(dev, clip);
>> +		}
>> +		b43_nphy_reset_cca(dev);
>> +	} else {
>> +		if (--nphy->deaf_count != 0) {
> 
> If this test logic correct? The following would make more sense to me:
> 
> 		if (--nphy->deaf_count == 0) {

It should be == 0. Specs match Broadcom code.


Larry

