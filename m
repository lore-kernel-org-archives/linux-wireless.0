Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3KKOGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 09:06:23 -0500
Message-ID: <1384178778.14334.21.camel@jlt4.sipsolutions.net> (sfid-20131111_150626_026017_A696ADD1)
Subject: Re: [PATCH v4] mac80211: fix the mesh channel switch support
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Mon, 11 Nov 2013 15:06:18 +0100
In-Reply-To: <1383894583-3454-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131108_081202_001431_43D4F2F5)
References: <1383894583-3454-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20131108_081202_001431_43D4F2F5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-08 at 15:09 +0800, Chun-Yeow Yeoh wrote:
> Mesh STA receiving the mesh CSA action frame is not able to trigger
> the mesh channel switch due to the incorrect handling and comparison
> of mesh channel switch parameters element (MCSP)'s TTL. Make sure
> the MCSP's TTL is updated accordingly before calling the
> ieee80211_mesh_process_chnswitch. Also, we update the beacon before
> forwarding the CSA action frame, so MCSP's precedence value and
> initiator flag need to be updated prior to this.

I guess I'll apply this.

>  		pre_value = cpu_to_le16(ifmsh->pre_value);
>  		memcpy(pos, &pre_value, 2);		/* Precedence Value */
>  		pos += 2;

However, it seems to me that you should be using put_unaligned_le16() or
so in places like this - maybe clean them all up?

johannes

