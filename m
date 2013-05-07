Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab3EGOCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 10:02:41 -0400
Message-ID: <1367935357.8328.38.camel@jlt4.sipsolutions.net> (sfid-20130507_160300_979048_A85CD8B2)
Subject: Re: [PATCH] iw: scan using meshid
From: Johannes Berg <johannes@sipsolutions.net>
To: Jacob Minshall <jacob@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 May 2013 16:02:37 +0200
In-Reply-To: <1366927339-4870-1-git-send-email-jacob@cozybit.com> (sfid-20130426_000234_553647_DE1C506A)
References: <1366927339-4870-1-git-send-email-jacob@cozybit.com>
	 (sfid-20130426_000234_553647_DE1C506A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-25 at 15:02 -0700, Jacob Minshall wrote:

> +	if (ies || meshid) {
> +		tmpies = (unsigned char *) malloc(ies_len + meshid_len);
> +		if (!tmpies)
> +			goto nla_put_failure;
> +		if (ies) {
> +			memcpy(tmpies, ies, ies_len);
> +			free(ies);
> +		}
> +		if (meshid) {
> +			memcpy(&tmpies[ies_len], meshid, meshid_len);
> +			free(meshid);
>  		}

In theory, I guess they should be sorted, but I suppose it doesn't
really matter.

johannes


