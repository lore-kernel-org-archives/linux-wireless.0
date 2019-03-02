Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CE3C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 21:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C775C20838
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 21:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfCBVeX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 16:34:23 -0500
Received: from gateway30.websitewelcome.com ([50.116.125.1]:26030 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726529AbfCBVeX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 16:34:23 -0500
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Mar 2019 16:34:23 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 8AEF27F2A
        for <linux-wireless@vger.kernel.org>; Sat,  2 Mar 2019 15:10:51 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 0BuFhiQ3uiQer0BuFhuOhN; Sat, 02 Mar 2019 15:10:51 -0600
X-Authority-Reason: nr=8
Received: from [189.250.88.58] (port=51114 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1h0BuE-0007Cd-6i; Sat, 02 Mar 2019 15:10:50 -0600
Date:   Sat, 2 Mar 2019 15:10:46 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [mt76/mt7603/mac] Question about missing variable assignment
Message-ID: <20190302211046.GA20268@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.88.58
X-Source-L: No
X-Exim-ID: 1h0BuE-0007Cd-6i
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.88.58]:51114
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

The following piece of code in drivers/net/wireless/mediatek/mt76/mt7603/mac.c
is missing a variable assignment before line 1058.  Notice that there
is a potential execution path in which variable *i* is compared against
magic number 15 at line 1075 without being initialized previously
(this was reported by Coverity):

1055 out:
1056         final_rate_flags = info->status.rates[final_idx].flags;
1057 
1058         switch (FIELD_GET(MT_TX_RATE_MODE, final_rate)) {
1059         case MT_PHY_TYPE_CCK:
1060                 cck = true;
1061                 /* fall through */
1062         case MT_PHY_TYPE_OFDM:
1063                 if (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ)
1064                         sband = &dev->mt76.sband_5g.sband;
1065                 else
1066                         sband = &dev->mt76.sband_2g.sband;
1067                 final_rate &= GENMASK(5, 0);
1068                 final_rate = mt7603_get_rate(dev, sband, final_rate, cck);
1069                 final_rate_flags = 0;
1070                 break;
1071         case MT_PHY_TYPE_HT_GF:
1072         case MT_PHY_TYPE_HT:
1073                 final_rate_flags |= IEEE80211_TX_RC_MCS;
1074                 final_rate &= GENMASK(5, 0);
1075                 if (i > 15)
1076                         return false;
1077                 break;
1078         default:
1079                 return false;
1080         }

My guess is that such missing assignment should be something similar
to the one at line 566:

	i = FIELD_GET(MT_RXV1_TX_RATE, rxdg0);

but I'm not sure what the proper arguments for macro FIELD_GET should
be.

This code was introduced by commit c8846e1015022d2531ac4c895783e400b3e5babe

What do you think?

Thanks
--
Gustavo

