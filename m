Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43680 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZG2VjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:39:23 -0400
Message-ID: <4A70C17B.6090309@candelatech.com>
Date: Wed, 29 Jul 2009 14:39:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Reinette Chatre <reinette.chatre@intel.com>
CC: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2009 02:32 PM, Reinette Chatre wrote:
> From: Reinette Chatre<reinette.chatre@intel.com>
>
> The connection monitor currently relies on probe requests paired
> with probe responses to ensure that a connection is alive. This is
> fragile in some environments where probe responses can get lost.
> When we receive beacons we can also consider the connection to be
> alive, so cancel connection poll instance when we receive a beacon.

I'm chasing a similar problem while working on virtual STA device
support in ath5k.  I was also going to try sending up to 3 polls before
giving up on the connection.  Does that seems like a valid thing to do?

I'll try using this patch as well to see if that helps.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

