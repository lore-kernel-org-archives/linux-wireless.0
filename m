Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013059.outbound.protection.outlook.com [52.101.72.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32B73E5A2F
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135120; cv=fail; b=X5PGiEWy5amzZJ8HUgJgiBB2M3Zwn1vfomaFI/oyCyh8A6T3VDdAHKt+Aakwwn3Fc1doIDW9Vu1GHD94ELwdEL9FTEN5AeDyxiwbZXZSTHR6YINdKtxHF8GtK3WcGCl1Uq99NVnifFCX4W6hDp5VOFYTc8/G+DHPQQN5q78i2kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135120; c=relaxed/simple;
	bh=/wfu6FCHhxZGaf1X0HOgG/fhkgFtuKquwcmTt4DykZs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=OMr5OPJ3YCOQIxHoz9OZln0yLa5v2I/4Cja3SeRr1Bj0mP8u53A07Y+AMokH2kXdx8K7P9pPfMNlcerjDXNYcVziJ9xUJ85xJdMbWC7MQFCm4d3xhNBsEfcDoGvlG4n56mWSE0UoxYTOADJq2GKVEMO6YhcEwV6b63zXqETKJyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ivUwe0+c; arc=fail smtp.client-ip=52.101.72.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ivUwe0+c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tUepiQ20rWaorRMUhtgBBrgtdkH1cCZb15Zw9QbeGddh5479nTxOcyYF7SIJXtDYCCK7/KDFr0RdKn9Rln3m8CoiPgw5A0A3j0iQfKF+e4a8U1dNPN80FEWyyQjV6PckXi0/h1vOjwXc9k+P3qpr/aNGN7pH60+lTSOgnqSjaPzH19Xtjc/TyaMp6I1x3lJUIStuT4wpFPc3c7fnyTW+ZydUZxTA1OReh0Z0FgQxkN9rOVJz/DNBKfgqt2ZWdxAQPURCZVzcGe1EPg8xhBqENXYq4MNB0JmV/hrZzypgEUBJDo5IzaQaZpFKKfFcBl66qxqey6CA3YeK6oWh7ibGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9VbK7uONRanDYK0MxrFRlSC46AYFYrN82k25uycKuc=;
 b=DFaz1JoHOzGVKj+PRznpvZ24nCOLf4RYcHqPxdy2CVUKVm1KohLca2HeaD9JVObTyvBm5Ru2fxSxi/+hkzmjkVNIu895mqpOkkpSZadfYRBj1RLM3Eu/omhl33iZN9ISsmaEQlj4wNTaZalCwpnh4SlhSkAx0raWiHSNv2E+LGe1+K6MVqmk2uYWfmG2sXhQ29KYvU8ZKNJKmU8WYOZ5hSlbpBuYOoAZgbFXrgIEg3FODvhT9/w9oDJKKl1ga10xEGNe/LVgQ3nFNixoL5LkSngOHy5w3BZUlJ5xAHTu1KMvvk8w72VGXPDww+HEYIVQqwuNLxoHMjeU11HLf50kbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9VbK7uONRanDYK0MxrFRlSC46AYFYrN82k25uycKuc=;
 b=ivUwe0+cG59w4fqPIUwPrfsU/WpmRxQx/sxhw8bNlBBv21QQiLZq20qge2nVie4c952GAC2qF5ZzsMZqDAQWjIK9BoLcW5PTV3pJsSLRPArcE+comUdElfPBeSk9CULsOelJWGPmFDr82U7bPAQVKOoUgBoDlKbD9bZejliBnhG29O1IvJJcdikTlN3HK9MPbLw/lpo4XUoK0GvpsF1G0Llx9/b9woO6Ga0O1p0yAT03xVkFYmz9iURiP85jO3fpKOEgKgMKYzg1mY/T5h9fSjPuhobfm7nCcmJyxW6J6mrbHouAVnEJFBnQecT5B0skFa2NkQBGhiFF5h6Szp1zuQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by DBBPR04MB8009.eurprd04.prod.outlook.com (2603:10a6:10:1ef::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 07:18:32 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:18:32 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next 0/3] wifi: nxpwifi: add Wi-Fi Direct (P2P) support 
Date: Fri, 16 Oct 2026 15:17:39 +0800
Message-Id: <20261016071742.3541420-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|DBBPR04MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ee05cdb-1f4b-47ed-9e70-08df2b55aef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|23010399003|376014|1800799024|6133799003|10067099003|18002099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	camNVTk5pr25CwZVLXtsxAnjXWSGDLrwlOyEAUjgIJ5Yz5c99vcnOyCZhQGdEnprCNJrEPJOgOga+KslfGNjJxAmE1RlUmjn/3iVnw7kxPlOHuDThNp9sC/ErSKY2J5b1za2Je4BJ62KGDj0rzskmrCrbDjwZgxZnUhARtJmfalRFAe8wF000mi0sJnCTeYr1YkaCOTdQ13KwNfgOQhhGodInFn/IxYgYBL5THR0bULxBqKN3c45adsIhpm/QnOsdnMVX5Ygl8ozWiAuxO82mR0Lcmhh3z9o/AIu+FCuQ9A+/eY0nIWhW9oMEonljyYP00FHu/3Z+bz5BGaInXxUgpQRceBLo041DqkATR88hrDT4OYCEjvv86gZ5n1Bbnig9kB0/CuySzxDxjzQEGVItd6PsZdufuGBnOicTlHVVzHGEOlGx4xsuPQCCNsz5BcSCKVVIABWJxryk0Uhw4xndrHwt5PkTzcTU23nc5Ujxn/dq0+qCL/aPiIXmWQ6MTOwG5ZmIpgXEUuh65WzjLUoqNL9CVjgAsI8QS1Q0rs87bwFRJmCaPu9LGI/QDaZknFUpvP1qFbkkM2JeE0Bc/nl0W29rhwmqXKv2bRIer0QUbhnx1AJ0SQQVI1wi6h8lAhW+ZmPyRqPTNz6eeqLt0zTz6nJz/PTHGaWAgARncz3uu0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(23010399003)(376014)(1800799024)(6133799003)(10067099003)(18002099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zzmvTuRp4PQNumA/0xf1i89ym79DupCAKqcpdp6WGoRBQt4Rsm30dgI7t85U?=
 =?us-ascii?Q?j/6mexvlVowDXtjT2jMKnH5M2RMjpFN5pf7ZfcHIKDZJKoWO8YefSDIg+ca1?=
 =?us-ascii?Q?JkxuXRg/dp6dl94n1ELv8R13bgQNQ0Fqeqgo32GAtU/Z8TPL+Q0NIByyPBFd?=
 =?us-ascii?Q?f/JP561YdtqTckcW/tRbhyedHELAPQVIrz7kvQv9LCoTZ8S83IDePSNFN/wZ?=
 =?us-ascii?Q?A91M3tlqwUSZIu6GpDC8/hi87AKVDZlbMCczivEWUEAIS3PNxKr88s/an3vu?=
 =?us-ascii?Q?b1ulftKBe3pkgd4KSVsLtG2B9D3eRNKVeMFKc5h4m1oIdaenWagI9IG8KwhH?=
 =?us-ascii?Q?VXKa3uO1xmFr7IKRjHvQySp3d2h5+xFn7u+Nx6264UTxd77TitKq73vCeUqF?=
 =?us-ascii?Q?V4rJjeSTgAwoDAD9Yljd4T5BNH/U9L2KYtwrME1hGKYBpaH35N6FjEpsHkQL?=
 =?us-ascii?Q?WGxYoOu4OUlettPsx1kihEX/LkBghEWblUxG2Sx9xcJvng5xQoQyw7Di4Cvo?=
 =?us-ascii?Q?oyXiJAsFD+C4QsMRM0wZwRZEpAu8TcT10cT8ypM3haaocR2hssb2J4wH6+rP?=
 =?us-ascii?Q?AZjIw6pKaOUJ+VUwfxVv+MWVRA92mVxReZYT6f2pn/7kLb5vDgNH2U0R8HEf?=
 =?us-ascii?Q?fR2rnMTdrZWnRCPD4T2BhzZUmqTsiMD9198HeyhkMzibvd3M+CYZGvB9SjjQ?=
 =?us-ascii?Q?6lbGUmTSwr6wrZi4w3Uljv/3B3IwTRT5ivpP07jZmOs72h541mAiLJYhZFE7?=
 =?us-ascii?Q?eNXd9O9KYF8ULj3tOWZQJavTj6eIhJvM6AX1G23s7S/mFX10O6Uesxc9JVYV?=
 =?us-ascii?Q?LwULxD9U0+0SnR8PuRHYw8Dfb4zxpLbLce7yOsu2vua/m07zObxR+eihlUrq?=
 =?us-ascii?Q?QPMZZKjOtuQ3UMwNDgDnMd5Z7k8ilSj6WYFYav3SJkXLGF3AfWC8EXxt5jQW?=
 =?us-ascii?Q?N9lw5sWAUX9bCqcEO8+Rdrl2pQ5mgxzDLF5xa/l2PQbAwjJkXFmA/AkHw7js?=
 =?us-ascii?Q?aCipPVCO8wHlRpntTrNgH/y2x+v/jplB8fE5ZAA6T8VdixZ9Mca1gymyhQXl?=
 =?us-ascii?Q?M/6CjwuxvtD/OAAaX8TEcFbTEu0gPhoSeUPhmGr9SlR/z3/zmPqemaQVtsIx?=
 =?us-ascii?Q?9FoadpBaYvbymlQOmfoJaayqTxoSfTTCDwp73BMt0bQzVh6A/jUElPkvjhC/?=
 =?us-ascii?Q?L0G4acrY6s2LUvRiIECdsMGij65h3opGAq4D91vYLkmC9KYJg8gTqy/AxnpG?=
 =?us-ascii?Q?/mjhh2dvf9GKf7q7OwXiVgqoq5apAV4Ffrk3TAoBItwgTYGeIolj503zix1v?=
 =?us-ascii?Q?h5DvmKI63476WRMzAsurOe+jvd0Q+f+7i6TX9uYgt3HJLHC5MAV8rXjrZcbT?=
 =?us-ascii?Q?IxzRsk0A4bOFE/wyEL8x9rLC/VjR0j4ioNGVqAVTKFdDUmiHS9PBsVcfGtfF?=
 =?us-ascii?Q?ITpqfy5LOXJ26L+TMzkDOBgbLGBTOq5qUf986+zdtP+1jfvtJRtEJ9U6MZq4?=
 =?us-ascii?Q?lOQqc0FTOWi+A/Ipz8yzqPU4ssRZ9ASlLYqHyTxzLA9PQJ0uZUOMEAol8TyG?=
 =?us-ascii?Q?q536kmcJdv+lc9c1eVfoeAntEw7ke0umLXZgAeqK9pCb++yXMNMdZGmRuR4q?=
 =?us-ascii?Q?dlQwt2P9z659WQ5lUOwc5l1Zx0B/kaVFHPvYRyEpLRHlD05n29gg42+J3dkf?=
 =?us-ascii?Q?tN3lcMOP6fx3BNig7s3b16haF60gC1da/tC7iMXArx9tOajPUrTc0pJ4hRIO?=
 =?us-ascii?Q?uiWuflCHfZFKQP7nvcJqAD1CUI854Lcj4rxoomJQ/viDh0Vclnx7?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee05cdb-1f4b-47ed-9e70-08df2b55aef6
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 07:18:32.1696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhGwqt24z3gFAWoAs8bzWb+jB6hQkjwUEikf22uwU42P1EjC0NaAgTD9QqaU8i0+pyUARgoYmRwAXptbEp8GEc4AZLcqaZuLUBtcWTs8LdV6zHtmFdKZ3ke2MEbuQjd1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8009

From: Jeff Chen <jeff.chen_1@nxp.com>

The firmware already supports P2P operation and role selection.
This series integrates that functionality with cfg80211 by adding:

  - P2P mode configuration support,
  - P2P interface capabilities and management frame registration,
  - P2P interface creation and role switching.

The implementation supports both P2P client and P2P GO operation.
Concurrent STA and P2P operation was verified using wpa_supplicant.

Jeff Chen (3):
  wifi: nxpwifi: add P2P mode configuration command
  wifi: nxpwifi: add P2P interface combinations and frame handling
  wifi: nxpwifi: enable P2P interface creation and role switching

 drivers/net/wireless/nxp/nxpwifi/11n.c        |   3 +-
 .../net/wireless/nxp/nxpwifi/11n_rxreorder.c  |   6 +-
 drivers/net/wireless/nxp/nxpwifi/cfg.h        |   3 +
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c   | 294 +++++++++++++++++-
 drivers/net/wireless/nxp/nxpwifi/cfp.c        |   3 +-
 drivers/net/wireless/nxp/nxpwifi/cmdevt.c     |  11 +
 drivers/net/wireless/nxp/nxpwifi/cmdevt.h     |   1 +
 drivers/net/wireless/nxp/nxpwifi/fw.h         |  16 +
 drivers/net/wireless/nxp/nxpwifi/init.c       |   1 +
 drivers/net/wireless/nxp/nxpwifi/join.c       |   1 +
 drivers/net/wireless/nxp/nxpwifi/main.c       |   5 +-
 drivers/net/wireless/nxp/nxpwifi/main.h       |   2 +-
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c    |  22 ++
 drivers/net/wireless/nxp/nxpwifi/sta_event.c  |   3 +-
 14 files changed, 363 insertions(+), 8 deletions(-)

-- 
2.34.1

