Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53175 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab2IMTDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:03:22 -0400
Received: by lagy9 with SMTP id y9so2179925lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2012 12:03:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347364329-19443-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1347364329-19443-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 13 Sep 2012 12:03:00 -0700
Message-ID: <CAB=NE6X78e=b6e1PQn2rPcLY+3C--qO5+WkcbaM3F7FF83YWig@mail.gmail.com> (sfid-20120913_210326_722580_446D31CA)
Subject: Re: [PATCH v1] cfg80211: Fix regulatory check for 60GHz band frequencies
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 11, 2012 at 4:52 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> Remove freq_in_rule_band, that was used to optimize regulatory rules check.
> Approach used in the freq_in_rule_band is incorrect for 60GHz band,
> where channel spacing is 2.160GHz.
> Also, it does not really add any optimization, since real check for frequency fit is
> always performed.
>
> Issue exposed in the following way: 60g band defines 3 channels supported wold-wide:
> channels 1..3 or 58320, 60480, 62640 MHz, and channel 4, or 64800 MHz,
> in the most of the world, with 2160 MHz spacing.
> Corresponded regulatory rule for channels 1..3 would be
> (57240 - 63720 @ 2160)
>
> And, when regulatory applies to the channel 2 (60480), it get disabled since it is
> more then 2GHz from either frequency boundary and freq_in_rule_band fails
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

NACK - please check the usage of -ERANGE returned here for its users.
It turns out that Country IEs are allowed to be sent by APs whereby
specific bands are not specified even though those bands are allowed
in that country, and although the device supports them. In such cases
without a band check like this if a country IE is issued with say only
2.4 GHz rules we'd end up disabling all 5 GHz and 60 GHz rules. What
the check does then is if we get an country IE we ensure that before
we disable channels on a band we ensure that the country IE has at
least one channel on the band. Otherwise we leave that band alone.

With your patch we'd break previous behavior where an AP may send a
country IE only for 2.4 GHz and force us to disable all of our 5 GHz
channels. We don't want that.

  Luis
