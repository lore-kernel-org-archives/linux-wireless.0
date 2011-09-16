Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41969 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab1IPH5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 03:57:05 -0400
Message-ID: <4E730147.1090408@openwrt.org> (sfid-20110916_095718_376321_31288985)
Date: Fri, 16 Sep 2011 09:56:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] mac80211: stop tx before doing hw config and rate
 update
References: <1314951719-9816-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1314951719-9816-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-02 10:21 AM, Rajkumar Manoharan wrote:
> The assumption is that during the hw config, transmission was
> already stopped by mac80211. Sometimes the AP can be switching
> b/w the ht modes due to intolerant or etc where STA is in
> the middle of transmission. In such scenario, buffer overflow
> was observed at driver side. And also before updating the rate
> control, the frames are continued to xmited with older rates.
> This patch ensures that the frames are always xmitted with
> updated rates and avoid buffer overflow.
>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
John, please revert this one, it's completely messed up. It stops 
queues, and calls drv_flush whenever it receives a beacon with 802.11n 
information, even if 802.11n is already enabled and the mode is the 
correct one.
Additionally, it even wakes the queues again before the settings have 
been applied, so it's 100% useless.

- Felix
