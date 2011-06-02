Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49352 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758412Ab1FBJGg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 05:06:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 2 Jun 2011 01:57:41 -0700
Subject: RE: [PATCH 2/2] mwifiex: correct the error check used for
 dev_alloc_name()
Message-ID: <477F20668A386D41ADCC57781B1F704307FD0BF3B4@SC-VEXCH1.marvell.com> (sfid-20110602_110646_960170_BF9030F3)
References: <1306198818-7423-1-git-send-email-bzhao@marvell.com>
 <1306198818-7423-2-git-send-email-bzhao@marvell.com>,<20110601191837.GG2509@tuxdriver.com>
In-Reply-To: <20110601191837.GG2509@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> commit 1c5cae815d19ffe02bdfda1260949ef2b1806171
> Author: Jiri Pirko <jpirko@redhat.com>
> Date:   Sat Apr 30 01:21:32 2011 +0000
> 
>     net: call dev_alloc_name from register_netdevice
> 
>     Force dev_alloc_name() to be called from register_netdevice() by
>     dev_get_valid_name(). That allows to remove multiple explicit
>     dev_alloc_name() calls.
> 
>     The possibility to call dev_alloc_name in advance remains.
> 
>     This also fixes veth creation regresion caused by
>     84c49d8c3e4abefb0a41a77b25aa37ebe8d6b743
> 
>     Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> This patch is now obsolete...

Hi John,

Thanks for the info. Please revert this patch then.

Regards,
Bing

> On Mon, May 23, 2011 at 06:00:18PM -0700, Bing Zhao wrote:
>> From: Amitkumar Karwar <akarwar@marvell.com>
>>
>> In failure case dev_alloc_name() returns negative errno code.
>> This patch corrects the check used for handling error path.