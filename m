Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B553C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DD220834
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=raspberrypi.org header.i=@raspberrypi.org header.b="bAj1Q8GY";
	dkim=pass (2048-bit key) header.d=raspberrypi.org header.i=@raspberrypi.org header.b="PtQjCxwg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8DD220834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=raspberrypi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbeK2VrL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 16:47:11 -0500
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:47648 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726823AbeK2VrL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 16:47:11 -0500
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wATAcKMe025049
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 10:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raspberrypi.org; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pp;
 bh=PHbCOAzq2hYGasnfxrdkvjExWUBMd3HeOFhYZSrUO6c=;
 b=bAj1Q8GY+2E9LIXhHT0VtNdnK350ChkpTWT0fblOmK8su4yXii4ZQnRYGzc1ywz+lrhP
 U14RLHEtmr6j3P6e5KMAB9j11mW5smzwvah2QIlvVIvDe0sKxzEf/emdLb7QjF3pO4/h
 x69S5LXLAeBZzh9ZG6SPXdPzk82e+Ls3aUQcth9ZaFbY8BHx54g+kq/0at0WUNL6PzfZ
 FAszFW1K99HY4pO9ePKPeZpvmbDwNY0FmxDDU5HSOtLpa03r0JuAVPU2uDDRU01a9Ki9
 5ktb6z7faXGbwpXy+FlSnIVNV1qsyYAZ4gF4zTghKFP18TZ43unkPxa1qPIcZDvXs+4O 3w== 
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        by mx08-00252a01.pphosted.com with ESMTP id 2p0vghs82s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 10:42:15 +0000
Received: by mail-wm1-f72.google.com with SMTP id v7so1402562wme.9
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 02:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PHbCOAzq2hYGasnfxrdkvjExWUBMd3HeOFhYZSrUO6c=;
        b=PtQjCxwgly/6YEXTEljnEki9CexYLpPq1yKFrd/EeQBiXl4QmrW20Xz2xUgue9D7Yp
         67Iw7QGgRGRW6bxPDcRr9VJ78U6j15CrZG4BjtOJkOxb3JPBDiYR4sk9CnopSORMbgBU
         W9C0S1GLa8hixtU8f8bWlfwX3qyAi5T8f/lKxJEzy40RxFwRWbVehyveZ2Gmrc0E2HZl
         g3SJMi3U2xcO3a3SJkHUHSdgdpvJjsAgOHfn7d73pQPKQJl9lyVvopV5poySZpv9G0sA
         Wz7d7M6zAJHF85E7KP8hWoxHc50sbovneVZMaDxsBf7MMayKujbbY/AXS0N1Aidzr/qG
         WpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PHbCOAzq2hYGasnfxrdkvjExWUBMd3HeOFhYZSrUO6c=;
        b=HFG5TOymbI9/EfJSkFODLAQB2/oSdGWKejYi/C3k0yOo+EfMr+VWwYYsNk0+aKPDJC
         BcbbME/3x7DpSzEVnMZJD//QIayxd/t3QH62qk0yUYKCjLKgheh6CzgN/cRYX15clXot
         Ural04tnnM3SNxaX8Wl/86KDE1ZGoztwsDjHcLcLBOwl0U514P619c64oi5+yAA4XZ8X
         6dSXlVQWpXgc+rBXG0McIADjJxhxEOI5XSSrNyPgT2DaAcqW+UtVGu6JQpjft/FKqbXp
         SefPRjMMNhZW+0LPOUks8ye3ApikObPYwP4Oe5QjRN20RXk8OFt8Nsoddsm8JvuTnAcH
         XRcQ==
X-Gm-Message-State: AA+aEWYBdfu+30ozeeKvfzkn/PHdi9juV1727Ul6bhBx0IfhdiikThf5
        zUZsONu+VacJDRUmDKwE7Ym47lc56rOo8hfGnb6uN5BsPHMD58Xow8QA6Cfu8nL6NVGdLl7mmqp
        8JOnbv1ABvIP+O9xGcyx2tR0iF2OoNA3tdu+Jbi+U+Rk=
X-Received: by 2002:a1c:400b:: with SMTP id n11mr1245706wma.85.1543488134076;
        Thu, 29 Nov 2018 02:42:14 -0800 (PST)
X-Google-Smtp-Source: AFSGD/XOSnEFzQhM+iaT58jyCd18eA3R+cr7cdYURyW8nctNWshZkRd8rvCNhEnxJ0zf89smNIBsuA4B0z0JYIdbpQM=
X-Received: by 2002:a1c:400b:: with SMTP id n11mr1245681wma.85.1543488133682;
 Thu, 29 Nov 2018 02:42:13 -0800 (PST)
MIME-Version: 1.0
References: <142675996.139583.1543082320719@email.ionos.de>
 <ab765dfac2c4a19d820677c5c05a5566@milecki.pl> <355192050.233466.1543151650720@email.ionos.de>
 <978d5d47-004e-21a9-0c53-2eb1571a5138@broadcom.com> <1820979779.200101.1543256045155@email.ionos.de>
 <638991280.323977.1543436036313@email.ionos.de>
In-Reply-To: <638991280.323977.1543436036313@email.ionos.de>
From:   James Hughes <james.hughes@raspberrypi.org>
Date:   Thu, 29 Nov 2018 10:42:02 +0000
Message-ID: <CAE_XsMJW5gUVB+eUhFP32XELe6E6P8ogO=tvuQ_Wbsuk+ojj5Q@mail.gmail.com>
Subject: Re: brcmfmac: regression using AP mode
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>, rafal@milecki.pl,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-29_07:,,
 signatures=0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 28 Nov 2018 at 20:14, Stefan Wahren <stefan.wahren@i2se.com> wrote:
>
> Hi,
>
> > Stefan Wahren <stefan.wahren@i2se.com> hat am 26. November 2018 um 19:1=
4 geschrieben:
> >
> >
> > Hi Arend,
> >
> > > Arend van Spriel <arend.vanspriel@broadcom.com> hat am 26. November 2=
018 um 11:11 geschrieben:
> > >
> > > So no AP listed here. I suspect Rafa=C5=82 was focusing on "device_ap=
_sme=3D1
> > > use_monitor=3D1" scenario. You can try adding AP entry with similar r=
x
> > > bits as P2P_GO above.
> >
> > thanks this make all driver errors like "setting AP mode failed -52" di=
sappear, but now hostapd 2.6 seems to stuck in a loop during establishing t=
he link:
> >
>
> i increased the debug level of brcmfmac to 0x5 and i'm getting this while=
 booting:
>
> [    5.288806] brcmfmac: F1 signature read @0x18000000=3D0x15264345
> [    5.289167] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4345/6
> [    5.293319] brcmfmac: brcmf_chip_cores_check  [1 ] core 0x800:51 base =
0x18000000 wrap 0x18100000
> [    5.293333] brcmfmac: brcmf_chip_cores_check  [2 ] core 0x812:54 base =
0x18001000 wrap 0x18101000
> [    5.293344] brcmfmac: brcmf_chip_cores_check  [3 ] core 0x83e:9  base =
0x18002000 wrap 0x18102000
> [    5.293353] brcmfmac: brcmf_chip_cores_check  [4 ] core 0x83c:14 base =
0x18003000 wrap 0x18103000
> [    5.293362] brcmfmac: brcmf_chip_cores_check  [5 ] core 0x829:21 base =
0x18004000 wrap 0x18104000
> [    5.293371] brcmfmac: brcmf_chip_cores_check  [6 ] core 0x135:0  base =
0x00000000 wrap 0x18107000
> [    5.293379] brcmfmac: brcmf_chip_cores_check  [7 ] core 0x240:0  base =
0x00000000 wrap 0x00000000
> [    5.295574] brcmfmac: brcmf_chip_get_raminfo RAM: base=3D0x198000 size=
=3D819200 (0xc8000) sr=3D0 (0x0)
> [    5.295686] brcmfmac: brcmf_chip_setup ccrev=3D51, pmurev=3D27, pmucap=
s=3D0x39d05f1b
> [    5.295698] brcmfmac: brcmf_get_module_param Enter, bus=3D0, chip=3D17=
221, rev=3D6
> [    5.295765] brcmfmac: brcmf_sdio_drivestrengthinit No SDIO driver stre=
ngth init needed for chip BCM4345/6 rev 6 pmurev 27
> [    5.296204] brcmfmac: brcmf_sdio_probe completed!!
> [    5.296219] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455=
-sdio for chip BCM4345/6
> [    5.413840] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 0=
x00198000; size=3D600487
> [    5.442090] random: crng init done
> [    5.442105] random: 7 urandom warning(s) missed due to ratelimiting
> [    5.539438] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 0=
x0025f940; size=3D1728
> [    5.636378] brcmfmac: brcmf_sdio_firmware_callback enable F2: err=3D0
> [    5.636577] brcmfmac: brcmf_bus_change_state ignoring transition, bus =
not attached yet
> [    5.636819] brcmfmac: brcmf_add_if allocate netdev interface
> [    5.637199] brcmfmac: brcmf_sdio_readshared sdpcm_shared address 0x001=
FF350
> [    5.638014] brcmfmac: brcmf_sdio_readshared sdpcm_shared address 0x001=
FF350
> [    5.641788] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455=
-sdio for chip BCM4345/6
> [    5.665557] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/6 wl0: =
Feb 27 2018 03:15:32 version 7.45.154 (r684107 CY) FWID 01-4fbe0b04
> [    5.666203] brcmfmac: brcmf_c_preinit_dcmds CLM version =3D API: 12.2 =
Data: 9.10.105 Compiler: 1.29.4 ClmImport: 1.36.3 Creation: 2018-03-09 18:5=
6:28
> [    5.673860] brcmfmac: brcmf_feat_firmware_capabilities [ ap sta wme 80=
2.11d 802.11h rm cqa cac dualband ampdu ampdu_tx ampdu_rx amsdurx tdls radi=
o_pwrsave btamp p2p proptxstatus mchan p2po anqpo vht-prop-rates dfrts txpw=
rcache stbc-tx stbc-rx-1ss epno pfnx wnm bsstrans mfp ]
> [    5.673890] brcmfmac: brcmf_feat_firmware_capabilities enabling featur=
e: MCHAN
> [    5.673899] brcmfmac: brcmf_feat_firmware_capabilities enabling featur=
e: P2P
> [    5.674522] brcmfmac: brcmf_feat_iovar_int_get enabling feature: PNO
> [    5.675854] brcmfmac: brcmf_feat_iovar_int_get enabling feature: TDLS
> [    5.676955] brcmfmac: brcmf_feat_iovar_int_get enabling feature: MFP
> [    5.678014] brcmfmac: brcmf_feat_iovar_int_get enabling feature: FWSUP
> [    5.678066] brcmfmac: brcmf_fws_attach FWS queueing will be avoided
> [    5.678920] brcmfmac: brcmf_cfg80211_attach Registering custom regulat=
ory
> [    5.681508] brcmfmac: brcmf_setup_wiphybands nmode=3D1, vhtmode=3D1, b=
w_cap=3D(1, 7)
> [    5.684720] brcmfmac: brcmf_setup_wiphybands nchain=3D1
> [    5.721118] brcmfmac: check_vif_up device is not ready : status (0)
> [    5.721190] brcmfmac: brcmf_net_attach wlan0: Broadcom Dongle Host Dri=
ver
> [    5.844422] Bluetooth: hci0: BCM4345C0 (003.001.025) build 0252
> [   10.845747] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.612740] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.613251] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.614724] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.616385] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.637118] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
> [   11.638643] brcmfmac: brcmf_config_dongle power save set to enabled
> [   11.639137] brcmfmac: brcmf_dongle_roam Internal Roaming =3D On
> [   11.640504] brcmfmac: brcmf_cfg80211_change_iface IF Type =3D Infra
> [   11.642531] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   11.642545] brcmfmac: brcmf_cfg80211_set_power_mgmt power save enabled
> [   11.767278] brcmfmac: brcmf_p2p_add_vif adding vif "p2p-dev-wlan0" (ty=
pe=3D10)
> [   11.789469] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
> [   11.791667] brcmfmac: brcmf_add_if allocate non-netdev interface
> [   11.792237] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.792260] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.912572] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.913704] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.913881] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.914027] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.915150] brcmfmac: check_vif_up device is not ready : status (0)
> [   11.915230] brcmfmac: check_vif_up device is not ready : status (0)
> [   14.706985] brcmfmac: brcmf_cfg80211_connect ie (29d9d630), ie_len (28=
)
> [   17.638253] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   19.655039] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [   21.780277] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [   24.744917] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [   24.995983] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [   25.246750] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [   25.446303] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [   26.569338] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [   28.692076] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)

I wonder if the test on line 302 ish in core.c should be <=3D. The head
delta is 0, which actually means its doesn't need to be increased in
size.

if (skb_headroom(skb) < drvr->hdrlen || skb_header_cloned(skb)) {
<<<< should be <=3D
     head_delta =3D max_t(int, drvr->hdrlen - skb_headroom(skb), 0);

Don't think this could be the cause of the problem though.

>
> and this after starting hostapd 2.6:
>
> [  207.921068] brcmfmac: brcmf_btcoex_set_mode DHCP session ends
> [  207.921352] brcmfmac: brcmf_cfg80211_change_iface IF Type =3D AP
> [  209.114209] brcmfmac: brcmf_set_mpc MPC : 0
> [  209.143594] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
> [  211.049412] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  213.051521] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  218.084704] brcmfmac: brcmf_escan_timeout: timer expired
> [  218.531282] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
> [  218.531776] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
> [  218.532228] brcmfmac: brcmf_set_mpc MPC : 1
> [  218.533962] brcmfmac: brcmf_cfg80211_change_iface IF Type =3D Infra
> [  218.537955] brcmfmac: brcmf_cfg80211_connect ie (537583ca), ie_len (28=
)
> [  223.410796] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  225.526035] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  227.705830] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  227.956466] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  228.207019] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  228.407567] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  229.521312] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
> [  231.621031] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient head=
room (0)
