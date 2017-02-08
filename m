Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35500 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753422AbdBHGH0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 01:07:26 -0500
Received: by mail-ot0-f194.google.com with SMTP id 65so16938748otq.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 22:07:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALLGbRLXa5m+eRhZpvWKyXkemB0qAkB=eoQKwns-vP29+izV+Q@mail.gmail.com>
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com> <CALLGbRLXa5m+eRhZpvWKyXkemB0qAkB=eoQKwns-vP29+izV+Q@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 8 Feb 2017 07:07:25 +0100
Message-ID: <CACna6rzKWAz_xxi=ehKijGtM4XEcioSjwmb=V0rq_vKioiS=Ew@mail.gmail.com> (sfid-20170208_070848_675954_7BF7623A)
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
To: Steve deRosier <derosier@gmail.com>
Cc: David Lin <dlin@marvell.com>, Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 February 2017 at 20:12, Steve deRosier <derosier@gmail.com> wrote:
>> + /* look for all matching property names */
>> + for_each_property_of_node(priv->dt_node, prop) {
>> + if (strcmp(prop->name, "marvell,2ghz") == 0)
>> + priv->disable_2g = true;
>> + if (strcmp(prop->name, "marvell,5ghz") == 0)
>> + priv->disable_5g = true;
>> + if (strcmp(prop->name, "marvell,chainmask") == 0) {
>> + prop_value = be32_to_cpu(*((__be32 *)prop->value));
>> + if (prop_value == 2)
>> + priv->antenna_tx = ANTENNA_TX_2;
>> +
>> + prop_value = be32_to_cpu(*((__be32 *)
>> + (prop->value + 4)));
>> + if (prop_value == 2)
>> + priv->antenna_rx = ANTENNA_RX_2;
>> + }
>> + }
>> +
>> + priv->pwr_node = of_find_node_by_name(priv->dt_node,
>> +      "marvell,powertable");
>> +#endif
>> +}
>
> AFAICT, there's no documentation for these DT bindings. The mwlwifi node
> and the marvell,powertable both need full documentation in
> Documentation/devicetree/bindings/... .
>
> Frankly I have a feeling I'm going to need these DT nodes and I'd like to not
> have to guess-and-check based on the code.

Please use ieee80211-freq-limit:
https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=b330b25eaabda00d74e47566d9200907da381896

Most likely with wiphy_read_of_freq_limits helper:
https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=e691ac2f75b69bee743f0370d79454ba4429b175
