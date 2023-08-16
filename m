Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77DEC27C41
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Aug 2023 21:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346363AbjHPVFP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Aug 2023 17:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346401AbjHPVFB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2023 17:05:01 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A0C2727
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2023 14:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=YA5MdGOmrDQHUJYuHa+CQzur+/CKJZZTvpSVXmLrS68=;
        t=1692219897; x=1693429497; b=V+8YPhO7ef0QS68XoSXeyqiyYfE5ZkbLBJHLbBN9vdRa38Z
        AB030n5vq3KxB2p1SXdb7UlRKZYwyJSUSEKHtIyTZtCeTVwk1CWGo1CQjcpk+LKThpwnHFSW71e/5
        RuvBJ4VPBp6b6E0I11WYGFpps4TnwcFf60+X6k+ZEp4EflJMVqBWJjQLaIbnYH2bZITW31kgbjfrR
        u5VHNbr+6+cChtf9tefgWHfrnoeKmYwGvG/lDRKsB4iQda7Dg4zMogmRhZ2rKI1NAW62gN7ldR2vS
        PdNubjVUWMUaxM1PjqqCtqqcpcapeKUMeptIXF/rsrEiflIGLmK0J/ZDYiRJmF3w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qWNhF-00BPmn-2p;
        Wed, 16 Aug 2023 23:04:54 +0200
Message-ID: <3e34b44f06a7b21a6148bec8750ebc3d4e78b284.camel@sipsolutions.net>
Subject: Re: WARNING in __ieee80211_beacon_get
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     syzbot <syzbot+18c783c5cf6a781e3e2c@syzkaller.appspotmail.com>,
        linux-wireless@vger.kernel.org, ramonreisfontes@gmail.com,
        syzkaller-bugs@googlegroups.com
Date:   Wed, 16 Aug 2023 23:04:52 +0200
In-Reply-To: <CANp29Y7TVNRFpcN1qSSurwWAtbBn90z_eUet3UdOcdDdUZ7zrg@mail.gmail.com>
References: <000000000000bf21d705b0e8674c@google.com>
         <4d51d5ec9f1a86b099900934661e1bbdefa269c7.camel@sipsolutions.net>
         <CANp29Y7MS5q=HVRuz-eXx4=9FxpuFJr3GkikG6MrKegxH6cO2A@mail.gmail.com>
         <bd2427a1c4ea30682c45c22c5f452e3dd8e674fb.camel@sipsolutions.net>
         <CANp29Y7TVNRFpcN1qSSurwWAtbBn90z_eUet3UdOcdDdUZ7zrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2023-08-16 at 21:56 +0200, Aleksandr Nogikh wrote:
> >=20
> > Is there an easy way to rebuild the kernel for it?
>=20
> How does an easy way differ from a difficult one in this case? :)
>=20

:-)

I was mostly thinking about "how the hell do I get the kernel into the
qemu image" but I realized later I don't even need to since qemu has the
-kernel option to boot the kernel directly.

Then I had to leave for a while so I only got to try it now, and indeed
I can reproduce it with a kernel built/booted that way, so I can make
changes for debugging. In fact, not even sure what else I really need
from the rootfs at that point, but this is still an easy way to
reproduce it.

Sorry for the noise.

johannes
