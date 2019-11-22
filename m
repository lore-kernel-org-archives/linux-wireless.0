Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6B2C43215
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 13:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF0D20715
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 13:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfKVNCt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:02:49 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45170 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfKVNCt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 08:02:49 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iY8a8-0003rO-7Y; Fri, 22 Nov 2019 14:02:40 +0100
Message-ID: <7d43bbc0dfeb040d3e0468155858c4cbe50c0de2.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: set the maximum EIRP output power for
 5GHz
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Date:   Fri, 22 Nov 2019 14:02:37 +0100
In-Reply-To: <CAK8U23amVqf-6YoiPoyk5_za3dhVb4FJmBDvmA2xv2sD43DhQA@mail.gmail.com> (sfid-20191122_135302_082448_33FD13BE)
References: <20191108152013.13418-1-ramonreisfontes@gmail.com>
         <fe198371577479c1e00a80e9cae6f577ab39ce8e.camel@sipsolutions.net>
         <CAK8U23amVqf-6YoiPoyk5_za3dhVb4FJmBDvmA2xv2sD43DhQA@mail.gmail.com>
         (sfid-20191122_135302_082448_33FD13BE)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-11-22 at 09:52 -0300, Ramon Fontes wrote:
> > How is hwsim related to ETSI? What does it matter?
> 
> It's well known that the frequency bands 2,4 GHz and 5 GHz are mainly
> used by Radio LANs and in many cases, the deployed technology is based
> on the IEEE 802.11 standards family. However, other technologies such
> as LTE-LAA are deployed in those frequency bands as well. That said,
> considering that hwsim is an excellent module that can be used in
> different network simulation scenarios; that it is not only used in
> North America; and also considering that some regulatory power limits
> are taken from the ETSI standards, why not set a maximum value
> supported by a renowned Institute? Without this new value, regdomain
> will not work as expected for some countries.

Right, so the commit log should say that it should be incremented to
allow regdb to work, rather than worry about ETSI specifics?

Or maybe this limit should just be removed entirely?

johannes

