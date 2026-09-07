Received: from mx0b-0024c301.pphosted.com (mx0b-0024c301.pphosted.com [148.163.153.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D967440BCBB;
	Mon,  7 Sep 2026 06:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.153.153
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764378; cv=fail; b=W7Y+7ldWQC4kvYS6tRE6DQeDms2Ork7UL+oI9EDtPBUvs23tzFpttarNlDDMBbytklT+5J65C8MvvEr99FP5kxJ4mGtdwmAvPChfHdHA4C2QIgaYNgcMeBxsTxUWhO1kjA7VfwSjRKzbSWzizzdGh1KKGkeGej6+Ej81LrFrsmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764378; c=relaxed/simple;
	bh=cFGHuu33ES0RkGFCYZjBOPezv2hkMevoLxxUv4zdDi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MuxLwoMbYEWgW1IAeVQfUDi8vzU3c/mbB9R3RXUWO5zWYl5yK/AGvOQeaEzaKOfE9RvSE9ybDvcmwXwh3neNuZOL6+GS7RswleEdAnCXbRKA0Sy77w4pA+BS14rmzmtzmyRbBHgcEc4EMrhhmliZ3DYp5MBO8a7TeI/iDmtmevk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=ieL8+eyJ; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=E8AL1p+h; arc=fail smtp.client-ip=148.163.153.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="ieL8+eyJ";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="E8AL1p+h"
Received: from pps.filterd (m0101742.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6873nLRb3505313;
	Mon, 7 Sep 2026 01:59:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=xeA4hxFgsz9LgXbNI2Hq500scis/qVqOekJwlHXCQTU=; b=ieL8+eyJFC5B
	ZbX4eNCtJquDh9RZD3zYUgrFsUz8JKK/LzGgFqRZwEpjt+m0PMzqoPa7SFy2rRiZ
	XysiVEIjiy7HgWz9Pxx4EwsszMccvC5Cau/sP7Li9SY7JnthvijVBMoy5dYP/0Nh
	FtU+O8/cRBje9pU8bW2x/YAU/CaxOtUmhif4IC1v2Vlm64wA6mK4PZjGSuVVn2qY
	MmWksndAFwDpc0Umi1JfcaWIr43IzyvaJSsDHmnMGkFQVv9X/1IYsiE+yVKnPGWn
	P56BD2qnL8g6Jw2gDAhMi0cMTXuePulvWb3kw67vUTgjaJ27fM1Gge4+6CEkmoRZ
	vdN6WXadKg==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020104.outbound.protection.outlook.com [52.101.61.104])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4ggckbae9t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 01:59:28 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pH7iRqJ0T5iv+CNJIc/qvMs07c7GF/714nnhpM/F7HS48u/ztsABvOH8LQMdDzvsMTgjl4xQ0E6QNuZ2DqkfUKpra8403Kl94HBRcEsnZEnyxveQYz9R3iI1Pm/RkPwYqgx3i4duTMYGttWEmW+DR4hX0uHHQZyrcvmPMpFSH7otVROv7MVfTuOpynUobACBz+tJz4hRk9pTmiBFm50ZY1CFLl4/NOq4mSSpVYkjfPAJBSjmg3wywtDVYXOTEa8Zog1x1JH6w9ZPkH1I/kuggU/U/sPYDq/GY0h5cNptBlc9IG0zGTNIl3RxKzq8cwij08Obofful5bM6tU7zRixbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xeA4hxFgsz9LgXbNI2Hq500scis/qVqOekJwlHXCQTU=;
 b=OiBnMHoetjqiDRaY8NvabTXOKt//CSPl3arRPImvx/C1eevwrcXPnlqqM333OroXpcJRJrp43ANy6ipyHkhDN0txbSddsZiH4G4+qYPTxaGUHnZtZZC5egn9/nHWPGNaV04mE0nS3PqFKOlk0qioR/gximr3vS+o1PwBjYGuPF7HfEioVwZuXQzqSyELrKD9eHyiHBj6qEOXysj/YVb6BTQog+71wGSwVCyq3pzcaJmtfYLqOUCiNeCkjj2QYSgAm5WvGaD6sa/m4xkfCH91GlELJ8QWvGQ6oPiuAERGHnf6P7xHpAASNpGlRWMvgxNUZWRJWZSWNJWQkAHHWwMydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeA4hxFgsz9LgXbNI2Hq500scis/qVqOekJwlHXCQTU=;
 b=E8AL1p+hrIavFkDIuza46FcEFMaumPwL6UDJn2upPlJOVP2cfJvW+c+vJvDcmVrQAWYTSJpCjudA2yc+r0OHIv19vDNSARPeZQut9YsrmGJ60L7qFZ9j6DeVIpbZVatvnS5XUFcw2b+c28rFeYsbT+eI3P/wk08JMZ+U3vhaJ+k=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 06:59:25 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 06:59:24 +0000
From: =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
Cc: "linux-devel@silabs.com" <linux-devel@silabs.com>,
        "Stockmann, Lukas" <lukas.stockmann@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Salvatella, Gerard" <gerard.salvatella@siemens.com>
Subject:
 Re: [PATCH wireless-next 2/2] wifi: wfx: fix error code on unsupported
 firmware
Date: Mon, 07 Sep 2026 08:59:20 +0200
Message-ID: <3424781.oiGErgHkdL@nb0018864>
Organization: Silicon Labs
In-Reply-To: <afd87cc3d8703bd107740396a8b38d3a24720335.camel@siemens.com>
References:
 <20260906204831.949692-1-jerome.pouiller@silabs.com>
 <20260906204831.949692-3-jerome.pouiller@silabs.com>
 <afd87cc3d8703bd107740396a8b38d3a24720335.camel@siemens.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: PA7P264CA0408.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:39b::23) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|BL1PR11MB5271:EE_
X-MS-Office365-Filtering-Correlation-Id: 40fccbea-136c-4cae-55f7-08df0cad8d2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|23010399003|38350700014|6133799003|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kfl88WY8FAlTtaO/GAqjmD78lo1jvhjggFtz/S/plDyOciLJpd33AL+qGxy4awaFEhrJK3KOLgjHNMCX0eDdvpbYvmwbseBfmcr3QQezyxyKaw3Qd+KU85D6f7fb074WGmOfR2aMoxbHC55VedGf0QSrHZ4vPHglSWz08YsCqv+xBAGYrD3mb2mz8+EuYIDmE+oRnIhnd8fghQ/LFgADVJiK7iWs9cZSzllAAYy26+CybGZVA9whv188XhpteX1pxJE1ghWvF6hlRNRmWu8b1gwhslM5KfsT9S0fQIeReVOXxw2/JWyqNnUSqlOn5Wftnwvx09wgB3U9h/+5YY7SBQ+el8z0AEbKsFfwwjBYJueJzMnkL+Uv2Aqb496tpRXV3UJ1lCgX/i1sEeKVhrNX4HRXDkWAO2Bu3cEbfBfhBNJJhvb1c8o92IB1CDjtkn9s3gYqzkt9Im8uEw2Ainvxl5n7hVidbPiKEmaRaLM+WezzqAFb+j2keXK2o+Oyau4p9FV5J0mP5Am6Jr8Rm4FhINUtgD48UcX2Chr7qGVTDECe7A1l/vX2if0pGpgKdqvhQ1M1tQ0/i+IFdlwR8ERx/z55eJpSmYdbcrJKH3Jkd+BkQfuC+ZcFVF6ZxeiwD5jf1KIFtHPoxJ1sCjGzL+ysDzsmuzq94GcuzyX6kIsL4MKh3J8XXqvk8ow81cU5K6TbEcDh/2DwmTgY+H3wz+9QidJ/Sz1A9j1TwLce0XQ/dSQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(23010399003)(38350700014)(6133799003)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dk0yT09hcUtIYTFSakVYbUpJRFdxZVUzejFPcm9ENThvTEYzSCt4aXZucWlW?=
 =?utf-8?B?Q1Iza05hR1hhQ0JESXJtQVM4SHQyTmZSYzh1WUhBallNYlJXOUpTNmxIUC9B?=
 =?utf-8?B?bXRreHVUYTBPZERJa1hyeHl6bGdldDN2L0Z3YWQ4Nmx0TVJ2MXBLZng1dVpk?=
 =?utf-8?B?OWErM3RWaXJZcmtLdmx0T0hvWVUyK0xqdzZYdFZoUVF6aXYzOFNCSVMxMlc0?=
 =?utf-8?B?eTNHcDhzTExQZlVpV1JmbzZ4ZjhKd0Uya0JObStlcEdyRHNOT08vUG1CSlZa?=
 =?utf-8?B?TUU5bm5Zc0RwK3lDaGVMbHVla2hXV3lwMm1CUUtUOXVEcjM2eTlBcVZYR1lC?=
 =?utf-8?B?bUNsUGlPNGo1SWxjU0c5L09venh3NkFONkl2Q29CaHdlY3dORkE4Z0hkdUVU?=
 =?utf-8?B?bW1YSHFZZGRQNHBBejJYKzdrcHI5ZTJwUDZ4TE92YTlOeDl4cXZNMG00USs4?=
 =?utf-8?B?T0pHa3RHRkpwclBKYkxwNTdTT1FqVXAzVjUyNndmenRBVFVPK0pIbklIOEty?=
 =?utf-8?B?Z2JWbm9YK0p1elpKdWJDcHl1N2pZazErQms4eC84VnRxNGRUdnpTN1JFdExl?=
 =?utf-8?B?eWdaYXVGZlMyY09OUnRkZTNHUXZCRkZZc2s0MWRhdk54aE9YckZJOGdsaWND?=
 =?utf-8?B?d29PK0Fkazl1eVQ5VEtkLzk2RWJaNGlDNmYxL2EwS3h1OU1yL2UyUjdSSG5E?=
 =?utf-8?B?WTQ0ZEIyd04yWm51RVk4eW1lSWhWS3pmTy94eGVkSkY2RlBuR2UrSVlub1Zm?=
 =?utf-8?B?cXhHNHprN3BlV2FKcnEydTM4TE9SVXg4bFJ5d0JLOGtIOEQyc0o1bzNMMXN2?=
 =?utf-8?B?N2lMSE91SjJxSUZhQ04rN1ZvVVFZcWRFMDgycGpTeG9jM0NVM0txckNOZjMx?=
 =?utf-8?B?Z0RrbUZjcTFRcnRyS3V4U1JGVlNhbkNwZElWUm1RTWl3RkI2MGVQQkprU1I1?=
 =?utf-8?B?M1RISFo5UkY5QTdxVzkvMHczWjV2YXhVaCs1blE4SmdoQ2dMa0JMNFh6Q0N4?=
 =?utf-8?B?MTV5NEJacmZURXhVSHVDS1AyYVNVcWFNLzZ3OVUyTnIxOG5WalZXU3U5Z2VU?=
 =?utf-8?B?eTJidkFHTm83c0t4Y1lrbGNueisvMWZncGwrZVZ3K1Jtc1JMY3pjanNtU1p5?=
 =?utf-8?B?YldNYzhQVHU4ZjZxTGxldkJvZE5hR21yWnhoMTNJN2xxaFlndUxKK09oZzVX?=
 =?utf-8?B?cHBONUo5VWJFNjM4MW0vb2tyTFk5VE1IQzBYcDlScUNZYnFlblBqVVBJTDFZ?=
 =?utf-8?B?N0JJZ1ZsV29Vc1JwcVF2OERvOXhIdy9lRVo0aDhKVElQRnNiYVhSRmlBRGpV?=
 =?utf-8?B?eU9xOHd1cXozdVduUkJwbE10RnhTOG1xcWJWWGp5MVRzeDEvOU1EQjNub0wv?=
 =?utf-8?B?OVNVZkMwSjljY1NEUVZpcWxNMldmalZhTlBpb1NYT2d6MkY0ejNRZnhFK2o4?=
 =?utf-8?B?c0ZYZmZ5SkJ3SDhVQ0NmdHVOL040Qnh4RHNpRDc4VFBPdUhMQ1Nhb1NHUS9L?=
 =?utf-8?B?eVVHcnIzRHdSNjdhWDdEQTFwK3FJVldZNHpXdFNKUVZFZnZnZUQzNzRKdXdn?=
 =?utf-8?B?NFNOd3FPK2JONW85OTRlRzRjakVJTkFsaDBqZG9JMURlbXZvVzBNK2hKMnEv?=
 =?utf-8?B?UW94NDJ0V2N5WHc2U3RWdmw4OHpDbUc4QzE3c3h0dnhad085ZXpJbjlweXFn?=
 =?utf-8?B?UE5PbnVpd2RFVUdSeHFSNDQ1WjNZV25ZNUM1b2c1eDYvZU1QYjBuOU11azRR?=
 =?utf-8?B?RFJIbjRuUXJ4TjNXNDIzWG9BZk9OVlpGZ1RqcEtaTElYNUVtWUlyeEFHbGRm?=
 =?utf-8?B?Zm0rSmo3eGFOZmkyWi9vaWJ6VG43cHQrR2YzS1JLMTNCWkRTRTBNVGc2Y1NJ?=
 =?utf-8?B?UzRxbjFMWTB5QXl0MVBwWmp0U0s3OWJPM3hZayt0ZG1sb2x5STQrOTVwOHdr?=
 =?utf-8?B?aTJoYU9HSlBtdUo4Rk9RekJyRlc5cEJBUkZ3QTV3eFhwRC9UQXlXNlEyTUhQ?=
 =?utf-8?B?ZlN4M0V1VFVidUVLaXNLWnhqTTZzdUI4cWxveU9sRFh5a1BNbWk2U3dnRGFH?=
 =?utf-8?B?Zlg3dW9MaHY4REdUMW12UHNuZSsrSlRFUEhRWjAvLzVOcnNqUlBNK2I3MGZR?=
 =?utf-8?B?OCtGRGVqZS9kelVtMFNSSm1UNDcyMzB0YVFLdWZBQ0dPbHo0SGJqVXpmdEZi?=
 =?utf-8?B?MnovZ3N0Z0trTGJieWRlaFZhWVBQbk8vaFhZeVdOeklQZzlYb3JXSEtzamhU?=
 =?utf-8?B?VU5uaXRJQm1vMEdLV0pBSTNiQUhKdndCUlJIZUF3Z1IzM0JYaG9Hc3pabERy?=
 =?utf-8?B?RW9DRUdaR1QzbGdNcFJ4L1c0YzRkbUxXT2RUZDd6V1Jtbk9xN0hPdz09?=
X-Exchange-RoutingPolicyChecked:
	TzMenQXbGaaaVVRjBfBWdJfnqc/hYsS1H2UtBv4+toPTA/a10pcSSu7nkpOAtWQXMd/bACtq0pPGahPoL/iNwSR3L64/XmOiCDfsdpXhq6cUYZFcD/5blJ3MYScq1kLOwR4RwD6mZR4+PLdOkwwV3GeyE1nmYukX7xHQRFP+3zUYQzQPAfpIKxlYBAH+LPQOapRluwBnLQqWRCT5ONpwwlUW4M/g5zhl37QTDNmLQRbnSGDr9XZqQgQkq1YP2hH/gA0iiAm0mUjH2ZsTIDHgsL1661bjBltsfK5DT1Lj4DWX5o4put6lmdF/D/DL5WH3etDdTwdXBNVibo/V6F/nKw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40fccbea-136c-4cae-55f7-08df0cad8d2e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 06:59:24.8942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ne4QApisRnp3p0f9oHsz66D2mDa5TLpp07++OtkaVzBBcF+7xx87bMuIpDiXvD98szkBxNezq0H1gg23k+UxfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5271
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA3MyBTYWx0ZWRfX0EeTEI4Ld8hR
 t6sp5uOmvB9/YL7gvCkS0AINAnk3jgmWORqLY3U+5WRGd2gKPzJX0Ka7xtnBC+kYkF6/2S1MJeW
 2t6lVMXGARloby3z/MjlL+t+3nF1w2o=
X-Proofpoint-GUID: b1eckQB8k9195ffSs_14GPHiP0_fOXeT
X-Proofpoint-ORIG-GUID: b1eckQB8k9195ffSs_14GPHiP0_fOXeT
X-Authority-Analysis: v=2.4 cv=bahbluPB c=1 sm=1 tr=0 ts=6a9e60d0 cx=c_pps
 a=pRYMHFsXyG92p8CuKGQZlQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=buQUfWhnF1OtDDk5FV7I:22 a=5RW1Jyjdn16SCdV86awA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA3MyBTYWx0ZWRfX3zXR3toBX9Wk
 x45BWAi7Ifu95tGWtM/+7FYWmCAiTD/bs0U4r+OfVo5wmBvckO2BJ29px/b8VYINrhgJ7oZ935A
 f1hzNuFKAzoX61SOZVAMlWnoufIpalU4Tg1dFLXMqnqi2VJrQC1W/oIoU+j3wJGG1SrpahqU7lb
 ElqbeWNM64jB7SIN3gTAEB2QoYRDtAui1vV7R+QP8CPpgsukSdXoKVHrdqwmWo+hE0MJfNrQu1t
 9h/F5m1RDHMBH/0wgjrtTpRUQxzYqK0FcMYV17zL4WV1HIvOfIwTQ6UCQxoS4h3iMWv1u5FE95k
 +ggfNAVy/oGwV9qwsW3rBQCJMDJMddDB8d/6V7QEfv64Mz7UI9c3TdCN2RvDUSb7rxsuY6JRuxY
 Fi7+w4KppMJZ3cIY/9gMldh4SGzzI/MhStNw9TUDNbOqHoKeSqrVEOWNUhqvWJP2hk/OJMcOwkt
 WmlMIZkHEvughUMF/9Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_01,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070073

On Monday 7 September 2026 08:20:54 Central European Summer Time Sverdlin, =
Alexander wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> Hi J=C3=A9r=C3=B4me,
>=20
> On Sun, 2026-09-06 at 22:47 +0200, J=C3=A9r=C3=B4me Pouiller wrote:
> > The 'secure link' feature is not supported by upstream (the reference
> > code relies on mbedTLS to implement it, which is not an option for the
> > Linux kernel).
> >
> > If the firmware enforce the 'secure link' feature, wfx_probe() exits
> > early. However, err still holds the value returned by the previous call
> > to wait_for_completion_timeout(), which is the number of jiffies left
> > before the timeout, hence strictly positive (the zero case is handled
> > just above).
> >
> > wfx_probe() therefore returns a positive value. The bus probe functions
> > forward it as-is and the driver core negates it (see really_probe()).
> > The device does not get bound, which is the expected outcome, but the
> > reported error code is a meaningless negative jiffies count instead of
>                                        ^^^^^^^^
> minor: I suppose it should have read "positive"

I mean, really_probe() inverts the value:

    /*
     * Return probe errors as positive values so that the callers
     * can distinguish them from other errors.
     */
    ret =3D -ret;
    goto probe_failed;

So, the jiffies count become negative

--=20
J=C3=A9r=C3=B4me Pouiller


