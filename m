Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59703 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EDOmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 10:42:43 -0400
Message-ID: <4DC165D7.50403@openwrt.org> (sfid-20110504_164246_838924_CD33BBE7)
Date: Wed, 04 May 2011 16:42:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Javier Cardona <javier@cozybit.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: Re: [PATCH 13/13] ath9k: fix beaconing for mesh interfaces
References: <1304467039-7730-1-git-send-email-javier@cozybit.com> <1304467039-7730-14-git-send-email-javier@cozybit.com>
In-Reply-To: <1304467039-7730-14-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-04 1:57 AM, Javier Cardona wrote:
> Mesh beaconing on ath9k was broken by this commit:
>
> commit 4801416c76a3a355076d6d371c00270dfe332e1c
> Author: Ben Greear<greearb@candelatech.com>
> Date:   Sat Jan 15 19:13:48 2011 +0000
>
> This patch assigns the right opmode when the device is used in mesh
> mode.
>
> Reported-by: Fabrice Deyber fabricedeyber@agilemesh.com
> Signed-off-by: Javier Cardona<javier@cozybit.com>
Any idea why exactly ath9k needs to use this opmode? If I understand the 
specs correctly, 802.11s does not use distributed beacons like ad-hoc 
mode, so theoretically it should be fine with using the AP iftype.
If beacons don't work at all in this opmode for 802.11s then this patch 
may just be covering up an underlying bug rather than fixing the real issue.

- Felix
