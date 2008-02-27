Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4234 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632AbYB0Ueg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 15:34:36 -0500
Date: Wed, 27 Feb 2008 15:04:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] ipw2200: queue direct scans
Message-ID: <20080227200446.GF3078@tuxdriver.com> (sfid-20080227_203446_632527_FF83A01B)
References: <1204141038.3007.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1204141038.3007.5.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2008 at 02:37:18PM -0500, Dan Williams wrote:

> @@ -6292,7 +6302,7 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type)
>  	}
>  
>  	if (priv->status & STATUS_RF_KILL_MASK) {
> -		IPW_DEBUG_HC("Aborting scan due to RF Kill activation\n");
> +		IPW_DEBUG_HC("Queuing scan due to RF Kill activation\n");
>  		priv->status |= STATUS_SCAN_PENDING;
>  		goto done;
>  	}

Does this really make sense?  There is no telling how long RF Kill
will be activated.

-- 
John W. Linville
linville@tuxdriver.com
