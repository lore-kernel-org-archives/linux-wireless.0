Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39993 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbbGVRb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 13:31:57 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: nick <xerofoify@gmail.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"Altman, Avri" <avri.altman@intel.com>,
	"eliad@wizery.com" <eliad@wizery.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linuxwifi] [PATCH] iwlwifi:Fix error handling in the function
 iwl_pcie_enqueue_hcmd
Date: Wed, 22 Jul 2015 17:31:51 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E7B3D53@hasmsx107.ger.corp.intel.com> (sfid-20150722_193221_244538_541C6897)
References: <1437583079-28861-1-git-send-email-xerofoify@gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E7B3D25@hasmsx107.ger.corp.intel.com>
 <55AFD306.5060303@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2015 08:30 PM, nick wrote:
> 
> 
> On 2015-07-22 01:28 PM, Grumbach, Emmanuel wrote:
>>
>>
>> On 07/22/2015 07:39 PM, Nicholas Krause wrote:
>>> This fixes error handling in the function iwl_pcie_enqueue_hcmd
>>> by checking if all calls to the function wl_pcie_txq_build_tfd
>>> have failed by returning a error code and if so jump to the goto
>>> label out from the cleaning up of acquired resources before
>>
>> What tests did you run on your patch?
>>
> None did I miss something?

I can't really accept a patch if you don't even test it, right?
Your patch doesn't look problematic at first glance, but hitting
these paths isn't easy and I am not very happy to change the behavior
without direct testing.

