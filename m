Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61106 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbcHDFaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 01:30:20 -0400
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] ath9k: fix GPIO mask for AR9462 and AR9565
Date: Thu, 4 Aug 2016 05:30:00 +0000
Message-ID: <1470288583349.11756@qti.qualcomm.com> (sfid-20160804_073029_214951_11B0F71D)
References: <1464932817-30988-1-git-send-email-miaoqing@codeaurora.org>
	<20160717230519.46e3a661@mir>,<87r3a6556p.fsf@qca.qualcomm.com>
In-Reply-To: <87r3a6556p.fsf@qca.qualcomm.com>
Content-Type: multipart/mixed;
	boundary="_002_147028858334911756qtiqualcommcom_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_147028858334911756qtiqualcommcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Sorry, try the patch.  AR5416 will invoke ath9k_hw_gpio_get() before gpio  =
initialized correctly.=0A=
=0A=
Thanks,=0A=
Miaoqing=0A=
=0A=
________________________________________=0A=
From: Valo, Kalle=0A=
Sent: Wednesday, August 3, 2016 9:54 PM=0A=
To: Stefan Lippers-Hollmann; miaoqing@codeaurora.org=0A=
Cc: linux-wireless@vger.kernel.org; ath9k-devel; sudipm.mukherjee@gmail.com=
=0A=
Subject: Re: [PATCH] ath9k: fix GPIO mask for AR9462 and AR9565=0A=
=0A=
Stefan Lippers-Hollmann <s.l-h@gmx.de> writes:=0A=
=0A=
> Hi=0A=
>=0A=
> On 2016-06-03, miaoqing@codeaurora.org wrote:=0A=
>> From: Miaoqing Pan <miaoqing@codeaurora.org>=0A=
>>=0A=
>> The incorrect GPIO mask cause kernel warning, when AR9462 access GPIO11.=
=0A=
>> Also fix the mask for AR9565.=0A=
> [...]=0A=
>=0A=
> I think I'm seeing a very similar issue on AR5008/ AR5416+AR2133 and=0A=
> 4.7-rc7 (mainline v4.7-rc7-92-g47ef4ad, to be exact).=0A=
>=0A=
> [    4.958874] ath9k 0000:02:02.0: enabling device (0000 -> 0002)=0A=
> [...]=0A=
> [    5.401086] ------------[ cut here ]------------=0A=
> [    5.401093] WARNING: CPU: 1 PID: 1159 at /build/linux-aptosid-4.7~rc7/=
drivers/net/wireless/ath/ath9k/hw.c:2776 ath9k_hw_gpio_get+0x148/0x1a0 [ath=
9k_hw]=0A=
=0A=
[...]=0A=
=0A=
> Reverting this, and the other patches depending on it, fixes the=0A=
> problem for me:=0A=
>=0A=
> e024111f6946f45cf1559a8c6fd48d2d0f696d07 Revert "ath9k: fix GPIO mask for=
 AR9462 and AR9565"=0A=
> db2221901fbded787daed153281ed875de489692 Revert "ath9k: free GPIO resourc=
e for SOC GPIOs"=0A=
> c7212b7136ba69efb9785df68b669381cb893920 Revert "ath9k: fix BTCoex config=
uration for SOC chips"=0A=
> dfcf02cd2998e2240b2bc7b4f4412578b8070bdb Revert "ath9k: fix BTCoex access=
 invalid registers for SOC chips"=0A=
> 668ae0a3e48ac6811f431915b466514bf167e2f4 Revert "ath9k: add bits definiti=
on of BTCoex MODE2/3 for SOC chips"=0A=
> c8770bcf5cefa8cbfae21c07c4fe3428f5a9d42a Revert "ath9k: Allow platform ov=
erride BTCoex pin"=0A=
> 79d4db1214a0c7b1818aaf64d0606b17ff1acea7 Revert "ath9k: cleanup led_pin i=
nitial"=0A=
> b2d70d4944c1789bc64376ad97a811f37e230c87 Revert "ath9k: make GPIO API to =
support both of WMAC and SOC"=0A=
> a01ab81b09c55025365c1de1345b941a18e05529 Revert "ath9k: define correct GP=
IO numbers and bits mask"=0A=
>=0A=
> AR9285 (168c:002b) is fine either way.=0A=
=0A=
Miaoqing, have you looked at this? Looks like another regression which=0A=
should be fixed.=0A=
=0A=
--=0A=
Kalle Valo=0A=

--_002_147028858334911756qtiqualcommcom_
Content-Type: text/x-diff; name="ath9k-fix-accessing-gpio-warning.patch"
Content-Description: ath9k-fix-accessing-gpio-warning.patch
Content-Disposition: attachment;
	filename="ath9k-fix-accessing-gpio-warning.patch"; size=538;
	creation-date="Thu, 04 Aug 2016 05:18:55 GMT";
	modification-date="Thu, 04 Aug 2016 05:18:55 GMT"
Content-Transfer-Encoding: base64

LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKQEAgLTI0ODIsNiArMjQ4Miw4IEBAIGludCBhdGg5
a19od19maWxsX2NhcF9pbmZvKHN0cnVjdCBhdGhfaHcgKmFoKQogCQlyZXR1cm4gLUVJTlZBTDsK
IAl9CiAKKwlhdGg5a19ncGlvX2NhcF9pbml0KGFoKTsKKwogCWlmIChBUl9TUkVWXzk0ODUoYWgp
IHx8CiAJICAgIEFSX1NSRVZfOTI4NShhaCkgfHwKIAkgICAgQVJfU1JFVl85MzMwKGFoKSB8fApA
QCAtMjUzMSw4ICsyNTMzLDYgQEAgaW50IGF0aDlrX2h3X2ZpbGxfY2FwX2luZm8oc3RydWN0IGF0
aF9odyAqYWgpCiAJZWxzZQogCQlwQ2FwLT5od19jYXBzICY9IH5BVEg5S19IV19DQVBfSFQ7CiAK
LQlhdGg5a19ncGlvX2NhcF9pbml0KGFoKTsKLQogCWlmIChBUl9TUkVWXzkxNjBfMTBfT1JfTEFU
RVIoYWgpIHx8IEFSX1NSRVZfOTEwMChhaCkpCiAJCXBDYXAtPnJ0c19hZ2dyX2xpbWl0ID0gQVRI
X0FNUERVX0xJTUlUX01BWDsKIAllbHNlCg==

--_002_147028858334911756qtiqualcommcom_--
