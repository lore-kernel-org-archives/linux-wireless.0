Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0CB346E59;
	Thu, 24 Sep 2026 09:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.184.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790241275; cv=fail; b=Mxle4cCsJxlONEACpZg8UyruICQ4cNexOg+i5bYpmQGuaszwjbA5pSlSd3nmiHb3nZRV06sQsx/NpMFYEnLfX3Y1DMO+MhfHSwFBUgdHW6gmMqiF8g9YTf9I2mD9DNc1tz2NI+N/KgwYxUbCJSm5h/UcE0tGHrZi6D3n2yer6ew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790241275; c=relaxed/simple;
	bh=/GL6RXjaT0j8/EEPih/gUuohHSHkMQb1hGTCqi4OcSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FyenYivVinGVqUcxnqk3as2JeMHbwhISeduVCVwfcvs2VbWUl5UYXM9SSXqR/a3XW+3sFQkJfyADAIEBUM07WGzBAztzxnA9z53su8Vjhqt/7SnQFKy95SZ5kyE+MQ5qCVWNkyn/v7c9AoTKB75sOGoOJDekai9sKhyqnkd58Hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=CeHX5Q7O; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=CR6iABDO; arc=fail smtp.client-ip=205.220.184.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="CeHX5Q7O";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="CR6iABDO"
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5dR692542585;
	Thu, 24 Sep 2026 11:14:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=270620241; bh=/GL6RXjaT0j8/EEPih/gUuoh
	HSHkMQb1hGTCqi4OcSw=; b=CeHX5Q7OEKTeKH9QfeDVaJ9giMWHuXH1TkY/Ofmz
	ka3xuOEm7Of6B3aQrHidfYQvZN8xEfPDd+N9VtnQZfPKlauoOMpu67I8cFRzLQ/R
	UDk1bbb5pBv6hlQTgGcnEQuge0H4yuBqyLahwYcesh2kf3UgtNyCM7xD0yAk7cjI
	YvRIyvVKoRJhfL57p7AL95Hp8iBhjR4TNcvJMXe0rmMjhiw+anXGwUEpadXejCx4
	1eK8mYTE6OXwzoR59yo1BJYqo0G1QQZRKndghw5lOGW9p0gWKiXM4ul/+6vYvwo9
	nQiWhheOUlUgsb2Ns7lshn6qtFFHrzAX00VOVnskqamOyw==
Received: from mrwpr03cu001.outbound.protection.outlook.com (mail-francesouthazon11021094.outbound.protection.outlook.com [40.107.130.94])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gvww7g74k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:14:09 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVBShURXzfO7HJSTuFCtPg2kdi6qfV/I4JTtVzDT/2mxeYNMi+W137WgQSvkbNXolbphDu4TNuZS/syTmlBCcREH4NRiCsoU6MNA87n9QqxiCPrZJXUc+gJfyYliyP65LllV9aBR9sE2z6K/vUce/5nwCvNbXWl0TgUGyfb/60v4OkR1+F7sQefo+X8+xdtbiK7Gb8L14Ju9nJUk6OXGUn4Mbts+SOqJfuUPnvgUzDiZQauwu9F3rPblvHBpwAs/yd/BDLcX+AlkLpLOKg6enbflJLw1UAUZIyYM5zv2KXlPQlcX31PWR9NjLv0XuArKeYo5UN+jX+ptkjtfhd1MNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GL6RXjaT0j8/EEPih/gUuohHSHkMQb1hGTCqi4OcSw=;
 b=vONhigiPZ0lVai7ykTYfK7l7VrkL824SvXbp8otDbF8tpS9k+VQ/nU/TamEU4H6VbOECDSEMstJM/3ZAu07QYb1kOggf0B6iLGz/OnLU3OMY5OmOikNJad+Kr6shfNiXpMt5YbuNw8iBCw7rC0Tcwcm+TUSPNwDDjpTp03d7czFY++BBL8PXWMOSObI53q7N8iSSTVSMGxbgqnTXFwAelA4bjTNUF3ZkJwz9SBc6iCLYxFi6koqZCiFLTHW9864xQgK0PO+qz0sR5kd83ikZky7GbQDziyjDwX2sriSD+ESBToZFdy1H9giXW+XbMW2n9r7tyh13QDgMDIH/N76h0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GL6RXjaT0j8/EEPih/gUuohHSHkMQb1hGTCqi4OcSw=;
 b=CR6iABDOuzo0cDbLkCesjUwnSfsarbdLpdVCgEWaUpdBmwqslPSYWoZQjscwxurALY+p8289xmYwtD1QY7ohf+BvvALf1gm0HCK13mltrgqQPxYDXTMas63rH/gCcBH/XTu3l1FXCc1v6QvZW7AqhicB1sbEzfUiA1NI6xXcDsI=
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by GVXP192MB1758.EURP192.PROD.OUTLOOK.COM (2603:10a6:150:68::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 09:14:05 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0428.015; Thu, 24 Sep 2026
 09:14:05 +0000
Date: Thu, 24 Sep 2026 11:13:57 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k: release peer accounting on peer delete
 timeout
Message-ID: <arTp1bbipr6FceMH@mpf-ESPRIMO-P9012>
References: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
 <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
X-ClientProxiedBy: BE1P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::17) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|GVXP192MB1758:EE_
X-MS-Office365-Filtering-Correlation-Id: da512702-277e-4823-bf8d-08df1a1c2e80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|4143699003|10067099003|56012099006|3023799007|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wqovi10wKrWPagiDz4GuRHmyM65dL3lbe7jw+QfDyuiWfbJnpXknXIAtCsU0yXyJ1Q4Pv30uOIcBo/cTMjPMMfmfhxuxzDnNZHz45Dqe1eVR1pXfcyK8ZKhYiJucx53r4xYdsvboWNwYEDClr6EVkFMgt4UQ3st9sScUYFgVH62HvehVPeckOO4R0fI9sF1Qd0QHjh3meCDpbydhyx/ozTqXWc20mrFuTacZqz/RZEM4AnDmMcShav27vP4B3lupqMOzEZCbI2qnpPOJUgGBGgveLPq1ths2nFOOkgzde4YQg4E8S41/gD/Ht4nA9zbMWYxrjeB87gN2uP9Q0rmbZTfPd3eH+TJCbLalC6Wagn/809DI1OXG5zZvfaN4UVq+AuWtj9ecM6CTnXxlxa263zC1EfV8M5D3rHEBPuSAO0OjFw5brNhr0mwPHsCnVFxDMZcCfY/g2YSqSGeXVsSex7BTE/+5pFsT8/02nIcKNQ8YI/sAVeilVGXA7LL8IlblgPVzNlsuAFlSQRRD9bHDZ2AA9+3m7UBVdVUpS2x5xaufMS1u8gGAb48QMSxKRqq3JJGhwcr8/ZUGs+aid5GnwlpY1lA+F9WIaqA7DQo1yDsBQ8h4YsBV7EzH1+L4bsMIw2wz3MQUOgRxrzTzNwd+IYzCETH4uBz79YAQwgZe8Zc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(4143699003)(10067099003)(56012099006)(3023799007)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5kU9v2JygwJCPuIT0X5nhmhuSdhrBYhYsoURlaFZTxb0my7sEWj1Kq1+Ml76?=
 =?us-ascii?Q?Z8nyVvWL9jm46kiXpny6V4bOOIhEkHkpCc80rpO+4m8lrV9S7+Gpl9XE6Pp4?=
 =?us-ascii?Q?ULQ1TzBH0Yl3ApnhnF4x45vsFJHNj2m13Cssq0SWtyBeabmWt6e0dor/6+fG?=
 =?us-ascii?Q?jcjhooiQDNkFnGPu6mT08MwycjI8LXepswaFESJvuoZy03ccuDdgUuMA0CH5?=
 =?us-ascii?Q?O4J0MK+i1PDRPCJLx3C1pAoLBxvqvZoNgB63jxZouu6T+BM9qq0sG6DKUL41?=
 =?us-ascii?Q?bzG2uQm+tK9ubw9izP4zeXLzMg/IC0F0kBUia4GtzH7KKGcqW3fluCg2FrbM?=
 =?us-ascii?Q?4A4a5YGpf0oqb7pgpnn+I7MyeQgp5o31a6+lPlKnxETy67xJNVbEGbF9yQTQ?=
 =?us-ascii?Q?26iI2G4Y7MduGFgAQX2DptROYsiRivqrpnDfw3q7+ErHQ34Z9Gr5P8eFzdY9?=
 =?us-ascii?Q?dUrGkrBbhpEggy28rfaPSNY5UXrlnZVyR3tnHhQN9Fknu3COqlBrXwskfjmF?=
 =?us-ascii?Q?/ZGlFgbRrG7J2XqZ/vL73ZtM1uAsh4+BYATcvOyhprf558GQpbFjpnKOSSQH?=
 =?us-ascii?Q?0NWlUL/kIUULRs6czmaRLIwLfPKRfGT6MvyY9MH4BDBulcrOKdKGi6uG+/1H?=
 =?us-ascii?Q?g++ndLj5KZ3u+TERA82dZWs8Ot/6qGdcAl9nTv6/ZXKsmcRGTY0n6xmRfuXy?=
 =?us-ascii?Q?vlsLySfIHmdg6Qv7V57QiFOKjQGV8E/XRvMh8z8EPEr9JY7QSohXrfQpi9Bn?=
 =?us-ascii?Q?FZH0CaIzarq+pauiptjZWSW6qKqzHDLOO89As+/Zy/wt7d4hh5xWrTeXsY5M?=
 =?us-ascii?Q?ZgeJ+j0mL3UP+SRxK3pP2YeT3R/dR6Lmy5rkrabQnzaC1bXA9szIzAyexpyb?=
 =?us-ascii?Q?FS1B0gDh8Arl1PYpYNkh7BCITvJyVakk360vGz1ncVOQMeRBp4ayImadi23G?=
 =?us-ascii?Q?+VYaTIz/bq44Drp0nMhjQWj+7uq6hr8Xb6unJZGgBWmHjxvHUew0ZH9hW1Ve?=
 =?us-ascii?Q?9LHzta861CHOW0cNMYd9Zq/QDxAaf6TkUuspr6+bQypt3X9i5uMtv/oYb4UF?=
 =?us-ascii?Q?vPZGkeEuWwX1qapL8ehc2TbjYHhHnKQZ8kgK6azfNHBOlAzUWjneH9eJYprJ?=
 =?us-ascii?Q?LzWzY+mQP2SLTv293Ljr1SPB1TN53yveaXtwtkaswJstz1apF6Iy4ASEqyPr?=
 =?us-ascii?Q?a1ZxkeRotMw4fefrK2kSaTmYMJSCweqMr0NN5pY4V5bf2+jJWYfPEyX+TO58?=
 =?us-ascii?Q?KLOjQ/VIOQwtLLTbAiiZ5P0jSmqFsidV20l3gc8cfo3jwZpFK0RwsBkMkVaE?=
 =?us-ascii?Q?PezsVtAVUOAGps/ieyBaisTQLnwETVjiYPklxDb6LA96Q89+VNiGoJ0pIDH7?=
 =?us-ascii?Q?bbub0ptKOQT0rGfwA+Ioa4k77spwsnnylmXA50kyCggIbmshrf8P9vh+YcEJ?=
 =?us-ascii?Q?2/MfVqfpEXltdHlgG5xcBpW7p8WEH+A2gPeFUjqEy+8OuX/ejuIwpIFP+oJH?=
 =?us-ascii?Q?w8+dofGYfud35BOJNOZ1p55lemmCqZA16AqWSh2TJ0i5RzMl4Bo//B6b1t1g?=
 =?us-ascii?Q?nAtyu1e41By5us1J6PsORFmwKglCaaNHQMx8REotGb6R3Gr77fGHouvPcYyn?=
 =?us-ascii?Q?z7gwOUnPCpUQcus07FTqpUjJGZ+7V1HRidZFDmpC68YHvMlJ7wgH/zL8X3qP?=
 =?us-ascii?Q?VaoStpiaDvMAt+caQ6ifgpRKK2u8jODzIEFYJSuD/SN9SQ8P39sEw2mn1IjC?=
 =?us-ascii?Q?+3zZnIuo8Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	n/0O8PTBeABbs1F53OWdG4ckx4FPCbUeJl0JCHyPAf+tg8rt6DaxKR4iRoRf6pjHTjpCvSgEoXlvs7dissxJdi4wENXu2uRj0tGA7hnm943W4Cmxscl26Vyj9WjgW8FBqyjAyjqDcntz0pkjrPvuJ7tqimqIIpdUGfoT50a/8X16yM0xOd1RikOGooLkHmIlOuT/A0TfIRKOFU8F0CD07mrsjNNnvgbQbnsO15yt61vIYdT8oZVXNNWuSr4NTtcONIWZrhbioAfaQ3N/HS6RaWVDdS34fygiaw4ruOByO96wHieqOosWX/83L9rDT5c8Ucf5YwpWtKcnps7dyJMSug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KqsXqe/pqSkNF/3UhYdSI2/wloZkAneCtKBZhUzW558Ag7FMWFSR3jUOaxucyuYxoessZgQE+YECnYiLvkRDH9dfJrx8DwO7t3d+2Nw3gvR/ecDhlsigPbviXLPqV3Xo07txWTYbh+7tb0IZyFlM26evZGMeSdNR92Ns7DKih/kaIFm4eLatsddx4a1TxErsSqM2A6KI9zga/Afu7WymcrMSy4ITfqQdqItfJZsJ2R+kwzwTsdDRbOwqh45YBUhxJymXRQcQOciTlsoQr+JwG8jgn6tzTVlFNdZJC2PNn+W6BrBqgI7J2d4CYasv4lXXNYj2To9r+FUTbRgnHLrYNX3l4lr35ZVvk5Ip9HloMI0arnHQHEFuasZ/NYqhGwpt84Yh2VFxSuBL3SpwN9iErURJORH1mHzkvk/jwOmJgtoHrg4ihk/Qhl79QrvLHtcH1giUCxCJiFkFCe3UKYsejLoi4z7zY03MUXJyRgaGrbvImzL9rIZ9IDE7JPnPaBThtivwvq6jOtsmqrRTIuE5GbRap+VsCgxna5etrj4P63Hb/WXHcy75wlMk80Y2eJ5SsJkISOzfhc1wp5VYyYpI5qAnYp4BDDxm8wFWu+qGmYy/d3MOagDMxl1lIFT8z873
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da512702-277e-4823-bf8d-08df1a1c2e80
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 09:14:05.2607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5it94gI3kp6cYAZSn3/MbtVfuMNgMLAvl6T0Gu96qdvfI/U68XhD/mH9t6yK/wX3+OSS7t2Ds1TztKFaSrB9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXP192MB1758
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
X-OrganizationHeadersPreserved: GVXP192MB1758.EURP192.PROD.OUTLOOK.COM
X-Proofpoint-ORIG-GUID: L_CpnvbDAlMwR-QZ5T7JsHYfMDEyOHD9
X-Authority-Analysis: v=2.4 cv=DPkacCNb c=1 sm=1 tr=0 ts=6ab4e9e1 cx=c_pps
 a=3aa8eInQk0TlGnflvv0sbw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=8ys4xmT3Mru1TjC2zVq1:22
 a=0OB9rZYAU_mni_PB6XIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: L_CpnvbDAlMwR-QZ5T7JsHYfMDEyOHD9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfX855K67u7hzZI
 B3lShAnPrK6Uo3hZzuYqZ5hgHXUERL+Ke0LAx1Bj9UaSqjQWsoSarvmiE8yMUoW9jYFrizfdOFh
 Git93bBz5CWaowECqtS0h2l7KWToCTI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfX5Pkz2XWONmL8
 efx1RpD9nIG3JP+V94V46Y0Va/1qZgvCStRYfA3gwioT448Kjuey2DGTtnFp5WD2V2Gx9jf0l7W
 v4yNS13AGMOLaxKnwrChDoDTZsBLXL3fOj6oJsi9zhHTQCiQJrhF0bwr2FrQl3E0yAyzlBG2HxV
 9LvZ/VGDH0l/2mEECX5iYBqLuJ4zZMsm2D0FuUhT671KRGJU/L/PgBilsVrjpgdjjzyGq3aEvYc
 Z9xqmC0fRb2th6eq8hrkqJGFdGst/HrC7/ZyRxLGqGhV4WMQaayGali9WDjj+kc0ZVQ6YrLrLij
 GJvYZY0mR6vehNF8dx8LHQGT3+fMUqBBYCPhwN4vPEbUGKvClxHfEcencrbpbIXnYQ1u1UAs+WI
 joRswWrB4HjLpM7K5QeeUSWkEE6i99UVyRQzxeh/7V9xgSwc/zXrDVngtB6J05oKfS0pUqGbUG6
 7IR1q+jmciYTzgZRWsw==

On 9/24/2026 9:29 AM, Baochen Qiang wrote:
>> On such a timeout __ath11k_peer_delete() returns early without removing
>> the local peer object, and ath11k_peer_delete() consequently skips the
>> ar->num_peers-- decrement (it only runs on the success path). The normal
>> free happens asynchronously in ath11k_peer_unmap_event(), which never
> Hmm, I don't think so. host waits for peer unmap event in ath11k_wait_for_peer_deleted(),
> before waiting for peer delete response. Since there is no "failed wait for peer deleted"
> log, unmap event is good and ath11k_peer_unmap_event() runs.

You are right, thanks. The unmap event is received, so the peer is
already removed from ab->peers and freed; what actually leaks is only the
ar->num_peers counter, because __ath11k_peer_delete() returns -ETIMEDOUT
from the *second* wait (the delete-response completion) and
ath11k_peer_delete() therefore skips the num_peers-- decrement.

So the essential fix is to return success on the timeout path. The
list_del()/kfree() is only a safety net for the other timeout case, where
ath11k_wait_for_peer_deleted() itself times out and no unmap event ever
removed the peer; that is why it is guarded by "if (peer)". I have
reworded the commit message and the code comment accordingly in v2.

>> runs when the delete response is lost or misrouted (e.g. because the
> what does 'misrouted' mean?

Poor wording on my side, dropped in v2. What I meant is the case you
describe below: the delete-response event is dropped in
ath11k_peer_delete_resp_event() because ath11k_mac_get_ar_by_vdev_id()
cannot resolve the vdev id (the "invalid vdev id in peer delete resp ev"
warning), so complete(&ar->peer_delete_done) is never called and the
wait times out even though firmware did delete the peer.

>> The problem was reproduced deterministically with a fault-injection
> curious what the patch does? does it modify ath11k codebase?

Yes, it is an out-of-tree debug-only patch (not part of this submission).
It adds a few module parameters to ath11k: one forces the next N
ath11k_wait_for_peer_delete_done() calls to return -ETIMEDOUT, and one
caps max_num_peers so the ceiling is hit after only a few deletes. With
the counter leak in place the AP stops accepting new stations after
max_num_peers forced timeouts; with this fix it keeps accepting them.

I have addressed the comment style (/* on its own first line) in v2 as
well. v2 follows shortly.

Thanks,
Michael
