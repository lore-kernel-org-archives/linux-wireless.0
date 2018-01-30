Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59558 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeA3H4q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 02:56:46 -0500
Message-ID: <1517299004.2189.38.camel@sipsolutions.net> (sfid-20180130_085650_233436_B7807E20)
Subject: Re: [PATCH v4 2/3] mac80211_hwsim: add nl_err_msg in
 hwsim_new_radio in netlink case
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 30 Jan 2018 08:56:44 +0100
In-Reply-To: <20180122170437.14213-3-benjamin.beichler@uni-rostock.de>
References: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de>
         <20180122170437.14213-3-benjamin.beichler@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-22 at 18:04 +0100, Benjamin Beichler wrote:
> 
> +		if(!info)
> +			pr_debug("mac80211_hwsim: radio index %d already present\n",
> +				 idx);

Can this really trigger? I think I'll edit it out - we do pass
info==NULL in the case of module init, but in that case nothing else
can interfere and we can't even really fail.

johannes
