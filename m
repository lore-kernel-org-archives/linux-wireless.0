Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A238521235;
	Wed, 16 Sep 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.184.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789569740; cv=fail; b=ACjMMXWXdjBEl0IoTEaQBdvicTaZiMzAiSav9q6N8t28/2ZmbeDENQYAeJN5UyFqgOeEOEcBnM78K0B8iNOn6iOW03xcTYHRHXqek7Q3vJoMu07dqJU4FFPdcFJlJKNNREhmrzBfqPt4A+JmgcB/8TR2jXBwjBEuwHWcUyd43H0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789569740; c=relaxed/simple;
	bh=YSapI5mS8G/Sc75iTX6W1g5qmF20q5i5mZU/EC1ZVAs=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=OLXZ3NdXWa634r0atdrpmxeoGVOjn8GMygWrqKXE1R1woNBTMoyvNpW5bRipUAiGgKu07kI5ji6T43rUerPs1iQE4eocDjf2y5O2YoEs+50DoOdOuHMo1i7jfUFUOXH40vhElYWLcbGjKkWgdTF8zHrllEFznHsyDF9l2toLrdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=BcPPj9ai; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=awyEy+He; arc=fail smtp.client-ip=205.220.184.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="BcPPj9ai";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="awyEy+He"
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GCXOtd963212;
	Wed, 16 Sep 2026 16:30:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	270620241; bh=19QaQlAT64m3/aRy6tuuqudMLXFPnwYo1E1Hr915uwk=; b=Bc
	PPj9aifiIRgJcLAkAqfdbUoQb75aeZmc6WTPcsz1g6UUV0dPCpjrKUkmSdIv9USw
	rgal1N++Kck8Oqqr3LP5BSW7UuCym2i2XSz3T1pM/Er8CRzHCTQC2SH9t9m/6Eb8
	wZQwFMYsdpq3S2SqyenP8F9epYvwAJHKtcflTU/MFuWbCXZAA8/0DEK6r38FOL1i
	kZzafpIY70/U9ggdDV4WUBQqItIV3SF86DccZIpNrqWQF5uI/j6dPBWni5pA3sHc
	rDU9fBq3RUiUgEBg9/69Z2P8El9ayo0fcvZAm7aSAPOLRJoA1BY8yByxqWcD0VuJ
	uuCaupk9HM+MT6kZOViA==
Received: from du2pr03cu002.outbound.protection.outlook.com (mail-northeuropeazon11021136.outbound.protection.outlook.com [52.101.65.136])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gphfuu09u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 16:30:33 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wOmBaI1RQCpvGPYINPywoPH7dHixnkLFiTbFLlMrKW2W6k0nEXoooJOnqPVe0AgltZxVze6dhgiAvXcjqOPKNy2EZnlVc/0ft+7oUG70n1tYBepeyiW0nHw71+QN764kaSH50lG/naVN0KuKpm2dOVxNsvEFEtmz9wfXQMSH2mI3vQTf/8PG+fy71xaeXBcj3lfp6lrxOpvqe/3JJ6AWjF4rRmNFh2jzOKIqb/FEpSxdXSAOrYnN6QpUSzHytuayg1Nal2JGSJAvlTHE/2Y57QD0nHe2sKGpAEOAaAOFJZxGGpYHVGcvRpMlV4IqVmq7SWZXfqqeo/YgvWDxtj0cdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19QaQlAT64m3/aRy6tuuqudMLXFPnwYo1E1Hr915uwk=;
 b=jv46x8ClEC0bxzrDq3X/0JCuxAklH4qdArY7kDwI7B8/osdS58cPJ8iU4kuKPIATW5kPFO2Hf8G6EKzLuSaSaiqSfaY1YhEciW4YQox1tt6ZnKgcwLM0u5XFeUmCLyRZg+T57Q6yOaP3tI2cHqBJI29W8M0/3fsVPlKmgNtbkK0SnhIT6IHs24S5qw6FdsItA4o1fbrp/Ak9wnYNdNM138bOykVrehA/F8Xz2Bf3ftroJbrHLgTxwcBgXVb5fgwXYE4fkDg6Fvht1YDUDRYniCnWJ+uCh5PeGS1kovNyiRN4wf6Kx3j+tqMozAvQ8PXpDBlKFk0jKDQHzTYKkL5YbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19QaQlAT64m3/aRy6tuuqudMLXFPnwYo1E1Hr915uwk=;
 b=awyEy+He324xrngQ5x22MTx0rNAfKRQwH6yGcik4Zgzzl151RqIM6j8o0s96H88sTykHlOD41jpHixfoYdoUHXDiVkMzvT/i3EeoQmmdyIQd2sfhHi+0H4iU7ZZn2iQUZRUQnT1svIUOANR2PuDGtZ2h/Apuegevl3VvC2cNQcg=
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by VI0P192MB3295.EURP192.PROD.OUTLOOK.COM (2603:10a6:800:2d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 14:30:28 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 14:30:28 +0000
Date: Wed, 16 Sep 2026 16:30:25 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: fix chain-mask shift on 64-bit big-endian
Message-ID: <aqqoAVbsVu574FwT@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: MM0P280CA0015.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::20) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|VI0P192MB3295:EE_
X-MS-Office365-Filtering-Correlation-Id: a4bc7f7d-d94c-457e-5c8f-08df13ff0de4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	nyfFrBnXlBI3Zys4MTwftRVYGD9yD+Uciti8euRuTfS/8QG2Y9TjaOXkrzSTGppYpiu48H0I10LR5R6uYg12N2J+7Ej1ck4NRXOxM5mYBTmrr0aqtB9oOERq2ahe5NVsTsIMnmXSCFd34DcRbWS+dkAE7H+cQL6A/se7KwcnAN4+swa3uaITckibPve1SFFJEKX4DKlyEZac7Im8q2/XB6LSqpM/Q3tLeHgokuMSfRL2DWzlMBy2LXCEHtkEBxr8xFi/xHk7bo/8sv6B06TN+8x/YlvI2zmeauMu5oOio8sO041VHqrmnz1N0tph9NikM/j/8UJa7ABS9WhXYezkaXluWvL9taJGhJyBV1jgbXV57e5x5DiDxLeTGvdSu1s3FzMwEVWVptp342G6/8nZueaOKWwnrTInKFLAKd4ZhrK3GOcz/13e+87NAvlgGhVun3URRqBldXjCQkiF4H7aseEbo40f4kghgA3tnqk8mZjF7ao8F1q+5OFF1d3wB7AW6eJWHjKXi9lEkmbJjbSDxWMMieya/P4pIMut9IrK59t/K31iiNriuAQ55Xa28NQBfQLcDwbyJvRv1KrlgRzTa4NWHnVEkq/XDQhx97UJqSdhqNfPP9qC1W2//nTCV3vjrKej9yETgW39ctQ9Yhzl/K8J7MC7NueiVDNiLVBJJTA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6s/mfYUMnJb07DmH2pAcy5TiWAvZfFaqgZzWYyOcDpQ2Q9hoIo0uNsoHV0Ii?=
 =?us-ascii?Q?pfcGb63d6jRD0F/Zl6Ldd6LL5MCZ2FlI8Ya493PChjmW+EzDmZYg/9fkxbaX?=
 =?us-ascii?Q?hLufBQirmxnr74SEVqpTX7cgQLBh+/wsomzi4BcJkuPUKwMZv+JaL41/yf/8?=
 =?us-ascii?Q?Y7WCRHKyOKatShWcZEVUYh+bga+CghXIls1VeGRNsiyJvHRdOBLCi8qAHZjG?=
 =?us-ascii?Q?705Qf+CMwcsoMy+T4inFZA7mmrKcR1lHNnPOLH9cw6jC6RY99pPX54rQjCFV?=
 =?us-ascii?Q?/sIq6JLs0G8wLECxeqptT6Jq90pEEBvDXofImnUkimjJfaacm/SJeOrip7ZB?=
 =?us-ascii?Q?8fkBJv6FhuAdUcRgtj+fYOub5U3oHlXWPcoT4Ha6040rFiYgyTJz88zIM9cp?=
 =?us-ascii?Q?eioo+2fv8gu7Ya4tc3IN3//Q6+CHYvj1Ddv/Y5siH+FL3BUnTzRDjrm0lY9L?=
 =?us-ascii?Q?U2Rt4yFMMjAJjMhiV++Y/dcQSSGH8Opy5RtWYx+h81yfyMZERGVc0q429oci?=
 =?us-ascii?Q?Jj/as7/bxd5/Cqm/CFpoG+1ZaC4zRx5Y4K9yZi5UfqqObVVHYxZQT2Slob1w?=
 =?us-ascii?Q?cnK8/0g93Qk3m4RDRcNKrkgRp3pI0GAkLAjfQxW4UvQdaEth2nkNDEpSc8Zi?=
 =?us-ascii?Q?tBQExJMkb+89xwOFJyKT4niRYiCPqpZ0uDL/zzYFnHIapKgxJQIGwW5RUrGR?=
 =?us-ascii?Q?FcBKxqg4uj7NJCRas/JaZcAqV/1xK/4Zc3xjA223orvE9m6JSVS4RvJMe0dJ?=
 =?us-ascii?Q?U7/DQOkw66eRiJVA6TcEZkxnkv5bPw9vKD12FfdfhZHIACTlG628O9/xTmsU?=
 =?us-ascii?Q?zmtCsk3ftFCImrdAcobQkBcLBw4f3GZJOPxLihEBLaNBzRkl3qG+sdXP+zI1?=
 =?us-ascii?Q?CBbVLm/FBOzMvlQEWt91Z7UNncthmhcUYGUGF6nkWl7zLA11wiXLyPzrILl7?=
 =?us-ascii?Q?DQvci90OEbZxJO7lZCq2U83txHL9oiXC4qYN4oIcl1yo4Aj0Lh1yThOWV2cs?=
 =?us-ascii?Q?/oTSL67FUA1igtl7AG+E4iCMgCRXUrn3oFnrpc+qYwkfBh/jbfbtQMtyR7C4?=
 =?us-ascii?Q?YSE9WOf7FEAP7JSxDBA9tAiKu19dB9GJ6tLejQd0FePTJ7n0VFpEdA8hjFx2?=
 =?us-ascii?Q?Gzyu4WjR1+1ojbdbKSQM+5uPKfk/7Rbe/uY+MRq6hJNXn0brzKQXrJiQ1Zwf?=
 =?us-ascii?Q?uT1l05FRjj6tI2onjNUxvZCvl9ddhWOg+OxoIAcx53Lp9+3Vpk105+fiXYbH?=
 =?us-ascii?Q?sDCNhz44OOSRFkwhhP973s5XsSkajj6hBHnsi5+RqdVlbF+FQ0Sd8ji+5cbE?=
 =?us-ascii?Q?/3UmllzVb3FDaUWucBhqfDMtdQ4pwHnfFn3pKUJkEdf5z9ds/qj/QplT69/W?=
 =?us-ascii?Q?qQ+7DDO/pyQUMCFbcFi5iyTE/ZVOykfvXskZXnvLqhW3iupCSM8umAmeWnzP?=
 =?us-ascii?Q?QXxz9mEiY4P0obMpeZH9gWF4kwReRppTqRe9oZLUdDo4kEek9YptEKEjqGyY?=
 =?us-ascii?Q?hoZdogT+rf+4wVSsqrxwCGQ5q85tbh3ccaNEaPjAONA2s0OkW2l3CoQWWJdt?=
 =?us-ascii?Q?kNf1c62vLnVmqUioEUQNCaKfr8+kqDY4KoGHG367fD3y9GhTzM0labA/ZzfD?=
 =?us-ascii?Q?K807wy8haNZIe0ElfR+o3H5Dc/lw/+GuJMQIrEnT3NZK/u7nHHJ6mRjpY7cS?=
 =?us-ascii?Q?vjjcSHdCLZULbx2S1WXC6j6OEnvCGMK6/6nT0j0R4lwDO4V7MAORYSrRoPCU?=
 =?us-ascii?Q?SyYhQGrDoA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	w+pfMsZUVHi/MS2ztiNRDInhpwxGYsrgfOGUkQNGB0mENPR6GIXs4t5DqLBJ1KZNFvjDMQeMNvSYOtRucviNfklMfRykFC+SDIj2NI4O8BxLa3+S5F/4EtgyklklNN6lZrjQTfTd62vYiPJixexcYFkJne0SaEWj1xIlA7aY08pVBJa6ZkKeu0vej+X1gvUlEobkK3P0fHQu6Ng2fN1D+d2w5dXsKAAPFNCZLV4QjkdPtKBhFBVmrCbxW0GO9FNYAS+b30b0v94DJGcXtmX8YCFHpRpKGf2F5nyyquy+4QtX7lv2rdtmKbBBvLungCsWvyUvlAGLeStJ67mIRLwNVQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6po9R2fnNlmz7HNdUchKLo6SvjaEjf0sJVkiJOZUANQjPhLTmvufpR7CudmC9EphZpKdFjd8d0BZR1ZZQ8CrFnKtQRXDQkgmmdYMvwbkyFt7IpdcIGMHTR2vMHVXPKEM7nefTAZc62yGy52+L+ig+NHcb8zF3LofnA6hEqwr3Fr4XiTScYZm30NUB/1pqCF3ByIufFu4CHbGihzn85x8L0kMUadMpnM27t4fGzMtzzqt0UymS5yRL7Eixb8ShjwBhxsrLV7Rsad2aeS/0V+2zTd1WHv1c5Z/x8Y6bc0KLjhOxq8e1YHP7zwkC69dgkmJDvkoySW99ao6kUQFfrvcg6oJoazXnt+OEEOyq10DoUH/nr+dep7+91ZMfPitCHwEpT2eGBjF5gHhhaGWCzjoeZC0tn2oKoTw8GbvZJR8IYhbNDzzVziiGnuF3HDkCitg+NwYgbqcsmr9oBa3Zrm0EY69gw8P7KMN6tYM0v396gpkhXVV+DrKaAULEUsxTcb5hQFEeW5mdsrrFFcIiCpamv6q4rFipbxnnrY0nYT2CEdmR8QkFiDtMWq58CeAfDjiYMdNcpIuFL97HfOGj0rCeNZjpsH0OjAdPQ1AuiNY9Zvo6pYvaylgGb45E/qOkDSu
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4bc7f7d-d94c-457e-5c8f-08df13ff0de4
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 14:30:28.1381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVGRG9HvvgLN4MWaiyyuI+RFm2xbcVuamwAGbKK0S7gRWZh4jV7xj9tZZAJasPgnFsLuz2DSIer98fNc/opBhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0P192MB3295
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
X-OrganizationHeadersPreserved: VI0P192MB3295.EURP192.PROD.OUTLOOK.COM
X-Proofpoint-ORIG-GUID: jU1EayGoA56AcvenET8D7VJadVvjsO9l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDE5NSBTYWx0ZWRfXyREVx848umJQ
 b//oHHMV5Qer6wnjZnKHghFL0E6S7lTlik0QlkuXLpkPk1GrjPOmGprdJQ+d1xKCdOuvYCf1ofg
 eRhstQXkNLEpNLBZGyeaJyFkqiw32KrZG1EM63f3oFryqK+/htL5ZWR5+3rWiSttP7hbkxqpFXw
 lyP+N7ThkXYkap+rLZty1Obh+m/sL68fhXJdQOVimGrUIBv/rpJMAOF8IKtEfhWUBgCrhYr0+fc
 t5panqKBu7E2XJGGbdzweVixeS/upAUCKuIcL4cCI6irfTMFQeum+Qe4Fyx1el4G1iYe3mgf+pP
 Ux07ah5EpFZaKYSTXDVSOewSJFxauhb7gT5HXZxaSlqcuxUEhqGKWoCW6Tc/V/XS1QpNcfvAyRL
 jz0qnbjK2FhCEmRcT2NZKPYqDEH1bZB1sgeq4CRN75P/cXJ5u21TR5qlbS4EgGlQ4XZLdbdMdus
 y3GvdqI4nGLP8Sjb6bg==
X-Authority-Analysis: v=2.4 cv=cpwOAF4i c=1 sm=1 tr=0 ts=6aaaa809 cx=c_pps
 a=mQV8N3j4UtCLVZXNy2nUkg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=8ys4xmT3Mru1TjC2zVq1:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=nK00Qy85uTKI54N9hnMA:9 a=CjuIK1q_8ugA:10
 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDE5NSBTYWx0ZWRfX4aoIO2FewK8B
 KDbSYcS28Txa2GRVcuDkTSeRhqZI5EjTlupZMiH/T7RYX9074+u+w/GXfzNEisMNsu0NT/syDN8
 Tj05416SNPL0a2trkSJeuNQhkcF3kew=
X-Proofpoint-GUID: jU1EayGoA56AcvenET8D7VJadVvjsO9l

ath12k_pull_mac_phy_cap_svc_ready_ext() derives the tx/rx chain-mask shift
with find_first_bit((unsigned long *)&pdev_cap->rx_chain_mask, 32).

pdev_cap->{tx,rx}_chain_mask are u32, but find_first_bit() treats the
pointer as an array of unsigned long. On 64-bit big-endian, unsigned long
is 8 bytes, so the u32 value ends up in the high 32 bits of the word while
find_first_bit(..., 32) only scans the low 32 bits, i.e. the adjacent
struct member. rx_chain_mask_shift is therefore computed as 32,
ath12k_mac_setup_ht_vht_cap() evaluates cfg_rx_chainmask >> 32 == 0, and
the driver advertises a VHT RX-MCS map with all streams "not supported".
mac80211 then rejects the VHT capability ("Ignoring VHT IE ... due to
invalid rx_mcs_map"), so the link only comes up as HT40 and never
negotiates 80/160 MHz. tx_chain_mask_shift happens to scan a zero word and
stays 0, so only the RX side is affected.

Use __ffs() on the mask value instead of pointing find_first_bit() at the
u32's storage. __ffs() takes its argument by value, so the shift is
computed correctly regardless of word size or endianness. The chain masks
are always non-zero here, so __ffs() is well defined.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -563,10 +563,8 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 	 * for tx/rx chainmask which will be used to advertise supported ht/vht rates to
 	 * mac80211.
 	 */
-	pdev_cap->tx_chain_mask_shift =
-			find_first_bit((unsigned long *)&pdev_cap->tx_chain_mask, 32);
-	pdev_cap->rx_chain_mask_shift =
-			find_first_bit((unsigned long *)&pdev_cap->rx_chain_mask, 32);
+	pdev_cap->tx_chain_mask_shift = __ffs(pdev_cap->tx_chain_mask);
+	pdev_cap->rx_chain_mask_shift = __ffs(pdev_cap->rx_chain_mask);
 
 	if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
 		cap_band = &pdev_cap->band[NL80211_BAND_2GHZ];
