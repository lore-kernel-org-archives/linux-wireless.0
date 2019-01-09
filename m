Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5403BC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 00:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2141020883
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 00:26:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uh2ZUBaQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfAIA0j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:26:39 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38139 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfAIA0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 19:26:39 -0500
Received: by mail-oi1-f195.google.com with SMTP id a77so4905775oii.5;
        Tue, 08 Jan 2019 16:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8zx82g9cBDFjhvGynA/TWXlRzTVooLgyscf0vSFXkbM=;
        b=Uh2ZUBaQdB2XeTD8oGAaW1eMPNqXStYyBeeTUE5tRW8UjlJR9wLWYIRWHT1WY9f+yi
         rcsItRSLIzM0v7Ea8lBTPb0R8MihyVFCULwEYICcUZHUMw/yrwHHdieOVsDuHngcglB7
         6dL7hD/HDQusp2j1N9iPHVkD13MTX/57DleL5nw4REKSTAhiSE7x6FSEpf0WYZYDehal
         thk2g+6b1cF2p+zeIDL3b5eugoFIueQIUZYvJxgPMOKxbDGfAg4OPfmztfGiSNJiVtFY
         gYVr/HRmMhNOlY1rqrCOi2PSiDGR1S3mAuXGM76jy/ILPOnVCOTjRAJ/ROILcE/fgdU+
         +7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8zx82g9cBDFjhvGynA/TWXlRzTVooLgyscf0vSFXkbM=;
        b=SD3r1NTojaXgDesdeopwHid2+jFuMBtfw+reQyz6HKsHtusihiqidrxVCYgStz89rd
         sSeiPWZ40MkC163Pq1zC0D/9Fkv4gveSHTGejgEvo/1zgjc73gUWoUllCPUpNANQgUcw
         eeZuSkMH636799tF7qItIVMWAcp1ZhLVwLtD+wIbAtMWVQaU8uu0kyTKVEXLZiE68o9X
         DNou+mBxAoFSqQ477We/5AOoGBzAMnV1YGcdJyH35otq5aZP+DgE9xgnejiFLJ6DqHT3
         X6UvD59dr4v/pjndt3e6vadRIbtaVHb3ePVaUm4f0ZmNTLPCqUa14mx3UnNyoQjk6giX
         R3Bw==
X-Gm-Message-State: AJcUukeQDXJxuY4vc6TyNQzxz8WtASpORRObvMaAtS9NjH/QizPbEFCJ
        kDDFxJENenjNENXPoO7BGmLvUpE2H1zBKDwJTKw=
X-Google-Smtp-Source: ALg8bN4R5y3Ib2eH0R8Jxyqy9vEZwWpi+ahG35XNczbz3RMYrUTy4VE4BofDL+r69OQ/G1mjEPTFsbmHk0eShVHVvdk=
X-Received: by 2002:aca:c501:: with SMTP id v1mr2401214oif.48.1546993597853;
 Tue, 08 Jan 2019 16:26:37 -0800 (PST)
MIME-Version: 1.0
References: <20181109000800.15431-1-jprvita@gmail.com> <83CA40B2-1AF3-49FA-9F94-C84A3C916583@holtmann.org>
 <CA+A7VXXfdyLWMpNaEzUzDe6PiktOKb5oJrufYrGeTyXyXChQfw@mail.gmail.com> <CA+A7VXX2fA5gC1_-nwFDswvB+we3R69ZTNiGDmrO+sftRdxxpg@mail.gmail.com>
In-Reply-To: <CA+A7VXX2fA5gC1_-nwFDswvB+we3R69ZTNiGDmrO+sftRdxxpg@mail.gmail.com>
From:   =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date:   Tue, 8 Jan 2019 16:26:01 -0800
Message-ID: <CA+A7VXXarPAb+vFNTqZDhpng_niLjSCxqEQdLLV9eGAn+PPUXQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Marcel,

On Wed, Dec 5, 2018 at 11:27 AM Jo=C3=A3o Paulo Rechi Vita <jprvita@gmail.c=
om> wrote:
>
> Hello Marcel,
>
> On Fri, Nov 9, 2018 at 4:36 PM Jo=C3=A3o Paulo Rechi Vita <jprvita@gmail.=
com> wrote:
> >
> > Hello Marcel,
> >
> > On Thu, Nov 8, 2018 at 11:49 PM Marcel Holtmann <marcel@holtmann.org> w=
rote:
> > >
> > > our hardware teams from the Bluetooth and WiFi side really need to lo=
ok at this.
>
> Were you able to get attention from the hardware teams with the logs
> I've provided? Are there any news or an idea of when / if we can
> expect this to be fixed in firmware? If not, do you have suggestions
> for an alternative solution?
>

Sorry to bother you again with this, but I'd really like to figure out
some way forward here. Did you get any feedback from the hardware
teams? Otherwise, I understand having an inter-dependency between the
wifi and bt kernel modules is not desirable, so do you have any
suggestion on how to solve this without adding this dependency?

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
