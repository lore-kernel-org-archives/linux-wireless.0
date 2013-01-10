Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46527 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3AJMHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 07:07:04 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: Re: Q: how to update platform power state for the network driver
Date: Thu, 10 Jan 2013 14:06:59 +0200
Message-ID: <1363680.r8KF83dygC@lx-vladimir> (sfid-20130110_130711_397126_48FBEFE4)
In-Reply-To: <6929081.7c7blFVDp4@lx-vladimir>
References: <6929081.7c7blFVDp4@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, January 09, 2013 07:20:06 PM Vladimir Kondratiev wrote:
> What is the best way to obtain this info in the network driver?
>

Found:

#include <linux/power_supply.h>
int power_supply_is_system_supplied(void);

returns:
positive if system is AC supplied,
0 if battery supplied
negative on error


