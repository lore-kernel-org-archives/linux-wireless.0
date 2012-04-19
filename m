Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36774 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2DSQTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 12:19:45 -0400
Received: by wgbdr13 with SMTP id dr13so8794058wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 09:19:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC79F14-24F2-4F90-8A47-B9B2744F5AE3@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com>
	<CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com>
	<816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com>
	<CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com>
	<5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com>
	<CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com>
	<8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com>
	<CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com>
	<9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com>
	<CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com>
	<8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com>
	<CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com>
	<37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com>
	<4F901224.1040508@sipsolutions.net>
	<EA757D90-2CCE-48A1-AF35-7F65EB45F7EE@gmail.com>
	<4F901F16.6080007@sipsolutions.net>
	<CAC79F14-24F2-4F90-8A47-B9B2744F5AE3@gmail.com>
Date: Thu, 19 Apr 2012 19:19:43 +0300
Message-ID: <CANUX_P2t86v0L=DDaaBdW-6Yb5ffSscv2aSy+jQ5dFc0TqWB_Q@mail.gmail.com> (sfid-20120419_181948_489946_60D58C43)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: multipart/mixed; boundary=0016e6d778b12b991404be0a8a3f
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016e6d778b12b991404be0a8a3f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2012 at 18:08, Dominik Feser
<dominik.feser@googlemail.com> wrote:
> May it be that the fact that Centos 5 doesnt have hotplug causes the issu=
e?
>

Don't think so.
Can it be a problem in the backport of request_firwamre_no_wait ?
Did I see somewhere that you run 2.6.38 ?
Can you check again after having applied the patch attached ?

from the main dir of compat:
patch -p1 < print.patch

Thanks

> Am 19.04.2012 um 16:20 schrieb Johannes Berg:
>
>> On 4/19/2012 7:09 AM, Dominik Feser wrote:
>>> Finally, here is the output of dmesg after recompiling:
>>>
>>> iwlwifi 0000:02:00.0: edd19e18
>>> iwlwifi 0000:02:00.0: d55c1e18
>>> iwlwifi 0000:02:00.0: d55c1ddc
>>> iwlwifi 0000:02:00.0: PCI INT A disabled
>>> Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
>>> Copyright(c) 2003-2012 Intel Corporation
>>> iwlwifi 0000:02:00.0: PCI INT A -> =A0GSI 17 (level, low) -> =A0IRQ 17
>>> iwlwifi 0000:02:00.0: setting latency timer to 64
>>> iwlwifi 0000:02:00.0: pci_resource_len =3D 0x00002000
>>> iwlwifi 0000:02:00.0: pci_resource_base =3D f447c000
>>> iwlwifi 0000:02:00.0: HW Revision ID =3D 0x34
>>> iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
>>> iwlwifi 0000:02:00.0: U iwl_request_firmware d5b37d70
>>> iwlwifi 0000:02:00.0: U iwl_request_firmware e09ebdd4
>>> iwlwifi 0000:02:00.0: ee2afe18
>>> iwlwifi 0000:02:00.0: U iwl_request_firmware ee2afdd4
>>> iwlwifi 0000:02:00.0: cc93fe18
>>> iwlwifi 0000:02:00.0: cc93fddc
>>
>> Still pretty useless since you get %pV printed as a pointer rather than =
a message. Does anyone know how to fix that in compat? But the iwl_request_=
firmware 3 times probably means it failed?
>>
>> johannes
>

--0016e6d778b12b991404be0a8a3f
Content-Type: application/octet-stream; name="print.patch"
Content-Disposition: attachment; filename="print.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h180mthh0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWRydi5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZHJ2LmMKaW5kZXggODBiMTQzOC4uNTc3M2E2
MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZHJ2LmMKKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZHJ2LmMKQEAgLTE4NSw3ICsxODUs
NyBAQCBzdGF0aWMgaW50IGl3bF9yZXF1ZXN0X2Zpcm13YXJlKHN0cnVjdCBpd2xfZHJ2ICpkcnYs
IGJvb2wgZmlyc3QpCiAKIAlzcHJpbnRmKGRydi0+ZmlybXdhcmVfbmFtZSwgIiVzJXMlcyIsIG5h
bWVfcHJlLCB0YWcsICIudWNvZGUiKTsKIAotCUlXTF9ERUJVR19JTkZPKGRydiwgImF0dGVtcHRp
bmcgdG8gbG9hZCBmaXJtd2FyZSAlcyclcydcbiIsCisJZGV2X2VycihkcnYtPmRldiwgImF0dGVt
cHRpbmcgdG8gbG9hZCBmaXJtd2FyZSAlcyclcydcbiIsCiAJCSAgICAgICAoZHJ2LT5md19pbmRl
eCA9PSBVQ09ERV9FWFBFUklNRU5UQUxfSU5ERVgpCiAJCQkJPyAiRVhQRVJJTUVOVEFMICIgOiAi
IiwKIAkJICAgICAgIGRydi0+ZmlybXdhcmVfbmFtZSk7Cg==
--0016e6d778b12b991404be0a8a3f--
