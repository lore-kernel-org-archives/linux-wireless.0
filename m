Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37336 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbeHNN7m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 09:59:42 -0400
Message-ID: <1534245118.3547.18.camel@sipsolutions.net> (sfid-20180814_131303_339421_811029D4)
Subject: Re: [PATCH] mac80211: ignore SA Query Requests with unknown payload
 data
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>,
        linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Date: Tue, 14 Aug 2018 13:11:58 +0200
In-Reply-To: <20180806224857.14853-1-Mathy.Vanhoef@cs.kuleuven.be>
References: <20180806224857.14853-1-Mathy.Vanhoef@cs.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-07 at 00:48 +0200, Mathy Vanhoef wrote:
> When operating in station mode, ignore SA Query Request frames that
> contain extra payload data. The kernel doesn't know how to handle these
> frames. Instead, give userspace a chance to handle these frames.
> 
> For example, with Operating Channel Validation, SA Query Requests may
> now contain an extra Operating Channel Information (OCI) element as
> payload data. The kernel should ignore these frames, since it does not
> know how to properly handle them. Instead, let userspace process these
> frames.
> 
> Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
> ---
> For background on Operating Channel Validation, see:
> https://mentor.ieee.org/802.11/dcn/17/11-17-1807-12-000m-defense-against-multi-channel-mitm-attacks-via-operating-channel-validation.docx
> 
> A corresponding patchset was also recently submitted to Hostap, see "Add
> support for Operating Channel Validation (OCV)".

In a perfect world, this seems fine. However, what if wpa_s doesn't
implement this (yet)? In that case, wouldn't it be better (or really
required) to still respond to the SA query request in the kernel?

Since you change wpa_s to subscribe to the relevant action frame:

> +       /* SA Query Request */
> +       if (nl80211_register_action_frame(bss, (u8 *) "\x08\x00", 2) < 0)
> +               ret = -1;

we could change the logic to be

if (!frame_includes_OCV || !cfg80211_rx_mgmt(...))
	respond_in_kernel();

I also think we shouldn't necessarily punt too short or otherwise
malformed frames to userspace, what's the point? We currently
drop/ignore those, and can continue to do so afaict?

johannes
