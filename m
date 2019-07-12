Return-Path: <SRS0=USiB=VJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C606C742A5
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 07:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AA592084B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 07:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfGLH6x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Jul 2019 03:58:53 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54328 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGLH6x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jul 2019 03:58:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hlqSB-0005H2-JM; Fri, 12 Jul 2019 09:58:51 +0200
Message-ID: <06c7c1a2c8d0f955cb107475d17587c156fb19de.camel@sipsolutions.net>
Subject: Re: [PATCH v3 0/3] mac80211/ath11k: HE mesh support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        hostap@lists.infradead.org
Date:   Fri, 12 Jul 2019 09:58:50 +0200
In-Reply-To: <1610842.TRhm9evnVP@bentobox>
References: <20190612193510.29489-1-sven@narfation.org>
         <c025150aad17bbe62595c4969ea2f53f009419d3.camel@sipsolutions.net>
         <1610842.TRhm9evnVP@bentobox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-07-03 at 11:23 +0200, Sven Eckelmann wrote:
> 
>     ~/tmp/wireshark/build/run/tshark -r /tmp/hwsim-test-logs/latest/wpas_mesh_max_peering.hwsim0.pcapng  -T fields -e wlan.sa -e wlan.mesh.config.cap 'wlan.fc.type_subtype == 8' 
>     02:00:00:00:01:00       0x00000009
>     02:00:00:00:00:00       0x00000009
>     02:00:00:00:01:00       0x00000009
>     02:00:00:00:02:00       0x00000009
>     02:00:00:00:00:00       0x00000008
>     02:00:00:00:01:00       0x00000009
>     02:00:00:00:02:00       0x00000009
>     02:00:00:00:00:00       0x00000008
> 
> With wireshark 3.0.0:
> 
>     tshark -r /tmp/hwsim-test-logs/latest/wpas_mesh_max_peering.hwsim0.pcapng  -T fields -e wlan.sa -e wlan.mesh.config.cap 'wlan.fc.type_subtype == 8' 
>     02:00:00:00:01:00       0x00000001
>     02:00:00:00:00:00       0x00000001
>     02:00:00:00:01:00       0x00000001
>     02:00:00:00:00:00       0x00000001
>     02:00:00:00:02:00       0x00000001
>     02:00:00:00:01:00       0x00000001
>     02:00:00:00:02:00       0x00000001
>     02:00:00:00:00:00       0x00000001
> 
> So I had to change the wireshark version (see below) which is used by hostapd.
> (just to document for me what I have forced it to a different version)

What. +hostap list.

This makes no sense, is that a tshark bug in one of the versions?

Maybe we should just use the JSON output, and parse that, but if tshark
now has a different idea of what the "wlan.mesh.config.cap" field is,
that won't help us at all?

Older versions were misparsing the HE element, but that has a length so
should only affect the HE element *itself*?


So ultimately, what do we do here?

Should we take this and sort out the tests?

johannes

