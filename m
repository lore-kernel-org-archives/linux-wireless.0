Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56196 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab2JDJd6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 05:33:58 -0400
Message-ID: <506D5804.4090806@openwrt.org> (sfid-20121004_113402_327792_6E6AD646)
Date: Thu, 04 Oct 2012 11:33:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 3.7 2/3] ath9k: improve suspend/resume reliability
References: <1349291272-93080-1-git-send-email-nbd@openwrt.org> <1349291272-93080-2-git-send-email-nbd@openwrt.org> <20588.62828.845432.706022@gargle.gargle.HOWL>
In-Reply-To: <20588.62828.845432.706022@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-04 4:33 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Ensure that drv_start() always returns true, as a failing hw start usually
>> eventually leads to crashes when there's still a station entry present.
>> Call a power-on reset after a resume and after a hw reset failure to bring
>> the hardware back to life again.
> 
> In what situations did HW reset (via start() or resume()) fail ?
I don't know what situations caused it, but this happened on a few
ChromeOS devices in the wild, and my patch fixed it.

- Felix
