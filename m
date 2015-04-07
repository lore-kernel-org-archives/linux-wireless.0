Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47223 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbDGAj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2015 20:39:28 -0400
Received: from [50.34.201.20] (unknown [50.34.201.20])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 0448040BA82
	for <linux-wireless@vger.kernel.org>; Mon,  6 Apr 2015 17:39:27 -0700 (PDT)
Message-ID: <5523273F.4060803@candelatech.com> (sfid-20150407_023934_513813_F236C9C9)
Date: Mon, 06 Apr 2015 17:39:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath10k to ath9k IBSS, ath9k has interface-combinations issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Has anyone tried running ath10k to ath9k IBSS?

I'm trying this with a somewhat hacked 4.0-rc6 kernel,
and latest wpa_supplicant.

ath9k to ath9k works with and without encryption, and ath10k to ath10k works (w/out encryption at least).

But, if I try to tell ath10k to connect to ath9k, then the ath9k reports interface combinations
issues and will not associate.  I've added some debug, and the issue is the 'num==0' part here:


int cfg80211_check_combinations(struct wiphy *wiphy,
				const int num_different_channels,
				const u8 radar_detect,
				const int iftype_num[NUM_NL80211_IFTYPES])
{
	int err, num = 0;

	err = cfg80211_iter_combinations(wiphy, num_different_channels,
					 radar_detect, iftype_num,
					 cfg80211_iter_sum_ifcombs, &num);
	if (err) {
		pr_info("cfg-comb-check: failed to iterate combinations\n");
		return err;
	}
	if (num == 0) {
		pr_info("cfg-comb-check: iter-combinations returned num==0\n");
		return -EBUSY;
	}

	return 0;
}
EXPORT_SYMBOL(cfg80211_check_combinations);

There should be exactly one interface on this radio that is admin-up, and it is the
one that I am trying to make run in adhoc mode.

Any ideas on this?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
