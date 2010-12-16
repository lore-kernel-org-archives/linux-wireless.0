Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55276 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0LPT6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 14:58:47 -0500
Received: by qwa26 with SMTP id 26so3619405qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:58:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292525806.3612.31.camel@jlt3.sipsolutions.net>
References: <1292524241-14837-1-git-send-email-javier@cozybit.com> <1292525806.3612.31.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 16 Dec 2010 11:58:24 -0800
Message-ID: <AANLkTimpmCdAx_8OqfqALwbWkX3NVaP98FzbxS4yJUFm@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Remove unused third address from mesh address
 extension header.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Thu, Dec 16, 2010 at 10:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 10:30 -0800, Javier Cardona wrote:
>> The Mesh Control header only includes 0, 1 or 2 addresses. If there is
>> one address, it should be interpreted as Address 4.  If there are 2,
>> they are interpreted as Addresses 5 and 6 (Address 4 being the 4th
>> address in the 802.11 header).
>
> Is this a draft change? Not sure I understand.

Yes, the address extension used to hold up to 3 addresses instead of
the current 2.  I don't recall the draft version when this changed,
but it is very unlikely that it will change again.  See section
7.1.3.6.3 in current draft (8.0).

Also, note that the extra address that I'm removing was not being
used.  I thought I better remove it before someone does start using
it.

Cheers,

Javier



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
