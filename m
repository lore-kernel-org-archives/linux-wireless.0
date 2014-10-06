Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62238 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaJFMdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 08:33:25 -0400
Received: by mail-ob0-f172.google.com with SMTP id wo20so3768210obc.17
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 05:33:24 -0700 (PDT)
Date: Mon, 6 Oct 2014 07:33:14 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFT] iwlwifi: dvm: drop non VO frames when flushing
Message-ID: <20141006123314.GA131459@ubuntu-hedt> (sfid-20141006_143328_223162_E873BA33)
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2014 at 04:57:12PM +0300, Emmanuel Grumbach wrote:
> +	if (vif)
> +		scd_queues &= ~BIT(vif->hw_queue[IEEE80211_AC_VO]);

I'm backporting this to 3.13, and this part doesn't work unless
77be2c54c5bd26279abc13807398771d80cda37a is also backported. Is this
critical, or can it be omitted in the backport?

Thanks,
Seth

