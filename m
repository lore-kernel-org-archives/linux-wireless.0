Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34966 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195Ab2JYCUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 22:20:02 -0400
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
Message-ID: <20616.41414.398817.807498@gargle.gargle.HOWL> (sfid-20121025_042007_538606_90FDD19F)
Date: Thu, 25 Oct 2012 07:49:50 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Regression in 3.7-rc2 for b43 and b43legacy
In-Reply-To: <50889F60.5090406@lwfinger.net>
References: <50889F60.5090406@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> I have discovered that both b43 and b43legacy broke somewhere between 3.7-rc1 
> and 3.7-rc2. The problem was bisected to commit fe57d9f. The commit message is
> 
> commit fe57d9f5c0a2c1ef97ba8cdc42cfda5743f287b8
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Jul 26 14:55:08 2012 +0200
> 
>      mac80211: track whether to use channel contexts
> 
>      Depending on the driver, channel contexts may be used or
>      not. If they are used, the driver must have support for
>      hardware scan and remain-on-channel; otherwise the driver
>      must not advertise support for multiple channels.
> 
>      Also prohibit WDS type interfaces when channel contexts
>      are to be used as there's no clear definition of which
>      channel they use.
> 
>      Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> It seems likely that the drivers are inadvertently advertising support for 
> multiple channels, What must be done to turn off this "feature"?

This has been fixed:
https://patchwork.kernel.org/patch/1625871/

Sujith
