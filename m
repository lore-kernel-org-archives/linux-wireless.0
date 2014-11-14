Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38206 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965734AbaKNWkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 17:40:23 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so4150777wid.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2014 14:40:22 -0800 (PST)
Date: Fri, 14 Nov 2014 23:40:18 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v6] mac80211: minstrel_ht: add basic support for VHT
 rates <= 3SS@80MHz
Message-ID: <20141114224018.GB14439@gobelin> (sfid-20141114_234028_966237_3A18242B)
References: <1413812762-6605-5-git-send-email-karl.beldan@gmail.com>
 <1413880718-31273-1-git-send-email-karl.beldan@gmail.com>
 <20141114164328.GA30967@w1.fi>
 <20141114171832.GA16541@magnum.frso.rivierawaves.com>
 <20141114173648.GA31675@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20141114173648.GA31675@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2014 at 07:36:48PM +0200, Jouni Malinen wrote:
> On Fri, Nov 14, 2014 at 06:18:32PM +0100, Karl Beldan wrote:
> > Yes, only with iw and nothing fancy, I also have had it running on some 
> > boards for some weeks as is and with rfc version for more than a year at
> > work (minstrel not the whole tree).
> > I guess I can take the tip of wireless-testing but can you give your
> > HEAD though ?
> 
> It looks like pretty much any snapshot between master-2014-11-04 and now
> is affected.. Anyway, the current master snapshot in my tests was
> 0e204e2422876c18034ca960c4fccf727a02a5c1.
> 

I tried to trigger the warning with it and nfc_p2p_* (even looping with
stop.sh; start.sh; run-tests.py nfc_p2p_*), to no avail, the tests are
successful and 0 warning.
I'll see if anything stands out in the code tomorrow.
 
Karl

> > > For example, with nfc_p2p_go_neg test case:
> > 
> > Have you reproduced it with other testcases (maybe more regular so that
> > I can get my hands on it faster) ?
> > Is it also happening when VHT support is not advertized by upper layers
> > ?
> 
> This seems to be specific to exact timing of frames since the same issue
> does not show up in non-NFC P2P test cases. So no, this does not show up
> with anything else than the nfc_p2p_* test cases (well, at least not in
> my desktop+kvm setup; YMMV with other CPU speeds that could potentially
> affect timing):
> nfc_p2p_go_neg
> nfc_p2p_go_neg_reverse
> nfc_p2p_ip_addr_assignment
> nfc_p2p_static_handover_tagdev_client
> nfc_p2p_static_handover_tagdev_client_group_iface
> nfc_p2p_static_handover_tagdev_go
> 
> I'd assume the key here is in P2P with NFC trigger having the fastest
> possible connection process due to all the optimizations in channel
> selection on WPS (which is those EAPOL Data frames that hit these rate
> selection issues immediately after association).
> 
> That said, if you use the tests/hwsim scripts from
> git://w1.fi/hostap.git there should be no difference on running some of
> these cases vs. something more regular..
> 
> If you have not used these test scripts previously, you can find more
> information about the setup here:
> http://w1.fi/cgit/hostap/plain/tests/hwsim/README
> http://w1.fi/cgit/hostap/plain/tests/hwsim/vm/README
> 
> -- 
> Jouni Malinen                                            PGP id EFC895FA
