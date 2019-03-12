Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83237C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4968D2147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfCLTiE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:38:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:57715 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbfCLTiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 15:38:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 12:38:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,471,1544515200"; 
   d="scan'208";a="306629873"
Received: from avarleyx-mobl.ger.corp.intel.com ([10.252.13.147])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2019 12:38:02 -0700
Message-ID: <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
Subject: Re: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kevin Locke <kevin@kevinlocke.name>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Tue, 12 Mar 2019 21:38:01 +0200
In-Reply-To: <20190312171205.GA12792@kevinolos>
References: <20190312171205.GA12792@kevinolos>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kevin,

Johannes (johill) is also in this list. :)

If this feature was explicitly disabled, it certainly means that
something was causing problems with it, so I'd be wary to enable it for
all DVM devices.

I guess we could enable it by default for devices that work fine, but
we would have to run it in real life for a lot longer with a lot more
different APs to be sure it won't cause any problems.

Emmanuel, do you happen to remember what was the issue, so Kevin could
test that specific scenario with this specific NIC?

Kevin, meanwhile you could add the option to your default module
configuration so it would be used by default on your machine.

--
Cheers,
Luca.


On Tue, 2019-03-12 at 11:12 -0600, Kevin Locke wrote:
> Hi Wireless Developers,
> 
> I have a Lenovo ThinkPad T430 (2342-CTO) with an Intel Centrino
> Ultimate-N 6300 (8086:4238) wireless card.  With the help of
> Reventlov
> and johill on #linux-wireless, we discovered that enabling TX AMPDU,
> by passing module option 11n_disable=8 (IWL_ENABLE_HT_TXAGG) to
> iwlwifi, increased TCP throughput significantly:
> 
> With an ASUS RT-ACRH13 AP and `iperf3 -s` running on a server with a
> 1Gbps wired connection, `iperf3 -R -c` on the ThinkPad increased from
> 63.2 to 104 Mbits/sec (using MCS 15 40MHz short GI).  With a Buffalo
> WZR-600DHP running OpenWRT, `iperf3 -R -c` increased from 63.2 to
> 76.9.
> 
> TX AMPDU was disabled by default for all iwldvm cards in 205e2210daa9
> because "iwldvm don't handle well TX AMPDU".  However, I have been
> using this configuration for >2 weeks without any issues or
> measurable
> change in ping times to the AP.  Are there any other potential
> side-effects I can check?
> 
> Would it be possible to enable TX AMPDU by default for at least some
> of these cards?  If so, what additional information would be
> required?
> 
> Thanks for considering,
> Kevin
> -------------------------------------
> linuxwifi@eclists.intel.com
> https://eclists.intel.com/sympa/info/linuxwifi
> Unsubscribe by sending email to sympa@eclists.intel.com with subject
> "Unsubscribe linuxwifi"

