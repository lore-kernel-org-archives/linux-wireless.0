Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40635 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab0IXSOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 14:14:34 -0400
Date: Fri, 24 Sep 2010 14:00:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix possible null-pointer dereference
Message-ID: <20100924180013.GD8077@tuxdriver.com>
References: <201009210057.13297.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009210057.13297.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 12:57:13AM +0200, Christian Lamparter wrote:
> net/mac80211/mesh_plink.c +574 mesh_rx_plink_frame(168)
> error: we previously assumed 'sta' could be null.
> 
> This bug was detected by smatch.
> ( http://repo.or.cz/w/smatch.git )
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index ea13a80..1d7c564 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -473,7 +473,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
>  	rcu_read_lock();
>  
>  	sta = sta_info_get(sdata, mgmt->sa);
> -	if (!sta && ftype != PLINK_OPEN) {
> +	if (!sta || ftype != PLINK_OPEN) {
>  		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
>  		rcu_read_unlock();
>  		return;

Are you sure this is the intended check?  It isn't clear to me from looking at the code.

Perhaps line 574 just needs to be protected by another NULL check?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
