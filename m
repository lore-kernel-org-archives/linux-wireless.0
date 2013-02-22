Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47959 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab3BVMiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 07:38:21 -0500
Message-ID: <512766B8.3030008@openwrt.org> (sfid-20130222_133825_498942_C6BC1D27)
Date: Fri, 22 Feb 2013 13:38:16 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Ben Greear <greearb@candelatech.com>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC] ath9k: Detect and work-around tx-queue hang.
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com> <20774.62475.588131.344540@gargle.gargle.HOWL> <5126F732.6040007@candelatech.com> <20774.63702.208829.602903@gargle.gargle.HOWL> <51270186.6070003@candelatech.com> <51275837.4020708@openwrt.org> <20775.25545.671357.512930@gargle.gargle.HOWL>
In-Reply-To: <20775.25545.671357.512930@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-22 1:25 PM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Please also check if the station(s) that the frames are queued for are
>> in powersave state for some reason. That would prevent the tx path from
>> throwing them in the hw queue, yet they'd still take up pending-frame
>> slots. I was planning on fixing this eventually by expiring frames that
>> stay in the queue for too long, but haven't decided on the exact
>> approach yet.
> 
> PS is disabled for multi-VIF.
What about off-channel PS due to scans, etc.

- Felix

