Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1KRQMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 11:12:12 -0500
Subject: Re: [PATCH v5 3/3] mac80211: Save probe response data for bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320917337-30561-3-git-send-email-arik@wizery.com> (sfid-20111110_102919_124845_A2E11EE2)
References: <1320917337-30561-1-git-send-email-arik@wizery.com>
	 <1320917337-30561-3-git-send-email-arik@wizery.com>
	 (sfid-20111110_102919_124845_A2E11EE2)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 17:12:09 +0100
Message-ID: <1321632729.10266.68.camel@jlt3.sipsolutions.net> (sfid-20111118_171224_255188_2FFC8542)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-10 at 11:28 +0200, Arik Nemtsov wrote:
> Allow setting a probe response template for an interface operating in
> AP mode. Low level drivers are notified about changes in the probe
> response template and are able to retrieve a copy of the current probe
> response. This data can, for example, be uploaded to hardware as a
> template.

> +static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
> +				    u8 *resp, size_t resp_len)
> +{
> +	struct sk_buff *new, *old;
> +
> +	if (!resp || !resp_len)
> +		return -EINVAL;
> +
> +	old = sdata->u.ap.probe_resp;

sparse warns here with RCU checking enabled in the kernel:

cfg.c:502:13: warning: incorrect type in assignment (different address spaces)
cfg.c:502:13:    expected struct sk_buff *old
cfg.c:502:13:    got struct sk_buff [noderef] <asn:4>*probe_resp


Please take a look, ieee80211_set_beacon() uses rtnl_dereference() to
avoid the sparse warning and annotate that the RTNL is used to protect
the pointer.

johannes

