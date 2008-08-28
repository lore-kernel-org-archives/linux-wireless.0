Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:60837 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYH1Ohq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 10:37:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so69334nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 07:37:45 -0700 (PDT)
Message-ID: <1ba2fa240808280737j3c6d3b76ndfbb1a8b2767db0e@mail.gmail.com> (sfid-20080828_163750_222263_B995C88B)
Date: Thu, 28 Aug 2008 17:37:44 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 10/11] iwlwifi: fix rx_chain computation
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1219931962.6064.54.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-10-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-11-git-send-email-yi.zhu@intel.com>
	 <1219927302.6064.30.camel@californication>
	 <1ba2fa240808280416h7f8975d4v218e79b1c2aeedf1@mail.gmail.com>
	 <1219931962.6064.54.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 4:59 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Tomas,
>
>> >> This patch fixes and simplifies rx_chain computation.
>> >
>> > come on, what does it fix? You are submitting patches for -rc4 kernels.
>>
>> The fix is here
>>
>> +       /* correct rx chain count accoridng hw settings */
>
> while you are at it. Fix the spelling. It is "according" :)

There is a cleanup patch, but it's deferred to 2.6.2X

>> +       if (priv->hw_params.rx_chains_num < active_rx_cnt)
>> +               active_rx_cnt = priv->hw_params.rx_chains_num;
>> +
>> +       if (priv->hw_params.rx_chains_num < idle_rx_cnt)
>> +               idle_rx_cnt = priv->hw_params.rx_chains_num;
>> +
>>
>> We would configure 1x2 MIMO like 3x3 -- big trouble
>
> And that should be in the commit message. Even explain the trouble that
> it causes
Correct.

> Regards
>
> Marcel
>
>
>
