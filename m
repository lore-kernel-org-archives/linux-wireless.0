Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:32487 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbYHEBrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 21:47:31 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1331088ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 18:47:30 -0700 (PDT)
Message-ID: <f2efd86c0808041847n195ee40k9abe6599d60f51b2@mail.gmail.com> (sfid-20080805_034734_623907_42B9A221)
Date: Mon, 4 Aug 2008 21:47:30 -0400
From: "Junty Mesmon" <jmesmon@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>,
	"Maxim Levitsky" <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [IWL3945]Fix statistics in monitor mode
In-Reply-To: <1217820737.3107.15.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4892E14A.4000203@gmail.com>
	 <1217820737.3107.15.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 3, 2008 at 11:32 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Fri, 2008-08-01 at 13:11 +0300, Maxim Levitsky wrote:
>> I guess it is time for me to add my .02 cents to iwlwifi driver.
>> Recently I reported a bug about crazy statistics (> 100 quality for
>> example) when turning on the monitor interface (this bug actually is
>> triggered when card is put in monitor mode, thus shows up when promisc
>> mode enabled as well)
>>
>> It turns out that iwl3945_rx_reply_rx wasn't filling in the statistics
>> when running in monitor on, instead a garbage was passed.
>
> Good catch. I'd suggest change 3945 the same way as 4965. That is, move
> the iwl_pass_packet_to_mac80211() for MNTR before setting
> priv->last_beacon_time, et al. We don't need to update these fields in
> monitor mode anyway.
>
> Thanks,
> -yi
>

If we can have this data, what reason is their not to have it processed?
     -J
