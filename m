Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43242 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882Ab2FOVFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 17:05:52 -0400
Message-ID: <4FDBA3AE.9040009@openwrt.org> (sfid-20120615_230555_256182_AF39E073)
Date: Fri, 15 Jun 2012 23:05:50 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com, c_manoha@qca.qualcomm.com
Subject: Re: [PATCH 4/9] ath9k_hw: clean up / fix ANI mode checks related
 to beacon RSSI
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org> <1339766727-61926-2-git-send-email-nbd@openwrt.org> <1339766727-61926-3-git-send-email-nbd@openwrt.org> <1339766727-61926-4-git-send-email-nbd@openwrt.org> <20120615174916.GB648@vmraj-lnx.qca.qualcomm.com>
In-Reply-To: <20120615174916.GB648@vmraj-lnx.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-15 7:49 PM, Rajkumar Manoharan wrote:
> On Fri, Jun 15, 2012 at 03:25:22PM +0200, Felix Fietkau wrote:
>> Beacon RSSI is only meaningful in station mode - in ad-hoc mode it
>> fluctuates, depending on which peer last sent a beacon, and in other
>> modes it is not set at all.
>> Fix places in ANI where the beacon RSSI is used to limit their use
>> to station mode only.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/ani.c |   12 +++++-------
>>  1 files changed, 5 insertions(+), 7 deletions(-)
>> 
> If so, we should not update beacon rssi in process_rssi in IBSS
> mode.
OK, that can be taken care of in a followup patch.

- Felix
