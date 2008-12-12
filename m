Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:55749 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbYLLWvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:51:04 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1584601rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:51:02 -0800 (PST)
Message-ID: <69e28c910812121451u25713c82o229a56006089edd6@mail.gmail.com> (sfid-20081212_235107_586324_47D1D8D9)
Date: Fri, 12 Dec 2008 23:51:02 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and F_TX_NOSEQ Radiotap TX flags
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1229121947.3565.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 <1229121558.3565.6.camel@johannes.berg>
	 <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com>
	 <1229121947.3565.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 11:45 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-12-12 at 23:43 +0100, Stefanik G=E1bor wrote:
>
>> I tried, but for some reason setting IEEE80211_TX_CTL_NO_ACK directl=
y
>> in __ieee80211_parse_tx_radiotap resulted in an oops upon unloading
>> the driver module.
>
> Huh? That doesn't make sense. Do you have more information on that?
>
>> Note that IEEE80211_TX_MON_NO_ACK is not equivalent to
>> !(IEEE80211_TX_CTL_ASSIGN_SEQ), as it also disables mac80211's built
>> in sequence numbering.
>
> Ah. But there's precedence for just doing
>
> if (unlikely(!(info->flags & ASSIGN_SEQ)))
>        return;
>
> in the handler that assigns the seq, and I prefer that over adding a =
new
> flag.
>
> johannes
>

But if we redefine !ASSIGN_SEQ to mean "use the sequence number
supplied by userspace", we will need a new flag to distinguish between
driver-level vs. stack-level sequence number assignments, which is
essentially the same as this patch. There is no way to switch between
3 states (control in driver, stack or userspace) using only one bit.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
