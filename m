Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25749 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbdALOaK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:30:10 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
Date: Thu, 12 Jan 2017 14:29:28 +0000
Message-ID: <20170112142926.GA19489@jouni.qca.qualcomm.com> (sfid-20170112_153014_338037_C8403431)
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
 <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
 <1484141491.29931.10.camel@sipsolutions.net>
 <20170112135843.GB17983@jouni.qca.qualcomm.com>
 <1484229979.5391.5.camel@sipsolutions.net>
In-Reply-To: <1484229979.5391.5.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2017 at 03:06:19PM +0100, Johannes Berg wrote:
> On Thu, 2017-01-12 at 13:58 +0000, Malinen, Jouni wrote:
> >=20
> > > I think this description is misleading - one could easily
> > > understand
> > > "for other cases" to indicate for the cases that the AP did
> > > explicitly
> > > reject it, but that's obviously not true.
> >=20
> > Well, the expectation here really was that the reason for the timeout
> > would be known if there was a timeout and the unspecified value would
> > be used in all other cases, i.e., in cases where the AP did indeed
> > explicitly reject the connection.
>=20
> Hmm. It doesn't really make sense to include the attribute in that case
> at all though, does it?

We don't.. This discussion here is about the C API where we cannot
remove the argument from the call without adding yet another inline
wrapper, but the actual function that generates the netlink message does
not add the timeout reason attribute for success or explicit rejection
cases.

> > Sure, I can say that NL80211_TIMEOUT_UNSPECIFIED is used when the
> > reason for the timeout is not known or there was an explicit
> > rejection instead of a timeout.
>=20
> See above - why even think about this attribute in the successful case?

See above.. C API. Or do you want yet another wrapper for
cfg80211_connect_bss() to be added while trying to hide
cfg80211_connect_bss() from drivers somehow?

> Fair enough. I still think we should not include the
> ATTR_TIMEOUT_REASON for the successful or explicit rejection case at
> all though. We can really even distinguish that in the low-level
> function, I think?

nl80211_send_connect_result() already does this:

        (status < 0 &&
         (nla_put_flag(msg, NL80211_ATTR_TIMED_OUT) ||
          nla_put_u32(msg, NL80211_ATTR_TIMEOUT_REASON, timeout_reason))) |=
|

That status =3D=3D -1 special case used to be internal special value within
cfg80211, but it gets exposed to drivers since we use
cfg80211_connect_bss() both internally and from drivers instead of
having separate wrappers for drivers for cases where the bss entry is
explicitly specified.

--=20
Jouni Malinen                                            PGP id EFC895FA=
