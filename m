Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41934 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab1BYLid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 06:38:33 -0500
Received: by qwd7 with SMTP id 7so1173329qwd.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 03:38:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298633651-5641-1-git-send-email-zajec5@gmail.com>
References: <1298633651-5641-1-git-send-email-zajec5@gmail.com>
Date: Fri, 25 Feb 2011 12:38:27 +0100
Message-ID: <AANLkTikC12gTdFpkC4VFkw-Q5w4Zg3AsHbpNqnu-DQda@mail.gmail.com>
Subject: Re: [PATCH] b43: fill PHY ctl word1 in TX header for N-PHY
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 25 lutego 2011 12:34 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> +       if (phy->type == B43_PHYTYPE_LP)
> +               bw = B43_TXH_PHY1_BW_20;

(...)

> +       if (phy->type == B43_PHYTYPE_N) {
> +               txhdr->phy_ctl1 =
> +                       cpu_to_le16(b43_generate_tx_phy_ctl1(dev, rate));
> +               txhdr->phy_ctl1_fb =
> +                       cpu_to_le16(b43_generate_tx_phy_ctl1(dev, rate_fb));
> +       }

Just to make it clear: this TX header is expected to be filled on
both: LP-PHY and N-PHY - that's why you can see some LP specific code
in filling function. It just was not tested yet on LP-PHY, that's why
it is still disabled.

-- 
Rafał
