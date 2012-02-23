Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33172 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2BWMXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 07:23:02 -0500
Subject: Re: [PATCH 3/6] iwlwifi: cleanup/fix memory barriers
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1329992168-19990-3-git-send-email-sgruszka@redhat.com> (sfid-20120223_111622_464410_98E63752)
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
	 <1329992168-19990-3-git-send-email-sgruszka@redhat.com>
	 (sfid-20120223_111622_464410_98E63752)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 13:22:58 +0100
Message-ID: <1329999778.3448.2.camel@jlt3.sipsolutions.net> (sfid-20120223_132307_124556_8D43BC27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 11:16 +0100, Stanislaw Gruszka wrote:

>  	__iwl_clear_bit(trans, CSR_GP_CNTRL,
>  			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
> +	/*
> +	 * In above we are reading CSR_GP_CNTRL register, what will flush any
> +	 * previous writes, but still want write, which clear MAC_ACCESS_REQ
> +	 * bit, be performed on PCI bus before any other writes scheduled on
> +	 * different CPUs (after we drop reg_lock).
> +	 */
> +	mmiowb();
>  }

I changed this comment to the, imho, more readable

        /*
         * Above we read the CSR_GP_CNTRL register, which will flush
         * any previous writes, but we need the write that clears the
         * MAC_ACCESS_REQ bit to be performed before any other writes
         * scheduled on different CPUs (after we drop reg_lock).
         */

johannes

