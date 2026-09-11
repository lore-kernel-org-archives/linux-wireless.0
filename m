Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazolkn19013086.outbound.protection.outlook.com [52.103.35.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF03CDBB5
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 22:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.35.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789164939; cv=fail; b=RCw5tBYp376b0tBkizcblKjBUNVsGGc1GQCAzEgBKylH/b4NRvUlFif35aTcDErmqp2IDPh/eGtgJckWD+E/kjntzlm92VrsOQBGIT42XNqNImJVC8z3DQ+F2q7KI7YtzWCPm6REIILa2QTK56WxtvVdOYQsbYWsxhPF/dU1+qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789164939; c=relaxed/simple;
	bh=bLna4kz6mC4IQWkFzaeKtrL2vwwNdTUyYDzMIpTZhfw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Au39phhtD4p/Kd9H0KGoetkVOF5mtrAYENt23hqeZALwdYPjtQHRPitK1QsfkG0Zm9N9JCxOmge1DG0OizRXwuw9znUcyGy5S5839kpIfvaWPoDbdhLwojRGsS+zrCOf2UwMRjagi6lv4Lzm36rrigXPwZKmHcC4zs3ciBBiI5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=e+Pu+YJe; arc=fail smtp.client-ip=52.103.35.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="e+Pu+YJe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AXU3l6GnIwdS71YOrzpeUujXsTAKoEiJfo88kEXw/H3C5FDqzzjEp9FbSCpO/AvXaRL6d945zu1KPefyhMW0BADZZaEu/Vq/tr3yJip3APMNnU699si9kCBsClVwdjMENtdevj3JZFTIQZhBIYvOxEyTvR+bDB0tZ4wmvB9E+YKMNifcDs0Evk9hdz/1MRsDXncFs21ex0N27dXsDoQP8VW4bhIPz5UrpBP3lqYTDgcySzMtTvVzgiYJeAffQaI3zK0whzi5DSktgXP1J4AQZ7sQWt6fLNQ1/bwjAmOi8vzInJFC/JACxQUyA8WFp7qrg9gL3y7zEL7poMiheMywIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNZkwB41rkojLWzbZiwN24SwcSYVkvKkv/iypAlnf9A=;
 b=ZU66A4kaKydTJCQdMVlmF0UaqIEiKhMwH14E/GCq84pfTe8+fIQcYblAqrkmQOKgIrGArkwIxOjO9eVsnCiggXDP11bYnHhUmJRQ3tLMXRWKTNKEqjR8AGEY/9oTTNLbUJMmAoJcFrbuWZY7sELxOdFcPuz/Hxzxym7WPcUF/N6PnVYBewt58QmGezfgBiE2uFUr9hUt1272FCwNFXcLhvh/OZhUWFuifRAhPtElAVxNdetdWdj0wULYEmWIxbRiMU2muqtWGSdb+fXlaxC7DuGoZY00j8yRHdy4GBk9FTcVhsMftTqgKIrIVPuQIhXTTTz7Z/sKS8XBtb+8Toh2nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNZkwB41rkojLWzbZiwN24SwcSYVkvKkv/iypAlnf9A=;
 b=e+Pu+YJeQYIiOFYKQ4x2DjE8Hse6hMH+Ce0kly5B+cHEqGjxNxfPXfuKgFuPknKqSbsXi19fblII8BYNZ6DajpaItFx1GJMDdNhIOOwoWBmycXqHU+MVnxgphIIez8y2IQ44gtKUOjb2C3Oe8tI3vq2wBDNQE7Dg+0Qz0s0XIKT3+yIKOK45mXym2zoAd3rtcWziuXfFr26Px12buJXfjc1D8gON6BfM3csBLbfZM43ADXe45TFEEhVE/GrCTNQAxFQciZLkisVga8QLACZ8IYOGGnIBPRr1oGRphj6hjRi+c13SusaV/vuCdoWWmEPNi/WCiqLljY03dupP6xjraQ==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by GV1P251MB0794.EURP251.PROD.OUTLOOK.COM (2603:10a6:150:51::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Fri, 11 Sep
 2026 22:15:33 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 22:15:33 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v3] wifi: mm81x: validate n_channels in disabled channels response
Date: Fri, 11 Sep 2026 23:15:31 +0100
Message-ID:
 <AS8P251MB00015A3FFF9F9A9628CB0BB0C8BE2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0006.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::12) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260911221531.96414-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|GV1P251MB0794:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d54ac3-4d74-4030-4156-08df1052323d
X-MS-Exchange-SLBlob-MailProps:
	vuaKsetfIZn9IFDOZRHBr3PkJ6iE+FIkFeGnMzt8OJ47Br0YQeRT3MphzTM3yxn2UjLpWAdhw/7iKkQ53eNObRHinNlZc19kLMc+JIweMcf2EcASp/IqThbWU9mrbXSvLVx3/mB6GonOR25BJr9yflYgZo1/x0CRtaq+ytT3Mc8/JECXuCI7AbcdowjRfjcDgjTb1VtIID1dQAKtx3yLmYlKkoERNmH9lT9IqMX1mnbjLwElO2guHL2+aIXvzvjwdH1LsPnBzlnUf3lbRsKP4a0LE/vHFsApwivo8738/umYL+2TFsoiOhdpP0LRybVKAiUpt92gh7L9KTY97INW1QP4BaYU8vyOn0FskdPyb7T39ACRw8SC+t83mCOLaB5kNxwLB2AEobEoTpy+Arg0M0tWyNvSWHUBj26xdz40iSjhjMECPpBatDdj65HvzaKWIbPF9Lx17kwWCZmCyDqLPcYc7aJd6keA1RcIBICSv/y551fW2GWuhe3YDbo0YE/FymLRosra1CvzrHAxHq5azJWGgQ8aPevnyv5+3HYZ/ojFacyT9ijUUq/7DBabCz+B7HXZnriV1TBkzAEAPGxtwjj6PjQJnzZor7Bk8uNbKqjRvANkyBvNQ73xLTez+83qZxCjlm0GFZ2G/Pkg/TgHvLtgQDkUTRreWx87NLIEHKc1iictSs6OzmBfNp5IIJY3wfEZj1hT9JDzWRzvIVh4F/MKcJD7D1M+dRutH8/xeSJtoT18v0mYbylgv4xT6h4pLqyP33rmknW6oHAYY+kILs2GlFmE6NjJT84Ec30YisouWLOSLPCaaHsYcFuDzrID
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|23021999003|25010399006|37011999003|25031999004|15080799012|12121999013|19110799012|8060799015|5072599009|24021099003|55001999006|5062599005|40105399003|1602099012|10035399007|2607281247196008|4302099013|3412199025|440099028|26104999009;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a8TzQgaNTV/tzfDh8xivGi7KwSpCxI5+E3S4Br7z7LP3FgKEPGpyBwg32Yz3?=
 =?us-ascii?Q?eI1jI95A2jiJ/9I1ywnXJFLL2/JZvgSlPXNSoktOjdzhKwVljDu4ab4dExyv?=
 =?us-ascii?Q?RbSA5+Mpj5NxJoOSbF33/fZAaQjH8SMFpArsxs7MXaXmZqCzp9vEdcFyuQDb?=
 =?us-ascii?Q?7jwVrgU+CuP/99Hx8zvv7sKXq/V3SeUsH2h3yuo8IAqFJt/6Ah4OBYvY8gMj?=
 =?us-ascii?Q?iTZwMgSLFzUwRtgHFDp/Xxr7bLCTdTyXL8DN8Jl9eOJDEvJYqF82nxE7gB5S?=
 =?us-ascii?Q?bFdvs2vRLrZ/V1aeJltv5DI20RWGbCOJVRitrmypFM76QE244vJ3i9mhYhqF?=
 =?us-ascii?Q?Q3ddidZd8Pa+pGRWHeWyKmpdP0VxcyI6G5D6G3xGrzHadfqwldWTe8wEH3RR?=
 =?us-ascii?Q?7SiFURJKKb2uEwTr8qu9OiUZx/XBDX2Hsr8X+0UhimB8e16VH/avD3WabfWB?=
 =?us-ascii?Q?dlLF+oGfuFtGAqaHiEgZ/j0cm/leoGuKmkeMR7RIk1ZFw1vri6MWjvvTSRwl?=
 =?us-ascii?Q?MCryGuaFWAf6Y1ECXnK/13AKtE5/bOc5ZwykyGfzVeDmC6Ra/I5hZGAoPBNb?=
 =?us-ascii?Q?50h6jn9AeBfD69Lhlp3+JOJEgcxkjXCxD4sUUYgF2TeXN1Rfn2fJ3UYngJtL?=
 =?us-ascii?Q?ZJ1nG9R9giNo+CzokPaWBaVUfz5pYMOPspWUHWAnUKKn5txfBQX+SwdsNxBm?=
 =?us-ascii?Q?U/T43/a6BntqF7YWBzc840+wy8amsjEAselvRZtKSq4UoH5JOkkkPf5Zak5t?=
 =?us-ascii?Q?2OlQJiIPOQzSAn7zHXnQJVoXYeRUFG5kNdq886JxgPJA2A/Td/aTTdPPAGO3?=
 =?us-ascii?Q?Mj9qoj1Jl8N9JthWzL8NICM3jjcJToWZzpSem4gOiz7dQTCOfT1n1EQX1BcX?=
 =?us-ascii?Q?lh85OMZS88/KsToTQyNraSRJH3NdUp4uxCsvfZ07Phu4yUrdqsnbRcrf2h4I?=
 =?us-ascii?Q?GvidGEWEpFccSkwO8pYVjTRWE+1pHbdTg8HZZoBP/becTD0Ojtuofml2PjX2?=
 =?us-ascii?Q?qHRAC0cJlTX/vFUc85PW42YqqZutzD8IORmmvUoOhXFFI9wUDzTT1OxhRwBk?=
 =?us-ascii?Q?TK2UP8m0E93h8iJLyq5S6LwVwMgHzdhMxesVJ7REU2A7lXje7vtvAyWPbPFj?=
 =?us-ascii?Q?eyHBZIjNF3Owsp/mhKj9hHg76Vg9VPKwrG7BP8hNgwEcvvJkExq9QG0XkFCI?=
 =?us-ascii?Q?izrs23ePlnZqPvbb?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rf6OfK28fE2mI/9hv8WoX1L7Jq0RrUXf5XgDLi7/YFD1clJik8z7F0D9mKU9?=
 =?us-ascii?Q?MC9PmJCdyjTZvCRtVvuReiMCbwGxTXHcY9KWmvpH5sHef0TGAW1adxW0ktmy?=
 =?us-ascii?Q?4Q6CaEeW5robaTaFy6zttCYrB5eD9pNjmn8V7zeP006XzhqaXD0fhUOTMr3k?=
 =?us-ascii?Q?lrqUOVsJBI4sdtx18qSoQBUoPECOk86DNgUtvrYGNYARf8QSDXz9EwEw61bO?=
 =?us-ascii?Q?+mrFCAyuwPy2PZqAPg2g2OuCG+ehbh2InE0ZFvzUrfMeUAbr6tOCMePtjBYx?=
 =?us-ascii?Q?krGw2wELUrVN43UisE9otrP6RJ/Fvl9cu7j//UL9P5bEJfU8+QBuWhE2BnBF?=
 =?us-ascii?Q?OvQbUQv8PrBWWS68U8148plVxAOZsEI64BZrTU7uWt13gAo1Orr5L66drhyX?=
 =?us-ascii?Q?jmZHTImVw4Wg9YmURpMnBqnmbZ03qnWBPHi8M1HrKSAjymgAhtJoMw9c2gmt?=
 =?us-ascii?Q?P093TmVkf4/NqVw7FIQS1hxY42io1FwlSDbvPUYecgDyaYa67v0ng3ByYzpn?=
 =?us-ascii?Q?xN9a28gmGG9oF6DPZuT4sEfz8boAPW/m3AcaHuURzQlvTVIQHekcrDsy//zT?=
 =?us-ascii?Q?UBin8PSelMhTkeqtWSz9OsNVpogBNvZ55nT9aI5zLcvvK8RRhbi+5aEwzF1S?=
 =?us-ascii?Q?nRPWjRSZb1elZZBvmkBsKDkeUx4CAONOc0MdVusYzHFwATPwFKGl54dghrU2?=
 =?us-ascii?Q?RvUTXBcdIQdNsGYhe6lcVBDqhdDPxp7moxRwExRDtNYyw2XL+Lz42yvmJBPg?=
 =?us-ascii?Q?23kmAETugOAEZiPNuzfFsYUV7eYMlEbzw7S99r9Otp4SOkFtBHhKEVcqhI/8?=
 =?us-ascii?Q?4idF/FcuYTfdkwF0AFTtuNv0MHobrjNVskQPVs8K6SG6+duooqU0YTxavXEy?=
 =?us-ascii?Q?iPcjMVxGknPcL0Bdh+XzF9BX0gH9By/kf+IgRUd4huEZ2tS12ox1Xjda9hpM?=
 =?us-ascii?Q?ZELItZfjTEbmEGV8u7MPSwxh6d2iP4Q4RoYeuNlSP/wJmKNR6zASqabodbTW?=
 =?us-ascii?Q?KaRBOzHcGIKfpreTqs7rPicpxYduboB34xliZUS83aVXrekZjL0ehkk1d0BR?=
 =?us-ascii?Q?xZW+WHgZeJwYEm3M6McgZKaUMEQ9ip4+SErOnWKHlFPccHmdn7iUnVmsJlvh?=
 =?us-ascii?Q?5EGNpptnWA6kkTA5s41v+j1shCdlpNgdg3eeHsFhBZ6LpO5Wi03Jz4BSnpQY?=
 =?us-ascii?Q?rN3kG/dgpmD0/ueTe9atvVqD5ai0rC3I5GOLkej5Wazjm2E2+o0ALgzVTAkc?=
 =?us-ascii?Q?ApVxtBuizY1dQjgOelQSgmkdKdjHoyQSwNIXyeE3ymfwm0FQSttkCUJxHDiG?=
 =?us-ascii?Q?SyGZQGMOeWesUiDs976ba+R32rIvRYpKY0Jw0OyMOroiTv2dZwUq/wYkB8mV?=
 =?us-ascii?Q?lvAJPn+O9gQwpCns409ROzb0gGoXcLW/Px9huLOzVYzYJxT1lozCTOXMlFyW?=
 =?us-ascii?Q?D9Wa4zemwzdbjL0sBI5CKh2TP6DJyiVD?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d54ac3-4d74-4030-4156-08df1052323d
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 22:15:32.9277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P251MB0794

mm81x_mac_check_fw_disabled_chans() iterates over n_channels entries of
the firmware response without validating the response length against
the array size. A firmware response with n_channels larger than
ARRAY_SIZE(mors_s1ghz_channels) reads past the end of the response
buffer.

Validate it right after the command returns, before the first loop.

Assisted-by: LLM
Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
v3:
  - single patch against wireless-next; v2 was stacked on v1 and did
    not apply (Lachlan)
  - wireless-next named in the subject so NIPA runs (Lachlan)
  - drop the flag-clearing paragraph; describe the check as validating
    the response length against the array size (Lachlan)
  - Assisted-by: LLM, placed before Fixes: (Lachlan)
v2: https://lore.kernel.org/linux-wireless/AS8P251MB00017F5BF791EA475A60A6CCC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/
  - move the check above the first loop, right after
    mm81x_cmd_get_disabled_channels() (Lachlan)
v1: https://lore.kernel.org/linux-wireless/AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/

The uint -> u32 change to mm81x_cmd_get_disabled_channels() will follow
as a separate patch once this lands.

Compile-tested only (W=1 on the base-commit below); I have no mm81x
hardware.

 drivers/net/wireless/morsemicro/mm81x/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 08ca116a6..c3035a993 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -279,6 +279,11 @@ static void mm81x_mac_check_fw_disabled_chans(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
+	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(mors_s1ghz_channels); i++) {
 		struct ieee80211_channel *ch = &mors_s1ghz_channels[i];
 

base-commit: 13e51269b6656768dc595ed6025e4974f2026543
-- 
2.43.0

