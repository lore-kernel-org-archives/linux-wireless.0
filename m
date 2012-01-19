Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53268 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2ASGra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 01:47:30 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3064AF5@HASMSX103.ger.corp.intel.com>
References: <20120110184917.GA26973@redhat.com>
	<1326221614.5067.6.camel@dcbw.foobar.com>
	<0BA3FCBA62E2DC44AF3030971E174FB3063085@HASMSX103.ger.corp.intel.com>
	<20120111014243.GA22066@redhat.com>
	<0BA3FCBA62E2DC44AF3030971E174FB306429E@HASMSX103.ger.corp.intel.com>
	<20120111195055.GA5140@redhat.com>
	<0BA3FCBA62E2DC44AF3030971E174FB3064AF5@HASMSX103.ger.corp.intel.com>
Date: Thu, 19 Jan 2012 08:47:28 +0200
Message-ID: <CANUX_P3UHz-Pr_M1H5pAbmKDY70es7nxkWSDGXG6-hvrPAMCJw@mail.gmail.com> (sfid-20120119_074739_532754_752D919C)
Subject: Re: iwlwifi worse than ever in current git.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Dave Jones <davej@redhat.com>, Dan Williams <dcbw@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> [16520.224964] iwlwifi 0000:04:00.0: U iwlagn_tx_agg_start Can proceed: ssn =
>> next_recl = 124
>> [16520.228038] iwlwifi 0000:04:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 124
>> [16520.228358] iwlwifi 0000:04:00.0: U iwl_trans_tx_queue_set_status Activate
>> BA Queue 11 on FIFO 1
>> [16520.229059] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra =
>> b8:c7:5d:0c:39:87 tid = 0
>> [16531.888296] iwlwifi 0000:04:00.0: U iwlagn_tx_agg_stop Can proceed: ssn =
>> next_recl = 631
>> [16531.888793] iwlwifi 0000:04:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
>> [16531.889247] iwlwifi 0000:04:00.0: U iwl_trans_tx_queue_set_status
>> Deactivate AC/CMD Queue 11 on FIFO 0
>> [16552.504609] iwlwifi 0000:04:00.0: U iwlagn_tx_agg_start Can proceed: ssn =
>> next_recl = 697
>> [16552.508182] iwlwifi 0000:04:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 185
>> [16552.508609] iwlwifi 0000:04:00.0: U iwl_trans_tx_queue_set_status Activate
>> BA Queue 11 on FIFO 1
>> [16552.509077] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra =
>> b8:c7:5d:0c:39:87 tid = 0
>> [16564.084058] iwlwifi 0000:04:00.0: U iwlagn_tx_agg_stop Can proceed: ssn =
>> next_recl = 1241
>> [16564.084506] iwlwifi 0000:04:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
>> [16564.084903] iwlwifi 0000:04:00.0: U iwl_trans_tx_queue_set_status
>> Deactivate AC/CMD Queue 11 on FIFO 0
>> [16568.975872] iwlwifi 0000:04:00.0: U iwlagn_tx_agg_start Can proceed: ssn =
>> next_recl = 1298
>> [16568.978796] iwlwifi 0000:04:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 18
>> [16568.979007] iwlwifi 0000:04:00.0: U iwl_trans_tx_queue_set_status Activate
>> BA Queue 11 on FIFO 1
>> [16568.979734] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra =
>> b8:c7:5d:0c:39:87 tid = 0
>> [16580.004052] iwlwifi 0000:04:00.0: U iwlagn_tx_agg_stop Can't proceed: ssn
>> 1491, next_recl = 150
>>
>
> I understand there is nothing afterwards... This is really weird. The sequence numbers here are really crazy...
> I need to think that over.
>
>>

Ok, I finally had a change to take a closer look at this. Please run
with debug=0xC0000000.

This will be noisy, but I guess we have no choice...
I will be travelling next week, so...
