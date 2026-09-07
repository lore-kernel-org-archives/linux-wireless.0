Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013072.outbound.protection.outlook.com [52.103.51.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F41838F65B
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 03:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788751085; cv=fail; b=AvllFxdUyG8Pd6LpJrBY+1oDJv2pznmz5IiFBwl4gcN3RNi/5iB7MfxoNo9j99FNHk1yLADBY9PIXh/PRmbVbMzIoSX2P7XHhKMOdRJNqe4mlBUixioGd9BaihMjDBWbbOyzZJe3CQUdFhRl2ga9BFWQNFihMDXm9KJ713ID0qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788751085; c=relaxed/simple;
	bh=ThbRaAbw9suuT2JMB0DbbAkQT38PZUY+229U/B7MYh8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=o9YORKaKI6bw5lZtaRO386omVev2ZQ9bo5nlgAbLBS0NA8mx/61x67E3FwqPOlY4FB1OBk4p6P6qt3kvTOQxokzcEUk+AtY8YyNEFUod6/l/pjwLdxwaP9UUOO9LaaQ73cZUQyVhukCaebfKk/TPM46ftG4TevfFaYhonpqZMqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=Txss2kYF; arc=fail smtp.client-ip=52.103.51.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="Txss2kYF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KiQqE7Tr0cCU9/fb8P1RKrkch7N1ecEFaRC085lorsOC47pGf88iXmZ6HN0zDXIB4qmA8Qgy4HBBRLsxAECnmNCq2qN6QMTrtj2QvPWmjd2XCeYrftslXuhMrLgEIuk1sGJe9VntWnS4ANcSaICaY4Df20lUI+osRSGNTe4+yOjR1I86OKV5PYxj443MTr6irbEfNZkXCFFDDNjjSpIJ2Xh5T0ICopk8ggaJm2L74vP0PGLJvSVHKK5SOBxhFacDGL0cTzqf9EcMi/LSsqZzlSLE1PlCk1dF77xSHQVLMV6YSLpwhkqUyOAoYoiyCXAFqySWpRPoCbY8Ql+NxgL5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNfeBmD+tV+dZWxNY4GAlRRdLDPgRmD1P07rU+YOvzA=;
 b=V7/O2vng/wTr+O1SwY26FOGLB9LRGncXCB7B7SVGQAIsQwor9TLRcjmegbEfA5LmGlIxaLion5FX1Fl+gir9WXEzlmuOcxe8mnc3FUomNbuzdrch44ySesQW7avmoOwlHkXZs6tpy30TuRuB+k7I7nY+rshSz3WuBZDmubK0TyJSB14ISYcs6fXnhyjzH0gb4HqcG5S999vuna2L2bPJjg+7NHv+fDp3k2d3sNSBm6vv744iEz79FdbN7bCuPmoVIhhe68L5YchVlP/FXcCGfTZdcTJRe+ujAOyX1qhthMUu7tIsBL92+UE2rmOcjOzYGojvXp2HnNHGZPIfQF1iRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNfeBmD+tV+dZWxNY4GAlRRdLDPgRmD1P07rU+YOvzA=;
 b=Txss2kYFRiWMxiqB9PZnmZMC5hQ0ZEjlBj6szbUcw4i86l3zJtdPDplBFFDfSR9gUp9azGABolWyC9yBdrlUs7FnuPwcZVKQVR0j1HWD4UNpviCWKJM77gZ6iUQAEb0yiNn7pnN29Lod68MP0JLN9DiabRR0InJHHHxDCypClWoLxjA+IBZVEYkPFnobO/DNTLWJ3KCrqmcFOJhwLzgGMpSYWc/KND/d53VvYEclESbGIzwux9miGm3LwJ5/DvMTNBnirQBN4beDe7rkMWyF4QQPCneeh/vasknGlTq71H+ZlcdPv0uiWh9QqmviW7WD494MqU+4d0CeFBwjhP4pTQ==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AS1P251MB0679.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:4aa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 03:18:00 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 03:18:00 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: jerome.pouiller@silabs.com,
	linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: wfx: validate MIB read length before copying to caller
Date: Mon,  7 Sep 2026 03:17:57 +0000
Message-ID:
 <AS8P251MB00014841C19595C74C545C80C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0059.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::17) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907031757.514028-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AS1P251MB0679:EE_
X-MS-Office365-Filtering-Correlation-Id: f356745e-7642-4b8a-9388-08df0c8e9f07
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5062599005|41001999006|24021099003|25010399006|5072599009|15080799012|12121999013|19110799012|51005399006|8060799015|23021999003|2604032031799003|55001999006|37011999003|25031999004|3412199025|440099028|26104999009|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XauME1BlDy8p81bu1SLb3xP8WU/QJI5Z0gcRGYzKOXfBCKcBxVyqGGXCEHb+?=
 =?us-ascii?Q?QKe83JVXtXondFshqgWHHSBgl/qjl1nU37WO9gN+g/F0yUeTAK77EBq2IBFU?=
 =?us-ascii?Q?YtKJUrM21gXdHMMg0ER7owp0oBbWl1KBjFrf7LK6kdvU0dUcDOiAooGNQajC?=
 =?us-ascii?Q?6UE73zM5Pna8rCoQGT8tJpxPM5y3ltZwo6vT6cPLKZAdaEB0qFxylg6kGO7O?=
 =?us-ascii?Q?in0kmLPCG4lzR9+XW8gg8w7bP5FXUjYCZW+BkOJZlXCtQAQpB2ayh5jdHbFc?=
 =?us-ascii?Q?iU0Zqd90hg5JTKJ8emwCr8mgniUqRoPXDfsZBvhEQ/6moDaO4mihCY2jWQnF?=
 =?us-ascii?Q?YRPM+zV2qYPNG3Fa/NcadTzUhvdJ09FwSAQq/G2ynazvEEhIVt2FFFz/iAdy?=
 =?us-ascii?Q?rS8HcxpUUapc1YP+LGzQdtN80wx8R5M+C8mT2s4mBqc9bEPohmu0LpCpXLZe?=
 =?us-ascii?Q?TQ9ApJUl6c37EAqFrRGspsD512FNgume+5SnUBrkxIwEoFrDNZc/9LTyydCK?=
 =?us-ascii?Q?tlHr+iDf+G5ykzPTI25u9cQ9OHiPrQvUD13YJzS8Ri1AmyizWqXsC8gYHkjF?=
 =?us-ascii?Q?d9/0XQGinxWelIkhN/3mwknD5v8v2Fmsu9PAaKxNYuiWTzKeG/USB5BXMK+5?=
 =?us-ascii?Q?q2Q5RLTpi8AMmYK+Uu/svT8l5Xw44qvZSpRcX+uyicfYq++Ke7WltOz+Db+T?=
 =?us-ascii?Q?1WsdHmT8fnCuMM/XIN+6395lZ8yhnw0bnqFcy5eoY9UrPJGvIRgBMi+18kuW?=
 =?us-ascii?Q?YMdIxruamP5o+tcngWnMsm4GkGowBWVu3LosiBiQgPFIxjN8k9I+ezv8s0bg?=
 =?us-ascii?Q?ENZS+KSlVK3HckTrsVhmop8+HWPbEhPNIOD7NEaYGuYT/L0V2fly0KSp/uTJ?=
 =?us-ascii?Q?7V71BSBUNpdJJuCrhyUge1WNlArWyx+/4XsttEJsRbhEiTIKPi8xCI9BMj3m?=
 =?us-ascii?Q?eUIIkSLCJ2q6fvqGZsQfbmqajm0ngV72K4kuVvOfPejw8Z83MMm+5Kpfoxa8?=
 =?us-ascii?Q?AORyot9B+qkooYHzdYQTyZAHrUmIJU5OH2TsH8/zQi/kzhWLkeRv+mnmiukm?=
 =?us-ascii?Q?xmthcLEgwQC2UImx6TdIY0VBLra+roQgnTsMcrcv5/qpBTC7L3x0AavJ5mzO?=
 =?us-ascii?Q?7iBrCP55t8VMUsw89VEeYDlHxVuAc9zIJpPYIMfaDFeavXPCH78GfFGXFer9?=
 =?us-ascii?Q?Mld7v1YS4Q+2o0tsxskIsHlvc67DwX69w1q4Jw=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yDeFnoNRn5tPqwqRn7gKmAMOnr8GsV/PYrDYYLa2cvPu9xqHeu6oVy4fDy0T?=
 =?us-ascii?Q?Jnv6/4b1O3gjoGyuwrf5AhgKj3vIDXXF3KaUekBfonYUC3J587xQMCz/dgIb?=
 =?us-ascii?Q?2iVbj43Yfa4QQa6G+pOzs0zuAihzned+h6DvsIF8N2FPyTM8H0zkxnY4A0m6?=
 =?us-ascii?Q?+HmidBYFAZ1j4x9QEzox2YnE0wcS91DUOABjf/Z354l5alS2TeSogodNkHZ3?=
 =?us-ascii?Q?uA70peIszLNEWEqJ15g6FLKVnvADRFwRmEC1GyLTVcKC/j2qLUyVgxxaboE9?=
 =?us-ascii?Q?eWcTnkX1CuKL8bZcWBzqFh+DqDH0DdiJg0BdjVWzAgoqmYnyeK8yv8dIxopT?=
 =?us-ascii?Q?xLe9k7/vtCYO4BBVPRLc6qd5OgFk/eL5XxixcMliwVgvHFC/c7/RZTiSVl1z?=
 =?us-ascii?Q?hqh8oJCDamNL/LK0QbORwlBREHVe5y5PcruKyvbTXgFN6KIbUnsn3g65l1n+?=
 =?us-ascii?Q?18Nvkwm09Zktn/WDILXI0rEYdncSoJzbLfNDo0FKoWvxgxjPZk9VnQ58lojY?=
 =?us-ascii?Q?5TemJ4JceabQ1OYK0OlU3zvWHb/3MKPHlq2g4JwnjQtJDU34vSiXk9bU01u0?=
 =?us-ascii?Q?ByUnqlhKleBASx1CVoJHzqtdRehv2lWDJWEVDwo3WPpQVZKB/CcLSFaKUcey?=
 =?us-ascii?Q?6zu/nIZtccQnSxws87TlqMWESrD99E1jlHwg6x616HKhuFmAOuIuNhrrgQgF?=
 =?us-ascii?Q?HS2f+eQ/e7XMuc6I8DQ/B0k3w7zY6rQ+iQGg8bdL52rakd82oLvlWGrYxSyB?=
 =?us-ascii?Q?j/PIrWIRUQvO0/h515cqxT9ERcoXtDzTnZdqnNj88dQ0ZgUwzAfv2N2VCMZW?=
 =?us-ascii?Q?OKyq6YzHwIqwDVsDaTO0QRMCtZceBU0yXGymocgW3gtmV/LB+815J6Yf1qNV?=
 =?us-ascii?Q?eYmpAg+L0pURWZ5FGr5wtZPTnY3bCq81viMb1j5CL+qbrBMQMcpqdNM3yfWg?=
 =?us-ascii?Q?ecW3uSjHxoqieMu7U2/JrIDcjfk+6y1/TrftOnRFF0TIDybKWdsYqrEiZ9fV?=
 =?us-ascii?Q?wtScRtQC3xAOb9ie4m5o777bvPqb/9W05zLcslUXy8ChXEs6IkZdOiReb9L3?=
 =?us-ascii?Q?1ln8WxeMo3l9MgGYyTecIt27/8u3LCwFTY1xyXINev5cys6/REMrenjSRwgJ?=
 =?us-ascii?Q?Y0YekFytwkNfZ0mIHC8BMEmuNEY1qB54NN/M9Z8Kkk1aWRhFPdkU35Jz6qp9?=
 =?us-ascii?Q?T2wX40gNLb8G7Mb7He/Yt4y99KgW4cnabUPMCHJK/T9DUwI9JIYD5S2gG0ht?=
 =?us-ascii?Q?A3wEBazqCMFgBUPQlhZjlo7zb+SmIa2DlJm9FFbQyhvlGhx3KjNkknTTvGdE?=
 =?us-ascii?Q?Giq1TSajy/jxK5uxPsnrVMUBFprbL1494fmx5doI6iyiutEP0DrgkBrKyveB?=
 =?us-ascii?Q?z79ghrqimd7qnTRiErRh1JiIX2OuzrgRsiTkGqG3EMU8y7XmSjUNgflfbVuh?=
 =?us-ascii?Q?OODp9FYk8vLzi9pW4VommySq1MZgw4E9?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: f356745e-7642-4b8a-9388-08df0c8e9f07
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 03:18:00.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1P251MB0679

wfx_hif_read_mib() copies reply->length bytes from the firmware
response into the caller-provided buffer without checking that
reply->length does not exceed val_len. A firmware response with
a length field larger than expected causes a heap buffer overflow
when writing to the caller buffer.

Replace the dead -ENOMEM check with an active validation that
reply->length fits within val_len before the memcpy.

Fixes: 9bca45f3d692 ("staging: wfx: allow to send 802.11 frames")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/silabs/wfx/hif_tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/silabs/wfx/hif_tx.c b/drivers/net/wireless/silabs/wfx/hif_tx.c
index 9f403d275cb1..a6bc1c522e3c 100644
--- a/drivers/net/wireless/silabs/wfx/hif_tx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
@@ -207,9 +207,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id, void *val, si
 		dev_warn(wdev->dev, "%s: confirmation mismatch request\n", __func__);
 		ret = -EIO;
 	}
-	if (ret == -ENOMEM)
+	if (!ret && le16_to_cpu(reply->length) > val_len) {
 		dev_err(wdev->dev, "buffer is too small to receive %s (%zu < %d)\n",
 			wfx_get_mib_name(mib_id), val_len, le16_to_cpu(reply->length));
+		ret = -EINVAL;
+	}
 	if (!ret)
 		memcpy(val, &reply->mib_data, le16_to_cpu(reply->length));
 	else
-- 
2.43.0

