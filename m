Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17704 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdKAK61 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 06:58:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: ath: Incorrect regDomainPairs/allCountries settings
Date: Wed, 1 Nov 2017 10:58:22 +0000
Message-ID: <87k1zaxo36.fsf@kamboji.qca.qualcomm.com> (sfid-20171101_115830_828689_E9D25014)
References: <1693831.JqVThioVz9@bentobox>
In-Reply-To: <1693831.JqVThioVz9@bentobox> (Sven Eckelmann's message of "Tue,
        08 Aug 2017 11:45:38 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> I just had two inquiries from Vietnam and Singapore regarding the used CT=
L=20
> limits by Atheros based chips. I've checked through the code and noticed =
that=20
> regd_common.h assigns SG to APL6_WORLD and VN to NULL1_WORLD.
>
>  * SG: APL6_WORLD
>    - 2.4GHz: CTL_ETSI
>    -   5GHz: CTL_ETSI
>  * VN: NULL1_WORLD
>    - 2.4GHz: CTL_ETSI
>    -   5GHz: NO_CTL
>
> But I personally would have expected that both countries would be assigne=
d to=20
> FCC3_WORLD.
>
>  * FCC3_WORLD
>    - 2.4GHz: CTL_ETSI
>    -   5GHz: CTL_FCC
>
> Maybe someone from QCA can check with their internal driver.

I asked around and got this answer:

"Correct, internal code base assigns SG and VN to FCC3_WORLD regdomain,
CTL limits are assigned accordingly as he mentioned."

--=20
Kalle Valo=
