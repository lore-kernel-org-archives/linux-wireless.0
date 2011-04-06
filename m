Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1DFNcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 09:32:21 -0400
Date: Wed, 6 Apr 2011 15:31:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, linville@tuxdriver.com
Subject: Re: [PATCH v7 01/10] nl80211: rename
 NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
Message-ID: <20110406133151.GB2197@redhat.com>
References: <1301966140-26080-1-git-send-email-thomas@cozybit.com>
 <1301966140-26080-2-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1301966140-26080-2-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 04, 2011 at 06:15:31PM -0700, Thomas Pedersen wrote:
> -	/* first allocate the new vendor information element */
> +	/* allocate information elements */
>  	new_ie = NULL;
> -	old_ie = ifmsh->vendor_ie;
> +	old_ie = ifmsh->ie;
>  
> -	ifmsh->vendor_ie_len = setup->vendor_ie_len;
> -	if (setup->vendor_ie_len) {
> -		new_ie = kmemdup(setup->vendor_ie, setup->vendor_ie_len,
> +	ifmsh->ie_len = setup->ie_len;
> +	if (setup->ie_len) {
> +		new_ie = kmemdup(setup->ie, setup->ie_len,
>  				GFP_KERNEL);
>  		if (!new_ie)
>  			return -ENOMEM;

No idea if this is a problem, but in !new_ie case, after function
exit ifmsh->ie_len will not match ifmsh->ie .

Stanislaw

