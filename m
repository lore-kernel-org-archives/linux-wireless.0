Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012012.outbound.protection.outlook.com [52.103.72.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610D631B828
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 10:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789814084; cv=fail; b=Syiz40SNVr1VXPwhyxm8H0qpfKnt8jtUaQZ9jk72l6jrjDtZBXPYdtUF8goDpDEVSuP12O0Tzhn1UVhuZsy9WtLasXEmevi7bZN4xI0nqKiVRApMKT29pk89ycgKOaFU5uHqh5InFJvU2PdWwbkJsoOKSzbeiPQ5o0zwn3/GXIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789814084; c=relaxed/simple;
	bh=zDpdanaBSVISITRDbH0uH4/+HgMqzJAAINU4CuBZNsc=;
	h=Message-ID:Date:From:Subject:To:Cc:Content-Type:MIME-Version; b=HtYHHnp16JlgQcy08TWi3qQn2rHubdZ8+SlwpgDTZvxjckRPHpBYLm/QB/BORICPm7VQy148oFcg7E9Sk66V+M956lc7xStrNfXKho9rfsPtv3j34oIy/EOaeCl5nBw+CPZ9HlusacfzlDJPfG1E1P/AxaMlYqEyFvXGCDbl1tE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=aby49/e0; arc=fail smtp.client-ip=52.103.72.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="aby49/e0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gTdm++znRl3VRhltIp+eu3S633K4wt2q1tTGNrw1wmVZUpWHQ6Y0Y9P/1XW6I+9O6bHc7lnyNhfJyxWDy7fDY6U2MGxmnpltBqdQ443KrkJVesFBduRDak9bJFcSf4QpiHOjhOfftnNIQMTb7LBKVMehouLhOjMbpqQRBVya2V9RXEmiubChTxaL4A39l35QcnCEBs5xcdMznlYIEW9jDSRmPzk7RtgUMwJMJaGl2nI7QsCIO79dVMmnMuKaPJW1s+e/T2kEDJi3jBRZsUDBLldeeXntky8n/HZFva+BWLcv5r7SSox10/LPEA4FWYsoK8+LJxFsBu2a3PcJqJJXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyVr1F9QF/9MLCHCO3e9CXhhchgYj7R2Y+g7gsmipoI=;
 b=qYvz595tDrU96MY2WBm19a25edRy+RrScnxvo235gyZAXqauZZmrGpVX+dCZyXs0nIVyMVytaIgv1rRBNgYb9rKn9XPsGsSa5C3ebUlK8WKlQXFkQNKGhKG39dBc3WJkEw1sO0l/VT6zQ3XCND/QjkYH6ZMbZW3ya5t0i/EDFoyTUCVNEgSsVQACIQcOFMK9x9+3w5lo+NjaPeoHq9nx7CnYTJzVc3lSptGOCMHD5b37UlUkwzWeHJoAgW8mr4Fz3kjtC/QR6VmLG4eEyRVXdukuDygqikHfD/M/SUI8hussyRkoLl5F4juYLi3+dLevVhnCIFk6AwHNZAfkvp5luw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyVr1F9QF/9MLCHCO3e9CXhhchgYj7R2Y+g7gsmipoI=;
 b=aby49/e0LQ+9NvwDvaEXJYiR7qljVbj+D3mBhvoipo1OiaNe1Cz8jJ0Jn7s+xfm+ra09Rfa8O6s0qTC8Dqk+p4APYHgOLJEwjr2PaaWwAGzRdtYCAUlLQykBKHUSFJhox24enOAcPuGYviT8FoLE+GqP/GQcsQaIM1UZ6/6JcWmf7qByQiTugT1QVHy2rjgb+6zI16CtDyw1GdUviPdqv5B0hCWPFa7Iiixx24wDxSd63IBD8mX8k1mtuvmOW3667hEbwVASbrnuXR+odmfGo2UcnyxGFrWX9MJYOysaK5C8OCkrQ5sHswTrXPNNk6/LJJBffB2NHii4sFNkwz4ACw==
Received: from SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:299::18)
 by SY0P300MB0657.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:285::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Sat, 19 Sep
 2026 10:34:39 +0000
Received: from SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM
 ([fe80::cce:a15c:1786:c1bb]) by SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM
 ([fe80::cce:a15c:1786:c1bb%3]) with mapi id 15.21.0406.007; Sat, 19 Sep 2026
 10:34:38 +0000
Message-ID:
 <SY8P300MB05515915C81B8D9E50D83F64DA862@SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM>
Date: Sat, 19 Sep 2026 18:34:34 +0800
User-Agent: Mozilla Thunderbird
From: jiyu <yuji1899@outlook.com>
Subject: [REGRESSION] iwlwifi AX200 (cc-a0-77): downlink capped at HE-NSS 1
 with, firmware core24.70-49 (77.8dbafb52.0), 2x2 with 77.f39cc7f9.0
To: linux-wireless@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0006.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:2::6)
 To SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:299::18)
X-Microsoft-Original-Message-ID:
 <06ccbee4-12de-47d0-96de-3d8722d680e0@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY8P300MB0551:EE_|SY0P300MB0657:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f8559a4-fb5f-4f47-b8fc-08df16399b50
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|39105399006|20031999006|23021999003|15080799012|6090799003|5072599009|4140399003|8060799015|19110799012|6140399003|40105399003|1602099012|10035399007|3430499035|2607281247196008|23121099006|3412199025|440099028|4302099013|26104999009;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTVzNlJ0T293YWNsNXIwWVFqTTczSVJ5WEJWdlNtVndxRDlsRU1ldjV1Y0xh?=
 =?utf-8?B?UVkvbmlqMjRnOU1VakVXbCtYZWFQcHZIcW5YRC82cWNWemNKQytHZXN5NG5Z?=
 =?utf-8?B?TTlrTWFLZ2JrMFlGcFltZ0NnVStqdDFpRGhLNXNOVzRQLzBKWjl5SFFQR3Qy?=
 =?utf-8?B?YTBNUkw4b2hnRWt5aEJ4WkNYMG1XWTI4VHZvRHlYaGp6emh5STN4MVhGVTNK?=
 =?utf-8?B?MTIrdzlLemJHZGQrSTlOTGQ2V3RNZVRxazgwNjVpUzdXa3Y2UEYybFEyT1k4?=
 =?utf-8?B?M0dwRk9ZTncyZmRYbVFnU2JDQzFIbEg1a1cwUjdKeGxSVkZDK0c5QVlCNUds?=
 =?utf-8?B?UTRxZjA5eG9Ea1RCTW8yMmkvamtMRmFGdU1iZDIxWVNzR25qUHJYb0ZqdTVo?=
 =?utf-8?B?dFVsSTRUd1pJTkdzRWJ2THBpYWQ2SjZKd3ZnRTZQeWpBOE5ic1M3UGRSMXQx?=
 =?utf-8?B?YW5UVEkwbUxRbitrWHIzWSs2bWlrcEhVcWRMT0RaYmtQYUFlSlNhTWw3UzRK?=
 =?utf-8?B?RzNScnhhWGdVcFhXMFBKRUhUUTg5SXMrbVF0UW9BVlNRQzdoKzFZN2ppdWVj?=
 =?utf-8?B?MWVtZzRxQmJleURrM0dFLzI5dXBTRXRiY1hGczE5aUtabEV4aDV2YmlqRFlu?=
 =?utf-8?B?dU85R1hvMlFIM2QyNTdNcDB6elgyMHZFNUIvM0RQalJiUC9aUUNiNXR0Ykdu?=
 =?utf-8?B?clN2SjEzbEh6R096d3E4QjdISTBwN1ZLaHFZSVUzUDdTRHNDZ2p3RWJKaWs1?=
 =?utf-8?B?aFRFWk1XU1Ayd3VYM1A0NVExZFZCdHRlQVNTQUtzVTBPZEV6Qm1jT1NpdTN0?=
 =?utf-8?B?RXk3SG5kVWc3akowUlJSOU5Qay9Ja1lUMzA1eXNmUXJTVEVISjd1bjdHaXo3?=
 =?utf-8?B?d0NFNm05bnRQWWZFTXJrSnlJcFg3dnBjQlZWU3NEV05LZ01teGJ1ZXhIR3FM?=
 =?utf-8?B?ejZtczcxYThpL1E3enhTeXZYNTRnRjJpcFFEa2ZLMk1yV1ZnWHRidExFVm8z?=
 =?utf-8?B?N3RqcEg1Y1Y1bkF3OWIyZVZURGlvQnZZNTdjVzM2YURTQXhZbzgzMlorUzA5?=
 =?utf-8?B?TDJ4MnhhTlZYVEtxRkJuL0dLVHdEMVhSVk5SWkhudy9iZmdQUjlUMFp1NXVB?=
 =?utf-8?B?eEpPRjgrOTBUTWV4eFRwOFZpbThxUWJ6SG9vT1VMMDhsTnZsOGVVaTNvc2J4?=
 =?utf-8?B?Ly9BVDdvQTViRTFHYTZJM1prb2hxOGxSUmRCQXdaeTVUanFlMUlwVVkrMVZ2?=
 =?utf-8?B?K0V6MmpOVTNOSzVqWXJDc1dvaXRyNkpnTGNaTCtlYjlTUEEzUEZQRFhjaFp3?=
 =?utf-8?B?VDg4bytLN3puQXFBdFdiTm15a3lMb3JjQlI1UzdUQ21BRzE2MDNJeVc5ZXkv?=
 =?utf-8?B?MjZBVWkzSHhqaFNzZzMzcisraW93cUtlZUdXZVVJZEdVM2E4YWNKUGdqOXpr?=
 =?utf-8?B?UzZDWHNRcHlFcE5NS2wyZ3dhc09TaUpVZ2pKaEVvR3VVZlBpWWZxSVgrNTE0?=
 =?utf-8?Q?U0B3prslv3MUySdLLgSTHTNl3rM?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjFlOTFCYkJWN3ByY2ZhU0trVytDVzh6RVBvWjg4d1RxV3lrd0NTOWNMY2Fs?=
 =?utf-8?B?SzBpV0l0N2tHVzBCMDF2Y2I5YXlNVFhhQis3MS9QcERtQTMwWHBIYmxCRlZN?=
 =?utf-8?B?L2U1MTNLbkhlVmtoRVRLZmFJR244M1RweGErZ2xtam4rZ2ZNeEtRYWxPeHRM?=
 =?utf-8?B?L2VRd2FYYzN2SUluRk5PUW9CdjdQYXAvN1o1ZVFPWWdwMjVxbDBiSEZxZ2dT?=
 =?utf-8?B?TldwSlN2R25hOG93TC9OTUtZK0Y0a1FkcnVmdDZqdDJlWGF1SkdHY2kyckwr?=
 =?utf-8?B?MFhYRVRvbkhKTXRSMEhWV0Y5RHJsNzJaNENxVWpMSGptUW1kZjdPMEt6a3ZZ?=
 =?utf-8?B?L3orYUdOcGRQSGNZNnZnbTZKSldYN0QzMTVMeXpRY01kY3haR1BNMXYrMGEx?=
 =?utf-8?B?dmpteDQzbUNXaitBcmwvSTVmQmZBVFh0WisyYnNHaHdSZVlyY3NBbmN0S1B2?=
 =?utf-8?B?UEtpR0VjR1FRdDliMWxBUFExVTQ2SVlmWUVMbE53OC9zeUV1VWJEeVFocXc4?=
 =?utf-8?B?RnIzRU9NYlRjOG1pU0N1NHpURytlaEVIOWdic0FpR2RSVXB1Z3pKdm02WmZS?=
 =?utf-8?B?Uyt3dnRjbzRtUG91NzBLcXcxa1Vab1dvVFBNek82M25hanAyTnI4SU1JZ2Zo?=
 =?utf-8?B?S3JkblpZbW90WllsMElDUk5xOWJCYUZNYkdzMWtrT0dMaWVyU0lCSnI3eTVK?=
 =?utf-8?B?TDk5WFU1REFXZmRKcWROOThMZDJ6REI5SENwOHBIVGQxNUJHd3NKemkyZmlk?=
 =?utf-8?B?bEVlWVhtTmpNaXpva0ZGK3FqVjFiQnlXK25VRXJrN25qYUFLU20yeDR3ZG5Q?=
 =?utf-8?B?VFdzeDlQajR4SFAyby9sV0ZjTElEM1p4blJXcmg3T09jUlRlcmgrOU0wS3g1?=
 =?utf-8?B?WWtCTEc4S0xCOVU4cmY0ZGd6b2ZMc0hBMDJFWXFTR1NyMW16Rml6Q0hlNXFS?=
 =?utf-8?B?MUNTWDhtbmR0UmJLT3pqM24veE4ycUFFSXY1eFZHdVY1ZDE3b3FTcWNOMHA5?=
 =?utf-8?B?RUovazBNaUFTOFo0WUtmenVHWHpJaDZreTQ4OVdyOWZYUCtFdXlFOU5xUGNx?=
 =?utf-8?B?UzgvYzlJblVhQ1AyZEZmczR4Q21LT0VUKzlnQVkwYmhkR1U4ZWNIM0VXU2dF?=
 =?utf-8?B?Z21ockRLWHZUQWxRUXkwdFh4UXo0VmV0RElPZE52M1IyYTJaY0lXM3h3emtO?=
 =?utf-8?B?dXNBdG9pN1VpZkZjeWFidm9KOVIvS2FKT3puNGoyQjFKTFRKM1d4ODE4VmVW?=
 =?utf-8?B?K0VGNXRhbFJHR28zZG5HSGZxOU9wWFlwNi9ocnBBZzB0TmJjRXU5T0k0SmRz?=
 =?utf-8?B?NWV6RklMaUs4NW51ZStCT1pVV3ZxQUZDdzhJZUsxR2FsS3JIdDdJUkljektD?=
 =?utf-8?B?aEdOSnhocGppUVVTZkNpRGNiTS83b1QwS3cvL1lJWlEwNXIyZnd4QnRLNEdk?=
 =?utf-8?B?OVExb00xTlF3VFlEWGF4MUtQaENlaUl0dEdRckpINnJER3ExUkhzd3hWMFZS?=
 =?utf-8?B?Vi9kdEx2MWx1YnRobnpOSnlDWWZqdy94RWVFbSt0aklWOWU4QkNtQk5PMWM1?=
 =?utf-8?B?Mm9HZUR6Mnp5dmw1eVdYaUcwYi85RHhPRnRhbks3cUdOMGlWM0ZXQ3lqZkFo?=
 =?utf-8?B?SVNPeXFNNnpRUG1oMWFXQW9YcFNPT2FHQ2h5M21BM043ZHNpQm52REl4TnRz?=
 =?utf-8?B?cC9FTEJDRnRZcnhMank4T3JMV2dBNUxISmpYdUlzVHp0OTEwZU5uWjhyNEhq?=
 =?utf-8?B?UlB0MXJ0ZzE5VFpHSDBGRW96c2c2NXNlLzQySEZXRFRxeW1JT05QeWtUcldR?=
 =?utf-8?B?SkR1SUZoaHZxYkNNVmtXc0VqUlpOVDFZNGZNTTRldzZRV0o3YjdwdjduWUlm?=
 =?utf-8?B?TjFTMTVVV3l1UWVGNXdGZ1V5UWJEeEtTZEF2QnRPbnRmN1E9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8559a4-fb5f-4f47-b8fc-08df16399b50
X-MS-Exchange-CrossTenant-AuthSource: SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 10:34:38.7799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY0P300MB0657

Hi,

(Please keep me in Cc - I am not subscribed to this list.)

Bug tracker entry with all logs and both firmware A/B runs:
https://bugzilla.kernel.org/show_bug.cgi?id=222031

Summary: an Intel Wi-Fi 6 AX200 [8086:2723] (rev 1a) receives only ONE 
spatial
stream on the downlink while transmitting TWO, but only with the newest 
cc-a0-77
firmware build. The kernel and the iwlwifi driver are unchanged between 
the working
and the failing case - only the firmware blob differs, so this is not a 
kernel code
regression; the same kernel (7.2.5-200.fc44) reaches full 2x2 with the 
previous build.

Hardware : Intel Wi-Fi 6 AX200 [8086:2723] (rev 1a), subsystem [8086:0084],
            "Detected RF HR B3, rfid=0x10a100"
AP       : TP-Link TL-7DR6560 (Wi-Fi 7 / BE6500), channel 157, 80 MHz, 
wired AP mode
Distro   : Fedora 44, kernel 7.2.5-200.fc44.x86_64

Firmware 77.8dbafb52.0 (linux-firmware commit "core24.70-49", 2026-08-20):
   rx bitrate: 600.4 MBit/s 80MHz HE-MCS 11 HE-NSS 1 HE-GI 0 HE-DCM 0  
  <- stuck
   tx bitrate: 1020.8 MBit/s 80MHz HE-MCS 11 HE-NSS 2 HE-GI 2 HE-DCM 0
   30/30 one-second samples during full downlink load showed HE-NSS 1
   downlink TCP (4 streams) 406-415 Mbit/s, downlink UDP 440 Mbit/s (41% 
loss)
   iw station dump per-antenna RSSI: signal: -47 [-47] dBm   (only one 
value)

Firmware 77.f39cc7f9.0 (core101-82 era, as shipped by Debian/Ubuntu):
   rx bitrate: 1200.9 MBit/s 80MHz HE-MCS 11 HE-NSS 2 HE-GI 0 HE-DCM 0
   tx bitrate: 1200.9 MBit/s 80MHz HE-MCS 11 HE-NSS 2 HE-GI 0 HE-DCM 0
   downlink TCP (4 streams) 827 Mbit/s, downlink UDP 742 Mbit/s
   iw station dump per-antenna RSSI: signal: -50 [-50, -52] dBm (both 
values)

The uplink runs 2 spatial streams in both cases and reaches 819 Mbit/s, 
i.e. above
the 600.4 Mbit/s 1-SS PHY ceiling - so both Tx chains and both antennas 
are fine.
The HE capability IE the client sends is byte-identical in both states, 
so this is
not a client capability negotiation issue.

Control experiment: a second machine with the *same* module (AX200, same
"Detected RF HR B3, rfid=0x10a100", byte-identical HE capability hex) on 
the same AP
negotiates 1200.9 Mbit/s HE-NSS 2 in both directions with firmware 
77.f39cc7f9.0.
Other clients on the same AP: Android phone 924 Mbit/s, iPad 715 Mbit/s.

Upstream commits touching intel/iwlwifi/iwlwifi-cc-a0-77.ucode 
(linux-firmware):

   2026-08-20  iwlwifi: update cc/Qu/QuZ firmwares for core24.70-49 release
   2026-07-02  iwlwifi: update cc/Qu/QuZ firmwares for core24.60-33 release
   2025-12-16  iwlwifi: update cc/Qu/QuZ firmwares for core101-82 release

The 8dbafb52 blob is identical in Fedora's 
iwlwifi-mvm-firmware-20260916-1, in the
iwlwifi/linux-firmware for-upstream branch and in mainline 
linux-firmware, so there is
no newer build to test yet. core24.60-33 (77.aa2dd297.0) is still 
untested - a bisect
between core24.60-33 and core24.70-49 is being prepared and will be 
posted to the bug.

Workaround in use: the older build pinned in /usr/lib/firmware/updates/, 
which restores
full 2x2 (verified over several load runs, no driver or module-parameter 
change).

See also bug 221685 ("Intel 8260 Rx cannot do VHT-NSS 2 with iwlwifi 
(while Tx can do
VHT-NSS 2 fine), speed halved to 433.3 MBit/s") - a same-shaped Rx-NSS-1 
asymmetry on a
different Intel chip.

Thanks,
JiYu

#regzbot monitor: https://bugzilla.kernel.org/show_bug.cgi?id=222031


