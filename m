Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020123.outbound.protection.outlook.com [52.101.56.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B77347BBD
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 14:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784729881; cv=fail; b=JBvK7mNuFUwe0l2ijDY9LzZgh3HUXqQqJXrFpABi9rcyHdIIsPqtyPt2qFNCYzw/rEJXTyNjOv5eGTT5wYZUvy/g14MPV0ZGxY8t9k4DpuDqwTPR4pBCAUdN+ljqIptkC867eLsxzBqrdXRFhGJy6hKThr/Dpovb/wQO3f0new8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784729881; c=relaxed/simple;
	bh=lE88mfUL3mFyb4vYAFE0Aklx2bxGx2raN6bN3Z9qPns=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=Ch6VEs7lA+i4IuqRTBdEbNkmo7XfxwyhoGGhf5aBc3v9nCwUnN20JkDw3fN/KHKUO+WuHQlcUcjAW6BTHV6VbhgUzXSuUu7RLRIA313IUluIMP05AmG1xQncRCZ9eLj85x52oUjWZtXyU66oggLHHHNhHdZM5t5/Rf12xmzucYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=locusrobotics.com; spf=pass smtp.mailfrom=locusrobotics.com; dkim=pass (1024-bit key) header.d=locusrobotics.com header.i=@locusrobotics.com header.b=H4tePkNt; arc=fail smtp.client-ip=52.101.56.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=locusrobotics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=locusrobotics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=locusrobotics.com header.i=@locusrobotics.com header.b="H4tePkNt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eiJuKWoSQTFsn1dE4MCy7W3yfYSt5fCQBftBZm6NC28YUxWdMwXVUS3SoABhaq74+jN65JWrTBmUWe9WzUWM278eBuUKd9dVp7HWHbJ6m4aaC5HUi1yZAWEkMsAoFvt9kRI3eYPl6jLd1h758oR5wj3Fk1kY/Gh74t9Kg5/xbWsb/aE6Zr4W4tDH+VsK73CurmQtesffMmHFJMtfbCPGhjEHa+lP+rG/cBd6BNSSrjbzGFdrFUuXnAfSLoSDW9/3Qn3R5eEcJ+N7UwowYiYtZWM5VsNHatgUrk77nNug+L6IrSorAp4hXHAaqAnq/r/FUAQSumsTsoknOvZlaVp2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hk+u1/myfto+NipN2hBQTG13UhLHv+p5mljgoM9oPhM=;
 b=bGB33f9Dlfwo92BEsgChXmKh5TDtKWw57HvsHzAe9XqTHrQOpdBypCtmSYMXKdGOiahz8WhqKVa+0CyQszILDEPlx6KVqR9wMOJcLg0LbpKxrhP+DeRqLnVw+tfvDMLpMLDobgVc8po52hi50EUSZShiu4muTns/W2sAHCamIhEp/xmUagQZnrjgRlIfQKJIMKlWfTimgcjY5M2UoryWj6gW0hX5DArSOUNXfUVMi2QkH36linMqce8AJ8JGufeKHH4LvYCtGTHIT9aH33VcLVmZtqECdSGGGgJxWbXyKcQU/mDDfnwnQUGAr7JjzS5jhrVMcl98ZXJHC6Jqplw9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=locusrobotics.com; dmarc=pass action=none
 header.from=locusrobotics.com; dkim=pass header.d=locusrobotics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=locusrobotics.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hk+u1/myfto+NipN2hBQTG13UhLHv+p5mljgoM9oPhM=;
 b=H4tePkNttG7mqXEQJUP1I15fK86JgnNdk327PmTk7jJiMit9PH28UaJefp04PexaQbtfeHAAGnAjC0YQjT8ArifjMhUJfOCkhwM5ZcgX+Gq1YXzFm+PT8v4eR1LsynPt9mIaD6y/2g4hgfo9fmw5KMMVTIqWthFy9Iz3cobg0XU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=locusrobotics.com;
Received: from IA3PR10MB8163.namprd10.prod.outlook.com (2603:10b6:208:515::14)
 by PH0PR10MB4503.namprd10.prod.outlook.com (2603:10b6:510:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 14:17:54 +0000
Received: from IA3PR10MB8163.namprd10.prod.outlook.com
 ([fe80::2315:3b49:a56b:7750]) by IA3PR10MB8163.namprd10.prod.outlook.com
 ([fe80::2315:3b49:a56b:7750%2]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 14:17:54 +0000
Message-ID: <6b1db9d8-b338-410a-a980-c2793912d5a6@locusrobotics.com>
Date: Wed, 22 Jul 2026 07:17:52 -0700
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "open list:MEDIATEK MT76 WIRELESS LAN DRIVER"
 <linux-wireless@vger.kernel.org>,
 "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>
From: James Prestwood <jprestwood@locusrobotics.com>
Subject: ath11k: unable to connect to 6ghz networks after cycling interface
 (IWD restart)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::23) To IA3PR10MB8163.namprd10.prod.outlook.com
 (2603:10b6:208:515::14)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA3PR10MB8163:EE_|PH0PR10MB4503:EE_
X-MS-Office365-Filtering-Correlation-Id: d52f5ead-caa4-44a2-60f9-08dee7fc0568
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|56012099006|11063799006|5023799004|10067099003|55112099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+8jCSZRiJ0eV5aaUD67QeMzWkbflmJLDdGSk6Z73dGC0/ch0qdDxln0eUpt9ZCJ8iE2zskBa0ULYa9mSjPEu+IeR/y3E8/6FPqlNq5KpTKpdWRRd8+NKl6AvcL0/aVjj0mkJcu6FhuILMIeXLGzcbnfqnhCpZTXtEZmsJC8gx0ISi7FE5IoMkApOquUM+wHZWbUa/+f+Wkmtv/1E7a5z0EyGexNc3WN+7UwAknmw3gMSDelXJT4r3wib7I7XhbVn7QNbYN5C8roSQk+lMBQxZMSAvcwd+EnT/4yz7qTSHBqgrVwEDzJIO622kP+k7UhjWUFfNrE8xKbFC+U1Y3p2cLNty9KPTcvlL7ypVBpw6ccfD08qyXpgHRiheeLNsz5XhUV7p/0w5BSKNR34poaurNx0cvDvO0crL0uV5MH15P0C7BIvGol8ksJKRVBOMgUjBiYQcK/YDejlNffL22Kms44ifxc3fNtykH9Wlsdu8wDFIQoJrk3A6RVGz2O8yS6W0Ftq6UA2D3LkK3YDaIRCmKHuTHBVCuoN78F/oRetcO/BxCAo8h7GpHyDBZuOfB67tc3N6HISOIkJzCvFctuQ0ZeJNDZUCSKbrvG3gm/X0pNdjq8yo/KIolIhlJp00N9an8CnRngE4A94BO0mB37Ep1UecD55AQIj49hMg8j2h+0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR10MB8163.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(56012099006)(11063799006)(5023799004)(10067099003)(55112099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2Q0U1MzSUU5MVJUQlZNaGVwK210R1Y3d1hsaE5oem5pVU5CaWVFZVRSU1JV?=
 =?utf-8?B?YUJsTlJ0WXU4cGY4U3p2SmNxUno3Y0ZxeHpabldwdlBYYW9Vb21ia0ovcUsz?=
 =?utf-8?B?bWg4eHJNOEZNZ0NDQzhHUm53bU4zcnFRUElRTGxSWDQvK0sxN1Q0WmdOSlI1?=
 =?utf-8?B?S1NtLzUzOGZJaGNvSXh0WnVYRE05WXRQc1d3YXEyOEh1TjJvU1p4VU5oYjBi?=
 =?utf-8?B?WFllcy9FaXNoVXpvb25TTTJiOHZ1MGRGcFV1cCtJOUxFS1g0TllNUGJOVWlx?=
 =?utf-8?B?T1BmKyswaGV5T0dTMklTSFpjRnFBWHJIVXUzaC92ZFRMaWdpdGdaU2FEM0Zw?=
 =?utf-8?B?Mzd0QnU2SENRb1JHdVp2V3hNOXFYTGVpYjB5NHdVRndIWFlISnR1Qjl1OTZW?=
 =?utf-8?B?am91ZFY4RGtxMUVJVWxSM0x4b1BaTDgzT0hjQjk1VU53Q0ttdkRlK3NMU3Qr?=
 =?utf-8?B?RE1VRnNXN0lKQkNyY0ZHUkNSZ3ZVa2tINzNMMlUybURUczRvTUZ6L2ZqSFdj?=
 =?utf-8?B?SkJGNE0yRkVaREtlMUNQWElXM2czdlNVYTgvVEJTdFR4ZFVIWXlLeGtmbktV?=
 =?utf-8?B?TFNabUtSWndGa09xR2x5SUxIeDZJVXJoalFoVkh2R3phTjBaaDlaZzVKcENq?=
 =?utf-8?B?Q3dmMXVoRzNZa0VQdGduODRORXVSZmkyM1JDWk9kbEswZHovNlJLRmg0UzQ0?=
 =?utf-8?B?eXRMV2k2YXc3THNPSzVqNjdPNFNyNHRrQ2xwK2xFMDZCTEcrMG1jdFNIUmtq?=
 =?utf-8?B?ekRsQjY4Vys5US90V1BVc1A3QXhoRitlM2kvNlNZMndlbVFNZDd5aUprNlQ3?=
 =?utf-8?B?Q1ZFeGRvZFBXT1R5NjNCYzF3cVU1UXVCV0h6cjg1LzJiQ0tLK2U5WmppR2o3?=
 =?utf-8?B?aTlmU0dUVjczbHFpTlNqSEl5dldyZWFzK05SUFNUSEdoOHRZWGJ2SXkxUEdp?=
 =?utf-8?B?NU5Ed21ISGw5aGllRWZxUlBheGtMUExrQ1lnb21rVWRwc2pCem9pTDZQSUlz?=
 =?utf-8?B?eVoyNTNaMklDQlB3WUkzbjZoQ1l6eEhVb0VBcWpuNzRQZklKQ1Yyc1lNaUlC?=
 =?utf-8?B?YjgvOXhrOVo4WHRoRVVXSUlUd1NWKzVhT1puQmxvNUNHbzZBeEh1QStnUWNG?=
 =?utf-8?B?L0p5V2QzN2djNnR3REZ3OG5lSHVoK2R4Z3h0SUVCM3Q5SGhXNG90bXpmNC8y?=
 =?utf-8?B?ZjBFWUI5ajdEbklvaFQwRmlma2VsMEwzSXRCUytjSDFSeVVDRUpSVTFWN1pQ?=
 =?utf-8?B?YllGeUQ2Rkl2NjhyUDZNOGhiMTkrOEhlNHRmTkZVVmpMUnRmdVg2VUxsZU5J?=
 =?utf-8?B?YjlmUGJpQWppTzdrbUVuY21sWjNHaFo2TzNFMkJJVHBXTEl0T25LK0Vtdzho?=
 =?utf-8?B?b1RIdFU5ZFBvRjJpUDJUUE8rdUpXZlArTlJEcGJqVzdDR1VZKzYwVm1DZWdl?=
 =?utf-8?B?QU1XZHQxekh2aUZoVGxIZlFIdXo4NFRRbm9YbnkzSGVOM21uMFU2UmpUUHhj?=
 =?utf-8?B?WHorMlY3K2txSFFiZFk3S21DaFQ3c2QzQlZuMjI0K0I1c255VmZlOGEyNlpl?=
 =?utf-8?B?aEhsSVhrTnpkeHQ2OFkrclVNMFZBbjRPNng5Q2JHQVZMK3U2dGJRdVhEeXdZ?=
 =?utf-8?B?R2N0MGdnNUdBUkZPOGZOc2cvVTFlTlo4cmJlNVdFRW1WMjJFVm1CN3VpODFU?=
 =?utf-8?B?VXA2dWhOVGxoVityc1AwVnNheVlDaFhjMG82a09nZkU0VzYzSG1VeHZmcUk0?=
 =?utf-8?B?cVZ3RGlhbXhhOWphVFpHZ1ZlYW05djBsOU1kVnhGYmJId0hqZko5VVltYlBy?=
 =?utf-8?B?T2VsREtoVnZtdkdHVnN1OW9CQWdaL0loTUxmWEticTVIZ0s1QU5iNTE4djly?=
 =?utf-8?B?eEc5ZklkUW91aElKMDJOemRHVk5aUnRnY0oxampEUFRkNTFqZ1E0R0psTzFt?=
 =?utf-8?B?QS9Nbm5PcXFVN1ZHRTVsWFVTc0R3T2Foek1XcmR6dTNsNUgwOUd5OWpOYzho?=
 =?utf-8?B?dmJwQWp0L0NwUzJrZkV4ZXVKeXpseStyeG8wZXh2MWpvdjFkcjhySEVZS1Q4?=
 =?utf-8?B?V2dSYTM4RWEvZkdMVlp0QjdxTkFLWWwyYnZJYjdHalJqMG5Nc2pkSkFkQ1lS?=
 =?utf-8?B?VVdZcTEvVkRGU0xqdWdINUdyWFl4QXUzQzZQWW1OdkxhTTFuSjYweWJvRkpN?=
 =?utf-8?B?b1VPVzRMVlJIV051T05KSkRzYm04bGt5R0VnaWdLMVdWRjNXT0NRZW5GREVN?=
 =?utf-8?B?STNBQlFPUE1SVm4wQmd3bXdqemw4OU1IWkVuOWpCdUdtUVM0Wjd5K2J6WVJk?=
 =?utf-8?B?amt2SUp2cHllTk1QU0ordjBVY0ZGNGNWWHhDUnJsOHlvRE5IOSs0T2FmL2xh?=
 =?utf-8?Q?1vt+A/VfzuhKqHT8=3D?=
X-OriginatorOrg: locusrobotics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52f5ead-caa4-44a2-60f9-08dee7fc0568
X-MS-Exchange-CrossTenant-AuthSource: IA3PR10MB8163.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 14:17:54.3311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 068f275f-67fa-4977-a33b-80fe854a9590
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6I3EBlpphMuJZQMrrLT8gRMDU/L18M9slJ3AcR9Z1TUFlYJM+qep1vCMYuu8zH2qprwbaTZh94en6ql82/1ynQv6uE1aljK3qtyRX5fJckA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4503

Hi,

Recently I've noticed an issue scanning 6GHz-only SSIDs. I am running:

Card: Qualcomm Atheros QCNFA765 (rev 01)
Driver: ath11k
Kernel: 6.8
Firmware: fw_version 0x1106196e fw_build_timestamp 2024-01-12 11:30 
fw_build_id WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.37
Running IWD

I can't reproduce this 100% of the time, but it happens quite frequently 
when I perform the following steps:

- Device is connected to a 5GHz SSID
- Switch the IWD profile to a 6GHz-only SSID
- Restart IWD

In some cases this works, but frequently IWD starts up and scans the 
entire spectrum (2.4/5/6ghz) and sees no 6GHz SSIDs. IWD continues to 
scan indefinitely and in some cases never sees a 6GHz SSID until its 
restarted. Restarting IWD does remove and create a wireless interface in 
the process. AFAICT the regulatory domain is set correctly and very 
early on when IWD scans and the kernel detects a US-FCC SSID.

This leaves the device unconnected until our external watchdog kicks in 
and restarts IWD which generally gets things working again. I've 
captured the netlink comms below and nothing looks wrong or incorrect 
about how IWD scans, the regdom, or enabled/disabled frequencies in the 
wiphy dump:

The regulatory domain is set:

 > Result: Get Reg (0x1f) len 508     Jul 22 13:32:08
     Wiphy: 0 (0x00000000)
     Regulatory Alpha2: US
     DFS Region: 1 (0x01)
     ...
             Rule 7: len 56
             Flags: len 4
                 No Outdoor
                 Auto BW
             Frequency Start: 5925 MHz
             Frequency End: 7125 MHz
             Frequency Range Max BW: 160 MHz
             Max Antenna Gain: 0 (0x00000000)
             Max EIRP: 2400 (0x00000960)
             DFS CAC Time: 0 (0x00000000)

During the wiphy dump when IWD starts up I see the frequency of my SSID 
and it is not disabled/no-IR:

 > Result: New Wiphy (0x03) len 72 [multi]            Jul 22 13:32:08
     Wiphy: 0 (0x00000000)
     Wiphy Name: phy0
     Generation: 1 (0x00000001)
     Wiphy Bands: len 40
         Band 3: len 36
             Frequencies: len 32
                 Frequency 40: len 28
*                    Frequency: 6755 (0x00001a63)*
                     Unknown: 20 len 4
                         00 00 00 00       ....
                     Indoor only: true
                     Max TX Power: 2400 (0x00000960)

IWD will then issues a trigger scan, and requests to scan on frequency 
6755 (among many others):

< Request: Trigger Scan (0x21) len 848 [ack]             Jul 22 13:32:08
     Wireless Device: 9 (0x0000000000000009)
     Information Elements: len 12
         Extended Capabilities: len 10
             Capability: bit  2: Extended channel switching
             Capability: bit 19: BSS transition
             Capability: bit 22: Multiple BSSID
             Capability: bit 32: QoS Map
             Capability: bit 62: Opmode Notification
             04 00 48 00 01 00 00 40 00 21 ..H....@.!
     Scan Frequencies: len 816
         <removed for readability>
*        69: 6755 (0x00001a63)*
         <removed for readability>

The kernel responds and includes 6755 in the response:

 > Event: Trigger Scan (0x21) len 844             Jul 22 13:32:08
     Wiphy: 0 (0x00000000)
     Interface Index: 15 (0x0000000f)
     Wireless Device: 9 (0x0000000000000009)
     Scan SSIDs: len 0
     Scan Frequencies: len 792
        <removed for readability>
*        69: 6755 (0x00001a63)*
        <removed for readability>

IWD receives a new scan result event, which also includes 6755:

 > Event: New Scan Results (0x22) len 844             Jul 22 13:32:14
     Wiphy: 0 (0x00000000)
     Interface Index: 15 (0x0000000f)
     Wireless Device: 9 (0x0000000000000009)
     Scan SSIDs: len 0
     Scan Frequencies: len 792
        <removed for readability>
*        69: 6755 (0x00001a63)*
        <removed for readability>

But in the scan results there are no 6GHz BSS's found. Plenty of 2.4 and 
5GHz though so the kernel is scanning. IWD also pulls a survey after the 
scan, which includes 6755:

 > Result: New Survey Results (0x33) len 52 [multi]             Jul 22 
13:32:14
     Interface Index: 15 (0x0000000f)
     Survey Info: len 40
*        Frequency: 6755 (0x00001a63)*
         Noise dBm: -96
         Survey Time: 30 (0x000000000000001e)
         Busy Time: 0 (0x0000000000000000)

I'm open to upgrading the kernel to debug, or trying patches. But I'm 
curious if there are any reports of this, or patches that have gone in 
since 6.8 to address scanning behavior similar to this. We have other 
devices connected to this SSID during this process so the APs are 
clearly sending beacons to maintain other connections. It feels to me 
that the kernel is not actually scanning 6GHz despite the netlink 
messaging saying it is.

Thanks,

James

