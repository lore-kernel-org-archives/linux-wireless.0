Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46904 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753117AbeBGJQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 04:16:15 -0500
Subject: Re: [PATCH] ath9k: break out of irq handler after 5 jiffies
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
References: <1517958324-13536-1-git-send-email-greearb@candelatech.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <2129dcdd-5963-c4da-600e-83f8c394d05c@nbd.name> (sfid-20180207_101620_619144_72639A58)
Date: Wed, 7 Feb 2018 10:16:12 +0100
MIME-Version: 1.0
In-Reply-To: <1517958324-13536-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-07 00:05, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> In case where the system is sluggish, we should probably break out
> early.  Maybe this will fix issues where the OS thinks the IRQ handler
> is not responding and disables the IRQ because 'nobody cared'
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
5 jiffies as a hardcoded value is a bad idea, since it produces
different behavior based on CONFIG_HZ.

- Felix
