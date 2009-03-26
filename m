Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:59972 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZCZBrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 21:47:09 -0400
Received: by ey-out-2122.google.com with SMTP id 4so96331eyf.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 18:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238020625.15025.15.camel@mj>
References: <1238020625.15025.15.camel@mj>
Date: Thu, 26 Mar 2009 03:47:04 +0200
Message-ID: <40f31dec0903251847p260446bfi22a1b4c587dc41cc@mail.gmail.com> (sfid-20090326_024714_031772_664CC13B)
Subject: Re: [ath5k-devel] [BISECTED] AR5414 fails to scan after "ath5k:
	Update reset code"
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/26 Pavel Roskin <proski@gnu.org>:
> Hello!
>
> AR5414 fails to scan most of the time starting with the revision
> 94f2e0d6234991d0c10d458f6f378934efbdf6d6 "ath5k: Update reset code"
>
> I have about 18 APs in the range. =C2=A0With the latest kernel, the s=
can
> results are usually empty. =C2=A0I tried reverting parts of the patch=
, as it
> cannot be cleanly reverted on top of wireless-testing, and I've seen
> scan results with all APs occasionally, but most of the time the scan
> results would be empty.
>
> With the last working revision, bbcce7389a7288c48d96d13bbf521e901236d=
287
> "ath5k: Update initvals", scanning gives all APs in range every time.
>
> The chip is reported by the driver as:
> ath5k phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
>
> $ lspci -vnn -s 0000:0b:00.0
> 0b:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242=
x 802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Subsystem: Apple Computer Inc. Device [106=
b:0086]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: bus master, fast devsel, latency 0,=
 IRQ 16
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Memory at fe8f0000 (64-bit, non-prefetchab=
le) [size=3D64K]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Power Management versio=
n 2
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [50] Message Signalled Inter=
rupts: Mask- 64bit- Count=3D1/1 Enable-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [60] Express Legacy Endpoint=
, MSI 00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [90] MSI-X: Enable- Mask- Ta=
bSize=3D1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Advanced Error Reporti=
ng
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UESta: =C2=A0D=
LP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- =
UnsupReq- ACSVoil-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UEMsk: =C2=A0D=
LP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- =
UnsupReq- ACSVoil-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UESvrt: DLP+ S=
DES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- Unsup=
Req- ACSVoil-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CESta: =C2=A0R=
xErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CESta: =C2=A0R=
xErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0AERCap: First =
Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [140] Virtual Channel <?>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Kernel driver in use: ath5k
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Kernel modules: ath_pci, ath5k
>
> It's a PCI Express minicard. =C2=A0The kernel architecture is x86_64.
>
> --
> Regards,
> Pavel Roskin

That's weird, I've tested this with my 5413 and it works just fine. It
seems that 5424 (pci-e version of 5413) still has some issues. Have
you tried monitor mode ?

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
