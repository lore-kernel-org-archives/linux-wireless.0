Return-Path: <SRS0=IsUp=WP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C567C3A59D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 11:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07ACF20844
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 11:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=miegl.cz header.i=@miegl.cz header.b="fcGNF4Y1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfHSLhT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Aug 2019 07:37:19 -0400
Received: from ocelot.miegl.cz ([195.201.216.236]:32786 "EHLO ocelot.miegl.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfHSLhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Aug 2019 07:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=miegl.cz; s=dkim;
        t=1566214636; bh=ghh9g6A4qrVc+U+j0QqnawRUrG/H0fA3kn3AVWTGdws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=fcGNF4Y1kD8PfoeH9kzL7epkTl/4KimTQLSCNEaByidQizrXIdU5Yf2LYCukBG/l2
         4YocG0IShQWt/RsM7okMQqggKypN0YAcpzIaqFcxbYC1oT6RQeDVkMf+h/CLQ/bnW2
         zlVXYP6uBSP8DM4h63rMuAqazp+klkGc4/LdDKz/zUjzGsymgkeW0ze/okVCaMrfqW
         ynMWApbzGZ1sb7fSp3GxZv3ykQBfnkNkdWdl0NwV2LBngs8O3pOQIwRDogVU84zKLF
         Ivf6FcVKszCmrITsQNgDb4+cmxyyq/UfEDA6m7QOpNbvl++p8tPfAhTjkl+2fHqaUR
         tK87pX/bodg1A==
Date:   Mon, 19 Aug 2019 13:37:07 +0200
From:   Josef Miegl <josef@miegl.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Implementing Mikrotik IE
Message-ID: <20190819113706.ujsz67sxcwt2ulmt@pepin-laptop.localdomain>
References: <20190815152844.k5mmddvbwrohkzr6@pepin-laptop.localdomain>
 <3a079683-6f57-3b42-f909-90c46e14f14f@newmedia-net.de>
 <20190816111044.4ntizgmpa3twbzcg@pepin-laptop.localdomain>
 <e8129acb-fc32-c85c-b504-ab8777a3f1a3@newmedia-net.de>
 <20190816113818.ohktykc4fyetzyvq@pepin-laptop.localdomain>
 <9985fddfb059640f36665efc9c1ef2dc0bdb7662.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9985fddfb059640f36665efc9c1ef2dc0bdb7662.camel@sipsolutions.net>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Aug 19, 2019 at 12:12:43PM +0200, Johannes Berg wrote:
> Contrary to what Sebastian states, it certainly is possible today,
> although not through wpa_supplicant's config file, only through the
> wpa_cli interface, using the VENDOR_ELEM_ADD command. There are various
> tests showing how to use this.

Thanks Johannes. I noticed this too and tried adding a config file
option (OpenWRT doesn't compile wpa_supplicant with wpa_cli). I've added
sta_vendor_elements option (exactly like ap_vendor_elements). This is
the code setting vendor_elem:

+++ b/wpa_supplicant/wpa_supplicant.c
@@ -5833,6 +5833,16 @@
        wpas_mbo_update_non_pref_chan(wpa_s, wpa_s->conf->non_pref_chan);
 #endif /* CONFIG_MBO */

+       if (wpa_s->conf->sta_vendor_elements) {
+               if (wpa_s->vendor_elem[VENDOR_ELEM_ASSOC_REQ] == NULL) {
+                       wpa_s->vendor_elem[VENDOR_ELEM_ASSOC_REQ] = wpa_s->conf->sta_vendor_elements;
+               } else {
+                       wpabuf_resize(&wpa_s->vendor_elem[VENDOR_ELEM_ASSOC_REQ], wpabuf_len(wpa_s->conf->sta_vendor_elements));
+                       wpabuf_put_buf(wpa_s->vendor_elem[VENDOR_ELEM_ASSOC_REQ], wpa_s->conf->sta_vendor_elements);
+               }
+       }
+
        wpa_supplicant_set_default_scan_ies(wpa_s);

        return 0;


But when I actually set sta_vendor_elements to something, all it does is
failing the 4-way handshake during association. The IE is perfectly
valid and it works with ap_vendor_elements, no nl80211 malformed IEs
error either. Am I missing something?

Josef

