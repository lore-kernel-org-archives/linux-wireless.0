Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE63C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 17:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3A7214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 17:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfCLRT4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 13:19:56 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:49666 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730113AbfCLRSd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 13:18:33 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2019 13:18:33 EDT
Received: from kevinolos (unknown [71.15.201.20])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id EDCABDBF65C;
        Tue, 12 Mar 2019 17:12:07 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id 84A021300406; Tue, 12 Mar 2019 11:12:05 -0600 (MDT)
Date:   Tue, 12 Mar 2019 11:12:05 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     linuxwifi@intel.com, linux-wireless@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Message-ID: <20190312171205.GA12792@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Wireless Developers,

I have a Lenovo ThinkPad T430 (2342-CTO) with an Intel Centrino
Ultimate-N 6300 (8086:4238) wireless card.  With the help of Reventlov
and johill on #linux-wireless, we discovered that enabling TX AMPDU,
by passing module option 11n_disable=8 (IWL_ENABLE_HT_TXAGG) to
iwlwifi, increased TCP throughput significantly:

With an ASUS RT-ACRH13 AP and `iperf3 -s` running on a server with a
1Gbps wired connection, `iperf3 -R -c` on the ThinkPad increased from
63.2 to 104 Mbits/sec (using MCS 15 40MHz short GI).  With a Buffalo
WZR-600DHP running OpenWRT, `iperf3 -R -c` increased from 63.2 to
76.9.

TX AMPDU was disabled by default for all iwldvm cards in 205e2210daa9
because "iwldvm don't handle well TX AMPDU".  However, I have been
using this configuration for >2 weeks without any issues or measurable
change in ping times to the AP.  Are there any other potential
side-effects I can check?

Would it be possible to enable TX AMPDU by default for at least some
of these cards?  If so, what additional information would be required?

Thanks for considering,
Kevin
