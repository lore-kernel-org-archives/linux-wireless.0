Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BC7C07E85
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D6B20645
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:07:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30D6B20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=w1.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbeLGKHQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:07:16 -0500
Received: from mail.w1.fi ([212.71.239.96]:43962 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbeLGKHP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 05:07:15 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2018 05:07:14 EST
Received: from localhost (localhost [127.0.0.1])
        by li674-96.members.linode.com (Postfix) with ESMTP id 756E811F08;
        Fri,  7 Dec 2018 10:01:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from li674-96.members.linode.com ([127.0.0.1])
        by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Qetajj2xAekw; Fri,  7 Dec 2018 10:01:53 +0000 (UTC)
Received: by jm (sSMTP sendmail emulation); Fri, 07 Dec 2018 12:01:50 +0200
Date:   Fri, 7 Dec 2018 12:01:50 +0200
From:   Jouni Malinen <j@w1.fi>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] Extended Key ID support for linux
Message-ID: <20181207100150.GA6183@w1.fi>
References: <20181111110235.14213-1-alexander@wetzel-home.de>
 <6102d09bb53a59b2789e31d84ffdda45165a895c.camel@sipsolutions.net>
 <f20cc734-c861-289c-c041-3fc99f1a5015@wetzel-home.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f20cc734-c861-289c-c041-3fc99f1a5015@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Dec 05, 2018 at 08:06:33PM +0100, Alexander Wetzel wrote:
> >On Sun, 2018-11-11 at 12:02 +0100, Alexander Wetzel wrote:
> >>IEEE 802.11-2012 added support for Extended Key ID, allowing pairwise
> >>keys to also use keyID 1 and moving group keys to IDs 2 and 3.
> >
> >Where do you read this? I've always been under the impression that
> >individually and group addressed frames use key IDs from different
> >"namespaces", so to speak, where PTK/STK can use 0 (0 or 1 with
> >"Extended Key ID" support) and GTK can use 0-3.

There is no such requirement to change group key IDs in the IEEE 802.11
standard when taking Extended Key ID mechanism into use.

> >In fact, the per-frame pseudocode in 802.11-2016 12.9.2.6 clearly
> >states:
> >
> >if MPDU has individual RA then
> >	lookup pairwise key using Key ID from MPDU
> >else
> >	lookup group key using Key ID from MPDU
> >endif
> >
> >If it weren't different namespaces, you'd not have to differentiate
> >here.
> >
> 
> I was indeed struggling to understand what the intend of the standard is
> here. I may well be wrong, but the note in "12.6.1.1.10 Mesh GTKSA" tipped
> the scales to assume keyIDs are within one namespace only.
> 
> "Since Key ID 0 is reserved for individually addressed frame transmission,
> there are at most three available Key IDs (only two if extended Key IDs for
> individually addressed frames are in use), and the different MGTKs would
> contend for the single remaining Key ID upon rollover."

Please note that this is is an informative note and not normative part
of the standard. IMHO, that note is not accurate and it looks likely
that it was added without full understanding on how the keys are used in
the standard..

> I got the impression Extended Key IDs were  added without updating all
> sections which should get updates. But the pattern is suspect, even the igtk
> numbers fit into the pattern:
> 
>  PTK 0 & 1
>  GTK 1 & 2 & 3
> iGTK 4 & 5

An AP is allowed to do this, but there is no requirement for doing so.
The pairwise key (TK, not PTK) is required to use Key ID 0 unless the
optional Extended Key ID for Individually Addressed Frames capability is
negotiated (and 0 or 1 if that capability is negotiated). Group keys
(GTK) are allowed to use Key IDs 0..4. IGTKs are allowed to use Key ID
values 4 and 5.

There is a long history behind this and some de facto constraints due to
that history and possible implementation constraints. However, as far as
the protocol itself is concerned, there would be no real need for having
IGTK use 4..5; it could have as well been 0..1 or 1..2 or whatever
combination the AP would like to use.

These three cases have completely independent namespaces for Key IDs as
far as RSN is concerned with one exception: "Use group cipher suite"
that was added as an option for some AP implementation that did not
support individual key mapping. That special case would end up using GTK
for both group-addressed and individually-addressed frames. That said,
I'm not aware of there having ever been an actually deployed device with
this constraint and even if there were, this mode is highly discouraged
and should not be used for anything today. Anyway, this exception and
similar implementation constraints are likely behind the expectations of
TK and GTK having to use different Key ID values.

As far as the kernel changes are concerned, cfg80211 and mac80211 should
support everything that's allowed by the standard, i.e., use of Key IDs
0..3 for GTK. It is up to the user space implementation on the AP side
(e.g., hostapd) to select which Key IDs are actually taken into use.

-- 
Jouni Malinen                                            PGP id EFC895FA
