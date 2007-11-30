Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:65036 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633AbXK3QdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 11:33:20 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1904342nze
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2007 08:33:18 -0800 (PST)
Message-ID: <43e72e890711300833m20bb79ffof1cc228c6ec4922c@mail.gmail.com> (sfid-20071130_163323_154140_8B565F2F)
Date: Fri, 30 Nov 2007 11:33:17 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: don't use if_id, use if_priv
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1196423301.6058.187.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196423301.6058.187.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 30, 2007 6:48 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Here's a non-functioning (except for b43/b43legacy) patch that gets rid
> of the if_id stuff all over in favour of a new if_priv pointer.
>
> This has two advantages:
>  * no more looking up interfaces by if_id, this is better for network
>    namespaces and performance
>  * allows drivers to store and retrieve per-interface data without
>    having to allocate own lists/hash tables
>
> and a small disadvantage:
>  * storage size can increase by four bytes on 64-bit machines.
>
> Comments welcome. I'll be improving this and making it at least compile
> with all other drivers.

What will ieee80211_sub_if_data's if_priv look like?

>  Maybe "struct if_priv" should be renamed?

Yeah, hm... mac80211_priv, iw_priv, subif_priv??

  Luis
