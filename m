Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58058 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbbCCPuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 10:50:25 -0500
MIME-Version: 1.0
In-Reply-To: <87fv9m84rq.fsf@kamboji.qca.qualcomm.com>
References: <1424103816-10566-1-git-send-email-zajec5@gmail.com>
 <1425313135-28225-1-git-send-email-zajec5@gmail.com> <87k2yy86ld.fsf@kamboji.qca.qualcomm.com>
 <CAOiHx==ZbVCsymBFhn60nBU2-gHU2HPdp1T9xdZpK9OVjAzFUw@mail.gmail.com> <87fv9m84rq.fsf@kamboji.qca.qualcomm.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 3 Mar 2015 16:49:56 +0100
Message-ID: <CAOiHx==Br=rzsXavM=hN99hPUi_rEKjoYfT2+JFy-Jb5+Ex0xw@mail.gmail.com> (sfid-20150303_165029_057227_CDD8D551)
Subject: Re: [PATCH][FIX][RESEND] b43: fix support for 5 GHz only BCM43228 model
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 3, 2015 at 4:44 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Jonas Gorski <jogo@openwrt.org> writes:
>
>> On Tue, Mar 3, 2015 at 4:05 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>> RESEND: It seems patchwork didn't catch my patch. Trying again.
>>>
>>> Odd, I still don't see it in patchwork. I wonder what caused that?
>>
>> I also see it neither in my b43-dev nor linux-wireless archives, nor
>> does google find it (only your reply).
>
> Ok, that explains why patchwork didn't catch it (it scans patches from
> the linux-wireless mailing list). I already applied the patch to
> wireless-drivers.git but I would appreciate if people would still review
> it:
>
> commit 0ff66cffde47de51c155ebdd2356403276c04cc4
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Mon Mar 2 17:18:55 2015 +0100
>
>     b43: fix support for 5 GHz only BCM43228 model
>
>     It was incorrectly detected as 2 GHz device.
>
>     Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>     Cc: stable@vger.kernel.org # 3.17+
>     Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index ccbdb05b28cd..75345c1e8c34 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -5370,6 +5370,7 @@ static void b43_supported_bands(struct b43_wldev *dev, bool *have_2ghz_phy,
>         case 0x432a: /* BCM4321 */
>         case 0x432d: /* BCM4322 */
>         case 0x4352: /* BCM43222 */
> +       case 0x435a: /* BCM43228 */

Broadcom agrees with that (taken from a broadcom sdk for bcm47xx):

#define BCM43228_D11N_ID        0x4359          /* 43228 802.11n
DualBand device */
#define BCM43228_D11N5G_ID      0x435a          /* 43228 802.11n 5GHz device */


If that's enough for you, feel free to add a Reviewed-By from me.


Jonas
