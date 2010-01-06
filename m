Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:24976 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0AFULK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 15:11:10 -0500
Received: by ey-out-2122.google.com with SMTP id 22so760416eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 12:11:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001061650.52062.mb@bu3sch.de>
References: <op.u54a5ufy9lhzdc@linux-g0th.site>
	 <201001061650.52062.mb@bu3sch.de>
Date: Wed, 6 Jan 2010 21:11:08 +0100
Message-ID: <b170af451001061211y51b3ca6do11fb24fbb1193c51@mail.gmail.com>
Subject: Re: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_carrier_search
	and it's calls
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/6 Michael Buesch <mb@bu3sch.de>:
> On Wednesday 06 January 2010 16:40:32 Rafał Miłecki wrote:
>> +static void b43_nphy_stay_carrier_search(struct b43_wldev *dev, bool enable)
>> +{
>> +     struct b43_phy *phy = &dev->phy;
>> +     struct b43_phy_n *nphy = phy->n;
>> +
>> +     if (enable) {
>> +             u16 clip[] = { 0xFFFF, 0xFFFF };
>> +             if (nphy->deaf_count++ == 0) {
>> +                     nphy->classifier_state = b43_nphy_classifier(dev, 0, 0);
>> +                     b43_nphy_classifier(dev, 0x7, 0);
>> +                     b43_nphy_read_clip_detection(dev, nphy->clip_state);
>> +                     b43_nphy_write_clip_detection(dev, clip);
>> +             }
>> +             b43_nphy_reset_cca(dev);
>> +     } else {
>> +             if (--nphy->deaf_count != 0) {
>
> If this test logic correct? The following would make more sense to me:

Huuh, thanks for catching that! I believe you saved me from long
debugging in future.

-- 
Rafał
