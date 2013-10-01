Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3JAL1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:27:47 -0400
Message-ID: <1380626864.14430.32.camel@jlt4.sipsolutions.net> (sfid-20131001_132749_445955_76972B45)
Subject: Re: [PATCH 4/5] {nl,cfg,mac}80211: finalizing mesh channel switching
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Tue, 01 Oct 2013 13:27:44 +0200
In-Reply-To: <1379115372-28426-5-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130914_013634_171516_9BF59D4C)
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1379115372-28426-5-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130914_013634_171516_9BF59D4C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-09-13 at 16:36 -0700, Chun-Yeow Yeoh wrote:
> Finalizing the requried procedures for channel switching completion and

typo: required

> also adding the function for updating the beacon and probe response frames
> with CSA and MCSP elements. Once the channel switching is completed, the
> CSA and MCSP elements are removed from the beacon or probe response frames
> as defined in the IEEE Std 802.11-2012 section 10.9.8.4.3.

I'd prefer you rewrote this to be more active ... this seems rather
observer style :)

> +int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> +	int ret = 0;
> +
> +	/* Remove the CSA and MCSP elements from the beacon */
> +	kfree(ifmsh->csa_settings);
> +	ifmsh->csa_settings = NULL;
> +	ret = ieee80211_mesh_rebuild_beacon(sdata);
> +	if (ret)
> +		return -EINVAL;

This seems totally racy with what I pointed out in the other patch ...

> +	/* Reset the TTL value and Initiator flag */
> +	ifmsh->chsw_init = false;
> +	ifmsh->chsw_ttl = 0;
> +
> +	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
> +
> +	mcsa_dbg(sdata, "complete switching to center freq %d MHz",
> +		 sdata->vif.bss_conf.chandef.chan->center_freq);
> +	return ret;

return 0

> +	tmp_csa_settings = kmalloc(sizeof(struct cfg80211_csa_settings),
> +				   GFP_ATOMIC);
> +	if (!tmp_csa_settings) {
> +		mcsa_dbg(sdata, "could not allocate memory for csa beaconing");

You should never print a message for memory allocation failures, they
already give very verbose output.

> +	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
> +	return ret;

return 0

johannes

