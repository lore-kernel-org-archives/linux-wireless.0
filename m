Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35910 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdKMIvw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 03:51:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johan Hovold <johan@kernel.org>
CC: "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: [PATCH] wcn36xx: fix iris child-node lookup
Date: Mon, 13 Nov 2017 08:51:49 +0000
Message-ID: <87po8m7e8s.fsf@qca.qualcomm.com> (sfid-20171113_095210_310724_6BC1DFBB)
References: <20171111170532.6110-1-johan@kernel.org>
In-Reply-To: <20171111170532.6110-1-johan@kernel.org> (Johan Hovold's message
        of "Sat, 11 Nov 2017 18:05:32 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johan Hovold <johan@kernel.org> writes:

> Fix child-node lookup during probe, which ended up searching the whole
> device tree depth-first starting at the parent rather than just matching
> on its children.
>
> To make things worse, the parent mmio node was also prematurely freed.
>
> Fixes: fd52bdae9ab0 ("wcn36xx: Disable 5GHz for wcn3620")

fd52bdae9ab0 is in net-next right now so the first release for that
commit should be v4.15-rc1.

> Cc: stable <stable@vger.kernel.org>     # 4.14

As fd52bdae9ab0 is not in v4.14 no need to Cc stable. I'll remove it.

> Cc: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Thanks, I'll queue this to v4.15.

--=20
Kalle Valo=
