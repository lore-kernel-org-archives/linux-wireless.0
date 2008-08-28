Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:47020 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYH1LQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:16:24 -0400
Received: by ey-out-2122.google.com with SMTP id 6so97467eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:16:22 -0700 (PDT)
Message-ID: <1ba2fa240808280416h7f8975d4v218e79b1c2aeedf1@mail.gmail.com> (sfid-20080828_131628_207370_43887B51)
Date: Thu, 28 Aug 2008 14:16:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 10/11] iwlwifi: fix rx_chain computation
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1219927302.6064.30.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:41 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Yi,
>
>> This patch fixes and simplifies rx_chain computation.
>
> come on, what does it fix? You are submitting patches for -rc4 kernels.

The fix is here

+       /* correct rx chain count accoridng hw settings */
+       if (priv->hw_params.rx_chains_num < active_rx_cnt)
+               active_rx_cnt = priv->hw_params.rx_chains_num;
+
+       if (priv->hw_params.rx_chains_num < idle_rx_cnt)
+               idle_rx_cnt = priv->hw_params.rx_chains_num;
+

We would configure 1x2 MIMO like 3x3 -- big trouble
Tomas

>
