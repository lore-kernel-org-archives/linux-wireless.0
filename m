Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD96C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 00:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60A8A20855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 00:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nz1Schec"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60A8A20855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbeKIJuH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 04:50:07 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44639 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeKIJuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 04:50:07 -0500
Received: by mail-pg1-f194.google.com with SMTP id w3-v6so38845pgs.11;
        Thu, 08 Nov 2018 16:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y6G3fJWoHOThjb5/JbAxsM3dEjjUKXbWiLs3zdGUVPU=;
        b=Nz1Schecg2Bbr5yaR4tZMmZSH3oMem7pfdH4Z03ifZJ6jLgvGvmwbxHdOWSSy9TI7S
         fzb8sQGoJHFHXO0LHBT27WRkf9N9XAG2kfCbKw4kKVyViVWIAeI1VBJUfwofZfbhcnTK
         tbDmVYXV8FbtP0Nxbqjtsmwctpvipv03LySpQv+qfA/7Hqebdg+AGtYNd1Qea9U+/lMR
         rzI7viNZjguPaywcDEQZfkWmPOzTnhxzS94ywQD+YnvfRwcm2E08oO3f4wze1HRhZ+h3
         GLgP7o3uhwHeNGosRTDRY6CJrtpCB6pHZfNgdKz+nkPHBPt0PR1dPI8ORSFwLFT1wKPR
         FvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y6G3fJWoHOThjb5/JbAxsM3dEjjUKXbWiLs3zdGUVPU=;
        b=Jt6vdyBlOIqT4iu0kmmRMABOAGC/Mj48w9by58NuiP7YBr8ZF1NmrhaMvlHMKiI1Gw
         miQ23kxV0M+cWxtim1CUevWdVAeL3c8lSTkmb2ewBJn67cq3MHYvIdWORx21x61LjRtV
         RO0bZEQSihVmD72diVRoHBmn0xnonl1pOLq5UQt8tXeRWi8vYbeplGCUmEgy8ctViRxD
         PT+4L9b0FocAEho8GLDfHVxJFZabhuHLe5bmBeBHdTZR40enMjFRKyr6oB/kEiRUHJfU
         bsJfK/uhzqD0whU6BipoV27tYVmcmpJxCPJbt0WXKaskp4dYpxW0hCyiTJ5e8+FT6Z1B
         h8Pw==
X-Gm-Message-State: AGRZ1gLoKG/yzWHsNZ/OphHs/s5wlkmTPyzZD4dl1egLTREi755zJ8vB
        r336VVbTsoy1WuxwLpkv9LpSvCr5oZVjg9/6cxg=
X-Google-Smtp-Source: AJdET5dZgJvOIm77JwKBWIp33lnOdZ+REl8qIaCpiMFzOCRLDeLqSUTs2aJWL5xuOUkRUSj5DRaAVTQjPBnVNyLPoRc=
X-Received: by 2002:a62:c184:: with SMTP id i126-v6mr6750841pfg.53.1541722325133;
 Thu, 08 Nov 2018 16:12:05 -0800 (PST)
MIME-Version: 1.0
References: <910F8A29-3141-422F-87EE-7BFBCDE9060C@holtmann.org> <20181109000800.15431-1-jprvita@gmail.com>
In-Reply-To: <20181109000800.15431-1-jprvita@gmail.com>
From:   =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date:   Thu, 8 Nov 2018 16:11:28 -0800
Message-ID: <CA+A7VXXDuxo2=mndMFgHHRUJHPXOaupt+0eN9DS0zvwGL2hrLQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     kai.heng.feng@canonical.com,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux@endlessm.com,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-bluetooth

On Thu, Nov 8, 2018 at 4:08 PM Jo=C3=A3o Paulo Rechi Vita <jprvita@gmail.co=
m> wrote:
>
> Hello Marcel,
>
> > On Oct 4, 2018, at 2:25 AM, Marcel Holtmann <marcel@holtmann.org> wrote=
:
> >
> > Hi Kai-Heng,
> >
> >>> I think Canonical were facing some wifi fw load error from some 8260
> >>> earlier module during the BT still loading the fw.
> >>> I believe we had later 8260 sku that fixed this issue.
> >>
> >> But there are already 8260 that is affected by this bug in the wild.
> >>
> >> Search "Bluetooth: hci0: Failed to send firmware data (-38)=E2=80=9D a=
nd there are lots of user are affected.
> >
> > which SKUs are these actually. What are the initial details about the b=
oot loader. For the Bluetooth side, you should be able to grab them from dm=
esg or by running btmon.
> >
> > So I am not in favor of this kind of hack and creating dependencies bet=
ween drivers. If you only have a hammer, then everything looks like a nail.=
 And this is a massive hammer trying to squash everything. This problem nee=
ds to be debugged. And this starts by providing affected SKU information an=
d firmware information. So get the details about the SKU and its Bluetooth =
and WiFi boot loaders.
> >
>
> I have a Lenovo Yoga 900 which presents this problem and has the same boo=
tloader / firmware information as Kai-Heng already posted:
>
> [    5.992426] Bluetooth: Core ver 2.22
> [    5.992438] Bluetooth: HCI device and connection manager initialized
> [    5.992442] Bluetooth: HCI socket layer initialized
> [    5.992444] Bluetooth: L2CAP socket layer initialized
> [    5.992450] Bluetooth: SCO socket layer initialized
> [    6.004941] Bluetooth: hci0: Bootloader revision 0.0 build 2 week 52 2=
014
> [    6.010922] Bluetooth: hci0: Device revision is 5
> [    6.010923] Bluetooth: hci0: Secure boot is enabled
> [    6.010924] Bluetooth: hci0: OTP lock is enabled
> [    6.010925] Bluetooth: hci0: API lock is enabled
> [    6.010926] Bluetooth: hci0: Debug lock is disabled
> [    6.010927] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
> [    6.014253] bluetooth hci0: firmware: direct-loading firmware intel/ib=
t-11-5.sfi
> [    6.014256] Bluetooth: hci0: Found device firmware: intel/ibt-11-5.sfi
> [    6.613961] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    6.613966] Bluetooth: BNEP filters: protocol multicast
> [    6.613974] Bluetooth: BNEP socket layer initialized
> [    6.983804] Bluetooth: hci0: Failed to send firmware data (-38)
>
> And the following product id and revision, from usb-devices:
>
> T:  Bus=3D01 Lev=3D01 Prnt=3D01 Port=3D06 Cnt=3D02 Dev#=3D  3 Spd=3D12  M=
xCh=3D 0
> D:  Ver=3D 2.00 Cls=3De0(wlcon) Sub=3D01 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D8087 ProdID=3D0a2b Rev=3D00.01
> C:  #Ifs=3D 2 Cfg#=3D 1 Atr=3De0 MxPwr=3D100mA
> I:  If#=3D 0 Alt=3D 0 #EPs=3D 3 Cls=3De0(wlcon) Sub=3D01 Prot=3D01 Driver=
=3Dbtusb
> I:  If#=3D 1 Alt=3D 0 #EPs=3D 2 Cls=3De0(wlcon) Sub=3D01 Prot=3D01 Driver=
=3Dbtusb
>
> I understand the drawbacks with the approach presented here and lack of c=
lear explanation of the problem, but I can confirm these patches work aroun=
d the problem on my machine. Is there any extra info or test result I can p=
rovide to help debug this? I can also dedicate time to help write a differe=
nt solution if some guidance is provided.
>
> Kai-Heng, did you end up filling a Bugzilla entry for this?
>
> Please CC-me on the replies as I'm not receiving emails from linux-blueto=
oth or linux-wireless anymore.
>
> Thanks,
>
> --
> Jo=C3=A3o Paulo Rechi Vita
> http://about.me/jprvita
