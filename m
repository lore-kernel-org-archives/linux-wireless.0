Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37540 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYH1L7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:59:25 -0400
Subject: Re: [PATCH 10/11] iwlwifi: fix rx_chain computation
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1ba2fa240808280416h7f8975d4v218e79b1c2aeedf1@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-10-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-11-git-send-email-yi.zhu@intel.com>
	 <1219927302.6064.30.camel@californication>
	 <1ba2fa240808280416h7f8975d4v218e79b1c2aeedf1@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 15:59:22 +0200
Message-Id: <1219931962.6064.54.camel@californication> (sfid-20080828_135927_403645_E1012188)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> This patch fixes and simplifies rx_chain computation.
> >
> > come on, what does it fix? You are submitting patches for -rc4 kernels.
> 
> The fix is here
> 
> +       /* correct rx chain count accoridng hw settings */

while you are at it. Fix the spelling. It is "according" :)

> +       if (priv->hw_params.rx_chains_num < active_rx_cnt)
> +               active_rx_cnt = priv->hw_params.rx_chains_num;
> +
> +       if (priv->hw_params.rx_chains_num < idle_rx_cnt)
> +               idle_rx_cnt = priv->hw_params.rx_chains_num;
> +
> 
> We would configure 1x2 MIMO like 3x3 -- big trouble

And that should be in the commit message. Even explain the trouble that
it causes.

Regards

Marcel


