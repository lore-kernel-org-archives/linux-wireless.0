Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BD4C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 13:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BD5720880
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 13:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="f5NR+bIX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfDIN2E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:28:04 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44513 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfDIN2A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 09:28:00 -0400
Received: by mail-io1-f66.google.com with SMTP id u12so14208273iop.11
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 06:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=xJVc12goI8rqGySbWSdxOIoYdvxImxl/QNO4neztKXI=;
        b=f5NR+bIXQSfde2BcDK/AtMhi+vY7SV0Q3mrZcwE7FSyiUi2hjBAQD++MmaDR20Iys8
         RvzWxSkXC6zBwuq3OmNXHXU2h7sjufzOra+fMy6ivg0+hPgYMZK6fIsS14gn5Gu9ppIA
         7yHcbbWvOfPcsHRoIqm5pb71TXKVILYuiPjFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=xJVc12goI8rqGySbWSdxOIoYdvxImxl/QNO4neztKXI=;
        b=WgbH21/W5SxSLTHURc6gRzprjJtYFDVKGTRBKN+3ykOe/+51ueW6gyVy/rpBTwz00l
         kEi5CCeEYOUQoBex6amrJ99+95WR9LUE8SgiiF+TtrgliEo6Xa6oMZ3MRzsl/PvRfgAT
         q6O7APbc8mNZjKc47fHEpPAkAT3AIvvQ4mHDIunx0HJRRMJjED74BHAW+erNnWv9/QZB
         PMnHqk7vShLrM+PVKer60mIBk/4Tk9ehxdf+DP1jzeNdi84FQ/IKQRPzfTbt7iRrCwkX
         uSiNqFnb99wFuitkmWJs4BmnHLR6u7iVJt8MDtJWr2nN4Ltj0ekicLjgZT7SwIdB1noB
         gAag==
X-Gm-Message-State: APjAAAUoikm/fxXNMs2qBlapOajafGaysJ3ECJzIztbR6jxWsrE6OYCW
        McrEZFXDBmn+qVkTxFDGnvJChVBARiQjfbpNgO83ng==
X-Google-Smtp-Source: APXvYqy01et48ReAOSaa4kFhye3b3Klu1UErPDXwE5xbVWJksNHuLhjMBRfNIJjL5gSUuguL4VbqOkwbSJ/SoAVk84c=
X-Received: by 2002:a5e:9e02:: with SMTP id i2mr21183504ioq.238.1554816478797;
 Tue, 09 Apr 2019 06:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190409002452.14551-1-megous@megous.com> <20190409002452.14551-3-megous@megous.com>
 <CAMty3ZBK2jPHTP4Y+hiy8Gq+Nx9iWYoUgke+BvopyzR8T6=0Xw@mail.gmail.com> <20190409113157.e4vrzesbgmyslomb@core.my.home>
In-Reply-To: <20190409113157.e4vrzesbgmyslomb@core.my.home>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Tue, 9 Apr 2019 18:57:47 +0530
Message-ID: <CAMty3ZAivyE922rpJ_FgnL=3hk1jR2eJsnuiQHqXd+NcmhQ+SQ@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 02/13] arm64: dts: allwinner: h6: Add
 Orange Pi 3 DTS
To:     Jagan Teki <jagan@amarulasolutions.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ond=C5=99ej Jirman,

On Tue, Apr 9, 2019 at 5:01 PM Ond=C5=99ej Jirman <megous@megous.com> wrote=
:
>
> Hi Jagan,
>
> On Tue, Apr 09, 2019 at 02:08:18PM +0530, Jagan Teki wrote:
> > Based on the conversation about using common dtsi from this thread[1],
> > I'm commenting here to make show the diff directly on the nodes,
> > giving comments on each node so-that we can see the diff globally.
>
> Thanks for the suggestions below. It mostly repeats the differences and
> commonalities I already stated in the previous discussion.
>
> I don't have much to add to what I already said previously, though, becau=
se you
> didn't address my concerns there. But I can restate and expand on those
> concerns.
>
> Previously I already agreed it's possible to base orangepi-3.dts on
> orangepi.dtsi, and proposed a maintainable way forward, and why to follow=
 it (to
> quote myself):
>
>   Schematics allow for high amount of variability in the power tree (see =
all the
>   NC (not connected) / 0R resistors) in the schematic around AXP805. Ever=
y board
>   based on this Xunlong design can be subtly different.

Well, how about defining them in required dts file and group it common
regulators in dtsi? The idea of all these 3 H6 OPI boards are
evaluated in the same design consideration by adding new IP's in new
boards design by keeping the core things common like lite2 has wifi,
one plus has emac and 3 has PCIe etc. This is what I got from
Steven(OrangePI).

>
>   I already suggested a maintainable solution, below. Where base dtsi has=
 empty
>   config for regulators and every board based on that just defines it com=
pletely
>   for itself.
>
>   A few regulators (for CPU/GPU) will most probably have the same meaning=
 on
>   every derived board, so these can probably be kept in dtsi without caus=
ing too
>   much annoyance.
>
>   It's unpleasant to have wrong regulator setup defined in an underlying =
dtsi,
>   and then trying to override it by removing/adding random properties in =
the
>   board dts for the new boards based on that, so that it fits.

If we manage them properly by moving common things in dtsi and rest in
dts, we may avoid these underlying issues.

>
>   The rest of the current HW descriptions in the sun50i-h6-orangepi.dtsi =
can be
>   shared (as of now).
>
> My suggestion was this:
>
>   So to base Orange Pi 3 dts on top of existing sun50i-h6-orangepi.dtsi I=
'd have
>   to first move some things out of the base dtsi to the OrangePi Lite2 an=
d One
>   Plus board dts files, in order to have sun50i-h6-orangepi.dtsi only des=
cribe
>   HW that is *really* shared by these 2 boards and Orange Pi 3.
>
>   If I do that, I'd undefine all the axp805 regulator nodes and move the
>   configurations to each of the 3 board files. That will probably end up =
being
>   the least confusing and most maintainable. See axp81x.dtsi lines 86-144=
 for
>   what I mean.
>
> You seem to be suggesting a solution where every time we add an OrangePi =
H6
> based board, the person adding it will have to go through the base dtsi a=
nd all
> the other boards based on it, status disable or otherwise change regulato=
rs in
> the base dtsi, patch all the other boards to re-enable it.
>
> It would be already unpleasant just adding a third board based on this ap=
proach.
> And when the fourth board is added, with another small differences in the
> regulator use/meanings, the person will be looking at patching 4 dts file=
s
> + adding one for his own board. For what benefit, to save some bytes righ=
t now?
>
> I think maintainability, ease of adding new boards is more important, tha=
n
> having a dtsi that tries to maximally cover all the commonalities between=
 the
> existing boards right now, without regards for the future. That's why
> I suggested an approach like in axp81x.dtsi lines 86-144.

True, if the boards indeed are different but we can maintain easily if
the boards are from same family of design based my experience and few
boards do share common things in dtsi already.

Anyway, thanks for inputs. Seems like patch is applied already may be
we can move into dtsi if require in future.

Thanks,
Jagan.
