Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40770 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2CRQLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 12:11:35 -0400
Received: by iagz16 with SMTP id z16so8146360iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2012 09:11:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331901642.6753.1.camel@jlt3.sipsolutions.net>
References: <1331923430-23861-1-git-send-email-yeohchunyeow@gmail.com>
	<1331901642.6753.1.camel@jlt3.sipsolutions.net>
Date: Mon, 19 Mar 2012 00:11:34 +0800
Message-ID: <CAEFj9861XC5rvBBB3DxLaPDrYFz7FECA82KpEF+L6rMsK1F6Sw@mail.gmail.com> (sfid-20120318_171138_856656_C61EFF09)
Subject: Re: [PATCH] mac80211: fix the endianness problem of HWMP sequence
 number in RANN propagation
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

>
> You should mark struct ieee80211_rann_ie to contain __le32, so that
> sparse will warn about things like this.
>

I try to change u32 to __le32 for the following members in struct
ieee80211_rann_ie.

struct ieee80211_rann_ie {
        u8 rann_flags;
        u8 rann_hopcount;
        u8 rann_ttl;
        u8 rann_addr[6];
        __le32 rann_seq;
        __le32 rann_interval;
        __le32 rann_metric;
} __attribute__ ((packed));

But when I compile using "make C=2 CF=-D__CHECK_ENDIAN__", I don't see
any sparse warning on this.

Please advice. Thanks

Regards,
Chun-Yeow
