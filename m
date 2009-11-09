Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43113 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZKINYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 08:24:20 -0500
Received: by bwz27 with SMTP id 27so3437293bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 05:24:25 -0800 (PST)
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com> <1257770381-7680-12-git-send-email-rpaulo@gmail.com> <1257771552.29454.171.camel@johannes.local>
In-Reply-To: <1257771552.29454.171.camel@johannes.local>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Message-Id: <B2865F30-1886-4985-AB76-2AAB769530F4@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>
From: Rui Paulo <rpaulo@gmail.com>
Subject: Re: [PATCH 11/21] mac80211: add WLAN_EID_RANN
Date: Mon, 9 Nov 2009 13:24:21 +0000
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 9 Nov 2009, at 12:59, Johannes Berg wrote:

> On Mon, 2009-11-09 at 12:39 +0000, Rui Paulo wrote:
>> Process the RX of RANN information elements.
>
> That commit log is not really right.

You're right. Is "Parse the RANN information element" a better one?

>> +	WLAN_EID_RANN = 49,	/* compatible with FreeBSD */
>> 	/* 802.11h */
>> 	WLAN_EID_PWR_CONSTRAINT = 32,
>> 	WLAN_EID_PWR_CAPABILITY = 33,
>
> I'd definitely prefer if here you added a 17-byte long struct that
> explains the layout of the IE, and then used that in patch 12. Also  
> it's
> probably useful to check the length directly in  
> ieee802_11_parse_elems.

I prefer structures describing the IE layout too, but I was following  
the mesh code on this. If structure layouts are preferable, then there  
are 4 mesh IEs that should probably be changed.

Regarding to the length check, I was also following the way the mesh  
code does it. Again, if we want to change RANN, we should probably  
also change PREQ, PREP and PERR.

Thanks,
--
Rui Paulo

