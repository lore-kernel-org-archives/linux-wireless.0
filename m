Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:54144 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231Ab2GWS3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 14:29:15 -0400
Message-ID: <500D97F8.9070702@net.t-labs.tu-berlin.de> (sfid-20120723_202918_489546_903E612F)
Date: Mon, 23 Jul 2012 20:29:12 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: jirislaby@gmail.com, johannes.berg@intel.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@nbd.name, rodrigue@qca.qualcomm.com,
	c_manoha@qca.qualcomm.com
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect user
 txpower changes
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <20120723164250.GA11893@localhost> <500D9716.10300@net.t-labs.tu-berlin.de>
In-Reply-To: <500D9716.10300@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After applying this 2 patches I got the following eeprom read on an
Wistron CM9:

[   38.880000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[0].freq
= 4920, rate[0].target_power_6to24 = 36, rate[0].target_power_36 = 32,
rate[0].target_power_48 = 28, rate[0].target_power_54 = 24
[   38.896000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[1].freq
= 5040, rate[1].target_power_6to24 = 36, rate[1].target_power_36 = 32,
rate[1].target_power_48 = 28, rate[1].target_power_54 = 24
[   38.916000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[2].freq
= 5170, rate[2].target_power_6to24 = 36, rate[2].target_power_36 = 32,
rate[2].target_power_48 = 30, rate[2].target_power_54 = 26
[   38.936000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[3].freq
= 5240, rate[3].target_power_6to24 = 38, rate[3].target_power_36 = 34,
rate[3].target_power_48 = 30, rate[3].target_power_54 = 26
[   38.952000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[4].freq
= 5320, rate[4].target_power_6to24 = 38, rate[4].target_power_36 = 34,
rate[4].target_power_48 = 30, rate[4].target_power_54 = 26
[   38.972000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[5].freq
= 5500, rate[5].target_power_6to24 = 38, rate[5].target_power_36 = 32,
rate[5].target_power_48 = 28, rate[5].target_power_54 = 26
[   38.992000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[6].freq
= 5700, rate[6].target_power_6to24 = 36, rate[6].target_power_36 = 32,
rate[6].target_power_48 = 28, rate[6].target_power_54 = 26
[   39.012000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[7].freq
= 5825, rate[7].target_power_6to24 = 34, rate[7].target_power_36 = 30,
rate[7].target_power_48 = 26, rate[7].target_power_54 = 24
[   39.036000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[0].freq
= 2412, rate[0].target_power_6to24 = 39, rate[0].target_power_36 = 39,
rate[0].target_power_48 = 39, rate[0].target_power_54 = 39
[   39.056000] ath5k: phy0: [bluse ath5k_eeprom] rate_pcal_info[1].freq
= 2484, rate[1].target_power_6to24 = 38, rate[1].target_power_36 = 38,
rate[1].target_power_48 = 38, rate[1].target_power_54 = 38

The 5 GHz values look ok for me, but is the 2,4 GHz amp really that
linear to support all powers at all rates ?

Greetings Thomas
