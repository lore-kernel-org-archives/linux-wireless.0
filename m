Received: from mx0b-0024c301.pphosted.com (mx0b-0024c301.pphosted.com [148.163.153.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C39365A14;
	Sun,  6 Sep 2026 20:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.153.153
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788727745; cv=fail; b=YJ7j7Nh3fUEbFRCouyld3S85uBqd/2bb2rmQVjgRMCMwpJAlSCqC8JZqaVuCcQ1gJt6lbZUt55/e+4hmq8GU5EYBtmSTJpXaItds6I23DOGbuLs5wMo9si2Bl0t94peIb7Sny9AyPPKM2jewcalHdBZp8S0nDjkOMbtVf+oWNog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788727745; c=relaxed/simple;
	bh=Q8lihZ2OsPJ7nI17JMhaPCeArsUrdbAjr1hX1Topglg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mV+KvwGkrYDxv/gb9QRLfhRscr6Vt8f1x0stQxh24B3B4+LBL6JoVThyJqsEvXqO5PO4dsD5HOC7fa79OhzuXnd1njognjoC34FZvdG27Z+dEqVxT34TjDBNJK0mp93ABGy2yg1PdN69PA6dkQM5CctttLCC0fYuW1z2mRgJP8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=xMBsW7Fp; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=Vq4diod2; arc=fail smtp.client-ip=148.163.153.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="xMBsW7Fp";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="Vq4diod2"
Received: from pps.filterd (m0101742.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686Km0K22754093;
	Sun, 6 Sep 2026 15:48:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps12202023; bh=Q8lihZ2OsPJ7nI17JMha
	PCeArsUrdbAjr1hX1Topglg=; b=xMBsW7FpWfvJpILqrNuxdt7+oCGeoY6IDMCR
	2aIyZ/JrMqazjYm93su7VcA2Fznfvr1gUmtOUzsN5q+hyJ0tMPlFfx9czRfZw8f5
	oDNLmwx/o8CeghVJZgutmJfyZO2rQ7kFxyrTfpsOwApTR5JRe8ZY4fnam+9ELypV
	AEmxoJSMP4RdyXlpEBxjMNYte1As9aYbGzN/Imj0sO/1ndZzDNzhwIhtIYezu67h
	OC29n8ZvlE3QQ8a038BWIMDwXWuf78Uj0/NZ7AFqAfJGF5VgGkAcEEz3SgnsCUIO
	b27x5KLy/vdlPYRFCq8WvNIk4lJjwDnCwQFKT8Dp7xUthMgQBw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022124.outbound.protection.outlook.com [40.107.200.124])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4ggckb9qyn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 15:48:49 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oB6NxZmN/mCs1hEKjFHimtcgSg62boU3uuZh3rjDb85m8iklbAAR9kbikaeJeUJtehj19ae3ogAuxr6Bxwbrno5xepNEZnqRquCM9zQnIhjm9baLHMi1epz9OgvtKfKxkkHqesPbcaYF471MtcxUeRpQ+kZlAhX1Wg64s43RRM8kywPBVASy9CVS6jSBIqI4lKG4dZAJSbdzG9K90IBzxCS9Fj7OAfqN7KTNPupcagqiMoDaF+pdggP8V1ycVJ6G5Vqq6OexfJNa2VhFaxHKJsx5IT/WyAziBWf1GsRoKbMrI7pyqtgy+nEKZfjzrT6xT3jX534NFhAC7/e1SIQj6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8lihZ2OsPJ7nI17JMhaPCeArsUrdbAjr1hX1Topglg=;
 b=l3RRV/BRjHtjsQyVEI5bfU14plwdvIfK/DXvv9iEQ3dvz1k0hJ2mgX0pEjhujsD98uq4r4e5W67YIkG74Zeqt0nXcDnaV1UGtf3lHhylYFbG4DtAzut67csWuvO8xluQKiLBTi5lKMwHUoufn98TYBtWHG3R4mHnJOqfHtLWJyxZH2w7l9/XaRoc8w5uU/psmCFLUtcyLej/C1NyULupGn9Zv46xf9TYFNNDEII4AaWyLvlxq+fknGzG6wDN8gDwzme7+eatC93CJmxbFaBeWCK/EFLbg+pQnL7YD8DXkUC4vKTCj6BtXfUQMtY3WieEVfcjtM0BYcTgw7gTl+b7Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8lihZ2OsPJ7nI17JMhaPCeArsUrdbAjr1hX1Topglg=;
 b=Vq4diod2tLjuc9BJLF2I/C4aFlTxQoXNkdC71G+XDAwHW7nYczznsckf3KSaBiVOeauQeIpyBk8ADGYS66ApNcYczMPjApoFfDjaNLwWTJZ6vO3W0bY78AcXPDAqjuixiZhWhHuoPcKIquS456PbzITeOCOM4n0z1j8gKgRjTbU=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by SJ5PPF82E3BEA84.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::83b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 20:48:46 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 20:48:46 +0000
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-devel@silabs.com,
        Alexander Sverdlin <alexander.sverdlin@siemens.com>,
        Lukas Stockmann <lukas.stockmann@siemens.com>,
        Gerard Salvatella <gerard.salvatella@siemens.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
Subject: [PATCH wireless-next 0/2] wifi: wfx: fix two minor issues in error paths
Date: Sun,  6 Sep 2026 22:47:27 +0200
Message-ID: <20260906204831.949692-1-jerome.pouiller@silabs.com>
X-Mailer: git-send-email 2.47.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PA7P264CA0356.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37c::9) To CY8PR11MB7779.namprd11.prod.outlook.com
 (2603:10b6:930:77::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|SJ5PPF82E3BEA84:EE_
X-MS-Office365-Filtering-Correlation-Id: ba71fbe9-37ab-4f01-ca82-08df0c583e2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|376014|52116014|1800799024|10067099003|6133799003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	0KIXH0qTIImNPwE5sjzYgfJb+E0ocvuNlm1FOhOaq9qAaNzvMIeznckoMCwlrPbg3OAkk0yBTHs1ERb6lx1c2CeOlUiRlaGaf2BWIQ6g0YSLeq9bRU1C+AeDnofhdwPqgFHzvUwIFaw2YJ+gQB8c2zgaodbiHf1IJ4DxXUOvP7nUucbU0bZrpBI5GNO5v2U6TBRuu8oJA7G99UOBz4kN2yRR/rjlEpZbXHtQLQlEWHABEA5pqtmG0LpyTGIzDYEQxZZD27uG4bqN9PPq4XGVi3aUcVTJwYr/FerBJLZzlvvPcbtZ0ThQweoIRzKyUqXlY4EKJ48YbCvNNyi1xG30NZOvGZaUAYonfsJaEdyQSwm2U9MW54jlLBvCS2b5iPI4TTZRIysTr8sDtovvRTS6MhX8qGEZYPf2xecmVqNUU6o1V+EPIFEHWgS710W7eQLRD6MMQudW+2BfXhbUb7Lxh09Ic2Bgv6I6G1KXbST5ZUWGp3fFx0QbAMzgkvmZPLWa0FId90tDyyifm6Kmzayxg/g7Ddong6smo/l+KFUB39sq/LIdayw/ycIBm/TqJErTYeqmK4exHfTJjHxzob8w4J8Gyq8wLXOGhSLjW8oCV+gpKN2oQ+1jPgfl/NMkfXjs6nZLaeLaxGNAGpLnji1pTj4RbbUs6S5hklaCTtfaRB8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(376014)(52116014)(1800799024)(10067099003)(6133799003)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3haNG1NZFdQU0FlRG1MM2pyN3REWjR1MXhmR2M2SUVGcm45UzFTOVBrVHV0?=
 =?utf-8?B?bWh6OURkeXNoeTJBNUtCSzZIanFqdTZMakdFN3NPTGJYQnhtZmJmMnRpSE5i?=
 =?utf-8?B?VitQR2tDQ3VTMXJadzhUMDhQWjlTRzdYUEZWTmtTTjdWcHU0N21nL2tnUTF4?=
 =?utf-8?B?cEVkT2trTkEyeHI3ZG9wbDkyOVFlcStlOEl4YVZmendoSEN0Mm5wV0NDOVRr?=
 =?utf-8?B?N3JMRkJQck1FL2dXaVpLdE9DQWRaZmVvM09UQnlwSTQxZEVzMHNjbEdOc1Mz?=
 =?utf-8?B?VVZ1aXk4a0tCblJiWHNIZmZpQk50NmcwMDVZdmM0QUlTS291a2NwV3BTOHJz?=
 =?utf-8?B?dC9VREVpR1dQa3lOSFIxY3c5K3N6d3FEV2dEcytmNktNSHlRNUYyRnpqekVP?=
 =?utf-8?B?NjdvVHBDMWtmNFRkL3d6RWFYSzJFQUhQWlN2Qy93MndzS1A0Z3g2SzVQdVJ5?=
 =?utf-8?B?ZTRCeXBJdDdkT3dyQllFV2VXRVVuMEF5QkFZa2hGeWJHd292bmdOamtCT2t1?=
 =?utf-8?B?VVhZdUc4VGlZMTdhQlNsZE1xMjBNNGkwWGRIQURieWN6enZsb1UyNHFaL3Vj?=
 =?utf-8?B?VGUxdXljMk9CQUV4dDY4ayt6SEhWZDlBQmN4ZWJlUTZPNGJ1amVCZngrV0JT?=
 =?utf-8?B?ZE4wS1hCZm92M1hWaFp0ODhyaXdvYTRtN2N6UFVNSXc3ZW9mQ24zSFh6dnlu?=
 =?utf-8?B?V0RFU1lFOTlNbmtaQ3R5ZEV1elRVMC9UUjlyOGIyUjA1MjNyWEF4ODA0cW5w?=
 =?utf-8?B?bkt1QnlaaEozMzJlTDdpZFUvSTNBaUp2a0trYkFWSi85NlRQUytFMUpPa0hM?=
 =?utf-8?B?Tm1RdUxYYTAwYWIraFZ4U2svQ2Zzc1o1RktFRHE5b01JUjVHWTkycjROZFFp?=
 =?utf-8?B?Z0lmYmdPN243N3Yyd3QvUmYwTjluUGFudTlWcFNLRVlaQmxHbnBMZS8rQWs1?=
 =?utf-8?B?S21GdTlBajNVV2syMzFzVTZ4TFVQZk5kNy8zY3M3U1l0TXlUWW1XMUJhQWww?=
 =?utf-8?B?L2ZobmVEZk9BVmdqdGt5WjZaMlprWjZqTGQ4WjJ3ZGZwNUE2VXNLeDRlUXQ5?=
 =?utf-8?B?OGpRaXJjWCtzWEdxcG4xaU5xVmVxakJZcHRCdnRIZ2ZndkZhYnF3dHdCalVt?=
 =?utf-8?B?cXVzQzZQQlZiZEdKZ3BnU0VUa2pmb3BJcmpibVBwaWU5TzJNb0dyNjdYY3JU?=
 =?utf-8?B?RE1PZVh2Z0kzdDFpa01tRm81Y1ByNk01dzlQU0dSbS8veWIrWnJ3UnJuUVdq?=
 =?utf-8?B?L3BJSXl1Y2p1REMvY0JicXlheUtxell6VE50V3VqcTlicGZhdWtTSXZrSTk1?=
 =?utf-8?B?YWdUVEJ4YmFBKytUSHlyNGIraDRudVV0WThrejI3RkhoSFZYK1NtN2FhTlpT?=
 =?utf-8?B?QUx2YzFONmxmRTE2bTZUd1FqaUNnZENndzNrYXhZZDFJNnZabVEycmR4NjQv?=
 =?utf-8?B?WXlYYmxmV0R4TU8yK2pxQUNhRUpHQUJnbThJb3pNRDNLTzhHRDRLUnZIZkx6?=
 =?utf-8?B?SVBDMXJydWtrM0VVMjNhUEN5S0hNalJTZUZ3TEtjWm84Z0hqVTNQTzlISVRZ?=
 =?utf-8?B?NGRMaWp6Rk9FbTRqb3hxWGlEaS9CM3lpUHNhOGFXaDN5ZUJOZU80aWF4bXlK?=
 =?utf-8?B?N1VtNmZ3TGgrL3l6QmNyZzFvU3ZQMGQ3ZUhTWGxpZWFNa0Rka0dSbHNVTE9j?=
 =?utf-8?B?cnNaWEUyWTdWb0VJUFV0blptVzNuWXdXZzYrTDJGVHVobVZwLzNMOEZQR2l6?=
 =?utf-8?B?MlpYUFRDcVc5c2dYR1RSRmVqZ2VzRnNzTUIvMWhvcC9OQzRXSWFZTURPR2xT?=
 =?utf-8?B?Z1hzZ3N5MjNPVXkwYkVBMXRURXJYUEczY0ZEbW1Ud2hHOVdCcjFhdC9ScHBR?=
 =?utf-8?B?R2FoWnBhV284NmVpY2tDeDBrSFZoM25PVk1GclVxbDFaSEV2OTl4UDlnM3BN?=
 =?utf-8?B?eHBPVGRYaGJEMDR3UWU5NU41OUdzNmdTUzZKZ3pYcVl0T1dBN0EwUHRsTnBv?=
 =?utf-8?B?Ukg5TXdmUGJYVVo3SUdjWjVWWWxMMzlzV25IcWZBZDNFNVFtOTR6R1g4MTFI?=
 =?utf-8?B?Wm14M3ZBTkZSOWk3TEh5QXpjVyt2THY4anJHNUNIa0JyREkxVXJ4ZWZNdEN6?=
 =?utf-8?B?bElmclFWdmFxak9ReXZCNno5WWI4QklDLzRwemNQRnRVRzIvOTZCS1ZGYTcz?=
 =?utf-8?B?S090WW5FY3JiSzlSYWJOYk1aalVzQjBPYU5ZcGtPejlBN3BLbXdUTG5RUlJD?=
 =?utf-8?B?RE9RR1hSMEFjaDc3RXVDTm1KUFdrU1g5bXJWL0VNWXlkZ01tQTA1MTFXY0Qy?=
 =?utf-8?B?K2VRemY5ajVRVXdmWWZXbzI5VmhFYzV1RkVNTFR5QUNjSnBwRE1XYldQTXNk?=
 =?utf-8?Q?wY2Ufq10WK7BAoVNzHlTlwheGLME9O3y6EIBdaK7gZ4Ws?=
X-MS-Exchange-AntiSpam-MessageData-1: xgu6HTJAc4hP9w==
X-Exchange-RoutingPolicyChecked:
	wNUXtVn5bQtH1sVMge8ECkDeMKprgcs47TkHu4dX7F3OhF5unV1XxpZzhdb77c+6vBbhndcW6gv0Zqqieh1TwedsqJhFKnjWqWM+M4B9nr6F2t3fB1w3DbLEA5qM9Mk8TvkGXAB5WGCujWEUlC+AegoXuULSe28Ls6KfQQi2Y7lRpL6T97N/CwLvmvcfVqYq4Mum/kboJkg3/eFp7au+5KkX0VoECBlRaAm0Qbea0FdZ6KjJb1D7UC20WmQelAIUGRrOV/hxdjSZ1clMpM/ED1KY0/4tmSgNlBi9KkSCWeELlxqE3ivfrRwkVBFL7R453P/Hpwgf0nMnLcH68JgZ0w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba71fbe9-37ab-4f01-ca82-08df0c583e2f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 20:48:46.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2wPvjGuqPeJQpbrWf52/8v3VpYO5n3B6gCrE39xkYqENw1nQTP7HbqnRjwKCkKl5fBr/c0jANcHzAOr+Wp8UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF82E3BEA84
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDIzMyBTYWx0ZWRfX4MDarDr5FUPF
 LDH2uXCyy9KBgfvMMGH4g2cgWf18Ahu5K5oKgpvnj8BU0aULr6VrTJ+D2L8v6RW5aBW8LfTRsYs
 e7uhjyk76YUqUs/deLHMJYGG/zWH/io=
X-Proofpoint-GUID: J-g6IYafF1TaQg7kjPbihmsJMUKa3P5c
X-Proofpoint-ORIG-GUID: J-g6IYafF1TaQg7kjPbihmsJMUKa3P5c
X-Authority-Analysis: v=2.4 cv=bahbluPB c=1 sm=1 tr=0 ts=6a9dd1b1 cx=c_pps
 a=6kjKZ7CY8GAURWpkwvnN0g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=buQUfWhnF1OtDDk5FV7I:22 a=VwQbUJbxAAAA:8 a=2AEO0YjSAAAA:8
 a=TRfGFMtpP3507h-uPkQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDIzMyBTYWx0ZWRfX+azktEpq5WpO
 seUE1iVUHab8TPVgVun1lZIe/9ncIQwWX/QVA3+kc4h0sndE06Tdz4AKFJ2FZESUbbtmmL1pQCL
 0Pv+CtsUfdAer1cFt4UdcG2lO28FjZdyH7wWHlYunnI1HX/PqXJ/12TXiOA9SHkd2Q93G0LSgv1
 HzhiiDI+yI6lRJEOjQjWXJwnlTZ24l3FG9UJaiIJPBCRbmcazNwHE50nI7UWuV9YKWqcLCSXQBI
 X0MIruvdkopA64s8gLMOh8xuuJ5TWD3rHIh9o4LmCxlq9B8IHKcg9+L0qRgmfyIHmW95qNZ3j3h
 5NCe0EcNd4SEN7VfFDzeFOvhH4T2fl/1tcYVcsN2ntCVIrp8Br9QoKxSDeE5diV8MOk1Obt28s9
 XF8hhzJ4dDAeuA6PeFOJDyFqAtZsOr+e/bgSWxxCsKsf+tLCfPmYZeSoBhjWILFBACMzhjmJnwa
 l9WNk8FYUaaIAXvezVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-06_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060233

Qm90aCBwYXRjaGVzIG9mIHRoaXMgc2VyaWVzIGZpeCBtaW5vciBpc3N1ZXMgbG9jYXRlZCBpbiBl
cnJvciBwYXRocyBvZgp0aGUgd2Z4IGRyaXZlci4gTmVpdGhlciBvZiB0aGVtIGlzIGxpa2VseSB0
byBiZSBoaXQgaW4gcHJhY3RpY2UgYW5kIGJvdGgKaGF2ZSBiZWVuIHRoZXJlIGZvciB5ZWFycyAo
c2luY2UgMjAyMCkuCgpUaGV5IHdlcmUgZm91bmQgZHVyaW5nIHRoZSByZXZpZXcgb2YgdGhlIHNl
cmllcyAid2lmaTogd2Z4OiBmaXggcG9zc2libGUKZGV2aWNlIGhhbmcgZHVyaW5nIGluaXQiIFsx
XSwgd2hpY2ggcmV3b3JrcyB0aGUgZXJyb3IgcGF0aCBvZgp3ZnhfcHJvYmUoKTogdGhlIGZpcnN0
IG9uZSBieSB0aGUgU2FzaGlrbyByZXZpZXcgYm90LCB0aGUgc2Vjb25kIG9uZSBieQpBbGV4YW5k
ZXIgU3ZlcmRsaW4uCgpUaGUgZmlyc3QgcGF0Y2ggY2FuY2VscyBhIGRlbGF5ZWQgd29yayB0aGF0
IGNvdWxkIGZpcmUgYWZ0ZXIgdGhlIGRldmljZQpoYXMgYmVlbiByZW1vdmVkIGFuZCBkZXJlZmVy
ZW5jZSB0aGUgZnJlZWQgc3RydWN0IHdmeF9kZXYuIFRoZSBzZWNvbmQgb25lCm1ha2VzIHdmeF9w
cm9iZSgpIHJldHVybiBhIHByb3BlciBlcnJubyBpbnN0ZWFkIG9mIGEgbGVmdG92ZXIgcG9zaXRp
dmUKdmFsdWUgd2hlbiB0aGUgZmlybXdhcmUgZW5mb3JjZXMgdGhlICdzZWN1cmUgbGluaycgZmVh
dHVyZS4KCk5vdGUgdGhhdCBBSSB0b29scyBoYXZlIGJlZW4gaW52b2x2ZWQgaW4gYm90aCBwYXRj
aGVzLiBTZWUgdGhlIGluZGl2aWR1YWwKY2hhbmdlbG9ncyBmb3IgdGhlIGRldGFpbHMuCgpUaGlz
IHNlcmllcyBhcHBsaWVzIG9uIHRvcCBvZiBbMV0uCgpbMV06IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC8yMDI2MDkwMTA4MzU0OC4xMTMxMzEtMS1qZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bS8KCkrDqXLDtG1lIFBvdWlsbGVyICgyKToKICB3aWZpOiB3Zng6IGZpeCB1c2UtYWZ0ZXItZnJl
ZSBvZiB0aGUgY29vbGluZyB3b3JrIG9uIGRldmljZSByZW1vdmFsCiAgd2lmaTogd2Z4OiBmaXgg
ZXJyb3IgY29kZSBvbiB1bnN1cHBvcnRlZCBmaXJtd2FyZQoKIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3NpbGFicy93ZngvbWFpbi5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KykKCi0tIAoyLjQ3LjMKCg==
