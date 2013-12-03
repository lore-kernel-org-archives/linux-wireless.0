Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37918 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3LCJU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 04:20:26 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so6160432wib.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 01:20:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 Dec 2013 14:50:05 +0530
Message-ID: <CABPxzYJfBG0YtCrfkg_PqV4MP+MdLePhD2QdFQF9D+EfPObnZQ@mail.gmail.com> (sfid-20131203_102035_600752_954AB66F)
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, j@w1.fi,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 3, 2013 at 12:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The GTK is shared by all stations in an 802.11 BSS and as such any
> one of them can send forged group-addressed frames. To prevent this
> kind of attack, drop unicast IP packets if they were protected with
> the GTK, i.e. were multicast packets at the 802.11 layer.
>
> Based in part on a patch by Jouni that did the same but in the IP
> stack, which was considered too intrusive.
>
As per RFC 1122 this is an invalid case:
         When a host sends a datagram to a link-layer broadcast address,
         the IP destination address MUST be a legal IP broadcast or IP
         multicast address.

         A host SHOULD silently discard a datagram that is received via
         a link-layer broadcast (see Section 2.4) but does not specify
         an IP multicast or broadcast destination address.

We can simply drop this frame irrespective of GTK/PTK is used.
