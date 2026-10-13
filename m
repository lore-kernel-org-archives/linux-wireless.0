Received: from SEVP216CU002.outbound.protection.outlook.com (mail-koreacentralazolkn19012062.outbound.protection.outlook.com [52.103.74.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29713EB11C;
	Tue, 13 Oct 2026 09:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883115; cv=fail; b=mV0pRkfZ2+md9MlteaI4+2GqV8nfZYWWaxufeQ+V2BqIhaC8Z2lOt1aoHxoNFNf5m/yvHWdA2QysQt4Dy94AsB2/tZZAyVbcWMl+asNAvI4PkzYOYKie61H0XozHwxdkGh5AWo2a1zp4ZxgD605V99bOZT8fiMYYs+3CBkVCWxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883115; c=relaxed/simple;
	bh=aLMNZo3SXbCUldio1tIYlzOH7bYzwXtHtbT5ETM1YQM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SVQcu9y1WlWPB+5lbz/KN6cF7TSOXRRk2lMlJfsaDcQ+QGkVJ+GQZI1ljjQEHaPVSW1Ul2SF1P8y94ObIv2AxBAqSDT0//4aNfC6HqBll698OwbIECMvXzXKAEiM6hTb/7ISzBkvnPgI3VDG9B+SRqD0GSsjU5/BOObaqBBkFQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alexvernel.com; spf=pass smtp.mailfrom=alexvernel.com; arc=fail smtp.client-ip=52.103.74.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alexvernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alexvernel.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdcUDW8sSQlRbsETfg1o/4NXZqgCmUVm2GueQIV1rmxqiXI1KYciypEEl+xxRZOjhFRX7I754OBIeJe/DwcVliRZi71iiFhbbe7J0/Iltnux3zFK2MEmtWcwJ4Vrl9sf5RvjH/fNNslwtd8GkHPrUr7RsI/FFcicHowRrdEYB05yCVFzAysXgQdSHrwwBCcNrN6xcILc/zb+i0rNTZ3j+LSbaB/fLUCjMRwDMX2vIHGFgS0rxjnGxsYvYnIIB6RuRZ6H2uZqDMKu6eP1KC54Kj363BVlgpM775c0g+1S5b1AX7O12VSEwQ/8BMM0NxXFv7nKIlmLznbGMl9/PNocTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zudCnU/np8rvVbLaDB5FDwBNS2Unmc6zx8KK8mzsmUA=;
 b=NNnlQl7onDB5PgkIqjA/Zi+66jeI/hCA0HuvBjeAsFJEsWltO3BJs1FCPPpO87otrEeJZy3wpBQFC/eLp/D1vZfmRy9FTpMNeb64jyYtjgL+uiyvy+RnfjT9T3LIBqRGOHDVZqQjxwYD81NCSOxs1GXmhw988nMmsbqz5twxh3GI3ABnc9OEGIILaa4MJmzpRtOYTStUqpogztPiXv8OpiffEe/D8Dieljb7dokcqwDOjcPKGu/3wpR8bPZXBXmPmEwINo4sYiHO6LBlK5cabujvliOj7mx6Jo8DXbQR7loNq2+pB/CLHRDztmvyXX8uTS7y/hceuZshk1g0T+FBoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SLXP216MB1067.KORP216.PROD.OUTLOOK.COM (2603:1096:101:9::6) by
 SE2P216MB2952.KORP216.PROD.OUTLOOK.COM (2603:1096:101:28b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.23; Tue, 13 Oct 2026 09:18:25 +0000
Received: from SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
 ([fe80::3dce:2b67:b21b:6152]) by SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
 ([fe80::3dce:2b67:b21b:6152%7]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 09:18:25 +0000
From: Alexander Vernel <alex@alexvernel.com>
To: linux-wireless@vger.kernel.org
Cc: loic.poulain@oss.qualcomm.com,
	wcn36xx@lists.infradead.org,
	stephan@gerhold.net,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless 0/1] wifi: wcn36xx: fix scan RX panic on WCN3620
Date: Tue, 13 Oct 2026 22:18:01 +1300
Message-ID:
 <SLXP216MB10675081A1D858B6421D5AF3B39E2@SLXP216MB1067.KORP216.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AK1P299CA0023.NZLP299.PROD.OUTLOOK.COM
 (2603:10c6:108:17::7) To SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:9::6)
X-Microsoft-Original-Message-ID:
 <20261013091802.1064081-1-alex@alexvernel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SLXP216MB1067:EE_|SE2P216MB2952:EE_
X-MS-Office365-Filtering-Correlation-Id: b93650a8-ed9d-4de0-1382-08df290aeeda
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|5072599009|23021999003|15080799012|260925184616899003|39105399006|25010399006|20031999006|8060799015|19110799012|4140399003|440099028|3412199025|40105399003|2607281247196008|30101999006|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yEJO4IARhrPXYzOdmP5ny4ZzDTK43Cp1NCwK8XGiBP8snBY32YoazF0MhsEv?=
 =?us-ascii?Q?56qRW/cnSR3LP+GhZ+dW+DmzSBJsbM8kfTkDuHVm3cYtjpTVArPv5557/iYq?=
 =?us-ascii?Q?MFqz0rqOwMMWlQK441V84Z/o8VV25nJ/7wgf6x0jMJpECY3BGkTceF8pAt3v?=
 =?us-ascii?Q?Qb+mDZfOjHq4B1CggTug8ERKyhYhpCtYpbbAL5PYsd/TXbkizJH/yCt/XWHb?=
 =?us-ascii?Q?8fQ0AbtnTfBaV/9wwFDwk8Gh7eN/bELS8VWVswYxG9OSF/0lJlN4JHHbU0nb?=
 =?us-ascii?Q?mYQdLrbnilFrwB1ZPQJOTeh0G4rA32/kwBLmt219qRUG3vWIx1Iv6FI+aHti?=
 =?us-ascii?Q?0U3hX+Ac6L2PT2rz6ZRiiNLxDwdCAJP8edHhtLgNW/2SJ3h9HvoEKO5L7Nbq?=
 =?us-ascii?Q?p3zHglmK+SeYwcQ4aGJXVsOhNreVseLWD5n4tj7leLngf2h5d42OYASLYfkR?=
 =?us-ascii?Q?uf1oSjVmH26doPpN+cXvVUmcv+Vhr2ASixrv+LrMzFbYh5tD3wVrdmIqI7mt?=
 =?us-ascii?Q?f4JLgv+VsM/mKXiQPyEklipUIZPmHgwa8Q9cV958TtG9ACJWEmXFjpozJX0+?=
 =?us-ascii?Q?VaAhtu3bI2u4BIbnQSzr4edRnWmhg68Ho9MFVMyKZqBGtVeRPx/sy9k1uVVM?=
 =?us-ascii?Q?Gv4hPhpMUvFN1d0otKvxd5nrvV5nZsj5xydMgNo4MhCqH03q9TUbRWEZJJRH?=
 =?us-ascii?Q?le6FnPLxg0OfLo5iQg1qreQrso8wo7/DTdtfPz5BddS3RTPD8uM7T2/EuSdg?=
 =?us-ascii?Q?z+I4J6GyU8WBG09nPPlVCOTMX0Dnl3sBX0YS1ns7Bp77NhW5mfPSGUmgpNmA?=
 =?us-ascii?Q?OaQpb92/jJciGSxXlkEpAkDvnzd+r7SgMjQlrOoqlPdTzP2rnTDH7QnYos3b?=
 =?us-ascii?Q?YJiuoPOs7K2XFj/M95+3vEzoGPiyOrUwtXLvnAeUVF1exkKBtXv2AJAVmDhz?=
 =?us-ascii?Q?x1kWVw0kj2GWer1+rYU2dkfSFmQR5MNnbcUrHowTmAM=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v+C3Gng7isfk3yLMQ8gWynD0xpVp7YrEga7+VkB65kV7+jF3U3rfgN0ZXJgL?=
 =?us-ascii?Q?PDCQzJy57ColKcue5rwDAGwfoHpMp+7cqY1gxeTN4GWxWNadhZGVQ86o3OVd?=
 =?us-ascii?Q?D2ny/z+MgjlN9UU22MNyClPoc3hNzcplLET63NykCulR9Nj8wHIC1VQnykeN?=
 =?us-ascii?Q?B5Evk5cuBbcFlEgHhC78KZpUsrR8U0kHaQ8AwWR/E8BUOoV+QHRPFjPvYYE1?=
 =?us-ascii?Q?XFhI3n81mRjrzLZsOTDA5LHRNpVllL/h+5sFXadanXgSAs7RoDKI3i820ByJ?=
 =?us-ascii?Q?gVxJRWeXOPSorxCv0bRU0RH7gvQWZjHazM4Ocbrbl1FgzaEJpTXiZRTyaWWL?=
 =?us-ascii?Q?Vj6HEFmi6i+L5V8ANlOekgzalb1ILge/hqcIg1Mn5SPhwdA7uD8eFlQwwaRA?=
 =?us-ascii?Q?s/xalAAgqBfGAmx6RdyXtHM4o9MmZ1KrGINAY9O93kAS+wXWjOXv4gSPyrjI?=
 =?us-ascii?Q?F1OIW3qawWt8yhkMi4yojPfWUlJPDBg+wpo92mtKxJcJ5VMwLF/O86r2CEJI?=
 =?us-ascii?Q?47Imd0dU5/GeX4xK2M/JaHyaJoW+XAmEFPgVT8Da7hkavsPdfdNY+eyZ1c1M?=
 =?us-ascii?Q?19QzVQLks7Gxby7V5Kt8UNUjbKgryjaymfsnyg18+H0MG591uvbNVGJJ5s6m?=
 =?us-ascii?Q?xZ8Vo9veaeELA6TSY6Jy6QNKT6BgRczGvzlHcjpn49XaJVxPfstxsAxsoSST?=
 =?us-ascii?Q?6Le/NdnyIVp55NuZ1uPIB34CJYAC+mjFvD/90bhgGsfVt+qHX3F0qyJLYPGZ?=
 =?us-ascii?Q?hSe6azwaBsGgjDUSoJVW1L4CY1OlUqcw5dZQFWsnC6Q3lWm0BPPGtqJjOqjx?=
 =?us-ascii?Q?SSO3E1IFmsGcbe2lEjE8fgmvA8/3/Iwl8FCckLHqgduOkUDgS6Ex/19lG8Da?=
 =?us-ascii?Q?X1pyjn7MAW8AiqsFQ0LYeQaoT6YO/em0ZvvTOcet4bDKM2qbNcmedbjCWpl1?=
 =?us-ascii?Q?DRs6M2fCIGJ73w4sEdpU1ucTpFfBsWOih9a3QRXgIfhWoal0MNw6tFY1ChpN?=
 =?us-ascii?Q?zRlL76kxahefEQUrmq5s3RZi0Gi2D+Ir+XNXPnN6QoYU5ylrovqwuuop0vXe?=
 =?us-ascii?Q?lBPMy0gf0kLPK6vI2Y1xfINMHq9slRgdS8b+43sfBHjHCFlI6igy7UuXpdhX?=
 =?us-ascii?Q?PoQTia+oZQWimnsBkTsWzf2BYJhzP4N5soZlGBwJzPYLZe3SqIpU9n/oGrZe?=
 =?us-ascii?Q?lfguNQJU5yv7a6xh9GGtX94kLITCpalrbjJDbyGRUJ9xY+5VKyNeVOrdiYZB?=
 =?us-ascii?Q?eRXhw/FDTYhJurO+YmHUfohl8gQaNM0Z6n3SCzCB4GYJ6/ACjG2I4KK9+Toj?=
 =?us-ascii?Q?MrxyH9fPlwgg4RZKYWPzyzeTOvOj07NkZJnlqFCrC0DcxBtfuF+d/KhMC3g2?=
 =?us-ascii?Q?ZzS4iyepeiDoZjwZGpT6mIssXicUdx25r6fVX7MDduIGGFR/bw=3D=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-94596.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: b93650a8-ed9d-4de0-1382-08df290aeeda
X-MS-Exchange-CrossTenant-AuthSource: SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:18:25.7696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2P216MB2952

Hi,

I hit a kernel panic while working on display support for my Lenovo
TB-X103F and tracked it down to the wcn36xx receive path.

The tablet uses a WCN3620, which only supports 2.4 GHz. A firmware scan
result was being interpreted as 5 GHz, and the driver dereferenced the
missing band in wcn36xx_update_survey(). The frequency in the crash was
5280 MHz.

Stephan Gerhold already had a workaround for this in the msm8916 tree [1].
This patch follows the same approach, but checks the registered bands
rather than the radio ID. It also drops scan results if the resulting
frequency isn't in the channel tables.

With the fix, the tablet completed a 20-minute run with Wi-Fi scan requests
and file transfers without another panic. I haven't confirmed whether the
bad firmware report occurred again during that run. A host test reproduces
the NULL-band failure with the original code and passes with the fix.
Hardware testing so far is WCN3620 only.

AI tools assisted with crash analysis, adaptation of the workaround,
testing and preparation and review of this submission.

Thanks,
Alex

[1] https://github.com/msm8916-mainline/linux/commit/0be2d63a476e83c757d9caafc22eae00bcfd1df8

Alexander Vernel (1):
  wifi: wcn36xx: validate scan bands against radio capabilities

 drivers/net/wireless/ath/wcn36xx/txrx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


base-commit: 6c377d19d4a5116d9bec5203aa3c6c11523e7898
