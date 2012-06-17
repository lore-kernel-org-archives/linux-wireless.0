Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29106 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2FQBH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 21:07:58 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20445.11677.349633.688444@gargle.gargle.HOWL> (sfid-20120617_030803_916025_A3142C5C)
Date: Sun, 17 Jun 2012 06:36:37 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <c_manoha@qca.qualcomm.com>
Subject: [PATCH 5/9] ath9k_hw: remove the old ANI implementation
In-Reply-To: <1339766727-61926-5-git-send-email-nbd@openwrt.org>
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org>
	<1339766727-61926-2-git-send-email-nbd@openwrt.org>
	<1339766727-61926-3-git-send-email-nbd@openwrt.org>
	<1339766727-61926-4-git-send-email-nbd@openwrt.org>
	<1339766727-61926-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> It was found to be buggy on a variety of chipsets from AR913x to AR928x.
> The new version (which was introduced along with AR93xx support) is more
> reliable in preventing connectivity dropouts and also fixes MIB interrupt
> storm issues.

What bugs exactly ? Can you elaborate which cases show improvement ?
OFDM weak signal detection ?
CCK weak signal detection ?
Noise immunity ?
Firstep_Level ?

MIB interrupt storms will not be seen because they aren't used at all.

False positives are an issue with ANI and has this been studied with the
move to the new algorithm ?

The new ANI algorithm is designed to take advantage of the HW improvements
in AR300 and above. Has it been verified that the older HW generation can actually
conform to the requirements of the new algorithm ?

If there are bugs or regressions in the existing code in ath9k, we can surely
fix them. But IMHO, saying 'general stability is improved' is not really a
justification for code extermination. Why can't we opt for a more evolutionary
approach ?

Sujith
