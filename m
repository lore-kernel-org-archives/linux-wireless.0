Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3JBIuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 04:50:05 -0400
Message-ID: <1380703802.13329.4.camel@jlt4.sipsolutions.net> (sfid-20131002_105009_807492_1D1E947E)
Subject: Re: [PATCH v2 4/5] {nl,cfg,mac}80211: finalizing mesh channel
 switching
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Wed, 02 Oct 2013 10:50:02 +0200
In-Reply-To: <1380700964-844-5-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131002_100258_662690_85CD382C)
References: <1380700964-844-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1380700964-844-5-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131002_100258_662690_85CD382C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-02 at 01:02 -0700, Chun-Yeow Yeoh wrote:
> Finalizing the required procedures for channel switching completion based
> on the procedures  defined in the IEEE Std 802.11-2012 section 10.9.8.4.3:
>  * Add the function for updating the beacon and probe response frames
>    with CSA and MCSP elements during the period of switching to the new
>    channel.
>  * The ifmsh->csa_settings is set to NULL and the CSA and MCSP elements
>    will then be removed from the beacon or probe response frames once the
>    new channel is switched to.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
> ---
> v2: fix typo mistake, commit message and return value.  
>     use spinlock to protect csa_settings  (Johannes Berg)

Is the spinlock really the best idea? It seems you could just use RCU
instead and avoid the extra lock? It's not exactly a hotpath, but the
paths that are assigning this should be locked already (I'd hope,
otherwise there might be more races) and the reader could be RCU.

johannes

