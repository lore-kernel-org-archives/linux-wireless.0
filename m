Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFA618C02E
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788714315; cv=pass; b=poEFp51jbDQrBcNXoioHL9gS6RpFeDCO5CWVT0VnQ902PLV+MSdQEThzrBiitd6DQ2kWERN+bnckFA3antMpzJDnGr0Q0UesKlp/fIZp3OuY9OpwZnKPugVcJGkvbn7Mx/gXtrvJIv8yemWSK2XuTFFV13W1JReg4Dv1YgtV5Y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788714315; c=relaxed/simple;
	bh=8fXne5T8mflJIcqQiHG7pXn1c3SyLN6hIiaTu1VteFE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=p3b+eVD2UEne+LL+NaV3GuWnCrUV8HJ+7lDpApQMdl0o8BrxJ1GjvoaLrCOTj79t/EhK7j/gW0hE35SeCu9Oou8gpTcTa24+YusanZdDxQcCp0OQRXvEcVKyejhP6V4delYCRKekmtK02iAoyE+1qkVrsK2vKki6q1OmtEq6i4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rYhYHbLu; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rYhYHbLu"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c25b661d37dso367277766b.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 10:05:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788714312; cv=none;
        d=google.com; s=arc-20260327;
        b=qd4bzJktF5B2w2YujETmn++Okq+l51A5kTMSVWosHC0puSqfVyCoPKvAR8/aGiassV
         9WKm1TvR1+J0PsKgLrQZRaOBDx6Lw1/ndzu8Oe8WVSqxTHH79g+M8BO9PrxKFkopw2nK
         zKrn9j2BVyAoBtRiThBKHqpV7yJ122ydDTBgIqeHKPKLDkyh4XGI+BNaMSzDCwWoOpap
         vPnJUI89VRMQg0BFfNjXAFaNFMgLOTbyZLwtKNeV6paGhZ1dBkdrcieFBM0N3wQdD7Ka
         IQXmLc7SviHLOiYsfzJRe5rfC46PwJCXjK299v+ontBeAWK7pg4zuwcv/FtRLD6xuRuE
         h2/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=lpZZMLMHvlqMqswwbt0dtw/wSlCGyEJ00c3Xa/znKv4=;
        fh=YwBtleC/YAjEWE4DPg2k2jqh/FMvJB0nl0KRnZchQG0=;
        b=nptnkN+ovVPv77fcz0ytiiaNIEWPSm3fBBEXhOUx/XdpFRvmm+XrTLhpitqZ3GtH6p
         GQ9zWqUB3zNlavH/OV6QU7C8SKaVUYJvdAucIuyNGPLQtEjmfR7Bxf4ELN/3VxQtgwPu
         BoQsE68WszX5h8u7mbUTjThhpPxJ4i/OrpcScYBlAILazbF/OwKqGZxfjF7RfrmhexOr
         vPERqN2QIXQdNtTJi8xeUpGdogYlg6xR3T0L8l5CkPxJoTfn8D9iJYPisdTRHz7Wferq
         reYIDzPRP4EPYqERYw+M2FndY9pxJENhxNtODxaWVfAJN0jlGn0uu0rFbrypiuvDz0Le
         ZV6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788714312; x=1789319112; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=lpZZMLMHvlqMqswwbt0dtw/wSlCGyEJ00c3Xa/znKv4=;
        b=rYhYHbLuRZ0L2E2mZ16lEFQIHNw6sEDskMkUzt01eurVJKZkrn8a3TUxS1r0i+vsvq
         5BZkmmq7auea4NaMzi+E05PDPz75FdrOjl6hCFE2kJ3gVZhFK0fRsQkhbSCCyHthFria
         /LebkYwOZJaPalmxWFpHHaGku59D+Z27zscbRMnHwmGX6NLPS6JzKoX3SmTuBhgVnXal
         lOAPnL4szixjsMwsdQqfvf5y/sVerGrSeugvdCDV2vRTPh1lDkTyEv3yZ4TOKbMjZFSu
         1HsVwgJ/n3nzR4bdFRHu1s4P1tu3y+oRifViFb6g1o8cr4hqnxUOFcQXGjZlni9b+fxx
         Z1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788714312; x=1789319112;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lpZZMLMHvlqMqswwbt0dtw/wSlCGyEJ00c3Xa/znKv4=;
        b=Fo6rPAlEoUTU7gm3M6XwFFiosmo6+UU2zMys14Pfn5+sYl+eivrDotdgog/c0S5oCv
         OSIKjIEHr+1pgJg39WjkQmJ0ech3z4aV6MF4dPgBHAVmUygg1j1M6mxCcsAtnWi5Gm5w
         r+aYP40Tyai7EhHHi5a71SHJ+VmhedK3+bWHZVSElnIl6N6yhQYY0xG5wMwCrm6XSC/X
         B3dqju8t1IqTuqrWWowAPeEpXnIFZhbvDLYV72e6NoseFwzxrDEqUFi7mVwseseRYUCu
         LovJwpR2+NKu96jH92XwZlgCESkog0QWZgAWzYYIOWwnK4lr8g5cQdK+dnQ23rWQ3Xew
         dxRQ==
X-Forwarded-Encrypted: i=1; AKwUvBzRhC792w0ws4G24AhXP31Q6KduXaNZMQ4JGkTFv3t4x2WMBbhkFSH2YKYki4y+d2YZFKQ9Q4hhkzjnGceJCg==@vger.kernel.org
X-Gm-Message-State: AFuF++mHibZ2tYusGb4TZvBJnAGCndZBkKP2W6Vc2p837IuYaUl5eEDO
	9sXX5ELyprThXqknx46EAyHdcrPvZvCayutzPSNs2Ck90/UHZ8ryj6LMZUisrXvZy357fPTwcYE
	+qLP2IyscqmERVvN1+Qd9/MYlnbcoZPw=
X-Gm-Gg: AYBFou0kbcN/jwu2r3wyBafNAJWfwFCyLb70lgZvP+vRQp4SV9u0CVNC35N0BITAnf2
	F2KNEazCnADeL2a0LgVA/0u6jh6hGqCLJGF7yqIDm2UFY2sRhOSkGRWlgvOH+g2aEZ9eLtGX9iG
	INrfFXL3l0RlZs1dUyUKTCAAiwqww9lQsLtTYCfNA2Ltcu8IIMpx41t3+5ugOqOYgMjH4X0Cwts
	MO8LQVEbJFM4AKuLCEeIY5cC0QM803plNxZXhVXnfQi0DaKX4WsrxujpFBoApB4LdhBUkDixo2P
	boSksnEucp9By8SYQwwOKEPxkzJngn/hsTj0rbMu
X-Received: by 2002:a17:907:d649:b0:c26:19e3:e982 with SMTP id
 a640c23a62f3a-c2619e3eee5mr525101766b.34.1788714311398; Sun, 06 Sep 2026
 10:05:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ermak S <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 20:05:02 +0300
X-Gm-Features: AcwNN1Ugy_dAKZY8eqVOuAgTRDDsM1ZKej_LqO6mg-LVUQmSKhoCBkDei60G_Nc
Message-ID: <CAMnMt5YMA70FJwH+ddo24Ejd8HbpFSgUv73Ybu-fu+F-gcoesQ@mail.gmail.com>
Subject: [PATCH] wifi: mt7601u: add vnd_reset parameter to fix probe failure
 on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000022f14f065ad38151"

--00000000000022f14f065ad38151
Content-Type: multipart/alternative; boundary="00000000000022f14d065ad3814f"

--00000000000022f14d065ad3814f
Content-Type: text/plain; charset="UTF-8"

wifi: mt7601u: add vnd_reset parameter to fix probe failure on Tenda U2

On certain MT7601U adapters, such as Tenda U2 and
other newer hardware revisions, driver initialization consistently fails
during probe with vendor request timeouts (-110 / -ETIMEDOUT):
  mt7601u 3-14:1.0: ASIC revision: 76010001 MAC revision: 76010500
  mt7601u 3-14:1.0: Firmware Version: 0.1.00 Build: 7640 Build time:
201302052146____
  mt7601u 3-14:1.0: Vendor request req:07 off:09a8 failed:-110
  mt7601u 3-14:1.0: Vendor request req:02 off:09a8 failed:-110
  mt7601u 3-14:1.0: Vendor request req:07 off:0734 failed:-110
  mt7601u 3-14:1.0: Vendor request req:42 off:0230 failed:-110
  mt7601u 3-14:1.0: probe with driver mt7601u failed with error -110

The failure occurs because mt7601u_load_firmware() unconditionally calls
mt7601u_vendor_reset() (MT_VEND_DEV_MODE_RESET) before uploading firmware
chunks. On these devices, issuing this vendor reset leaves the internal
MCU / FCE DMA engine in an unresponsive state after the first firmware
URB is submitted. As a result, reading MT_TX_CPU_FROM_FCE_CPU_DESC_IDX
(0x09a8) immediately times out.
Introduce a boolean module parameter 'vnd_reset' (default: false) to
make this vendor reset optional. When the vendor reset is skipped,
firmware upload succeeds and the wireless interface initializes normally.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301

More issues with Tenda U2 and Linux:
- https://www.opena.tv/viewtopic.php?t=63919
- https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
- https://bbs.archlinux.org/viewtopic.php?id=224859
-
https://www.reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/

Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru
<GermanAizek@yandex.ru>>
Signed-off-by: Herman Semenoff <GermanAizek@yandex.ru>
Signed-off-by: Herman Semenoff <germanaizek0@gmail.com
<GermanAizek@yandex.ru>>

diff patch changes for sashiko.dev viewer
```
---
 drivers/net/wireless/mediatek/mt7601u/mcu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index bad6ca821..abf4767f1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/usb.h>
 #include <linux/skbuff.h>
+#include <linux/moduleparam.h>

 #include "mt7601u.h"
 #include "dma.h"
@@ -21,6 +22,14 @@
 #define MCU_FW_URB_SIZE (MCU_FW_URB_MAX_PAYLOAD + 12)
 #define MCU_RESP_URB_SIZE 1024

+static bool vnd_reset;
+module_param(vnd_reset, bool, 0644);
+MODULE_PARM_DESC(vnd_reset, "Perform vendor reset during firmware upload
(default: false)");
+
+static bool disable_usb_sg;
+module_param(disable_usb_sg, bool, 0644);
+MODULE_PARM_DESC(disable_usb_sg, "Unused compatibility parameter");
+
 static inline int firmware_running(struct mt7601u_dev *dev)
 {
  return mt7601u_rr(dev, MT_MCU_COM_REG0) == 1;
@@ -459,8 +468,10 @@ static int mt7601u_load_firmware(struct mt7601u_dev
*dev)
  mt7601u_wr(dev, 0x94c, 0);
  mt7601u_wr(dev, MT_FCE_PSE_CTRL, 0);

- mt7601u_vendor_reset(dev);
- msleep(5);
+ if (vnd_reset) {
+ mt7601u_vendor_reset(dev);
+ msleep(5);
+ }

  mt7601u_wr(dev, 0xa44, 0);
  mt7601u_wr(dev, 0x230, 0x84210);
--
```

--00000000000022f14d065ad3814f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>wifi: mt7601u: add vnd_reset parameter to fix probe f=
ailure on Tenda U2</div><div>=C2=A0</div><div>On certain MT7601U adapters, =
such as Tenda U2 and</div><div>other newer hardware revisions, driver initi=
alization consistently fails</div><div>during probe with vendor request tim=
eouts (-110 / -ETIMEDOUT):</div><div>=C2=A0 mt7601u 3-14:1.0: ASIC revision=
: <span class=3D"gmail-wmi-callto">76010001</span> MAC revision: <span clas=
s=3D"gmail-wmi-callto">76010500</span></div><div>=C2=A0 mt7601u 3-14:1.0: F=
irmware Version: 0.1.00 Build: 7640 Build time: <span class=3D"gmail-wmi-ca=
llto">201302052146</span>____</div><div>=C2=A0 mt7601u 3-14:1.0: Vendor req=
uest req:07 off:09a8 failed:-110</div><div>=C2=A0 mt7601u 3-14:1.0: Vendor =
request req:02 off:09a8 failed:-110</div><div>=C2=A0 mt7601u 3-14:1.0: Vend=
or request req:07 off:0734 failed:-110</div><div>=C2=A0 mt7601u 3-14:1.0: V=
endor request req:42 off:0230 failed:-110</div><div>=C2=A0 mt7601u 3-14:1.0=
: probe with driver mt7601u failed with error -110</div><div>=C2=A0</div><d=
iv>The failure occurs because mt7601u_load_firmware() unconditionally calls=
</div><div>mt7601u_vendor_reset() (MT_VEND_DEV_MODE_RESET) before uploading=
 firmware</div><div>chunks. On these devices, issuing this vendor reset lea=
ves the internal</div><div>MCU / FCE DMA engine in an unresponsive state af=
ter the first firmware</div><div>URB is submitted. As a result, reading MT_=
TX_CPU_FROM_FCE_CPU_DESC_IDX</div><div>(0x09a8) immediately times out.</div=
><div>Introduce a boolean module parameter &#39;vnd_reset&#39; (default: fa=
lse) to</div><div>make this vendor reset optional. When the vendor reset is=
 skipped,</div><div>firmware upload succeeds and the wireless interface ini=
tializes normally.</div><div>=C2=A0</div><div>Link: <a href=3D"https://bugs=
.launchpad.net/ubuntu/+source/linux/+bug/1716301" rel=3D"noopener noreferre=
r" target=3D"_blank">https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1=
716301</a></div><div>=C2=A0</div><div>More issues with Tenda U2 and Linux:<=
/div><div>- <a href=3D"https://www.opena.tv/viewtopic.php?t=3D63919" rel=3D=
"noopener noreferrer" target=3D"_blank">https://www.opena.tv/viewtopic.php?=
t=3D63919</a></div><div>- <a href=3D"https://askubuntu.com/questions/141885=
0/the-problem-with-wi-fi-u2" rel=3D"noopener noreferrer" target=3D"_blank">=
https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2</a></div>=
<div>- <a href=3D"https://bbs.archlinux.org/viewtopic.php?id=3D224859" rel=
=3D"noopener noreferrer" target=3D"_blank">https://bbs.archlinux.org/viewto=
pic.php?id=3D224859</a></div><div>- <a href=3D"https://www.reddit.com/r/arc=
hlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/" rel=3D"noopener nore=
ferrer" target=3D"_blank">https://www.reddit.com/r/archlinux/comments/1d6df=
v5/mt7601u_usb_wifi_not_working/</a></div><div><br>Signed-off-by: Herman Se=
menoff &lt;<a href=3D"mailto:GermanAizek@yandex.ru" rel=3D"noopener norefer=
rer" target=3D"_blank">GermanAizek@aizekgroup.ru</a>&gt;</div><div>Signed-o=
ff-by: Herman Semenoff &lt;<a href=3D"mailto:GermanAizek@yandex.ru" rel=3D"=
noopener noreferrer" target=3D"_blank">GermanAizek@yandex.ru</a>&gt;<br>Sig=
ned-off-by: Herman Semenoff &lt;<a href=3D"mailto:GermanAizek@yandex.ru" re=
l=3D"noopener noreferrer" target=3D"_blank">germanaizek0@gmail.com</a>&gt;<=
br><br></div><div>diff patch changes for <a href=3D"http://sashiko.dev">sas=
hiko.dev</a> viewer</div><div>```</div>---<br>=C2=A0drivers/net/wireless/me=
diatek/mt7601u/mcu.c | 15 +++++++++++++--<br>=C2=A01 file changed, 13 inser=
tions(+), 2 deletions(-)<br><br>diff --git a/drivers/net/wireless/mediatek/=
mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c<br>index bad6ca=
821..abf4767f1 100644<br>--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c<=
br>+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c<br>@@ -10,6 +10,7 @@<b=
r>=C2=A0#include &lt;linux/delay.h&gt;<br>=C2=A0#include &lt;linux/usb.h&gt=
;<br>=C2=A0#include &lt;linux/skbuff.h&gt;<br>+#include &lt;linux/modulepar=
am.h&gt;<br>=C2=A0<br>=C2=A0#include &quot;mt7601u.h&quot;<br>=C2=A0#includ=
e &quot;dma.h&quot;<br>@@ -21,6 +22,14 @@<br>=C2=A0#define MCU_FW_URB_SIZE	=
		(MCU_FW_URB_MAX_PAYLOAD + 12)<br>=C2=A0#define MCU_RESP_URB_SIZE		1024<br=
>=C2=A0<br>+static bool vnd_reset;<br>+module_param(vnd_reset, bool, 0644);=
<br>+MODULE_PARM_DESC(vnd_reset, &quot;Perform vendor reset during firmware=
 upload (default: false)&quot;);<br>+<br>+static bool disable_usb_sg;<br>+m=
odule_param(disable_usb_sg, bool, 0644);<br>+MODULE_PARM_DESC(disable_usb_s=
g, &quot;Unused compatibility parameter&quot;);<br>+<br>=C2=A0static inline=
 int firmware_running(struct mt7601u_dev *dev)<br>=C2=A0{<br>=C2=A0	return =
mt7601u_rr(dev, MT_MCU_COM_REG0) =3D=3D 1;<br>@@ -459,8 +468,10 @@ static i=
nt mt7601u_load_firmware(struct mt7601u_dev *dev)<br>=C2=A0	mt7601u_wr(dev,=
 0x94c, 0);<br>=C2=A0	mt7601u_wr(dev, MT_FCE_PSE_CTRL, 0);<br>=C2=A0<br>-	m=
t7601u_vendor_reset(dev);<br>-	msleep(5);<br>+	if (vnd_reset) {<br>+		mt760=
1u_vendor_reset(dev);<br>+		msleep(5);<br>+	}<br>=C2=A0<br>=C2=A0	mt7601u_w=
r(dev, 0xa44, 0);<br>=C2=A0	mt7601u_wr(dev, 0x230, 0x84210);<br>--<br>```</=
div>

--00000000000022f14d065ad3814f--
--00000000000022f14f065ad38151
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.diff"
Content-Disposition: attachment; 
	filename="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mtq29ec40>
X-Attachment-Id: f_mtq29ec40

RnJvbSBjMDNkNzNkMzdkZjQ0MGQwMDQ2ZDY4NDA2ZmRlMmFhMWY2MmZlMGQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIZXJtYW4gU2VtZW5vZmYgPEdlcm1hbkFpemVrQGFpemVrZ3Jv
dXAucnU+CkRhdGU6IFRodSwgMyBTZXAgMjAyNiAwNzoxNDozMiArMDMwMApTdWJqZWN0OiBbUEFU
Q0hdIFtQQVRDSF0gd2lmaTogbXQ3NjAxdTogYWRkIHZuZF9yZXNldCBwYXJhbWV0ZXIgdG8gZml4
IHByb2JlCiBmYWlsdXJlIG9uIFRlbmRhIFUyCgp3aWZpOiBtdDc2MDF1OiBhZGQgdm5kX3Jlc2V0
IHBhcmFtZXRlciB0byBmaXggcHJvYmUgZmFpbHVyZSBvbiBUZW5kYSBVMgoKT24gY2VydGFpbiBN
VDc2MDFVIGFkYXB0ZXJzLCBzdWNoIGFzIFRlbmRhIFUyIGFuZApvdGhlciBuZXdlciBoYXJkd2Fy
ZSByZXZpc2lvbnMsIGRyaXZlciBpbml0aWFsaXphdGlvbiBjb25zaXN0ZW50bHkgZmFpbHMKZHVy
aW5nIHByb2JlIHdpdGggdmVuZG9yIHJlcXVlc3QgdGltZW91dHMgKC0xMTAgLyAtRVRJTUVET1VU
KToKICBtdDc2MDF1IDMtMTQ6MS4wOiBBU0lDIHJldmlzaW9uOiA3NjAxMDAwMSBNQUMgcmV2aXNp
b246IDc2MDEwNTAwCiAgbXQ3NjAxdSAzLTE0OjEuMDogRmlybXdhcmUgVmVyc2lvbjogMC4xLjAw
IEJ1aWxkOiA3NjQwIEJ1aWxkIHRpbWU6IDIwMTMwMjA1MjE0Nl9fX18KICBtdDc2MDF1IDMtMTQ6
MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6MDcgb2ZmOjA5YTggZmFpbGVkOi0xMTAKICBtdDc2MDF1
IDMtMTQ6MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6MDIgb2ZmOjA5YTggZmFpbGVkOi0xMTAKICBt
dDc2MDF1IDMtMTQ6MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6MDcgb2ZmOjA3MzQgZmFpbGVkOi0x
MTAKICBtdDc2MDF1IDMtMTQ6MS4wOiBWZW5kb3IgcmVxdWVzdCByZXE6NDIgb2ZmOjAyMzAgZmFp
bGVkOi0xMTAKICBtdDc2MDF1IDMtMTQ6MS4wOiBwcm9iZSB3aXRoIGRyaXZlciBtdDc2MDF1IGZh
aWxlZCB3aXRoIGVycm9yIC0xMTAKClRoZSBmYWlsdXJlIG9jY3VycyBiZWNhdXNlIG10NzYwMXVf
bG9hZF9maXJtd2FyZSgpIHVuY29uZGl0aW9uYWxseSBjYWxscwptdDc2MDF1X3ZlbmRvcl9yZXNl
dCgpIChNVF9WRU5EX0RFVl9NT0RFX1JFU0VUKSBiZWZvcmUgdXBsb2FkaW5nIGZpcm13YXJlCmNo
dW5rcy4gT24gdGhlc2UgZGV2aWNlcywgaXNzdWluZyB0aGlzIHZlbmRvciByZXNldCBsZWF2ZXMg
dGhlIGludGVybmFsCk1DVSAvIEZDRSBETUEgZW5naW5lIGluIGFuIHVucmVzcG9uc2l2ZSBzdGF0
ZSBhZnRlciB0aGUgZmlyc3QgZmlybXdhcmUKVVJCIGlzIHN1Ym1pdHRlZC4gQXMgYSByZXN1bHQs
IHJlYWRpbmcgTVRfVFhfQ1BVX0ZST01fRkNFX0NQVV9ERVNDX0lEWAooMHgwOWE4KSBpbW1lZGlh
dGVseSB0aW1lcyBvdXQuCkludHJvZHVjZSBhIGJvb2xlYW4gbW9kdWxlIHBhcmFtZXRlciAndm5k
X3Jlc2V0JyAoZGVmYXVsdDogZmFsc2UpIHRvCm1ha2UgdGhpcyB2ZW5kb3IgcmVzZXQgb3B0aW9u
YWwuIFdoZW4gdGhlIHZlbmRvciByZXNldCBpcyBza2lwcGVkLApmaXJtd2FyZSB1cGxvYWQgc3Vj
Y2VlZHMgYW5kIHRoZSB3aXJlbGVzcyBpbnRlcmZhY2UgaW5pdGlhbGl6ZXMgbm9ybWFsbHkuCgpM
aW5rOiBodHRwczovL2J1Z3MubGF1bmNocGFkLm5ldC91YnVudHUvK3NvdXJjZS9saW51eC8rYnVn
LzE3MTYzMDEKCk1vcmUgaXNzdWVzIHdpdGggVGVuZGEgVTIgYW5kIExpbnV4OgotIGh0dHBzOi8v
d3d3Lm9wZW5hLnR2L3ZpZXd0b3BpYy5waHA/dD02MzkxOQotIGh0dHBzOi8vYXNrdWJ1bnR1LmNv
bS9xdWVzdGlvbnMvMTQxODg1MC90aGUtcHJvYmxlbS13aXRoLXdpLWZpLXUyCi0gaHR0cHM6Ly9i
YnMuYXJjaGxpbnV4Lm9yZy92aWV3dG9waWMucGhwP2lkPTIyNDg1OQotIGh0dHBzOi8vd3d3LnJl
ZGRpdC5jb20vci9hcmNobGludXgvY29tbWVudHMvMWQ2ZGZ2NS9tdDc2MDF1X3VzYl93aWZpX25v
dF93b3JraW5nLwoKU2lnbmVkLW9mZi1ieTogSGVybWFuIFNlbWVub2ZmIDxHZXJtYW5BaXpla0Bh
aXpla2dyb3VwLnJ1PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYwMXUv
bWN1LmMgfCAxNSArKysrKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21l
ZGlhdGVrL210NzYwMXUvbWN1LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2
MDF1L21jdS5jCmluZGV4IGJhZDZjYTgyMS4uYWJmNDc2N2YxIDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L21jdS5jCisrKyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL21lZGlhdGVrL210NzYwMXUvbWN1LmMKQEAgLTEwLDYgKzEwLDcgQEAKICNpbmNsdWRl
IDxsaW51eC9kZWxheS5oPgogI2luY2x1ZGUgPGxpbnV4L3VzYi5oPgogI2luY2x1ZGUgPGxpbnV4
L3NrYnVmZi5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZXBhcmFtLmg+CiAKICNpbmNsdWRlICJt
dDc2MDF1LmgiCiAjaW5jbHVkZSAiZG1hLmgiCkBAIC0yMSw2ICsyMiwxNCBAQAogI2RlZmluZSBN
Q1VfRldfVVJCX1NJWkUJCQkoTUNVX0ZXX1VSQl9NQVhfUEFZTE9BRCArIDEyKQogI2RlZmluZSBN
Q1VfUkVTUF9VUkJfU0laRQkJMTAyNAogCitzdGF0aWMgYm9vbCB2bmRfcmVzZXQ7Cittb2R1bGVf
cGFyYW0odm5kX3Jlc2V0LCBib29sLCAwNjQ0KTsKK01PRFVMRV9QQVJNX0RFU0Modm5kX3Jlc2V0
LCAiUGVyZm9ybSB2ZW5kb3IgcmVzZXQgZHVyaW5nIGZpcm13YXJlIHVwbG9hZCAoZGVmYXVsdDog
ZmFsc2UpIik7CisKK3N0YXRpYyBib29sIGRpc2FibGVfdXNiX3NnOworbW9kdWxlX3BhcmFtKGRp
c2FibGVfdXNiX3NnLCBib29sLCAwNjQ0KTsKK01PRFVMRV9QQVJNX0RFU0MoZGlzYWJsZV91c2Jf
c2csICJVbnVzZWQgY29tcGF0aWJpbGl0eSBwYXJhbWV0ZXIiKTsKKwogc3RhdGljIGlubGluZSBp
bnQgZmlybXdhcmVfcnVubmluZyhzdHJ1Y3QgbXQ3NjAxdV9kZXYgKmRldikKIHsKIAlyZXR1cm4g
bXQ3NjAxdV9ycihkZXYsIE1UX01DVV9DT01fUkVHMCkgPT0gMTsKQEAgLTQ1OSw4ICs0NjgsMTAg
QEAgc3RhdGljIGludCBtdDc2MDF1X2xvYWRfZmlybXdhcmUoc3RydWN0IG10NzYwMXVfZGV2ICpk
ZXYpCiAJbXQ3NjAxdV93cihkZXYsIDB4OTRjLCAwKTsKIAltdDc2MDF1X3dyKGRldiwgTVRfRkNF
X1BTRV9DVFJMLCAwKTsKIAotCW10NzYwMXVfdmVuZG9yX3Jlc2V0KGRldik7Ci0JbXNsZWVwKDUp
OworCWlmICh2bmRfcmVzZXQpIHsKKwkJbXQ3NjAxdV92ZW5kb3JfcmVzZXQoZGV2KTsKKwkJbXNs
ZWVwKDUpOworCX0KIAogCW10NzYwMXVfd3IoZGV2LCAweGE0NCwgMCk7CiAJbXQ3NjAxdV93cihk
ZXYsIDB4MjMwLCAweDg0MjEwKTsKLS0gCjIuNTUuMAoK
--00000000000022f14f065ad38151--
