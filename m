Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40215 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab0AVXRU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:17:20 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYSkf-0008OO-Ix
	for linux-wireless@vger.kernel.org; Sat, 23 Jan 2010 00:17:17 +0100
Received: from p4FF0DD95.dip.t-dialin.net ([79.240.221.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 00:17:17 +0100
Received: from Markus_Baier by p4FF0DD95.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 00:17:17 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: Compat-wireless bleeding-edge daily builds broken since  2009-12-11
Date: Fri, 22 Jan 2010 23:17:00 +0000 (UTC)
Message-ID: <loom.20100123T001444-561@post.gmane.org>
References: <Pine.LNX.4.64.0912261245080.5112@cheetah.psv.nu>	 <20091229020027.GE30201@bombadil.infradead.org>	 <4B59FC5E.1020802@redfish-solutions.com>	 <43e72e891001221153w5c4c4bc6g63883b5012d384b7@mail.gmail.com>	 <4B5A20C3.6020304@redfish-solutions.com> <1264198240.9056.4.camel@mj> <4B5A2FA2.5000603@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip A. Prindeville <philipp_subx@...> writes:

> "Fixed minutes ago"?  I thought that Markus's last message was stating it was
still broken...

There is no patch until now.
But I think Pavel posted the line in the code that causes the error :-)

                case ALG_CCMP:
                        if (!ieee80211_is_data_present(hdr->frame_control) &&
                            !ieee80211_use_mfp(hdr->frame_control, tx->sta,
                                               tx->skb))
                                tx->key = NULL;
                        skip_hw = (tx->key->conf.flags &
                                                IEEE80211_KEY_FLAG_SW_MGMT) &&
                                   ieee80211_is_mgmt(hdr->frame_control);
                        break;

