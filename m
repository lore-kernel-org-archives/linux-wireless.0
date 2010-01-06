Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35459 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab0AFPu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 10:50:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_carrier_search and it's calls
Date: Wed, 6 Jan 2010 16:50:50 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u54a5ufy9lhzdc@linux-g0th.site>
In-Reply-To: <op.u54a5ufy9lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001061650.52062.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 January 2010 16:40:32 Rafał Miłecki wrote:
> b43: N-PHY: implement b43_nphy_stay_carrier_search and it's calls

Hm, The phrase "stay carrier earch" doesn't make a lot of sense to me.
Is "stray carrier search" or something like that meant?
Not that I care much, but I'm just wondering if this is just a typo.

> +static void b43_nphy_write_clip_detection(struct b43_wldev *dev, u16 *vals)

We know that these values are the clip thresholds, so use a better variable name, please.

> +{
> +	b43_phy_write(dev, B43_NPHY_C1_CLIP1THRES, vals[0]);
> +	b43_phy_write(dev, B43_NPHY_C2_CLIP1THRES, vals[1]);
> +}
> +
> +static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *vals)
> +{
> +	vals[0] = b43_phy_read(dev, B43_NPHY_C1_CLIP1THRES);
> +	vals[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
> +}
> +
> +static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
> +{
> +	u16 tmp;
> +	bool suspended = false;
> +
> +	if (dev->dev->id.revision == 16 && dev->mac_suspended == 0) {

Do not check for mac_suspended==0 here. b43_mac_suspended does this internally.

> +		b43_mac_suspend(dev);
> +		suspended = true;
> +	}
> +
> +	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
> +	tmp &= (B43_NPHY_CLASSCTL_CCKEN | B43_NPHY_CLASSCTL_OFDMEN |
> +		B43_NPHY_CLASSCTL_WAITEDEN);
> +	tmp &= ~mask;
> +	tmp |= (val & mask);
> +	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
> +
> +	if (suspended)
> +		b43_mac_enable(dev);
> +
> +	return tmp;
> +}
> +
> +static void b43_nphy_stay_carrier_search(struct b43_wldev *dev, bool enable)
> +{
> +	struct b43_phy *phy = &dev->phy;
> +	struct b43_phy_n *nphy = phy->n;
> +
> +	if (enable) {
> +		u16 clip[] = { 0xFFFF, 0xFFFF };
> +		if (nphy->deaf_count++ == 0) {
> +			nphy->classifier_state = b43_nphy_classifier(dev, 0, 0);
> +			b43_nphy_classifier(dev, 0x7, 0);
> +			b43_nphy_read_clip_detection(dev, nphy->clip_state);
> +			b43_nphy_write_clip_detection(dev, clip);
> +		}
> +		b43_nphy_reset_cca(dev);
> +	} else {
> +		if (--nphy->deaf_count != 0) {

If this test logic correct? The following would make more sense to me:

		if (--nphy->deaf_count == 0) {

> +			b43_nphy_classifier(dev, 0x7, nphy->classifier_state);
> +			b43_nphy_write_clip_detection(dev, nphy->clip_state);
> +		}
> +	}
> +}
> +
>   enum b43_nphy_rf_sequence {
>   	B43_RFSEQ_RX2TX,
>   	B43_RFSEQ_TX2RX,
> diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
> index e5e402a..6ab07fc 100644
> --- a/drivers/net/wireless/b43/phy_n.h
> +++ b/drivers/net/wireless/b43/phy_n.h
> @@ -932,6 +932,9 @@ struct b43_phy_n {
>   	u32 deaf_count;
>   	bool mute;
> 
> +	u16 classifier_state;
> +	u16 clip_state[2];
> +
>   	u8 iqcal_chanspec_2G;
>   	u8 rssical_chanspec_2G;
> 



-- 
Greetings, Michael.
