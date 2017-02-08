Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34537 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdBHG1M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 01:27:12 -0500
Received: by mail-wr0-f195.google.com with SMTP id 89so7744213wrr.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 22:26:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3e57f30c29254db4a906e3e71ac36da5@SC-EXCH02.marvell.com>
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
 <CALLGbRLXa5m+eRhZpvWKyXkemB0qAkB=eoQKwns-vP29+izV+Q@mail.gmail.com>
 <CACna6rzKWAz_xxi=ehKijGtM4XEcioSjwmb=V0rq_vKioiS=Ew@mail.gmail.com> <3e57f30c29254db4a906e3e71ac36da5@SC-EXCH02.marvell.com>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 7 Feb 2017 22:26:17 -0800
Message-ID: <CALLGbRJ9h5fvS+DLOBGTcejW8yiwFW-xey+TaubauH2rZuVWwQ@mail.gmail.com> (sfid-20170208_072847_880364_BE451B37)
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
To: David Lin <dlin@marvell.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 7, 2017 at 10:15 PM, David Lin <dlin@marvell.com> wrote:
>> Rafa=C5=82 Mi=C5=82ecki [mailto:zajec5@gmail.com] wrote:
>> On 7 February 2017 at 20:12, Steve deRosier <derosier@gmail.com> wrote:
>> >> + /* look for all matching property names */
>> >> + for_each_property_of_node(priv->dt_node, prop) { if
>> >> + (strcmp(prop->name, "marvell,2ghz") =3D=3D 0)
>> >> + priv->disable_2g =3D true;
>> >> + if (strcmp(prop->name, "marvell,5ghz") =3D=3D 0)
>> >> + priv->disable_5g =3D true;
>> >> + if (strcmp(prop->name, "marvell,chainmask") =3D=3D 0) { prop_value =
=3D
>> >> + be32_to_cpu(*((__be32 *)prop->value)); if (prop_value =3D=3D 2)
>> >> + priv->antenna_tx =3D ANTENNA_TX_2;
>> >> +
>> >> + prop_value =3D be32_to_cpu(*((__be32 *) (prop->value + 4))); if
>> >> + (prop_value =3D=3D 2)
>> >> + priv->antenna_rx =3D ANTENNA_RX_2;
>> >> + }
>> >> + }
>> >> +
>> >> + priv->pwr_node =3D of_find_node_by_name(priv->dt_node,
>> >> +      "marvell,powertable");
>> >> +#endif
>> >> +}
>> >
>> > AFAICT, there's no documentation for these DT bindings. The mwlwifi
>> > node and the marvell,powertable both need full documentation in
>> > Documentation/devicetree/bindings/... .
>> >
>> > Frankly I have a feeling I'm going to need these DT nodes and I'd like
>> > to not have to guess-and-check based on the code.
>>
>> Please use ieee80211-freq-limit:
>> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?=
id=3Db3
>> 30b25eaabda00d74e47566d9200907da381896
>>
>> Most likely with wiphy_read_of_freq_limits helper:
>> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?=
id=3De6
>> 91ac2f75b69bee743f0370d79454ba4429b175
>
> I already replied meaning of these parameters:
> <marvell,2ghz> is used to disable 2g band.
> <marvell,5ghz> is used to disable 5g band.
> <marvell, chainmask> is used to specify antenna number (if default number=
 is suitable for you, there is no need to use this parameter).
> <marvell,powertable> should not be used for chip with device power table.=
 In fact, this parameter should not be used any more.
>

David, I think you're not understanding the comment, or at least
that's what it looks like to me. Yes, you did reply as to the meaning.
And, your reply, while informative, didn't tell us you understood and
were willing to fix the problem. I doubt you meant it this way, but it
feels defensive and like a brush-off.

First off, you will still have to document any DT bindings you're
adding. Just because you answer the question in the review doesn't
mean you're not responsible for doing so.

And second off, I think that Rafal (and sorry about my spelling, looks
like there's some sort of accent on the l that I don't know how to
make my keyboard do) is saying: there's already some generic bindings
that can be used to disable the 2g or 5g bands. Granted they're even
newer than your patch, but I do think if said bindings exist and are
appropriate, you should use them.

- Steve
