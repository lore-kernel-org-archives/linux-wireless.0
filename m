Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2DAC2F425
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6FB02085A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="TlOP649D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfAUOl0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 09:41:26 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:40980 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbfAUOlR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 09:41:17 -0500
Received: by mail-ua1-f66.google.com with SMTP id z24so6958455ual.8
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2019 06:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kqmp7wi8kNIRbVhXAsqOXat4glJcWecSXxhkinoXM38=;
        b=TlOP649DDcYkneTBnWDrwS8E/TSYICZpmABMI9rW2ZnAiDlAslZwO9fUn7apYT/VuN
         iAndVc1qQb/g7DjccHL/FZxHmO6uXbelX2RNaRX4c1TxO90S/SyVquPNEypiNcfw0+Ns
         tzTV92iG29n3Na9SE/Q32YndIghyCe+PgsX+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kqmp7wi8kNIRbVhXAsqOXat4glJcWecSXxhkinoXM38=;
        b=hhvFy0n8dEDlvsdLObqyLt8Bx/dA3xWAtDKWWYWPToKMJBvUpwbTrajKvanv1HTjZI
         MIX4+g/oGg8MP1vdkJv+6pTIrUt3g6bT008YUkzTLt3z++k0tjXXYiZeX7nQOtwvfRV3
         fW9oeOQU7WTDoyXaXok9Bfy72PK7TMUY57N3VG2g852Px1RuN4VM3o9YX/KMpEgQ6w7g
         /p5sqV2xno09oyhZ43aIbFbbJaqUnvpBTWXvmmes75BrNHwycls9wttQa8EueRGcMADp
         DkKCRSqVyaVCqNuKw7xPpFXnIETm0LsPC7EzuKYZ/dT+xD/MACMAhBTCaQSf3cKnnVLl
         22Tw==
X-Gm-Message-State: AJcUukecHOGZm7A1j0XBsZeus7XS5F5w8BeF+Rg6eLnmrKgNwyCBZSPa
        e3xjLIsXwv/knuWeLGVmOETG920EFVT7yKj1qL0pvw==
X-Google-Smtp-Source: ALg8bN43f9QvrAF7Wsx0kjn4nfqpR33FUY0j4QyHNxKY4I/ipvft334Wn0kSqjQNEXkQ+LCGWeYrCQ+nMsCu2OmHYCU=
X-Received: by 2002:ab0:31d5:: with SMTP id e21mr12108721uan.107.1548081675413;
 Mon, 21 Jan 2019 06:41:15 -0800 (PST)
MIME-Version: 1.0
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
 <258ecb6b-c2b2-c8b8-9804-4df69002d9f5@web.de> <CAPDyKFoqfyvQRnSBRvPVxrL-nmf1YoSzxRkPfGwr==L3LOwgaw@mail.gmail.com>
 <5bf8514a-eb15-b098-1857-835b36d4a67c@web.de> <CAPDyKFo=m50jiQ639xzP9tzn+=Bn0CXXwO6p0_jPH0EnSc0UQg@mail.gmail.com>
In-Reply-To: <CAPDyKFo=m50jiQ639xzP9tzn+=Bn0CXXwO6p0_jPH0EnSc0UQg@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 21 Jan 2019 15:40:38 +0100
Message-ID: <CAPDyKFrt3+i83x_qyTrVVCSxda_+3HpJPR6RuPBxzRHnZTRVvA@mail.gmail.com>
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000058e291057ff8da6b"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--00000000000058e291057ff8da6b
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Jan 2019 at 16:09, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Fri, 18 Jan 2019 at 13:09, Jan Kiszka <jan.kiszka@web.de> wrote:
> >
> > On 17.01.19 10:54, Ulf Hansson wrote:
> > > On Wed, 16 Jan 2019 at 21:26, Jan Kiszka <jan.kiszka@web.de> wrote:
> > >>
> > >> On 16.01.19 12:37, Ulf Hansson wrote:
> > >>> During "wlan-up", we are programming the FW into the WiFi-chip. However,
> > >>> re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> > >>> is made in-between the programmings.
> > >>>
> > >>> To conform to this requirement and to fix the regression in a simple way,
> > >>> let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> > >>> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> > >>> current code is to treat this scenario as an error, but unfortunate this
> > >>> doesn't work as expected, so let's fix this.
> > >>>
> > >>> The other part is to guarantee that a power cycle of the SDIO card has been
> > >>> completed when wl12xx_sdio_power_on() returns, as to allow the FW
> > >>> programming to succeed. However, relying solely on runtime PM to deal with
> > >>> this isn't sufficient. For example, userspace may prevent runtime suspend
> > >>> via sysfs for the device that represents the SDIO card, leading to that the
> > >>> mmc core also keeps it powered on. For this reason, let's instead do a
> > >>> brute force power cycle in wl12xx_sdio_power_on().
> > >>>
> > >>> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> > >>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > >>> ---
> > >>>
> > >>> Changes in v2:
> > >>>        - Keep the SDIO host claimed when calling mmc_hw_reset().
> > >>>        - Add a fixes tag.
> > >>> ---
> > >>>    drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
> > >>>    1 file changed, 7 insertions(+), 8 deletions(-)
> > >>>
> > >>> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> > >>> index bd10165d7eec..4d4b07701149 100644
> > >>> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> > >>> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> > >>> @@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
> > >>>        }
> > >>>
> > >>>        sdio_claim_host(func);
> > >>> +     /*
> > >>> +      * To guarantee that the SDIO card is power cycled, as required to make
> > >>> +      * the FW programming to succeed, let's do a brute force HW reset.
> > >>> +      */
> > >>> +     mmc_hw_reset(card->host);
> > >>> +
> > >>>        sdio_enable_func(func);
> > >>>        sdio_release_host(func);
> > >>>
> > >>> @@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
> > >>>    {
> > >>>        struct sdio_func *func = dev_to_sdio_func(glue->dev);
> > >>>        struct mmc_card *card = func->card;
> > >>> -     int error;
> > >>>
> > >>>        sdio_claim_host(func);
> > >>>        sdio_disable_func(func);
> > >>>        sdio_release_host(func);
> > >>>
> > >>>        /* Let runtime PM know the card is powered off */
> > >>> -     error = pm_runtime_put(&card->dev);
> > >>> -     if (error < 0 && error != -EBUSY) {
> > >>> -             dev_err(&card->dev, "%s failed: %i\n", __func__, error);
> > >>> -
> > >>> -             return error;
> > >>> -     }
> > >>> -
> > >>> +     pm_runtime_put(&card->dev);
> > >>>        return 0;
> > >>>    }
> > >>>
> > >>>
> > >>
> > >> Just tested on both HiKey (620) and Ultra96 but it fails to fix the issue on
> > >> both. I'm getting
> > >>
> > >> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> > >>
> > >> during boot again, and the interface is not available.
> > >
> > > Okay, sounds like this may be a different problem then. Can you share
> > > the complete log and the kernel config?
> >
> > You can find the config here [1], log from the HiKey boot attached.
> >
> > > I can prepare a debug patch as well, if you are willing to re-run the test?
> >
> > Sure, send it over, I can run it.
>
> Alright, sounds great. However, I need to defer that to Monday/Tuesday
> next week.
>
> >
> > >
> > > Adding a post-power-on-delay-ms of 1 ms as you suggested [1], doesn't
> > > sounds like the correct solution to me, unless I am overlooking some
> > > things. The point is, since the mmc core succeeds to detect and
> > > initialize the SDIO card, the power sequence seems to be correct.
> >
> > Yeah, I'm not claiming at all I know what I'm doing there, just that it happens
> > to work.
>
> I see. Good to know, thanks!
>
> >
> > Jan
> >
> > [1]
> > https://github.com/siemens/jailhouse-images/blob/next/recipes-kernel/linux/files/arm64_defconfig_4.19
>
> I have looked through the log and the defconfig. No obvious things
> found at this point. Thanks for sharing them!
>

So, I have put together a debug patch, mostly to verify that things
seems to be correct in regards to runtime PM. It should produce some
prints to the log, particular during power on/off of the SDIO card and
during probe of the wifi driver. Please re-run the test on top of the
v2 version of the $subject patch.

Kind regards
Uffe

--00000000000058e291057ff8da6b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-wlcore-sdio-mmc-Debug-for-runtime-PM-and-power-on-of.patch"
Content-Disposition: attachment; 
	filename="0001-wlcore-sdio-mmc-Debug-for-runtime-PM-and-power-on-of.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jr6ftz4w0>
X-Attachment-Id: f_jr6ftz4w0

RnJvbSBlZjc4OTA0NjNhZTliZWM4ZmFiN2QxNjQ0ODY4MTkyMzczNjcwNmUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBVbGYgSGFuc3NvbiA8dWxmLmhhbnNzb25AbGluYXJvLm9yZz4K
RGF0ZTogTW9uLCAyMSBKYW4gMjAxOSAxNTozMTo1NyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHds
Y29yZS9zZGlvL21tYzogRGVidWcgZm9yIHJ1bnRpbWUgUE0gYW5kIHBvd2VyIG9uL29mZiBvZgog
U0RJTwoKU2lnbmVkLW9mZi1ieTogVWxmIEhhbnNzb24gPHVsZi5oYW5zc29uQGxpbmFyby5vcmc+
Ci0tLQogZHJpdmVycy9tbWMvY29yZS9wd3JzZXFfc2ltcGxlLmMgICAgICB8ICAyICsrCiBkcml2
ZXJzL21tYy9jb3JlL3NkaW8uYyAgICAgICAgICAgICAgIHwgMTkgKysrKysrKysrKysrKysrKyst
LQogZHJpdmVycy9tbWMvY29yZS9zZGlvX2J1cy5jICAgICAgICAgICB8IDI2ICsrKysrKysrKysr
KysrKysrKysrKysrLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy90aS93bGNvcmUvc2Rpby5jIHwg
MjcgKysrKysrKysrKysrKysrKysrKysrKysrKystCiA0IGZpbGVzIGNoYW5nZWQsIDY4IGluc2Vy
dGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvY29yZS9w
d3JzZXFfc2ltcGxlLmMgYi9kcml2ZXJzL21tYy9jb3JlL3B3cnNlcV9zaW1wbGUuYwppbmRleCBl
Y2UzNGM3MzQ2OTMuLmI5YjFmYzczYTVhMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9tbWMvY29yZS9w
d3JzZXFfc2ltcGxlLmMKKysrIGIvZHJpdmVycy9tbWMvY29yZS9wd3JzZXFfc2ltcGxlLmMKQEAg
LTY2LDYgKzY2LDcgQEAgc3RhdGljIHZvaWQgbW1jX3B3cnNlcV9zaW1wbGVfcHJlX3Bvd2VyX29u
KHN0cnVjdCBtbWNfaG9zdCAqaG9zdCkKIAlpZiAoIUlTX0VSUihwd3JzZXEtPmV4dF9jbGspICYm
ICFwd3JzZXEtPmNsa19lbmFibGVkKSB7CiAJCWNsa19wcmVwYXJlX2VuYWJsZShwd3JzZXEtPmV4
dF9jbGspOwogCQlwd3JzZXEtPmNsa19lbmFibGVkID0gdHJ1ZTsKKwkJZGV2X2luZm8obW1jX2Rl
dihob3N0KSwgIiVzIGNsa19wcmVwYXJlX2VuYWJsZSgpXG4iLCBfX2Z1bmNfXyk7CiAJfQogCiAJ
bW1jX3B3cnNlcV9zaW1wbGVfc2V0X2dwaW9zX3ZhbHVlKHB3cnNlcSwgMSk7CkBAIC05NCw2ICs5
NSw3IEBAIHN0YXRpYyB2b2lkIG1tY19wd3JzZXFfc2ltcGxlX3Bvd2VyX29mZihzdHJ1Y3QgbW1j
X2hvc3QgKmhvc3QpCiAJaWYgKCFJU19FUlIocHdyc2VxLT5leHRfY2xrKSAmJiBwd3JzZXEtPmNs
a19lbmFibGVkKSB7CiAJCWNsa19kaXNhYmxlX3VucHJlcGFyZShwd3JzZXEtPmV4dF9jbGspOwog
CQlwd3JzZXEtPmNsa19lbmFibGVkID0gZmFsc2U7CisJCWRldl9pbmZvKG1tY19kZXYoaG9zdCks
ICIlcyBjbGtfZGlzYWJsZV91bnByZXBhcmUoKVxuIiwgX19mdW5jX18pOwogCX0KIH0KIApkaWZm
IC0tZ2l0IGEvZHJpdmVycy9tbWMvY29yZS9zZGlvLmMgYi9kcml2ZXJzL21tYy9jb3JlL3NkaW8u
YwppbmRleCBkOGUxN2VhNjEyNmQuLmNlN2QyOWFkMjY1MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
bWMvY29yZS9zZGlvLmMKKysrIGIvZHJpdmVycy9tbWMvY29yZS9zZGlvLmMKQEAgLTEwMjksMTEg
KzEwMjksMTMgQEAgc3RhdGljIGludCBtbWNfc2Rpb19wb3dlcl9yZXN0b3JlKHN0cnVjdCBtbWNf
aG9zdCAqaG9zdCkKIAogc3RhdGljIGludCBtbWNfc2Rpb19ydW50aW1lX3N1c3BlbmQoc3RydWN0
IG1tY19ob3N0ICpob3N0KQogeworCWRldl9pbmZvKCZob3N0LT5jYXJkLT5kZXYsICIlc1xuIiwg
X19mdW5jX18pOwogCS8qIE5vIHJlZmVyZW5jZXMgdG8gdGhlIGNhcmQsIGN1dCB0aGUgcG93ZXIg
dG8gaXQuICovCiAJbW1jX2NsYWltX2hvc3QoaG9zdCk7CiAJbW1jX3Bvd2VyX29mZihob3N0KTsK
IAltbWNfcmVsZWFzZV9ob3N0KGhvc3QpOwogCisJZGV2X2luZm8oJmhvc3QtPmNhcmQtPmRldiwg
IiVzIC0gRE9ORVxuIiwgX19mdW5jX18pOwogCXJldHVybiAwOwogfQogCkBAIC0xMDQxLDE5ICsx
MDQzLDI3IEBAIHN0YXRpYyBpbnQgbW1jX3NkaW9fcnVudGltZV9yZXN1bWUoc3RydWN0IG1tY19o
b3N0ICpob3N0KQogewogCWludCByZXQ7CiAKKwlkZXZfaW5mbygmaG9zdC0+Y2FyZC0+ZGV2LCAi
JXNcbiIsIF9fZnVuY19fKTsKIAkvKiBSZXN0b3JlIHBvd2VyIGFuZCByZS1pbml0aWFsaXplLiAq
LwogCW1tY19jbGFpbV9ob3N0KGhvc3QpOwogCW1tY19wb3dlcl91cChob3N0LCBob3N0LT5jYXJk
LT5vY3IpOwogCXJldCA9IG1tY19zZGlvX3Bvd2VyX3Jlc3RvcmUoaG9zdCk7CiAJbW1jX3JlbGVh
c2VfaG9zdChob3N0KTsKIAorCWRldl9pbmZvKCZob3N0LT5jYXJkLT5kZXYsICIlcyAtIHJldD0l
ZCBET05FXG4iLCBfX2Z1bmNfXywgcmV0KTsKIAlyZXR1cm4gcmV0OwogfQogCiBzdGF0aWMgaW50
IG1tY19zZGlvX2h3X3Jlc2V0KHN0cnVjdCBtbWNfaG9zdCAqaG9zdCkKIHsKKwlpbnQgcmV0Owor
CisJZGV2X2luZm8oJmhvc3QtPmNhcmQtPmRldiwgIiVzXG4iLCBfX2Z1bmNfXyk7CiAJbW1jX3Bv
d2VyX2N5Y2xlKGhvc3QsIGhvc3QtPmNhcmQtPm9jcik7Ci0JcmV0dXJuIG1tY19zZGlvX3Bvd2Vy
X3Jlc3RvcmUoaG9zdCk7CisJcmV0ID0gbW1jX3NkaW9fcG93ZXJfcmVzdG9yZShob3N0KTsKKwor
CWRldl9pbmZvKCZob3N0LT5jYXJkLT5kZXYsICIlcyAtIHJldD0lZCBET05FXG4iLCBfX2Z1bmNf
XywgcmV0KTsKKwlyZXR1cm4gcmV0OwogfQogCiBzdGF0aWMgaW50IG1tY19zZGlvX3N3X3Jlc2V0
KHN0cnVjdCBtbWNfaG9zdCAqaG9zdCkKQEAgLTExNDIsNiArMTE1Miw4IEBAIGludCBtbWNfYXR0
YWNoX3NkaW8oc3RydWN0IG1tY19ob3N0ICpob3N0KQogCQkgKiBFbmFibGUgcnVudGltZSBQTSBm
b3IgdGhpcyBjYXJkCiAJCSAqLwogCQlwbV9ydW50aW1lX2VuYWJsZSgmY2FyZC0+ZGV2KTsKKwor
CQlkZXZfaW5mbygmY2FyZC0+ZGV2LCAiJXMgRW5hYmxlZCBydW50aW1lIFBNKClcbiIsIF9fZnVu
Y19fKTsKIAl9CiAKIAkvKgpAQCAtMTE4Myw4ICsxMTk1LDExIEBAIGludCBtbWNfYXR0YWNoX3Nk
aW8oc3RydWN0IG1tY19ob3N0ICpob3N0KQogCQkJZ290byByZW1vdmVfYWRkZWQ7CiAJfQogCi0J
aWYgKGhvc3QtPmNhcHMgJiBNTUNfQ0FQX1BPV0VSX09GRl9DQVJEKQorCisJaWYgKGhvc3QtPmNh
cHMgJiBNTUNfQ0FQX1BPV0VSX09GRl9DQVJEKSB7CisJCWRldl9pbmZvKCZjYXJkLT5kZXYsICIl
cyBwbV9ydW50aW1lX3B1dCgpXG4iLCBfX2Z1bmNfXyk7CiAJCXBtX3J1bnRpbWVfcHV0KCZjYXJk
LT5kZXYpOworCX0KIAogCW1tY19jbGFpbV9ob3N0KGhvc3QpOwogCXJldHVybiAwOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9tbWMvY29yZS9zZGlvX2J1cy5jIGIvZHJpdmVycy9tbWMvY29yZS9zZGlv
X2J1cy5jCmluZGV4IGI2ZDgyMDNlNDZlYi4uZTQzNTdjZTE4OGVmIDEwMDY0NAotLS0gYS9kcml2
ZXJzL21tYy9jb3JlL3NkaW9fYnVzLmMKKysrIGIvZHJpdmVycy9tbWMvY29yZS9zZGlvX2J1cy5j
CkBAIC0xMzQsNiArMTM0LDggQEAgc3RhdGljIGludCBzZGlvX2J1c19wcm9iZShzdHJ1Y3QgZGV2
aWNlICpkZXYpCiAJY29uc3Qgc3RydWN0IHNkaW9fZGV2aWNlX2lkICppZDsKIAlpbnQgcmV0Owog
CisJZGV2X2luZm8oZGV2LCAiJXNcbiIsIF9fZnVuY19fKTsKKwogCWlkID0gc2Rpb19tYXRjaF9k
ZXZpY2UoZnVuYywgZHJ2KTsKIAlpZiAoIWlkKQogCQlyZXR1cm4gLUVOT0RFVjsKQEAgLTE0OSw2
ICsxNTEsNyBAQCBzdGF0aWMgaW50IHNkaW9fYnVzX3Byb2JlKHN0cnVjdCBkZXZpY2UgKmRldikK
IAkgKiBwbV9ydW50aW1lX2dldF9ub3Jlc3VtZSgpIGluIGl0cyByZW1vdmUgcm91dGluZS4KIAkg
Ki8KIAlpZiAoZnVuYy0+Y2FyZC0+aG9zdC0+Y2FwcyAmIE1NQ19DQVBfUE9XRVJfT0ZGX0NBUkQp
IHsKKwkJZGV2X2luZm8oZGV2LCAiJXMgLSBwbV9ydW50aW1lX2dldF9zeW5jKClcbiIsIF9fZnVu
Y19fKTsKIAkJcmV0ID0gcG1fcnVudGltZV9nZXRfc3luYyhkZXYpOwogCQlpZiAocmV0IDwgMCkK
IAkJCWdvdG8gZGlzYWJsZV9ydW50aW1lcG07CkBAIC0xNjYsMTEgKzE2OSwxNCBAQCBzdGF0aWMg
aW50IHNkaW9fYnVzX3Byb2JlKHN0cnVjdCBkZXZpY2UgKmRldikKIAlpZiAocmV0KQogCQlnb3Rv
IGRpc2FibGVfcnVudGltZXBtOwogCisJZGV2X2luZm8oZGV2LCAiJXMgLSBwcm9iZSBPS1xuIiwg
X19mdW5jX18pOwogCXJldHVybiAwOwogCiBkaXNhYmxlX3J1bnRpbWVwbToKLQlpZiAoZnVuYy0+
Y2FyZC0+aG9zdC0+Y2FwcyAmIE1NQ19DQVBfUE9XRVJfT0ZGX0NBUkQpCisJaWYgKGZ1bmMtPmNh
cmQtPmhvc3QtPmNhcHMgJiBNTUNfQ0FQX1BPV0VSX09GRl9DQVJEKSB7CisJCWRldl9pbmZvKGRl
diwgIiVzIC0gRVJSIGNhbGwgcG1fcnVudGltZV9wdXRfbm9pZGxlKClcbiIsIF9fZnVuY19fKTsK
IAkJcG1fcnVudGltZV9wdXRfbm9pZGxlKGRldik7CisJfQogCWRldl9wbV9kb21haW5fZGV0YWNo
KGRldiwgZmFsc2UpOwogCXJldHVybiByZXQ7CiB9CkBAIC0yMDgsMTEgKzIxNCwyNSBAQCBzdGF0
aWMgaW50IHNkaW9fYnVzX3JlbW92ZShzdHJ1Y3QgZGV2aWNlICpkZXYpCiAJcmV0dXJuIHJldDsK
IH0KIAorI2lmZGVmIENPTkZJR19QTQorc3RhdGljIGludCBzZGlvX2J1c19ydW50aW1lX3N1c3Bl
bmQoc3RydWN0IGRldmljZSAqZGV2KQoreworCWRldl9pbmZvKGRldiwgIiVzXG4iLCBfX2Z1bmNf
Xyk7CisJcmV0dXJuIHBtX2dlbmVyaWNfcnVudGltZV9zdXNwZW5kKGRldik7Cit9CisKK3N0YXRp
YyBpbnQgc2Rpb19idXNfcnVudGltZV9yZXN1bWUoc3RydWN0IGRldmljZSAqZGV2KQoreworCWRl
dl9pbmZvKGRldiwgIiVzXG4iLCBfX2Z1bmNfXyk7CisJcmV0dXJuIHBtX2dlbmVyaWNfcnVudGlt
ZV9yZXN1bWUoZGV2KTsKK30KKyNlbmRpZgorCiBzdGF0aWMgY29uc3Qgc3RydWN0IGRldl9wbV9v
cHMgc2Rpb19idXNfcG1fb3BzID0gewogCVNFVF9TWVNURU1fU0xFRVBfUE1fT1BTKHBtX2dlbmVy
aWNfc3VzcGVuZCwgcG1fZ2VuZXJpY19yZXN1bWUpCiAJU0VUX1JVTlRJTUVfUE1fT1BTKAotCQlw
bV9nZW5lcmljX3J1bnRpbWVfc3VzcGVuZCwKLQkJcG1fZ2VuZXJpY19ydW50aW1lX3Jlc3VtZSwK
KwkJc2Rpb19idXNfcnVudGltZV9zdXNwZW5kLAorCQlzZGlvX2J1c19ydW50aW1lX3Jlc3VtZSwK
IAkJTlVMTAogCSkKIH07CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy90aS93bGNv
cmUvc2Rpby5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvdGkvd2xjb3JlL3NkaW8uYwppbmRleCA0
ZDRiMDc3MDExNDkuLjBhODJhMTFjYWU5NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvdGkvd2xjb3JlL3NkaW8uYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy90aS93bGNvcmUv
c2Rpby5jCkBAIC0xNTQsNiArMTU0LDggQEAgc3RhdGljIGludCB3bDEyeHhfc2Rpb19wb3dlcl9v
bihzdHJ1Y3Qgd2wxMnh4X3NkaW9fZ2x1ZSAqZ2x1ZSkKIAlzdHJ1Y3Qgc2Rpb19mdW5jICpmdW5j
ID0gZGV2X3RvX3NkaW9fZnVuYyhnbHVlLT5kZXYpOwogCXN0cnVjdCBtbWNfY2FyZCAqY2FyZCA9
IGZ1bmMtPmNhcmQ7CiAKKwlkZXZfaW5mbyhnbHVlLT5kZXYsICIlczogU1RFUDFcbiIsIF9fZnVu
Y19fKTsKKwogCXJldCA9IHBtX3J1bnRpbWVfZ2V0X3N5bmMoJmNhcmQtPmRldik7CiAJaWYgKHJl
dCA8IDApIHsKIAkJcG1fcnVudGltZV9wdXRfbm9pZGxlKCZjYXJkLT5kZXYpOwpAQCAtMTYzLDcg
KzE2NSwxMiBAQCBzdGF0aWMgaW50IHdsMTJ4eF9zZGlvX3Bvd2VyX29uKHN0cnVjdCB3bDEyeHhf
c2Rpb19nbHVlICpnbHVlKQogCQlyZXR1cm4gcmV0OwogCX0KIAorCWRldl9pbmZvKGdsdWUtPmRl
diwgIiVzOiBTVEVQMlxuIiwgX19mdW5jX18pOworCiAJc2Rpb19jbGFpbV9ob3N0KGZ1bmMpOwor
CisJZGV2X2luZm8oZ2x1ZS0+ZGV2LCAiJXM6IFNURVAzXG4iLCBfX2Z1bmNfXyk7CisKIAkvKgog
CSAqIFRvIGd1YXJhbnRlZSB0aGF0IHRoZSBTRElPIGNhcmQgaXMgcG93ZXIgY3ljbGVkLCBhcyBy
ZXF1aXJlZCB0byBtYWtlCiAJICogdGhlIEZXIHByb2dyYW1taW5nIHRvIHN1Y2NlZWQsIGxldCdz
IGRvIGEgYnJ1dGUgZm9yY2UgSFcgcmVzZXQuCkBAIC0xNzEsOCArMTc4LDEyIEBAIHN0YXRpYyBp
bnQgd2wxMnh4X3NkaW9fcG93ZXJfb24oc3RydWN0IHdsMTJ4eF9zZGlvX2dsdWUgKmdsdWUpCiAJ
bW1jX2h3X3Jlc2V0KGNhcmQtPmhvc3QpOwogCiAJc2Rpb19lbmFibGVfZnVuYyhmdW5jKTsKKwor
CWRldl9pbmZvKGdsdWUtPmRldiwgIiVzOiBTVEVQNFxuIiwgX19mdW5jX18pOworCiAJc2Rpb19y
ZWxlYXNlX2hvc3QoZnVuYyk7CiAKKwlkZXZfaW5mbyhnbHVlLT5kZXYsICIlczogU1RFUDVcbiIs
IF9fZnVuY19fKTsKIAlyZXR1cm4gMDsKIH0KIApAQCAtMTgxLDEyICsxOTIsMjAgQEAgc3RhdGlj
IGludCB3bDEyeHhfc2Rpb19wb3dlcl9vZmYoc3RydWN0IHdsMTJ4eF9zZGlvX2dsdWUgKmdsdWUp
CiAJc3RydWN0IHNkaW9fZnVuYyAqZnVuYyA9IGRldl90b19zZGlvX2Z1bmMoZ2x1ZS0+ZGV2KTsK
IAlzdHJ1Y3QgbW1jX2NhcmQgKmNhcmQgPSBmdW5jLT5jYXJkOwogCisJZGV2X2luZm8oZ2x1ZS0+
ZGV2LCAiJXM6IFNURVAxXG4iLCBfX2Z1bmNfXyk7CisKIAlzZGlvX2NsYWltX2hvc3QoZnVuYyk7
CiAJc2Rpb19kaXNhYmxlX2Z1bmMoZnVuYyk7CisKKwlkZXZfaW5mbyhnbHVlLT5kZXYsICIlczog
U1RFUDJcbiIsIF9fZnVuY19fKTsKIAlzZGlvX3JlbGVhc2VfaG9zdChmdW5jKTsKIAorCisJZGV2
X2luZm8oZ2x1ZS0+ZGV2LCAiJXM6IFNURVAzXG4iLCBfX2Z1bmNfXyk7CiAJLyogTGV0IHJ1bnRp
bWUgUE0ga25vdyB0aGUgY2FyZCBpcyBwb3dlcmVkIG9mZiAqLwogCXBtX3J1bnRpbWVfcHV0KCZj
YXJkLT5kZXYpOworCisJZGV2X2luZm8oZ2x1ZS0+ZGV2LCAiJXM6IFNURVA0XG4iLCBfX2Z1bmNf
Xyk7CiAJcmV0dXJuIDA7CiB9CiAKQEAgLTMxNSw3ICszMzQsNyBAQCBzdGF0aWMgaW50IHdsMTI3
MV9wcm9iZShzdHJ1Y3Qgc2Rpb19mdW5jICpmdW5jLAogCiAJLyogaWYgc2RpbyBjYW4ga2VlcCBw
b3dlciB3aGlsZSBob3N0IGlzIHN1c3BlbmRlZCwgZW5hYmxlIHdvdyAqLwogCW1tY2ZsYWdzID0g
c2Rpb19nZXRfaG9zdF9wbV9jYXBzKGZ1bmMpOwotCWRldl9kYmcoZ2x1ZS0+ZGV2LCAic2RpbyBQ
TSBjYXBzID0gMHgleFxuIiwgbW1jZmxhZ3MpOworCWRldl9pbmZvKGdsdWUtPmRldiwgInNkaW8g
UE0gY2FwcyA9IDB4JXhcbiIsIG1tY2ZsYWdzKTsKIAogCWlmIChtbWNmbGFncyAmIE1NQ19QTV9L
RUVQX1BPV0VSKQogCQlwZGV2X2RhdGEtPnB3cl9pbl9zdXNwZW5kID0gdHJ1ZTsKQEAgLTMzNiw2
ICszNTUsOCBAQCBzdGF0aWMgaW50IHdsMTI3MV9wcm9iZShzdHJ1Y3Qgc2Rpb19mdW5jICpmdW5j
LAogCWVsc2UKIAkJY2hpcF9mYW1pbHkgPSAid2wxMnh4IjsKIAorCWRldl9pbmZvKGdsdWUtPmRl
diwgImNoaXBfZmFtaWx5IGlzICVzXG4iLCBjaGlwX2ZhbWlseSk7CisKIAlnbHVlLT5jb3JlID0g
cGxhdGZvcm1fZGV2aWNlX2FsbG9jKGNoaXBfZmFtaWx5LCBQTEFURk9STV9ERVZJRF9BVVRPKTsK
IAlpZiAoIWdsdWUtPmNvcmUpIHsKIAkJZGV2X2VycihnbHVlLT5kZXYsICJjYW4ndCBhbGxvY2F0
ZSBwbGF0Zm9ybV9kZXZpY2UiKTsKQEAgLTM3NSwxMSArMzk2LDE1IEBAIHN0YXRpYyBpbnQgd2wx
MjcxX3Byb2JlKHN0cnVjdCBzZGlvX2Z1bmMgKmZ1bmMsCiAJCWdvdG8gb3V0X2Rldl9wdXQ7CiAJ
fQogCisJZGV2X2luZm8oZ2x1ZS0+ZGV2LCAiQWJvdXQgdG8gYWRkIGNvcmUgZGV2IChjaGlsZCku
Li5cbiIpOworCiAJcmV0ID0gcGxhdGZvcm1fZGV2aWNlX2FkZChnbHVlLT5jb3JlKTsKIAlpZiAo
cmV0KSB7CiAJCWRldl9lcnIoZ2x1ZS0+ZGV2LCAiY2FuJ3QgYWRkIHBsYXRmb3JtIGRldmljZVxu
Iik7CiAJCWdvdG8gb3V0X2Rldl9wdXQ7CiAJfQorCisJZGV2X2luZm8oZ2x1ZS0+ZGV2LCAiLi4u
YWRkZWQgY29yZSBkZXYgKGNoaWxkKSAtIHByb2JlIGNvbXBsZXRlIVxuIik7CiAJcmV0dXJuIDA7
CiAKIG91dF9kZXZfcHV0OgotLSAKMi4xNy4xCgo=
--00000000000058e291057ff8da6b--
