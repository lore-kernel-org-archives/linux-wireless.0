Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:56052 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755362AbXEVXB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 19:01:59 -0400
Message-ID: <465362EA.9090008@linux.intel.com>
Date: Tue, 22 May 2007 14:38:50 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <20070516182700.912a21ed.randy.dunlap@oracle.com> <464BD9D4.4020909@linux.intel.com> <464BEEB0.8030402@garzik.org>
In-Reply-To: <464BEEB0.8030402@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:

> As an aside #2,
> 
>> +#if IWL == 4965
>> +           (rxon1->ofdm_ht_single_stream_basic_rates ==
>> +            rxon2->ofdm_ht_single_stream_basic_rates) &&
>> +           (rxon1->ofdm_ht_dual_stream_basic_rates ==
>> +            rxon2->ofdm_ht_dual_stream_basic_rates) &&
>> +           (rxon1->rx_chain == rxon2->rx_chain) &&
>> +#endif
> 
> 
> those #if's should go away.

Agreed.  We'll continue working to remove those over time.

Originally the intent was to have a single driver that supported the 4965 and 3945 via run-time switching.  As development moved forward, switching to a build-time approach made more sense.  base.c was then isolated from the hardware specific code and the specific HW functionality was moved into iwl-3945 and iwl-4965.  The remaining chunks are small code pieces where that work hasn't yet completed.

James

> 
>     Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
