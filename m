Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51951 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbbCCPoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 10:44:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jonas Gorski <jogo@openwrt.org>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH][FIX][RESEND] b43: fix support for 5 GHz only BCM43228 model
References: <1424103816-10566-1-git-send-email-zajec5@gmail.com>
	<1425313135-28225-1-git-send-email-zajec5@gmail.com>
	<87k2yy86ld.fsf@kamboji.qca.qualcomm.com>
	<CAOiHx==ZbVCsymBFhn60nBU2-gHU2HPdp1T9xdZpK9OVjAzFUw@mail.gmail.com>
Date: Tue, 03 Mar 2015 17:44:25 +0200
In-Reply-To: <CAOiHx==ZbVCsymBFhn60nBU2-gHU2HPdp1T9xdZpK9OVjAzFUw@mail.gmail.com>
	(Jonas Gorski's message of "Tue, 3 Mar 2015 16:38:54 +0100")
Message-ID: <87fv9m84rq.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_164438_454080_0DCB3D4A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonas Gorski <jogo@openwrt.org> writes:

> On Tue, Mar 3, 2015 at 4:05 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> RESEND: It seems patchwork didn't catch my patch. Trying again.
>>
>> Odd, I still don't see it in patchwork. I wonder what caused that?
>
> I also see it neither in my b43-dev nor linux-wireless archives, nor
> does google find it (only your reply).

Ok, that explains why patchwork didn't catch it (it scans patches from
the linux-wireless mailing list). I already applied the patch to
wireless-drivers.git but I would appreciate if people would still review
it:

commit 0ff66cffde47de51c155ebdd2356403276c04cc4
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Mon Mar 2 17:18:55 2015 +0100

    b43: fix support for 5 GHz only BCM43228 model
    
    It was incorrectly detected as 2 GHz device.
    
    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
    Cc: stable@vger.kernel.org # 3.17+
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index ccbdb05b28cd..75345c1e8c34 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5370,6 +5370,7 @@ static void b43_supported_bands(struct b43_wldev *dev, bool *have_2ghz_phy,
 	case 0x432a: /* BCM4321 */
 	case 0x432d: /* BCM4322 */
 	case 0x4352: /* BCM43222 */
+	case 0x435a: /* BCM43228 */
 	case 0x4333: /* BCM4331 */
 	case 0x43a2: /* BCM4360 */
 	case 0x43b3: /* BCM4352 */


-- 
Kalle Valo
