Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752450AbdHOHQZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 03:16:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "jouni\@qca.qualcomm.com" <jouni@qca.qualcomm.com>,
        "avinashp\@quantenna.com" <avinashp@quantenna.com>,
        "smatyukevich\@quantenna.com" <smatyukevich@quantenna.com>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
        "imitsyanko\@quantenna.com" <imitsyanko@quantenna.com>
Subject: Re: [PATCH] nl80211: add an option to allow MFP without requiring it
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
        <87lgmmt6l7.fsf@purkki.adurom.net> <1502734400.3282.4.camel@intel.com>
Date: Tue, 15 Aug 2017 10:16:17 +0300
In-Reply-To: <1502734400.3282.4.camel@intel.com> (Emmanuel Grumbach's message
        of "Mon, 14 Aug 2017 18:13:22 +0000")
Message-ID: <8760dpb8se.fsf@kamboji.qca.qualcomm.com> (sfid-20170815_091628_814427_A04D8C73)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> On Mon, 2017-08-14 at 20:14 +0300, Kalle Valo wrote:
>> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>>=20
>> > User space can now allow the kernel to associate to an AP
>> > that requires MFP or that doesn't have MFP enabled in the
>> > same NL80211_CMD_CONNECT command.
>> > The driver / firmware will decide whether to use it or not.
>> >=20
>> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[...]

>> > --- a/net/wireless/nl80211.c
>> > +++ b/net/wireless/nl80211.c
>> > @@ -9115,6 +9115,7 @@ static int nl80211_connect(struct sk_buff
>> > *skb, struct genl_info *info)
>> > =C2=A0	if (info->attrs[NL80211_ATTR_USE_MFP]) {
>> > =C2=A0		connect.mfp =3D nla_get_u32(info-
>> > >attrs[NL80211_ATTR_USE_MFP]);
>> > =C2=A0		if (connect.mfp !=3D NL80211_MFP_REQUIRED &&
>> > +		=C2=A0=C2=A0=C2=A0=C2=A0connect.mfp !=3D NL80211_MFP_OPTIONAL &&
>> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0connect.mfp !=3D NL80211_MFP_NO)
>> > =C2=A0			return -EINVAL;
>> > =C2=A0	} else {
>>=20
>> I guess I'm missing something, but how is backwards compatibility
>> supposed to work from user space point of view? If user space uses
>> NL80211_MFP_OPTIONAL with an old kernel, the kernel will reject the
>> command with -EINVAL and user space will try again without
>> NL80211_MFP_OPTIONAL?
>
> No you are not. I simply forgot that point. I guess that this would be
> the behavior, yes...

I don't think that's very robust. How would user space (wpasupplicant)
know if the the EINVAL is because NL80211_MFP_OPTIONAL is not supported
by the kernel or because of some other error?

> This is relevant for ap_scan=3D2 wpa_s configuration only which makes it
> not really common, but still, you are right. Not sure how easy it will
> be to write this logic in the supplicant though... Unless we add an
> nl80211 feature bit but I feel it'd be a bit of a waste.

I don't feel that adding a feature bit is waste, I rather use a feature
flag than making ugly hacks to user space. But of course this is up to
Jouni and Johannes.

--=20
Kalle Valo
