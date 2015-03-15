Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:45078 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbbCOKSA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 06:18:00 -0400
Date: Sun, 15 Mar 2015 11:17:58 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: core: harmonize error case handling in
	ath10k_core_start
Message-ID: <20150315101758.GA28477@opentech.at> (sfid-20150315_111828_961436_90E1A345)
References: <1426323313-1344-1-git-send-email-hofrat@osadl.org> <550497A0.5040508@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <550497A0.5040508@cogentembedded.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 14 Mar 2015, Sergei Shtylyov wrote:

> Hello.
>
> On 03/14/2015 11:55 AM, Nicholas Mc Guire wrote:
>
>> All of the bringup/init functions called in ath10k_core_start return 0 on
>> success and != 0 on failure - ath10k_wmi_wait_for_service_ready and
>> ath10k_wmi_wait_for_unified_ready were adjusted to fit this model and the
>> call sites here fixed up accordingly.
>
>    If you've changed the sense of these function's results, you need to  
> adjust the call sites in the same patch, because otherwise one wouldn't 
> be able to bisect this...
>

yup both patches would mess up if individually applied or reverted.
sorry my ignorance - did not think of that problem - will fix it 
up as a single patch and repost. 

thx!
hofrat
