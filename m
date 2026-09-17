Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB42D47ECD0;
	Thu, 17 Sep 2026 07:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.183.31.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789631097; cv=fail; b=LSbzWD3oJDFmsmNohYP7/xbvSrK6LeTPHGtqQkUd2yTNMTo+XziNXULaeK2ygNTshDIQVG24JdBja8WJtdbXW/r/HaX5lCMFZoujJozUml0F2wgxd6Hk1AGpCYuOcgcpGEkrbON1eZ+ybkkzx9b1VKzajvpJz05kQV8mpWMCU0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789631097; c=relaxed/simple;
	bh=KtH/OkaCmsNwjNU1mjwVFnWiThz0kquQDqIAzptzjRw=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=VtEYsbLzO3dARtAWilQZ6DgA8tS84IB63BzSxTWOP5TGt6d5j8bP1QCswX41cwAVj1Bo88HiWFdj+qhFOAsatYIS4Gy3Yck1keZoHAn7Rjt0rX7l5ZtBz8KSxWw42Rn0TBxMWqDBbNJOqZa6qxrzpgA+t0Wqu9dpoUQrCzITkS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=AANEa903; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=vJ4iFmNs; arc=fail smtp.client-ip=185.183.31.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="AANEa903";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="vJ4iFmNs"
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H5xxk13569456;
	Thu, 17 Sep 2026 09:19:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	270620241; bh=UFRUTKlgzAWtkw5mAzQ33KY4t2k1aj4GhZ6WW5Hk0kA=; b=AA
	NEa903VuCxyClN06XeyGBDM0/PWaxYBNMG9/+AD92tWKERvm6dPuo0eULPKF6346
	6LWfs/QQRKXK61imphMllY4Jyd1JSbcZ1SCl+hRFEBGdJYl0DcN/0HhMBoEgvjnw
	h3ZIXOUcDomfvfPV5NEtqqmJMFYqFwnQmK0vDW8/9bWSYwVktNdHbuLsuFTcWWpH
	KqRMqtT8pUE6IE0aHfOAaEAH1qZbJn0hsyrEXQ18q0hfTM7qmiOO17Abnaw4+o34
	3D2KmlyV8VL/vo6dN5kWRR81dNnvE68pyHZE8SMzE8bpWgyCwZaOC2DhlUwJmuvr
	02Fm7jAtUyOaHhUKsQvA==
Received: from du2pr03cu002.outbound.protection.outlook.com (mail-northeuropeazon11021135.outbound.protection.outlook.com [52.101.65.135])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gmtr46a95-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 09:19:26 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y8PIaiCcvBo8zXExVrH3Bjc/xhaUQHBsZZ6HCFZQdfO5znUW15wXWjkzuwtvmDqr/a5Q2RrzNXgryed4PLLMon9xw8kEJshCzIqG6eQ7WOWwq9ta0nU5mRlGm88K1+3TdYQDwV2/xD1IuRYPDKkClMTINNFnd+3186unzunCaC3lkkSSoy2O1pZ/NLFLEAAfLWU6Z12Rye16kfQlsTkAxZwSQKDc+J4G79Vf3qeWr0ryr1HGj4O1ZeQc+Aw02xo62Xfe+iIvjot8KkPk5WvENuwr6jX57pLBcuFxWJc/ObSkQLU3h1tOuES/ANOGE4V642Aj+gES016gQuX1yYmqDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFRUTKlgzAWtkw5mAzQ33KY4t2k1aj4GhZ6WW5Hk0kA=;
 b=Awt9vf4LdTc26S8soUqeMB64GapNMoGQZCykEXmsun5Nb5tkzsyl1eMmJhI2HX3A9VaEl3aGHNEuByGFip42sVIzP0WqJkv61BzU4Js3BEooEMEsf/fDVi0hkWJDzUWu3iXO0YoJ8uqbqCJ7Ce4bv0Ey3f9DvhTrQZQeczXpcTz/Sa2sJ6kSVcl+z1LrLcgd/r4Td90YuoIc0tUeDja8P7L+/rjEDmTUpBrtVWJgIS4tygFnCTYBlQFVi9HAyQSfKkxY1xSvmk3aF8GAbgcx6v01x8GQy39aKwnS1lrELPDOGUlw1OslaJw6sKoVhM8WDaleIU1xhCddC7/OWEnCow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFRUTKlgzAWtkw5mAzQ33KY4t2k1aj4GhZ6WW5Hk0kA=;
 b=vJ4iFmNsa4MTEw+Jfgu+e8qbSyWwiZ2aXozc60wbCqKM1L6HdK6EJGovMaZVMEwrMixavR+oEVPJl0p5HKyMjxdWfcC7N4tW7mERAt+4dibr8xtldl+NjX5nkAL3XAjduX0+k0i8nNcTu+2Ylhwx5zcnbWRkuqmHGJtdGoEnUM0=
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by GV4P192MB3214.EURP192.PROD.OUTLOOK.COM (2603:10a6:150:2b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 07:19:22 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 07:19:22 +0000
Date: Thu, 17 Sep 2026 09:19:14 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath11k: fix chain-mask shift on 64-bit big-endian
Message-ID: <aquUchJlTVZGEfkl@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: GV3PEPF0001DC11.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::26f) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|GV4P192MB3214:EE_
X-MS-Office365-Filtering-Correlation-Id: f5de4445-0e8e-41a0-047d-08df148bff23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qXzncAZamhiWvls/q7Y2o2axGuIWBdqwnW6NZ7Koz4Xw1KpIMhYL1fKjpNdAGbLZRp6y2W/NKuY8mb+Ws0m8zeB70t4tyvQwGFb/GAP/Ju8Tr5uKhr/iwEimE0FWHAHgZr0ojb5dKrxZzjCHdFpRdhRZsjoqbPQ+q/Mg7gSxROXyCRT7WgJzZabPq1eZnd7KZaCK1oSbCaQGlYQ5RQHqz8Py76tun6Pv6xxwsMTF7/N1UEQ/9fPZ5GTtSMFlKfislc3cJK24Efg/J6fGskwi427kNNVrVccbRYpqNHend2Kfboe3+q+KSW18Ptmt2fZjwhvEgOWDTc3VQzf7QNIZQj52ZKY9u6ok5DSgcsWK3JY3hg9kt+jOcdRMuw2yb/Malm+q1lNKLqp9FszgI2DO6PKEcwpap0j7EjgA2AsHtJJ0Sh3rkqCNWom3AJg+CXR8egibBbqGOMeIBwJFwIl4xYcXQ8M6X8pQ1pMEIdmuwy65/xMIssD5A8xivWeT8MCtj5vPT/soUvTaO51yfwUlhI9arRsftXDs1QIYiu4OcAoicB1G1QYH2GmO3Cy5PC2Hj7v2JYqdUyYbRG7Op61QoW4+p/0gEVnRcg/RFGci8WygziL6GcZYoqMfoEHVtznGNOH3ZdL4DfovSYsgujHuRtHllADJgepZVSSVvU9fPrc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PaD1zski/0FgqlhnyRDM4CzdwgWN/bflhsM+vnOEyTU388zMb7PPts7f1rvJ?=
 =?us-ascii?Q?64FT2DCuwhKfHUpO6QLI0E7bSxXEoMiZ4KnvNi8ZyPXXazoXOnf60YzanNcR?=
 =?us-ascii?Q?DG2FQUG10Im58UMnTCOfrwQHHX2HDayoKvPy5z+2mkKorvDONqeKJPd4p346?=
 =?us-ascii?Q?lT14gbwYE4tfrTF0g+kPKlJwxsbmTAzfYGSj8G6bUN1duAn7UkOW7D+JFvdF?=
 =?us-ascii?Q?9Kw9oUERuZTGvQ0Lh6I8ZSdg8ABXCaea4yxnXvuJb4eewZfmQldLqYj/YltH?=
 =?us-ascii?Q?hfybv7ADPmGlzjB9/565QRtojlxobj0IQ78A5bpX0iA73V+CO3qLrMFJcX2A?=
 =?us-ascii?Q?hnDoo74DcM1K3e5hWoNbAuSK4U9QMzcG1lIuNcXUdwugC270GGvr6JLsmmOq?=
 =?us-ascii?Q?aqGb5OhuBtehoM1kLDEkt9TZ7a0etyzfPWNHH9RbdzjbIf7e80OsNardBKIX?=
 =?us-ascii?Q?45ifxd2Qy0IppAW/SOzBuObwaaA+kzU/zHkb2MdusAyYYQqEClBE7JNoD+b7?=
 =?us-ascii?Q?gQhZ6A11Yh1nPR92ZXeXalSSKEFQF8bsY32KSRa7QzDw4eCUk2LDB071F9zp?=
 =?us-ascii?Q?qh3LxWATQZ55adM6LopQXf4ggXGW1127jTKBB3hAUqHfpIpI38i/AqSAV6aw?=
 =?us-ascii?Q?U3/sT+fkSZGkym1oYNcGSCKoRQvrf9kG/VVl/055Go2KnJuhNW9xXAegX7/x?=
 =?us-ascii?Q?EB4kMbb18oItPmC0Qh1gRRpOQVTofytReu4/bYXJid0fbNLeTu/z87vo4FXJ?=
 =?us-ascii?Q?AbhHhe/xBkmcyUo3JKcwhpZB2eYjt5FsUTuVKTOIIdNJ0UVAX4D3SzYLGOLi?=
 =?us-ascii?Q?Ruf+itR3hNQO+GhH558xInj0UIUhmJGr2gpakZHs+TbYSWIGGlheEqvSZ4Rm?=
 =?us-ascii?Q?0O4VRTaNe6M4pQdFs0CT+xkS2YTjrllWD5OSe1U33G8v9NHuymOp67fXZIKO?=
 =?us-ascii?Q?TWH3dc7+gib+raBk39yK2IG4zdp6Q7rhiuhretYo2nsMlUZ66nSdkLPXnqJ9?=
 =?us-ascii?Q?gxi+YXUCHor6WQTp9hYNvOGSSScX8Nlv2LQh9ZHFn82biw7nVqlz+1FSxsdG?=
 =?us-ascii?Q?pdN8mVvWooCG1Wx+YTsjMOklltyder8TuqYgpdHO/93FgEp5SmBhJ8QH2/ZG?=
 =?us-ascii?Q?opeJJk/DK5G1S67fhz1Iq7gXH0pC9WVoS2cuxx8wbg37bSquiYO7XlBTaT6v?=
 =?us-ascii?Q?N+cXWFUZV8QVXgAgLFTrLYZOdUtQrC5NXSntO5BTAmis+WkhMyKRXIxUAB03?=
 =?us-ascii?Q?CnxjE0owA5o5TTGSIQH8ye5JBEyrPDLnoMB3cd1cNaUQ8S+g2Hh/q6RJ/lSo?=
 =?us-ascii?Q?zIhnkxKeMXfi+n3DPN47R3RkJPtauwf5vRdCIKhxAp6tYtkbOzAL/F0rxGRi?=
 =?us-ascii?Q?BG0OplzenPg5KDJ/BHiMNj4Gk44S8UHtHn7u8zf3WyaihMrW+6IP/IQtA16j?=
 =?us-ascii?Q?Wtq58R0Bn9bQ4KG2qM4u8/yd0KSFG3YjpoyjNLKik2eDsNmzOxNCJR70a74q?=
 =?us-ascii?Q?6oqI0OvAN1DCwEobIBiGyXdB4LjktOQc+m0Z84Ao62Phnd1srPngYjKCaXnP?=
 =?us-ascii?Q?P1/+bj69nca07Bc9EIwsnN2E3f3Y9kMzV2Xf9tkTuZ/3CkhNWn4I6FFmqGFO?=
 =?us-ascii?Q?10gERjcbSc0ZzT0kALwjlgvrqtvMvBKFTm0k9Who3d1i3MSLbJx2uV7cORIu?=
 =?us-ascii?Q?TSchw9uLtXkRHus/QdfzR8zvieCbV5ZZi2h2fcdrYBvScKWxmspF9UiSjTSj?=
 =?us-ascii?Q?kP8uDcEyiw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	u9AukMItOSG1hjvhrUk61oQUgRSnc7Ny+KUzWGgMLF369hrjkf2eGoEmm+WNBgHVS0eiM9M0KYqJ7EzANfhwDjUbBb9pkFBI7jBBCP3dQRxVfX+ipfNfixXeWvReuyU5J3ezda5Xl77erwyaFR1qmMMEimm7OCnQ2XyXf6GhxS591DNk8Fz4R7YzbPATGqh9qiJGPyEzCqLeDMFHdAXNIvBnUbeh9bW5V8/f86mGZJTGiXSOptTIwYbiFzO53G6QDJ4McGE24j6EGA0mPuNi2b4tsrMOptUlwvTXyX3QdJC1VYyfLoaIRVh5xqFnzdIIOJYzGtKYKmDPGzHao8dO1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	42i3GdGJD8oega7QMcV1YMJQigscsb9iH9CYP86uOMNrWgsPW59d4mBk/qx1ck3J85/3htdzYKIBQnK5GbNCZ4IMnEJ3+7vBvhbo7OXpFUW35xRhgDse9PoduQvl7CXZenlp7q+FyjXMrn809i63HqbSgkoWs6jBC2G/a/Guux/yrBrNamDfpqxz0Rh1KWZb2mMTFZqo7EGwf3b99eQMFGsRaY3lBq/m4VHs2ax93BeXi0TEcxwz71GQikjKypAdSbhN71xENBGw3Fk09Wo7onMl4jSvp52Sew8fKI5RcEMEbPXQ+5c5Ttg78oAWGGIQfppaPtw1B2H4wS11lqGc4xzXB8w389MKFuFQkqD1aBcDdBvt0KfzNzJ+95qZnPRqECyoMmqX36aFN6O9Ve9lWIc1Zpfy+gvPLMn1Cgfz7Q4OPBHRVsbGIbgOuvxAVdSXuaXOcmkEA7DQ70YwrlOkQorroj2JeYjZItCAC3thoAmv79XB6w2yOvRQW6huKUk1YszU3wT1Bp3wmBcys5lpJewYaBEGEUW7bX6POyKfSU2w8PT8a6LEKUlvg93WyesVrUgO61TX8zVFqpvHs9oNZemkb5zqRlqixb3G9gNsClq4flgCy/1FeacXkkgZ1sX5
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5de4445-0e8e-41a0-047d-08df148bff23
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 07:19:22.4137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GH8pziPExc/flr6wMLhl06OfcHR9GSLUlAQhgc5E/Yl/6YcJuz+m4QeBZgEfM/SxJyFpy6aJ5rOyiNUw8/Plcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4P192MB3214
X-MS-Exchange-CrossPremises-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 104.151.95.196
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext:
	DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: GV4P192MB3214.EURP192.PROD.OUTLOOK.COM
X-Proofpoint-ORIG-GUID: 3z6cAMuF3CkX0ejMdb2fOEnDZ7bm34gc
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA5NyBTYWx0ZWRfX15EmZuj75/gR
 aDMU4bQ9/9jGvkSmUnrOlrcES/yAvftZ/2Z7Z+/8Pkq0SSDEG0SqAMf3/WVb5HFzMNpLRMLzWMw
 WHhIj+aMDKm5TsAqgl3Nd3iwW2u2Pjc=
X-Authority-Analysis: v=2.4 cv=F7HC5ahN c=1 sm=1 tr=0 ts=6aab947e cx=c_pps
 a=+Y5nWMJkOAgZasFIEkvMHg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=WQ4YJ39tjzx_Hbm9pN5v:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=DoVTubjhm-SzYe3wg3AA:9 a=CjuIK1q_8ugA:10
 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-GUID: 3z6cAMuF3CkX0ejMdb2fOEnDZ7bm34gc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA5NyBTYWx0ZWRfX4ytvcnmhjQGF
 VGV1XP6eB0O7W+5PUgat+w6ROPUQ5BpYGWdLoPQzZfRROUdU4TF3wx9LsPGcADciO4YaPDRRVpx
 P54dax/KSSacFXD8zLLdtNwi19MZM+xxEyYiONQ/2tKpqjpCSI8rhRqO4sEMl92QECigpFvPo8c
 S0JEQfSuZTl7a3+SZR/AgIpW37pxYtiewzpWUa33EztvkZmBxZjosfAAOc0FXmc2Rwn6k4WEB7X
 lRRF4itELK6l7xYqUlYse9GCaziQxm5FFYP5p+4Opib3svfRBrR42EDJ2OQVN3f7nS7BhmiqMcx
 BidjahOge0nT8WLs3Z9qL5uFl2LNFpUlt7ygIc03fnhp417ixC1VJYH5GG1q1ySgS5CItyv1ZwV
 11A5KDkVBLyD8KA5xR2immHhzVa6Iq6FtONvFQ4RyNtiJf2QsJYLDcUbEmBz15UWo7QLOMiUSOZ
 7hy1swwg0MD2+uYmAfA==

ath11k_pull_mac_phy_cap_svc_ready_ext() derives the tx/rx chain-mask shift
with find_first_bit((unsigned long *)&pdev_cap->rx_chain_mask, 32).

pdev_cap->{tx,rx}_chain_mask are u32, but find_first_bit() treats the
pointer as an array of unsigned long. On 64-bit big-endian, unsigned long
is 8 bytes, so the u32 value ends up in the high 32 bits of the word while
find_first_bit(..., 32) only scans the low 32 bits, i.e. the adjacent
struct member. rx_chain_mask_shift is therefore computed as 32,
ath11k_mac_setup_ht_vht_cap() evaluates cfg_rx_chainmask >> 32 == 0, and
the driver advertises a VHT RX-MCS map with all streams "not supported".
mac80211 then rejects the VHT capability ("Ignoring VHT IE ... due to
invalid rx_mcs_map"), so the link only comes up as HT40 and never
negotiates 80/160 MHz. tx_chain_mask_shift happens to scan a zero word and
stays 0, so only the RX side is affected.

Use __ffs() on the mask value instead of pointing find_first_bit() at the
u32's storage. __ffs() takes its argument by value, so the shift is
computed correctly regardless of word size or endianness. The chain masks
are always non-zero here, so __ffs() is well defined.

This is the ath11k counterpart of the same fix for ath12k.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -444,10 +444,8 @@ ath11k_pull_mac_phy_cap_svc_ready_ext(struct ath11k_pdev_wmi *wmi_handle,
 	 * for tx/rx chainmask which will be used to advertise supported ht/vht rates to
 	 * mac80211.
 	 */
-	pdev_cap->tx_chain_mask_shift =
-			find_first_bit((unsigned long *)&pdev_cap->tx_chain_mask, 32);
-	pdev_cap->rx_chain_mask_shift =
-			find_first_bit((unsigned long *)&pdev_cap->rx_chain_mask, 32);
+	pdev_cap->tx_chain_mask_shift = __ffs(pdev_cap->tx_chain_mask);
+	pdev_cap->rx_chain_mask_shift = __ffs(pdev_cap->rx_chain_mask);
 
 	if (mac_phy_caps->supported_bands & WMI_HOST_WLAN_2G_CAP) {
 		cap_band = &pdev_cap->band[NL80211_BAND_2GHZ];
