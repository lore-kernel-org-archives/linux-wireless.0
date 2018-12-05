Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8BDC04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 19:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 636EB2082D
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 19:27:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4lz65tY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 636EB2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbeLET1m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:27:42 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:50496 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbeLET1l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 14:27:41 -0500
Received: by mail-it1-f193.google.com with SMTP id z7so23243746iti.0;
        Wed, 05 Dec 2018 11:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oLotLyKcPlEXHkBT7sWl5hhytgzI2XZBOs+20YWdxLs=;
        b=i4lz65tYDPpQ/de04sFBKCEbhj4/Ik0tpaHEnVM8r5wnImRVWnbdkZPuObohoatAAl
         XaC+pKn3VyFbo3i/xIwAn0BZgBvF1hg+OF5zuknTt9Wga7UUTa9zWVc++na+WZ/meXs+
         L6j3xu/5vB4W2EBSgsMPXc+xkj3RGrpGOwSwtT6i7JB036ti3Q5QdLHpwOqHTG3Wc6it
         aV+AtIgdbWnYDo+XMBUnW9nz38Nh4JMZWaOpq80mVL3ZXsSkl3QNpH6Tj0K3S6vea8E6
         FLEf3IW7wBLSKUCEPy07+5dxkDaQ9GDo55+Vu8rZwGwy/YRcpJZ3MRrJUiRrm/K4skKH
         0xNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oLotLyKcPlEXHkBT7sWl5hhytgzI2XZBOs+20YWdxLs=;
        b=OncAyDnhPXsfXGj9T9mWrt7izMkz2txF9qOc4k3SgSLDuE6ZGYpBwdCN/peotFFOsA
         Hli969cTZKMb9A/g/FAd15izUr/3/kSWiZmQeY50SK4slZg79B2GVeVTCShbEqiCvAur
         VR9AxsAJGEzfbPsIkUKbAR/BofKYEXEd+uhf1LyGwq2M4oqtxX3P0Cq7LOhsqWPD/iVA
         Zq+RfuvAD0qM2hY+5YwW7CCQ0SAIwvePh3jRjDJ6u4FHqkuFsJzirfMy0/UNxzwRnG1z
         tEMg3Blfdx/pIIKzXwj7U8bUD5BBPYtrlRPnB2480pglUW773oDvgMMlfbEVu2/mz8A/
         03Jw==
X-Gm-Message-State: AA+aEWbshYjmj6GiSLCKiTRe7vuCDn7PMCWMSSy90n5rPzw8Ieg+JSMx
        Vz9PhnndYZgjmODJIQy5ba4wklFj39Gr5ncf2zo=
X-Google-Smtp-Source: AFSGD/UIJN+bcf9F2k9hQ3j3mL3k6mDpjnUTJy7RopY0RxbEe5cJbzBNNmABnoMGt6UmjG9KMlwzRrgMKdPrrDKdkiY=
X-Received: by 2002:a02:a906:: with SMTP id n6mr22607991jam.123.1544038060675;
 Wed, 05 Dec 2018 11:27:40 -0800 (PST)
MIME-Version: 1.0
References: <20181109000800.15431-1-jprvita@gmail.com> <83CA40B2-1AF3-49FA-9F94-C84A3C916583@holtmann.org>
 <CA+A7VXXfdyLWMpNaEzUzDe6PiktOKb5oJrufYrGeTyXyXChQfw@mail.gmail.com>
In-Reply-To: <CA+A7VXXfdyLWMpNaEzUzDe6PiktOKb5oJrufYrGeTyXyXChQfw@mail.gmail.com>
From:   =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date:   Wed, 5 Dec 2018 11:27:04 -0800
Message-ID: <CA+A7VXX2fA5gC1_-nwFDswvB+we3R69ZTNiGDmrO+sftRdxxpg@mail.gmail.com>
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

On Fri, Nov 9, 2018 at 4:36 PM Jo=C3=A3o Paulo Rechi Vita <jprvita@gmail.co=
m> wrote:
>
> Hello Marcel,
>
> On Thu, Nov 8, 2018 at 11:49 PM Marcel Holtmann <marcel@holtmann.org> wro=
te:
> >
> > our hardware teams from the Bluetooth and WiFi side really need to look=
 at this.

Were you able to get attention from the hardware teams with the logs
I've provided? Are there any news or an idea of when / if we can
expect this to be fixed in firmware? If not, do you have suggestions
for an alternative solution?

Thanks,

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
