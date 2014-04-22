Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbaDVOjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:39:10 -0400
Message-ID: <1398177530.4211.3.camel@jlt4.sipsolutions.net> (sfid-20140422_163914_195235_F523DC21)
Subject: Re: [PATCH] mac80211: avoid handling of SMPS for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Tue, 22 Apr 2014 16:38:50 +0200
In-Reply-To: <1398161965-1427-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140422_121953_155991_188FCDCE)
References: <1398161965-1427-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20140422_121953_155991_188FCDCE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-22 at 18:19 +0800, Chun-Yeow Yeoh wrote:
> The patch "mac80211: implement SMPS for AP" has caused kernel
> oops at mesh STA if the peer mesh STA operates in sleep mode
> and then becomes active mode. It can be easily reproduced by
> setting the following commands at peer mesh STA:
> 
> iw mesh0 station set aa:bb:cc:dd:ee:ff mesh_power_mode deep
> iw mesh0 station set aa:bb:cc:dd:ee:ff mesh_power_mode active
> 
> Kernel oops will happen at mesh STA aa:bb:cc:dd:ee:ff.
> 
> Fix this by avoiding SMPS for mesh mode.

Applied, thanks.

johannes

