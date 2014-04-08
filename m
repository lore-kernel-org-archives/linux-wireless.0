Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDHKDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 06:03:24 -0400
Message-ID: <1396951400.5936.15.camel@jlt4.sipsolutions.net> (sfid-20140408_120327_856727_52770814)
Subject: Re: [RFCv2 1/6] cfg80211: export expected throughput through
 get_station()
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 08 Apr 2014 12:03:20 +0200
In-Reply-To: <1396211704-4677-2-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
	 <1396211704-4677-2-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-30 at 22:34 +0200, Antonio Quartulli wrote:

> -	STATION_INFO_INACTIVE_TIME	= 1<<0,

Since you're touching these all anyway, maybe convert to use BIT().


> @@ -1013,6 +1015,9 @@ struct sta_bss_parameters {
>   * @local_pm: local mesh STA power save mode
>   * @peer_pm: peer mesh STA power save mode
>   * @nonpeer_pm: non-peer mesh STA power save mode
> + * @expected_throughput: expected throughput as reported by the RC algorithm
> + *  about the bitrate having the maximum throughput. This field can be filled
> + *  only by drivers using Minstrel

This value needs a documented unit ... :)

johannes

