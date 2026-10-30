Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.72.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793345784;
	b=XiVg0vuJ3A9PfukhpoKcEH5NI4UrvDan3ugvtdRiyjgkkB0txqwXFZvplhnavVd1jFsG
	 0XozsdDNxwtiupsRTuucd0T6SRoxCQbhb+hox4oZWYZBdWrd/whpX+csBF9sXicQoTL4G
	 uZRiYEhSGKRKY16hWZU++QrRgsXv3pdp1FmQkL8W4dKwDyN4WzUCca5cJgDnryWbSNhg/
	 NMb1R/pnHTqrzrR/Y6Cur4svqvo2ZThX37F2iOTulEt4hGTHP3S/6Hz97ye8ubWe49ai9
	 b88nyoRMg5iKkvBOHBXosjy6MdtCh7G95CFLwRRGaPGptTwUjg3O74FpdLAhn3R2pDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793345784;
	h=DMARC-Filter:Received:X-ICL-RepId:X-ICL-Out-Info:Dkim-Signature:
	 mail-alias-created-date:Received:From:Content-Type:
	 Content-Transfer-Encoding:Mime-Version:Subject:Message-Id:Date:Cc:To:
	 X-Mailer:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Authority-Info-Out:X-Proofpoint-ORIG-GUID:X-JNJ;
	bh=U8+TgC0g1nzmkR2OIcXhff0e4d03P8e3RHNbpSpnNGE=;
	b=jmmSSJFReA4E/tGIj5xrMGblBYBar6N4OoLstslPKIPx0wzEKCH82GfC62oaj7ip/op/
	 c7TxIviNCEhkunNge4h06n6SEOaZOSUSI7sIa8GMu2HbG9xx3bMZChYJ1hG6B0Wnd6kCe
	 mIhwHw2uzsIUMOf3a8M1uYjaZ9JRnikC6liygakz3JF1jb5G74qocSBy/3p+iLMO9pOd3
	 9z+10nIKdRolwM159Z1fhx0YPfmtEPEVm2QxXixgOdsYyTPSsMHcfA+iGQGWezFEChZct
	 p7m9wSOMYWQpF1uSQUI2EsoO4nnAkKAHx7DpnBS+CIjBDjzwOcMX/QQUA+h51nmaMYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shreyan.sh;
	spf=pass smtp.mailfrom=shreyan.sh;
	dkim=pass header.d=shreyan.sh header.i=@shreyan.sh header.a=rsa-sha256 header.s=sig1 header.b=ZWnCeS2C;
	arc=none smtp.remote-ip=57.103.72.64
Received: from outbound.ms.icloud.com (ms-2005a-snip4-1.eps.apple.com [57.103.72.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C124606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:36:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C124606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shreyan.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shreyan.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shreyan.sh header.i=@shreyan.sh header.a=rsa-sha256 header.s=sig1 header.b=ZWnCeS2C
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-5 (Postfix) with ESMTPS id C166618000DA;
	Fri, 30 Oct 2026 07:36:21 +0000 (UTC)
X-ICL-RepId: 01a18bbc-ff4e-7cb7-b594-c379c51ca7c2
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhNBEMDUxxCDUEdXANYEhVdRVsEdxhaAlwBUgMZGFpQXxwOHl8ZVwlYFh0eX0tAEwRLEwVSB11NVg1HD1geXBQXFUBDXgheH0wcHQ5YBhIATQoONgZZBV4JVgNDBTYSFF1FQAVFDksRV1ZABRcGWxQERAJeD1pxMwpKHigAWHFdDUAAKBpTdEYNVQFaci93Rng9CygBLnIDUQpWFFYFHANRRhMZThtXTVoNQBlYBm0UVhVSBFk=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shreyan.sh; s=sig1; t=1793345782; x=1824881782; bh=U8+TgC0g1nzmkR2OIcXhff0e4d03P8e3RHNbpSpnNGE=; h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To:x-icloud-hme; b=ZWnCeS2CjN2dedE+4/3UTrYd/+4ZTKNLLX1qHRGXq2mS8nJWydBsX/pJ4dI8TEDSYDW0SbDrgtG4jeBh52OBcGRqpuUp+UB5qXOaeCwVYMcDeNOjiay4qfaTEuyUZT6MMBS/gROzIxZ0dT7xfDQxfbOcUaqAKOP/xBd6H4H4nvRYQHy4fDEQAUTteDlTDQb5/jNv5riEQH7rztbGPoBK8VtDgHLOlnvnvHVn2mU+WrQrV71W5sbEAjxAEt5Xdbsn03rdpE8waRqWNzQV0TtkfkWYm7njrfp5m6TegKytX7GFTEPbQf72RgC3wBlquOrAVjlFNvNKoloVuwwXq+M+9g==
mail-alias-created-date: 1750351224127
Received: from smtpclient.apple (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-5 (Postfix) with ESMTPSA id 55DD318000CA;
	Fri, 30 Oct 2026 07:36:19 +0000 (UTC)
From: hi@shreyan.sh
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: [PATCH] wifi: rtl8xxxu: Enable AP mode for RTL8188EU
Message-Id: <1381CC32-E73C-483E-8F64-27EDE6AE8E6E@shreyan.sh>
Date: Fri, 30 Oct 2026 13:05:57 +0530
Cc: linux-wireless@vger.kernel.org,
 Ping-Ke Shih <pkshih@realtek.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAzMCBTYWx0ZWRfXwQ5IH3Y8f+lV
 d/dlcDdFQrouho8VdUEW+WkQ3UKTEtnBqORVMY44EeqZBzXbRx01ub63UHrWBGJiEui8xKY91Ql
 ykcHFv0V2XKqRtyhtUJwc6p41lYPaKEpUmNz6gLcYENctRvzB26xjR/VABvI+sk+lM2y/RXvh5n
 YbU0uq07UQeOsvnQqK2z4ADiCRVdUZNxIk3kiMaM7wLfIAjDEdmbrOMAxGXY3kHIcIBfCIXl8EU
 Bpg4Y6+X8mRFuX8bgWCxy+1sonTFiqwCZpGT29MCLHCbzAD50Y9xmJaW6NxPFudub2JEEqQat03
 iHv03siw5wRsekPIO9i+ZuXacM8BCk5X6158XWpYgKRCwe5kC9iHzlmZ1MUwRs=
X-Proofpoint-GUID: uStpIDsINYZghPZz8usa8DBLc9Nh9eXm
X-Authority-Info-Out: v=2.4 cv=MtpfKmae c=1 sm=1 tr=0 ts=6ae448f6
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Gv6b3Y6SaleGLcC1qPMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: uStpIDsINYZghPZz8usa8DBLc9Nh9eXm
X-JNJ: AAAAAAABLnxcp/KX3lv0F3tb9L6giOPP2CfRvnI97Sx2FIKmTho2gS81x4dbeKfQ4aRycD
 +waBzdE/F0pr8CloZVus6M/YKiabaQHl4FDnxu7OWs4fw5rfysz7UgP/UEMO2HoRpHC2i3
 XbVuDEYk0rgZ8libwcveZZEWl9Wlf5xyw/mXX7h1tUFt6HkUkwla9IKKqWf0UmLvIfAJr4
 Ozvas1g1z1G01rs2mDDmLbFbH3h0w9WY+aPIbNHFq9FKoZ3thfvhs7hmN2DPlYQH346Fn4
 YtHhewyDHlKW4eWNYa/WqM41bLk2suYSVUedaqRdk2RTC4RI+uNhpxAttO7dO2G+omz6Zd
 f6r+dKFGda4O/KHWithIA8eo9nrFt/ZzG57+6GRciONkvjQQI5YohJ536lA8t2kPipprOu
 ohJrCmmi/UjG1HszfktRPzQHX/F/e5hU2qlZFBi6hSff8y8XD12ZvQCS0nE4VzcTIe6v87
 JDOkXCYirf+pF1Ptj02hQtCti1MQ2fX6BH7d0iXbKde1XFd1tYYlG75GCVVlRA6UggQhYC
 lqmhMwWczBhJw0P+elFhlTTfmjeY5ZgL/R0fYnFUJnoRqaBQ1mKXWL8OlcEjhE0ZzoYz/w
 2MqPdhRcoVU+n2UYERMnCYCW9EAu8KfCjEbyZi8tKdm5KMCFJmlqx3k1tFVmt16LCHtPwj
 ewM9fQj+WLb+YxDANpCeTD9y6DFRKpk3nW1kFfEt+aR+51P2QlSbpJF0mo2YRPwG/07P5y
 Nb/O+V2UKevKE6Ouw2qbRJI89Q1Gol9/mHn7N37FEnCblqsFoUHrDPV3gunLfdJePRDR1Q
 fFN8rYsDDEDG3HObmPebCYTuEwQVLRENAQSoZIRPvcnGb6K5ys9ZWhvjX2QgdHrIgt2Ln8
 qGg8XxK4VZLYs9fUAN+FiXfGOLoukL6Q7azQfEH83FszXG9eu3SuNYyHDeIdhDXSLFTsqo
 Di/T0XH2nR5j0NoIV4w218jlfA2gQ2xGl4dyrSYtDN2RN7xY7hv/oJ1QGbRhJ6h3szZBNm
 UiF7ADDYMEcsuuP4CEmKXya6AHT+jlXrPAVgQESePtgOiBDr1Y1Xv4PLzjlEG4FZd+fWF/
 0Q6ATpUXbcdmPcGTRcndc7LJCzsUPzi1h8B6Z0Y2DufBXaVq/YN3jvErMUUufuxlkg5S17
 /cZlUnC6xWQQU2BN/k76CvEebwjrUQZ7j34tfcm0yw5Y11yq0jrrLFFfMlhfKRzr/PEDu1
 tUo2WIyBdSvq25EkiUk8gNnChnPG7gg=

=46rom 0a3cdd4c6cc416804e49c935516a22e854a87483 Mon Sep 17 00:00:00 2001
From: Shreyansh Khajanchi <hi@shreyan.sh>
Date: Fri, 30 Oct 2026 12:34:44 +0530
Subject: [PATCH] wifi: rtl8xxxu: Enable AP mode for RTL8188EU

The RTL8188EU shares the AP mode implementation in core.c with the
other chips supported by this driver, so advertising
NL80211_IFTYPE_AP is enough to make it usable as an access point.

Set max_macid_num to 32 as well, so that max_ap_assoc_sta is
initialised. The vendor driver defines NUM_STA as 32, and starts
station MAC IDs at 2 because 0 and 1 are reserved for
broadcast/multicast. This matches RTL8192CU, which also sets
max_macid_num to 32.

Tested with an RTL8188EUS (0bda:8179) on a Raspberry Pi Zero running
6.12 (armv6): hostapd serves a 2.4 GHz WPA2 network, clients associate
and pass traffic.

Signed-off-by: Shreyansh Khajanchi <hi@shreyan.sh>
---
 drivers/net/wireless/realtek/rtl8xxxu/8188e.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c =
b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
index fea5aec..0c3ab32 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
@@ -1867,6 +1867,8 @@ struct rtl8xxxu_fileops rtl8188eu_fops =3D {
 	.init_reg_pkt_life_time =3D 1,
 	.gen2_thermal_meter =3D 1,
 	.hw_feature_report =3D 0,
+	.supports_ap =3D 1,
+	.max_macid_num =3D 32,
 	.max_sec_cam_num =3D 32,
 	.adda_1t_init =3D 0x0b1b25a0,
 	.adda_1t_path_on =3D 0x0bdb25a0,
--=20
2.56.0=
