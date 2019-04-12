Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B90C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18C52171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfDLLTf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 07:19:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46168 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfDLLTf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 07:19:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEuDV-0004Vi-Jv; Fri, 12 Apr 2019 13:19:33 +0200
Message-ID: <1bff68dc5b1f35092d8ec273edd05a80ca64c5c5.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 12 Apr 2019 13:19:32 +0200
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


> AP-no-delay-client-HW-crypt.cap.gz
> 	same as above, only cleint using HW crypto

> You can e.g. find the "corrupted" looking frames with the wireshark filter
> "(wlan.fc.type_subtype == 0x0028) && !(llc.dsap == 0xaa)"

For everyone else - make sure to set "ignore protected bit - with IV" in
wireshark.

> Each capture here only has exactly one, the very first packet using the 
> new key.

Yeah. Note that this packet is really quickly after the EAPOL 4/4
(1.5ms) so perhaps the key wasn't installed yet or something? Hmm, then
again, it should be before we send the confirmation?

But I don't know. The tracing would definitely tell me what's going on.

Btw, if you do record such tracing, it helps if you compile
wpa_supplicant with CONFIG_DEBUG_LINUX_TRACING and start it with the -T
argument to record all of its debugging into the trace file as well.

johannes

