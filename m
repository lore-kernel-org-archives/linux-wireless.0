Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E523C10F0F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3A7F21726
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfDEPcD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 11:32:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35098 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfDEPcD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 11:32:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hCQoy-0006H0-Qj; Fri, 05 Apr 2019 17:32:00 +0200
Message-ID: <aa7040c0cdb233fbb55fbe34673406a0c7356c74.camel@sipsolutions.net>
Subject: Re: [PATCH 4/6] netlink: add strict parsing for future attributes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     nicolas.dichtel@6wind.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>
Date:   Fri, 05 Apr 2019 17:31:58 +0200
In-Reply-To: <c85732ca-892e-a1f2-0a52-cbf383a47ab5@6wind.com> (sfid-20190405_172251_324134_A0F331B8)
References: <20190404065408.5864-1-johannes@sipsolutions.net>
         <20190404065408.5864-5-johannes@sipsolutions.net>
         <c85732ca-892e-a1f2-0a52-cbf383a47ab5@6wind.com>
         (sfid-20190405_172251_324134_A0F331B8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-05 at 17:22 +0200, Nicolas Dichtel wrote:
> Le 04/04/2019 à 08:54, Johannes Berg a écrit :
> [snip]
> > As we didn't want to add another argument to all functions that get a
> > netlink policy, the workaround is to encode that boundary in the first
> > entry of the policy array (which is for type 0 and thus probably not
> > really valid anyway). I put it into the validation union for the rare
> > possibility that somebody is actually using attribute 0, which would
> > continue to work fine unless they tried to use the extended validation,
> > which isn't likely. We also didn't find any in-tree users with type 0.
> 
> OVS_TUNNEL_KEY_ATTR_ID seems to be one if I'm not wrong.

Indeed, good find.

I guess I'll change the commit message, but all it really means is that
OVS can't use any validation function etc. for OVS_TUNNEL_KEY_ATTR_ID,
which seems like a reasonable trade-off.

johannes

