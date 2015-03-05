Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbbCEWyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 17:54:06 -0500
Date: Thu, 5 Mar 2015 23:54:04 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, ArikX Nemtsov <arik@wizery.com>
Subject: Re: [PATCH v10 2/3] cfg80211: Add API to change the indoor
 regulatory setting
Message-ID: <20150305225404.GB25035@wotan.suse.de> (sfid-20150305_235409_878741_1DCEEADB)
References: <1425447127-22958-1-git-send-email-ilan.peer@intel.com>
 <1425447127-22958-2-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425447127-22958-2-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 04, 2015 at 12:32:06AM -0500, Ilan Peer wrote:
> -int regulatory_hint_indoor_user(void)
> +int regulatory_hint_indoor(bool is_indoor, u32 portid)
>  {
> +	spin_lock(&reg_indoor_lock);
> +
> +	/* It is possible that more than one user space process is trying to
> +	 * configure the indoor setting. To handle such cases, clear the indoor
> +	 * setting in case that some process does not think that the device
> +	 * is operating in an indoor environment. In addition, if a user space
> +	 * process indicates that it is controlling the indoor setting, save its
> +	 * portid, i.e., make it the owner.
> +	 */
> +	reg_is_indoor = is_indoor;
> +	if (reg_is_indoor) {
> +		if (!reg_is_indoor_portid)
> +			reg_is_indoor_portid = portid;
> +	} else {
> +		reg_is_indoor_portid = 0;
> +	}
>  
> +	spin_unlock(&reg_indoor_lock);
>  
> -	reg_is_indoor = true;
> +	if (!is_indoor)
> +		reg_check_channels();
>  
>  	return 0;
>  }

OK lets start with this...

 Luis
