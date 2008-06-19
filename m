Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:3488 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbYFSNIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 09:08:01 -0400
Received: by py-out-1112.google.com with SMTP id p76so271573pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 06:08:01 -0700 (PDT)
Message-ID: <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com> (sfid-20080619_150811_894315_573ADDE8)
Date: Thu, 19 Jun 2008 16:08:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Broken fragmentation
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1213878207.8967.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213869365.1312.48.camel@johannes.berg>
	 <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com>
	 <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 3:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Now it crashes in the driver...maybe the txinfo to cb changes. Looking into it.
>> > Tomas
>> Looks like this is the second part keyconf is null
>
> Part? You mean fragment? What encryption algorithm? I've quickly looked
> and all of them seem to do the control.hw_key assignment in their
> respective _skb handler so it should be done for all fragments.

The problem is w/o crypto
I think this is not set on each fragment
info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;

Tomas

> johannes
>
