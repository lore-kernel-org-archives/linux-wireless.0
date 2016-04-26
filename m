Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35974 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbcDZQJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 12:09:52 -0400
Received: by mail-yw0-f175.google.com with SMTP id o66so19974850ywc.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 09:09:51 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 26 Apr 2016 21:39:31 +0530
Message-ID: <CABPxzYLy=zCjjCb1BuMayxx47FDS7yEFOr7bpwbce7dZKrWsPA@mail.gmail.com> (sfid-20160426_180955_607320_452F1F56)
Subject: [RFC] Sampling Holes in Minstrel when VHT is enabled
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Karl Beldan <karl.beldan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

With the current design, occasionally we are seeing issues
where minstrel sends 3x3 rates for our 2x2 chip.

IMHO, couple of things can cause this

1) update_caps doesn't take local HW capabilities in to account

2) While calculating sample_idx, we use MCS_GROUP_RATES
which can cause a sampling hole.

For eg: if sample_idx: 78, group will be 7 it is HT
so rate_idx will be : 8  +  (2-1) * 8 = 16 = 3x3 MCS0 20 MHz.

ideally we should add

a) local hw_checks and update groups.supported accordingly.

b) use the formula index % get_max_group_rates (or) replace all
instances of MCS_GROUP_RATES for HT with 8.
(in set_rate, get_sampling_rate etc..)


-- 
Thanks,
Regards,
Chaitanya T K.
