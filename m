Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1CQJ1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 05:27:46 -0400
Subject: Re: [PATCH] iw: Add send callback with optional debug handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Sean Robinson <seankrobinson@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimQRgAr9aY_zs0L7hjXhECiR9w8V5Y7fbwrJ1DX@mail.gmail.com>
References: <AANLkTimQRgAr9aY_zs0L7hjXhECiR9w8V5Y7fbwrJ1DX@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 10:29:27 +0100
Message-ID: <1300354167.3774.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-16 at 17:28 -0700, Sean Robinson wrote:
> libnl supports callbacks for send and recv.  This patch enables callbacks
> for sent messages and uses the debug callback for the --debug option, as
> the recv callbacks do.

I can't apply this, the patch is corrupted.

>  	cb = nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_DEFAULT);
> -	if (!cb) {
> +	s_cb = nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_DEFAULT);
> +	if (!(cb && s_cb)) {

I think (!cb || !s_cb) would be easier to read.

johannes


