Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5072AC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A3E620850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfDLJvl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:51:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44986 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfDLJvk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 05:51:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEsqQ-0001Zc-Gu; Fri, 12 Apr 2019 11:51:38 +0200
Message-ID: <0de9d60ffef574b34e9a76ad2cea68fab49aac0f.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 12 Apr 2019 11:51:37 +0200
In-Reply-To: <185ea9a2-f3c6-04a5-000b-44191da5a0ee@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-8-alexander@wetzel-home.de>
         <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
         <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
         <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
         <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
         <ed6e95dad39ef0ac98c62e3acd3f78fd7b3a6d2b.camel@sipsolutions.net>
         <185ea9a2-f3c6-04a5-000b-44191da5a0ee@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-10 at 22:46 +0200, Alexander Wetzel wrote:

> my new test AP came with a Intel AC-3168, which seems to use only one 
> antenna, potentially also explaining my fist impression that it's a 
> worse card for sniffing than my old Ultimate-N 6300.

Right, that's worse in some way.

> It looks like my (new) Wireless-AC 3168NGW (firmware 29.1044073957.0) 
> does not have the new key ready for Rx when needed. I have a roughly 5 - 
> 15 ms long window where the card scrambles received packets using the 
> new key. (Note: I can't replicate that at the moment. May be wrong!)
> I first suspected the card "cleared" the new key for usage a bit too 
> soon and tried to verify that by waiting a bit after installing a key to 
> the HW. But it looks like it's not so simple...
> 
> I've added a 40 ms delay in the mvm driver after the call to 
> iwl_mvm_set_sta_key() and it first looked like that improved the 
> situation. So I moved the sleep to iwl_trans_send_cmd() behind 
> send_cmd() when not being in CMD_ASYNC but I can't see any any 
> differences any longer. At the moment (with the new test setup) I always 
> get one corrupted frame when downloading from the AP. Always the first 
> frame using the new key...

Ok, that's interesting. Definitely something I'd want to reproduce here
locally and see where exactly we select the wrong key.

FWIW, no timing changes should be needed, once the firmware responds
(and we wait for that when installing a key) everything will be in
place.

> As for the test procedure: I just add a monitor interface in parallel to 
> the "normal" interface on the AP. With HW encryption enabled we should 
> only get cleartext packets and don't have to worry about encrypted 
> packets in our capture at all:
>    iw phy phy0 interface add mon0 type monitor
>    ip link set up dev mon0
> And start a capture in the interface:
>    tcpdump -pi mon0 -s0 -w /tmp/AP.cap

Right.

> I've just uploaded some captures for you to 
> https://www.awhome.eu/index.php/s/AJJXBLsZmzHdxpX also. I've enabled 
> swcrypto on the client for the first two and enabled HW crypto on the 
> client again for the third and forth.
> 
> AP-40ms.pcap.gz
> 	delay hack as outlined above on the AP
> AP-no-delay.cap.gz
> 	no hack (just some useless printks)
> AP-no-delay-client-HW-crypt.cap.gz
> 	same as above, only cleint using HW crypto
> AP-upload-no-delay-HW-crypt.cap.gz
> 	same as previous, only uploading instead of downloading.
> 	(and too many broken packets on receive, indicating a bad
> 	reception/sniffer card)
> 
> In all captures I have a normal (1s) ping running to the AP from the 
> cleint and start a download from an internal server after a while.
> 
> You can e.g. find the "corrupted" looking frames with the wireshark filter
> "(wlan.fc.type_subtype == 0x0028) && !(llc.dsap == 0xaa)"
> 
> Each capture here only has exactly one, the very first packet using the 
> new key.

I'll take a look, but a trace-cmd recording would be more interesting
than the monitor interface, as it also tells us when what key was
installed etc.

If you have some time, you can find how to record that here (under the
"Tracing" section):

https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging

Please do review the privacy notes there at the end of the page if you
do this, you should probably send the files to me/us directly rather
than post publicly. They do contain the keys of your (test) network to
some extent - at least of course the PTK(s)/GTK(s), but usually also the
KEK/KCK.

> When you look at the captures keep in mind that both the client and the 
> AP also have the two not merged patches applied. But I do not see how 
> that makes a difference here.

Agree.

johannes

