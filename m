Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011001.outbound.protection.outlook.com [52.101.70.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A39474276
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 12:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808621; cv=fail; b=byKK50ve00fwKmhAZ5hhNQ3KXjZ92k9CgVO48ecIn7K6be+3RManHY8gERsIxRwCCdjEWQc3NMv8wj/oqQAr/b6+5ua+hsQbGQuEi+EmJ91u0dT34EXZEy++2khdB71wknxF3Dqk1L8FxeERPwtIWi08OPRUaR8pxfkdU6CLN44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808621; c=relaxed/simple;
	bh=ruTP7uufnz1EAwwCTTOsWwfzFUD0dfhiFcnMqcL8LuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=O/RgheNDWIeqRLoM6VG/AQZqhgAGOeT7+hkHPbKWzl7hzTFXPkP3gVtS+B3HRaMCtwDE/JuRDSDgk1Dd40zcl/FhM5QSwTaWt7C799c8z5qSDJJJB/UBW/kV7Hp4q3ppXVE5ab9+IzJUuZR2R4w6oLHdmVAHdxveIpO5oXhqBnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=W9ac81bB; arc=fail smtp.client-ip=52.101.70.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="W9ac81bB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mzF/AnXwhfTn6J+rdVifiDRvv4hw5KaPsHxO4WnThJFkEpb72qUHfnEeBHHjJ66Q54bi9kg13V7i+bvTOlOZDr2yymn2mWj0bn+iHpz8vAGsDo7AUM7ATBHyqDhbFgdfvH8Vv29zGSWI7P3mEWFR9YJkkiSErNmDx1cafsgqwV8RNDh4n++pOXMZStqkFi0wmfLWd/CVxCnd8DsOiPkT0zVGmK4k7C6z9aRmQkjA+voFIMpl4gsN9ujTCr7ooyAu+4SzQitoGMP/JdHXQ07veLx0ftSAFRKUazB+WwGDy7gxTMli8q0ZW/+pZoOKQd13IQ9lZ73nvWNdHWQd+PkJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WwgLdiChsgpBySlxTyvuO53ApccCZSRKmhFSOJTZfE=;
 b=lnxDZbCzQl7gwC14LxT8EXIzs0h9xmTWYc/bTeXNb1yCWafCh1g2pX0d/3CwrmvAKy5srolPXVHeGzA5UFft3RSkTkwQFM3a2vA5G582020G7gzyBNwe1CJ06SeGjNsjb4ZZtZgtsMskTsvh/2v1ChK8S8LCh6zHXkQjKgs5x4mMeopqJ2rJ2Vczzs5w/AnauopLp8hKb1pAsSDm1Pt+1Y8R006f0gkg87mRuUSr6AGSXDI7e7G/StLFvsIB1CYNH9TGGLflUXdpWutjIna6aHmMfbr47NQQqo9cEn8xr7RGmSqhGJ472cYq/uHZvBqb8EDFNwN5s5yu5zui1k0bbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WwgLdiChsgpBySlxTyvuO53ApccCZSRKmhFSOJTZfE=;
 b=W9ac81bB27KjfYxxnT3eQEbUFMA5S8OpzhwUX+gm7tu3MLpX0RAssUYOpm/VJKmW5ToGYFx25ZrFus8cT7HQOXKmAsqXALT9ErG3ur/69znr/7qvrzu/9W+gGJjM7NkKXPjzzJEXuGrbBBkuKJRGF9z0L0j/wWbMBWkhIk7lQ0JfLV2eqVbKDktn8g8KYBGYcalY9UR61+I6/ip4W6rhylR9jnQ5+gGMS0LBhSD7CZUfsh7B4d+fBPyZYoBLA7hl6akDFi1cjwouec5A5gPzKl5r3ibT9qBtYY0uQXtqvm9g/RcihKf8D6tCWmFl6EO8k1cC7hYzG8+Et6wsnm3F2Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by FRWPR04MB11151.eurprd04.prod.outlook.com (2603:10a6:d10:170::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 12:36:56 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0496.015; Mon, 12 Oct 2026
 12:36:56 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: briannorris@chromium.org,
	johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next v2 0/2] wifi: mwifiex: append hotfix number to firmware version string 
Date: Mon, 12 Oct 2026 20:36:22 +0800
Message-Id: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::15) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|FRWPR04MB11151:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a5aa3d4-90c0-4f92-8717-08df285d8021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|19092799006|23010399003|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Aek8/SogdUzHdFspQCsVGfoXg+LocTfkIdrbcKknEjt+zYfPaSruj9r+FPNqwrpybAMlqyipqfL/ssh4lHLWMoLd/1BXIpoYBWmgRAf5uJLx/idlhJZK0jJ7B0KECvv2wGu6OLLWhQaQF/wfRgcVxiVSLRXn23NUPjaj1G2BoNEUMWdbkfctQF9qPaCMQLz96tEDmlOvLJtOXdR2fvC6c7LhXbXst5Lp6u/nJIM9Y4BbQ6c4XGChMQzTfgstiN+yn6+6pP4gpQLW1qYD/RxDR5DS4v8fkqRyNkItfbpSuMVtg2xKM72bS9wLx2q6ZKbkFExtmSZHepaq+J/YYKF68ViRUUsfGkQoJ7X5Yvw8FIYX/+Hd3CCH02Lw7x0p+IfTcFEjKzoph5TqhcyycxYImyMAmDjKf9zmEXhvLm6oteInl1i2cYW1Yu4mhzJLF2xvDhkhaRtRaEQPoxDRgRYNO10uJqxgEmbszadrqjT0JpH5E5wmSpe/Zux0kJPejIBR4JKZ/XmfOTo9iU+c4tsE7+5ORPmIha8DaFAeIYz3yBbPgfU5mxYkjXS8YHP30udg7s2IxBkq8dodltBwZg8lxNMaKkle8MdL3fFaRjXUToLds9QKRrwQumF6pHYkoxd2pRO2bbeEKr8jqL7BgWNv2ITM8IkR60M0wusVWwCBFHo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(19092799006)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XNORhZzQ2kPoTcAdf/6q+x+J9GT/237JKYlmqZ0Fj7CiahI3Yc1NFAPrey2G?=
 =?us-ascii?Q?uKRVyT8tsm0MhYy8qAtcrIloL0APGvSgU4bJ+ynnirbjMBpQIgQR1XeZW0RU?=
 =?us-ascii?Q?4r5Cw8l/8fqWxfvIMN7g1mc2aDPJeJ4NRCkfw8T/g351BtXGDrd8PIdkM7oP?=
 =?us-ascii?Q?+TJerEqIqJgny6E+vERch3YowlRCLvujgAJx/+RWh2gA/ZUGJVz+zTUOs5dp?=
 =?us-ascii?Q?on1zLCsCwQroORY2dKCk27CPWKharevmfFVjm9OODNy7SNJpGr22O7v8uaW9?=
 =?us-ascii?Q?s3b7tSVp6cscYz3JAI3CNiUWzlS4z1eowSUdeIKDbT0/k9giZMKzIe+tLv3u?=
 =?us-ascii?Q?Os4TNSs1/T7pN/ZS4Gx+pDKnjpV9nWkiZk3SembsM2klRxg/0NYHFSlUSsse?=
 =?us-ascii?Q?BCpMQuBsEEZR3xQE2VVR5kULy+hzQlW/nqy/52JTSgiW2S2FDYoWcZNHTe3y?=
 =?us-ascii?Q?GXHBWqnBMzVI9DP7JAfFz8ef34k+mPhW+p9LVjATBGiesKOfMCeEqAG/2UxM?=
 =?us-ascii?Q?MS/Kq/Ls+cBoPZ+2nYYtUKKYILihKrDjzrulMJe0NVJO9GcLxVqJRfoboFnP?=
 =?us-ascii?Q?jR04AklEVain7xldx0hDad4he+Irv0+y6DdUOxtdxpeEcTlgrsJP03RQQE3D?=
 =?us-ascii?Q?QUR7iFclfRFCQNiti2ZyRRILuzqneJ9T4wtCMu9yzMSy7h+wTwAtPpL/sidv?=
 =?us-ascii?Q?MavzXd880ReDZV/VLQLCwRy886lKwN9HnxhGc4YeQowwz40uSfHuXe64dS7w?=
 =?us-ascii?Q?hPnHkpgDCj4ejPR6aJTlerN5GOo0MKwQ75cqCRzcdyOCS0UBw0Woytkd9Gl6?=
 =?us-ascii?Q?JBsLia+TC1UjvJFXl2u9uE0efb1lHIlGul+8CyDvOMbk9luutRQ6D9Qycoar?=
 =?us-ascii?Q?Np7wRWUaDup5kqU1+iHv9XO5EzJ3Hv6EAIGMPrSu57394ZPD2KCBzAsXyWpW?=
 =?us-ascii?Q?DHtnn+p0cqP8PWvB8kvMKNZpCp7XkRRrnvigNSi5C3pH5bt5WNykKscl78oR?=
 =?us-ascii?Q?bHOHxmU6FZa+osq2au+4dfmxlK64j/uZAd4+nUbFC4HtIFISLX/4Hdyk6wT1?=
 =?us-ascii?Q?Jyf1/HHAnXDdBMdxvwVe1/9WUPdKyI5maixy7SMTVz0jt90P2EoefMfl1pGQ?=
 =?us-ascii?Q?CkoiYfttKW4+8fjTNWCZisZ/9q7xyyRwbWog2qHM0lK8Mhq4acfX5Km1Es7N?=
 =?us-ascii?Q?Toy8w49OnFljeSW8sApmzrLl+PU0olcF7jDOgjIXfFPh0PmozZLXMDRWkkWO?=
 =?us-ascii?Q?m2vgcbBt76MHa6VqIzdFroPbHv/VfjkepLY3zoY+une1bheuU61V0hsfpQQF?=
 =?us-ascii?Q?zmNJ1oLYJBU7fdhdIb4WVEZlrvlZYiLe+4VeIHCI+mxrQ1onN86NgZUYd9Rx?=
 =?us-ascii?Q?PURw8RMU91fs/ti43VtGjQV6fu5Qhslfbt13bqdjLWXzHFlMdeTpGnaTyz7m?=
 =?us-ascii?Q?s+XNhcgwKNez/g5+VA9WpT4o++3BkrVkTno4rDG1OcoOfXs7PDN+lc4TsLIT?=
 =?us-ascii?Q?CU4tooHVF8GpKqwNLRA8z7+3Xd/4wqt/C7aQIjlxgYjzOBP/6YBDoFWIUtoC?=
 =?us-ascii?Q?KHs+2k59xci9j+Yw46Lj6AoFSZzhSTcG/ayUeR7efRXRsUxxJ6cN0QDvpkPj?=
 =?us-ascii?Q?OVQC1Fo2TIRXXfKIUEIrkCR6QsgUEkK7mgccvSeMbQ0tpdJkccHmDbMp/si1?=
 =?us-ascii?Q?R2ysog+LiTjHrTPY2TRfda6cwaMwGiASjE6aIPXUmHaFF8MR3XFQ/QlKplyv?=
 =?us-ascii?Q?/nYToeYfd/WV2bOiN15uaB49e6AtBwOf5YCWUTlmysMpzLD4Ivvf?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5aa3d4-90c0-4f92-8717-08df285d8021
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 12:36:56.1811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgf/VsW2cCpD2kvkse54mdp1pS9V2dEDkXAVRHJPJDAdclF/tBanM3FJ1wJ5Ldvn45nMxig0dlaXcF8VR21sNr0mu/SlcOVctOQAxKkclx95LmgSYz8rtFAR2IxIGuu5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRWPR04MB11151

From: Jeff Chen <jeff.chen_1@nxp.com>

Changes in v2:
- Split TLV validation into a separate patch
- Add generic GET_HW_SPEC TLV length validation

Jeff Chen (2):
  wifi: mwifiex: append hotfix number to firmware version string
  wifi: mwifiex: validate GET_HW_SPEC TLV lengths before parsing

 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 22 +++++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/fw.h     |  6 +++++
 drivers/net/wireless/marvell/mwifiex/init.c   |  1 +
 drivers/net/wireless/marvell/mwifiex/main.h   |  1 +
 .../net/wireless/marvell/mwifiex/sta_ioctl.c  |  3 ++-
 5 files changed, 30 insertions(+), 3 deletions(-)


base-commit: fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
-- 
2.34.1

