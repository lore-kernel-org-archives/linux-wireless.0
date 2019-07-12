Return-Path: <SRS0=USiB=VJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035B3C742B1
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 09:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D78BE2084B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 09:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfGLJan (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Jul 2019 05:30:43 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55670 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfGLJan (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jul 2019 05:30:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hlrt1-0006ph-4U; Fri, 12 Jul 2019 11:30:39 +0200
Message-ID: <a6e317539fbd53ad5e2fd62ce3544260a3f74e77.camel@sipsolutions.net>
Subject: Re: [RFC 0/8] nl80211: add 6GHz band support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        Tova Mussai <tova.mussai@intel.com>
Date:   Fri, 12 Jul 2019 11:30:38 +0200
In-Reply-To: <8ca6ef2e-b41b-da40-b29a-77666d440495@broadcom.com> (sfid-20190711_133055_699489_979FBCFB)
References: <1558353645-18119-1-git-send-email-arend.vanspriel@broadcom.com>
         <df53f969297fea1f3c8101cd2c1571a957985d2a.camel@sipsolutions.net>
         <16aeb2310e8.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
         <9ba78df6-18a3-5c1c-6c57-3fa71531b460@broadcom.com>
         <48a43287e65e1d24082dea2cc32ca14998acb8d1.camel@sipsolutions.net>
         <8ca6ef2e-b41b-da40-b29a-77666d440495@broadcom.com>
         (sfid-20190711_133055_699489_979FBCFB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-07-11 at 13:30 +0200, Arend Van Spriel wrote:
> 
> I assume user-space does not necessarily need the band, but hostapd 
> needs to be aware that it is operating in 6GHz to setup the correct 
> (information) elements in the beacon. Obviously the operating classes 
> can be used there, but I don't think there is any issue with nl80211 
> exposing a 6G band.

Yeah, I don't really see any *issue* with it, in many places we don't
really even care about the band enum.

In a sense, *most* of the places that consider the channel don't
actually care about the band, the channel num/freq conversion helpers
are a bit of the odd ones out in that regard. In the chandef, for
example, we don't have the band.

Really the original use for the band enum was mostly around the
advertising if capabilities. As you pointed out, 6GHz actually *does*
have different capabilities, though it's not clear to me what exactly
the behaviour differences are. Scanning is a big area, of course.

When we discussed splitting up or not the band, I think what we mostly
considered was the channel num/freq conversion helpers, and Jouni
pointed out that really what we should be doing for those isn't to
consider the band but the operating class instead.

So I'm starting to think that perhaps the decision we came to in Prague
was a little hasty, without considering the full impact?

I do completely agree that we should have knowledge about the operating
classes in the kernel eventually, and probably we will need to have it
here if we need to parse reduced neighbor reports etc. OTOH, we have
already ieee80211_operating_class_to_band(), and that seems sufficient,
though probably we should consider a combined helper that takes
opclass/chan# instead of having to call two functions?

However, from a feature advertisement point of view, we might very well
consider 6 GHz to be a separate nl80211 band, in particular if there
*are* indeed differences around what rates are permitted? Which is
really the only place where we care. Or maybe, thinking about this more,
if there could be devices that have different capabilities in 6 GHz than
in 5 GHz, in the sense of HT/VHT/HE capabilities?

Can somebody do the legwork and really go look at the spec to figure out
what the differences are? I'm not even sure now legacy rates are
permitted or not - you (Arend) seemed to imply they're not, and Igor
said only for beacons ...

I tend to think that this would be the deciding factor. For example, if
we do end up sending a probe request on 6 GHz, would we include a
different supported rates element than on 5 GHz? Or might there even be
devices that have different PHY paths and thus possibly different
capabilities for 5 and 6 GHz, essentially requiring a new place (a new
band enumerator) to store those capabilities, so we don't have to try to
figure out the difference in code later?

I'm almost tempted to say that given all these possibilities we should
in fact add a new value to the band enum, worst case we just duplicate
some data, but if there do end up being differences we can handle them
much more gracefully than if we put everything into 5 GHz.

Jouni, what do you think?

Thanks,
johannes

