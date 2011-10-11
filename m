Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34615 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1JKLsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:48:02 -0400
Received: by ywb5 with SMTP id 5so6423257ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 04:48:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318332927.3965.9.camel@jlt3.sipsolutions.net>
References: <1318332535-8815-1-git-send-email-helmut.schaa@googlemail.com>
	<1318332927.3965.9.camel@jlt3.sipsolutions.net>
Date: Tue, 11 Oct 2011 13:48:02 +0200
Message-ID: <CAGXE3d8cuBg28PfMYQcAJ96oTEqUg6rG8ExUr+Sezq51eM2J_Q@mail.gmail.com> (sfid-20111011_134807_539636_FF030B7D)
Subject: Re: [PATCH] mac80211: Populate radiotap header with MCS info for
 tx'ed frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2011 at 1:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> So using something like
> this would allow us to save some space as well:
>
> struct ieee80211_tx_status_rtap_hdr {
>        struct ieee80211_radiotap_header hdr;
>        union {
>                struct {
>                        u8 rate;
>                        u8 padding_for_rate;
>                        __le16 tx_flags;
>                        u8 data_retries;
>                } non_mcs;
>                struct {
>                        __le16 tx_flags;
>                        u8 data_retries;
>                        u8 mcs_known, mcs_flags, mcs;
>                } mcs;
>        }
> } __packed;

I thought about the same but this means we have to fill in
different fields (non_mcs.tx_flags vs mcs.tx_flags) for the MCS
vs legacy path and set the radiotap header len differently in
both cases.

Or should we just get rid of the whole struct and fill in the
rtap header dynamically like it is done in the rx path and
drop the build-bug-on thing?

Helmut
