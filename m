Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6893EB64DC
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Jul 2023 09:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjGOJ43 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Jul 2023 05:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjGOJ42 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Jul 2023 05:56:28 -0400
Received: from out203-205-251-82.mail.qq.com (out203-205-251-82.mail.qq.com [203.205.251.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A8A26BC;
        Sat, 15 Jul 2023 02:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1689414973;
        bh=JpDCCEP/8aNDbjWStl7V/1DHXjS0bFNz+rqHDxrKpuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VstwCYvtKqUXCxgOt60w+O655qL4wwfbwkr0CC6EjGQvgiNptIxAsN/tWsk6p/b5N
         3K8MLNsu00HsY7/3UUTb5SRAmDogyY223Ke/RdcrrScvcgIpokBtlw5EYvnGXwoZYp
         oG3MXXUw3KkcyJ5zWg0jsPRhh34ofxIDOzTl2TL4=
Received: from localhost.localdomain ([220.243.191.12])
        by newxmesmtplogicsvrszc2-0.qq.com (NewEsmtp) with SMTP
        id E0AA9045; Sat, 15 Jul 2023 17:56:10 +0800
X-QQ-mid: xmsmtpt1689414970tnk2wq92o
Message-ID: <tencent_283F851E543C098B9BC8DAA32D79B00A0F07@qq.com>
X-QQ-XMAILINFO: N7xt/Xavkw6SPgp6fMF86Ya0b7fRfpshou9aHNkYNeG1Lo+iWmEXJqDEFpx8mn
         R53G9Kqvzuxpp4AivDQQAkcq3WEnyYs161XP9+s9urcpHOeJugw1hxAtzEURchfp9Ok/vdljHukV
         PRKGW3UHHKnAAQOnTuuwZCOs4iRIr7z0Gof+gdnd6w/ZWrZeTxpVraEbyzDBzExC+5B1T9WqORo+
         7dFG6M9QyffDAmzFWZ74FRz0MUjZ4iinjBVj6q6aVq29taxGUHhfh4uCALPPaRzZpvgF6Xnuivad
         c2ZF2f+Coo7UsvsMYllMNSp057dMyrfkbkhp7mRAMPQVB9TgsWNL0taZQmdbUrpcxbbwGJ8WHrpd
         MULh4pKppfqaZgjYWFQ24wV+n2PsirV4wAmqMBT97rXQTUu+eTnZb8dYep1KnTqiazjJaNKh+6hl
         RQl3bh9/CnF2Adb/U5ziSsd+LxT9BOkUcGTevMVoeJCw5bZ+QUS0oC0/BS1/d9eu6OPj1cptKt0X
         +NUzcSD6YtNQljpGr9xgzoW68D6difgy7vJHYFFnhd0H5JjZWdVmDOScrcNaDdFVBlMJLa88LlCQ
         iqnhi9v3pgd/nomO0vXRQ2M8LEXxATM2ytMgTh4EuxrWD/ZCmGuHqUE0WmwzLjMbexkRtEmVtUY6
         3f5NOTwZy1z4iJ34OEE9xwJ9S7lSfAgrvSZ1LlBxulgvOdo25Sj+LJ7uG4Ki1togfTZUdN9osOp+
         sxRraaBgHi+lQXTg2ZKDs+CeI4sRDyhCyrtyGfdR1ifsVi5Qe7pVdP+dj5TXJqp7rtcpeJxVtBRH
         76q86plXVMOq/DpoBTuuDvr/UjILgGz62wLQlZgB1UTP90tkXwj4vjWtXhefZU5vWp8feAuwO81J
         29H9NvnDvf8OUFPFhwAicuNa9hIe/MOLP5/OMKiZZs++ahGV3wKumdOdU0mqzrhHSNPMHsdgmcw3
         A7UAj+M2KBpEls0OQkBVUpCzuCdJcI01iR9jkMY3alxG6ScR8eumxC7OYJjtAm
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Markus Elfring <Markus.Elfring@web.de>
Cc:     LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] wifi: rtw89: debug: fix error code in
 rtw89_debug_priv_btc_manual_set
Date:   Sat, 15 Jul 2023 17:56:10 +0800
X-OQ-MSGID: <4849586.31r3eYUQgx@localhost.localdomain>
In-Reply-To: <a97b0b0c-8141-5391-727a-aa29fedc016b@web.de>
References: <tencent_7C09B91B925AF62D7CB0280F028563540807@qq.com>
 <a97b0b0c-8141-5391-727a-aa29fedc016b@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

=E5=9C=A8 2023=E5=B9=B47=E6=9C=8815=E6=97=A5=E6=98=9F=E6=9C=9F=E5=85=AD CST=
 =E4=B8=8B=E5=8D=885:22:08=EF=BC=8CMarkus Elfring =E5=86=99=E9=81=93=EF=BC=
=9A
> > If there is a failure during kstrtobool_from_user()
> > rtw89_debug_priv_btc_manual_set should return negative error code
> > instead of returning the count driectly.
> >=20
> > Fix this bug by returning the correct error code.
>=20
> How do you think about to use an other wording approach
> (like the following) for an improved change description?
>=20
>=20
>   Return an error code instead of a count after a failed call
>   of the function =E2=80=9Ckstrtobool_from_user=E2=80=9D.
>   Omit the label =E2=80=9Cout=E2=80=9D with this source code correction.
>=20
>=20
> Regards,
> Markus
Thanks for your kindness reply and advice and I will change my description
in the next version.

Regards,
Shurong



