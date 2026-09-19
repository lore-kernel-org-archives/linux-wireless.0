Received: from MA0PR01CU012.outbound.protection.outlook.com (mail-southindiaazolkn19011027.outbound.protection.outlook.com [52.103.67.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C803396B68;
	Sat, 19 Sep 2026 22:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.67.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789855571; cv=fail; b=tLAiUv2B1wqEk87DbMa9yuJfcEwv7DoQv6TczI34Z5W6zzf1X89ay/zNB5IQJo9yVUr64K657br1sY3Ujm4Whfy5L7/8CqH9gOrrlvifieIg3ZtfEtcf3pVVZlPEIm6R8+ERAlFAKxbKJkfxpylZzEpr6BtbbkzHusPOypcbNlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789855571; c=relaxed/simple;
	bh=8CFT2NFy2eGDXJNt0Okx9BncRmF39PFyLnl6oXT6/7A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lVSztYVwaCujmmp/xRdSrUSj/so5HQbNlC1WhUtB6XGqouysE6fdeLqeNVaS4ydTN953t9sJmhONCHjpV/AjDOcyyKr+WD1C6l2VO7Wv+GyxqsCalXEG6c2oPTLOIn4XS6ZC3yPLumou5CNn6E3IBCGMT8yAV9l1kDHO9ZT+iPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=mDLzwjap; arc=fail smtp.client-ip=52.103.67.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="mDLzwjap"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cWfQOuTTOq+M0DtdMPSMsNsxt17OX0q91Ho0LCp1mqRWv7jI5XJSwhZYC1XgpELDu9kzg5bUJJ2a5hD3q49h8GJCP5Wstn1o/nbTvlAjn4bM8dxIK71rwW84JMPRFekVNeaQ2faE+slxMh8mh7kAnJnqY0JytrWrg4wrVv9Xm9odGc905Pkx68pvqCdhHFGkJqXU4VWNas+8z+5vSbo2nZoN7fl/vUBFOt1ViE6XZQY1wtiVGOcuXz/my3fRNSlIj5VgVmri74ENDpGq26QJD+FZLekZxjNNcwhTFdCV1nhwfVQEg/jk+4+GQT+XL2hnDVtdJh9ZJO/jsDKVbYJFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPDJBNKXPXKTGfhQCNjEmrV5Fb84WJGAiaxEvxjiOpQ=;
 b=MRk7VZeLkQHF+ui+X40a2BKtdanmfn5PIt5s1f0FjUwQjQ3Gs3MG43aYm9+ksdczYpUw9mYS1fnZRBoEbGVj+lEIP7GMhIiHpuFYeWfI0e5Ywd2znBL/CZrgvZrAxIu19/+oXGU435MdJZunrxqxGYQ+Y5DdKjV9tlnMpvPg/RUBYZFU/ENwWKzQjxfGvPWVu82qUxvJTVOunJHoZqP34Hotz3b4/8auj6QAoJ4kFkWe7WpxnmgtlqcNVHprWYaIV2ULMu3h/yNvfnz2tBKMEo3EojiYkqVpCQs7gsQs4xhOjzWX+oyYB+x52nfJS+1d+JFXgn2KPzINpY4IurfYOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPDJBNKXPXKTGfhQCNjEmrV5Fb84WJGAiaxEvxjiOpQ=;
 b=mDLzwjapFn5f0zA5AW86AJf8gM2wy+SyV7F29LMClW0lrXShpCCCLuAHnM+cWbUHYqy0muMaQ8iWrMweeny5lkIg87fDxjdpkOjSUy2UK2DZPnK51bf8FdUwBUrErDvGDDFFxHA4+vBneQ+td+tWxwtTD3YjcfvKj3EH8OYV5A5BLLaIST6qGt86qY2xuBEx8ogsZke+wO/j3Mj7Iv/pJyT2DaxDTPOnSXNWIg5T0U0ab5bjgpoFhFYhiLicuaXObjV7Hq+Q8ZlnOPGPZSsgyYE4vu0yK5U64OjxlQJnIkLpxN9XcMQFdQ3DPb2VLJWhaK+u6TAUGpTVZ/ZCBWtdkg==
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18) by PNZPR01MB4206.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.7; Sat, 19 Sep
 2026 22:06:02 +0000
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295]) by MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295%4]) with mapi id 15.21.0451.004; Sat, 19 Sep 2026
 22:06:01 +0000
Message-ID:
 <MAUPR01MB115463CF01C37B9FFBAB3A420B8862@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
Date: Sun, 20 Sep 2026 03:35:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: handle missing D3 ACK on BCM4377 T2 Macs
To: Andre Eikmeyer <dev@deq.rocks>,
 Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260918213014.1890677-1-dev@deq.rocks>
Content-Language: en-US
From: Aditya Garg <gargaditya08@live.com>
In-Reply-To: <20260918213014.1890677-1-dev@deq.rocks>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::12) To MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18)
X-Microsoft-Original-Message-ID:
 <4b0be281-0756-4ae3-bd7e-695a7e7bf7d1@live.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MAUPR01MB11546:EE_|PNZPR01MB4206:EE_
X-MS-Office365-Filtering-Correlation-Id: 7722b0e8-45c1-4ac2-d873-08df169a3109
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|21061999006|24021099003|15080799012|23021999003|5072599009|6090799003|19110799012|12121999013|8060799015|8022599003|25031999004|12091999003|3071699003|2607281247196008|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFIxTXJGa1ZPVnY2NDNBb2w1cmU0eWRKSTFQYit2WWNJZTRTVE1XTVZISVA0?=
 =?utf-8?B?VlVhcmkrYzViWlZHcWFrc1d6RzdsVUd2MDZsUmNKaVd0S0cyMDFVOW1tVlVG?=
 =?utf-8?B?OHlIanoxN3ZwSGJWZlAvTEZPQ1NDUWNrblBlNHlSbDYwYTBiR1lzZXVDVFZO?=
 =?utf-8?B?dnFpdGI3RE4vWmdNa28vbzlqYm5aQzlqWWYxZ0IzRG8yWlhOcXA3M0dRSDlp?=
 =?utf-8?B?OUZjZG1nRHdTUEV1Y1RpRk5zMk9xU1Nrc3FCMWJGbGpVOVdZQ3JjYjJJK3Z4?=
 =?utf-8?B?VHVpc3ptYWwyMlFWckt4Y2dZU0JEYjdwbjhVSUpkdTFSSy9ERzdYQXFvY1JP?=
 =?utf-8?B?QjZ0L2pwRXVEY3RVcm00Zm8xUGQ4N25ueTIwRWRPK1B0K25OZDZ3MTlZRDUr?=
 =?utf-8?B?bG5KM00vVzJaSmF0aTJIWWp6bklhV3liMG1jR1dKVWFHUmJidTFNaTdsWFZN?=
 =?utf-8?B?UURMeFBzbXp0RFZhU1hkMm1id1lub2RaL0RWREpuazUwMGVPcXE3K1ErWFVD?=
 =?utf-8?B?REkxc1ZXZ2tMQ0FyWitZQTdWTkY0bXRwVEtjdmpsc1Jsb3dxWUppelZiRzNS?=
 =?utf-8?B?UXJXeWlWcmVLWkcrcytaM2lhZHBaYlN4MXFsb213bysyN3BLUi8ySFpRQ1Ir?=
 =?utf-8?B?Rm1sb25NOEJJQXBTYmRzZ0lSUkFoMWVnZ21XdFJOU0M2R29wVnUwWkNxMUxX?=
 =?utf-8?B?bWdibWxwUWJuOUdtSi9lNnBhdW9WMVJKdFpHcGpidkppVVdoVHlpTkVzRldY?=
 =?utf-8?B?UFpVVjBjN2xFLzBieFlzZkF4KzNrS1lsUUdBNVlIUXlBVzJxdzFhY09XOXEx?=
 =?utf-8?B?ZHY4ZUFEQ1BBb2lUZHFKMWxmUk9oZzFuK0NNb05CTnpsNmY4RHh2QnZWYXoz?=
 =?utf-8?B?VDVxa0ZHM240NWc3eDNhTHljdzc4VFNsY2kxYmcxUG13U0kwZDZZTE9xVE55?=
 =?utf-8?B?UkFhV2QvNTc4dGYwQW9vQVNSNnEvVlMxZEtZSTh5OHNLQ1EybGdHcWxHZ1JC?=
 =?utf-8?B?Q0lTZkFlK0NxaHRiMHQzQ3l6TVBFcmNzUXg1NWVKWnZUc0xYMWVqU3p4UDBY?=
 =?utf-8?B?eU1xS0lPQWd5L1VDQktKREpzcm1KeVlhZk1kcklvaHZzR1B4M09QNzNOQlNW?=
 =?utf-8?B?SThwVklOc09EYk4xc29sRmQxVTlCcWxpa3lrZDJNb2hzMHBST0NiZXk4RUU1?=
 =?utf-8?B?SmkyU0plN212cWR4RzFRYUVhSk01QkRtbWowNmlTYVBJTnBBd0d3LzJuZkFw?=
 =?utf-8?B?Z0FaempNNUtFRTcxUE5kOVRPWnA3Z3d5blBiRDRWSWN4N1NyR0krUjJuakIx?=
 =?utf-8?B?bENyQ2RLNEpIQndkNkdOcERkam8rZ0JscEs1WFpmTEd0MmRKVDZEUjM3Z1hu?=
 =?utf-8?B?Q2tuWmYwa0dpbnRJdDRKZVI1b3U1K21oVmNIMFVHS21KNFRJZVFSZEN3U1Jk?=
 =?utf-8?B?czIvM2huK1J4SGVjWGFReUFteHRKbGpZbituZzJnPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHlXVm9ZOVQ1SXI4dWdNQlFJL3N1TFMwcFVVckxEWjhoUEFjT3M1M0hDbDFN?=
 =?utf-8?B?Rlh6cTl4dVR2emdZSlFnTU4xRndEV1cxOEtsVm82d1dVRXkzcG9OSXF0N0VX?=
 =?utf-8?B?MFhLaDJUNVByKzgvUkgzMWVwdUFka0JQMzJxUXNxSUxSY0ZaRWdkL0Jhcmhj?=
 =?utf-8?B?dmhWNXgyTzkweFkzZmsxbDNxZU9hT1JKU1Y0YnNiMFFKb2hIRW5nMDlYQVNY?=
 =?utf-8?B?L1EzVThLSkNaY3BtTjA0QTF3ZkdEV3J3Rmc0aDQ3Z2M1U043cmZRNmJVN2Mz?=
 =?utf-8?B?clpCR0t4MzczSnFYQmVPN09OWGthZWJPUm5pYXRnelZObVNEUkZYdHdqbUl3?=
 =?utf-8?B?ZUZvMTkvZjlhZEF2N0dqMFN5NUZxMjNEZ004K0d1SGU3YysycHEzWndhUVk4?=
 =?utf-8?B?NjdwUzNCaVpaMjBkeFppNjFsY3pvV2VjSWowN3RDUFltUExUdHRKTlFjbXBN?=
 =?utf-8?B?U0lKbnFsNDlJSkRMM1ZXZVNkZE5uSmV6bXpZS1gxc2xncGZoZjFjSnY5d0hJ?=
 =?utf-8?B?WGs2NEloMDVIZ3NjbGZidXlIY0U5TTVDVmFSOTNMa0ROZ2UxZllVUzlaMW5u?=
 =?utf-8?B?SnNzZmZaOVBPTEd4Y1FDVGlHN3NIZ1VMWHJtanhmQWRFNnZDYXhabmNVTE5F?=
 =?utf-8?B?VnpNY0U0NWFpc1NqNTlmM3gwVzZQa3daNE1RVG50MFQySW5OWjRoRlM1eXMz?=
 =?utf-8?B?blJxalJaUzNXZnprSVdzNVJoc25KbHcvY0YrVVZxdTFpdUdnYUVFbmxUM0pi?=
 =?utf-8?B?OXk0WnFSc0dadVpUTlpCdkVvdi9NZExYc1E2N011L0FIS2tFZWxwcy85eTY2?=
 =?utf-8?B?c1NuZDA2VDBOOXRTRmVOQmlNTHpRR1NoVDBmU1JYOFg5U3ZrZGY0NUZMSisz?=
 =?utf-8?B?N0ZyUHdxOGpwS2ZzejFjOFl1OWIrZWpWeW1LK2lsdkhUdWtoRDVSRm5sTlk3?=
 =?utf-8?B?NlF4QnpwSzJVMFFvNnNieE51T1FYVlFUT2pOTUJYbzBlTkllQUx0NHJCajFi?=
 =?utf-8?B?Q0tudjk0MW9kOWJ0ZnNqdXl5ZGVCa0oraVRUUmZ0U1JaUG9PSlpvMTBaUGlL?=
 =?utf-8?B?SXZWa1VDOVN5ZmdnM1dQbFJLY0IzdExHMytRYjVyZHp6bjdKNjdtWVpWR3Bn?=
 =?utf-8?B?NjhKRklsKzZGK3ZFR2RxVC9TUG8vaDFmOUNCelV1d2JHVEZqaGk3TitQVVF3?=
 =?utf-8?B?c05GVFBTdEYrMS82NmNYb3FvOWZCRUkyUjIrVTJhV1ppSTAzV05MT0c3aDd1?=
 =?utf-8?B?aU5kd3ZqMlhvVGhIU2hKZkE2cCtVY1J4bUJZNlB0Y3VxbS9vZHROSzVhWXJv?=
 =?utf-8?B?OWNLV1RyUFdDc3RtUVRDa1VwaW1YUDRnVGphalFSb2liZS9uU3paU1JFaU9v?=
 =?utf-8?B?WDNMRXpnOTVFZCsvRG9UTnBJL2ZnU3IyTGNrNkh1NUgrOGt3b0l3Sk1YWm0z?=
 =?utf-8?B?cHZla3VPZm5EY0pobkk4TEdGMi9iQVdLZjlaWEZOODFsbUZLdUprS2kwRVU1?=
 =?utf-8?B?U01FdlhsRHB0YWxVcjNBSnc0a0JkOFRDMVZFY3pPVURTaDhaNFoyYWloZWcr?=
 =?utf-8?B?Ym1yU0hDQWZ4ZnlNTll3Y0lFUnM2NjRYb0hWcXFHa05RLzNWQ3FYaWpxZ05O?=
 =?utf-8?B?N0dVSUpvQWRNOFphanRjcFByUmU3T1orRXhQVjJlWUw3dTIzaGtmdjZHMjc5?=
 =?utf-8?B?SlpqdTMyZVg3aWgrNnA0Q2VjRkZvaHJzY1kzNjlWSXFnQXFERU91eXlYdlVW?=
 =?utf-8?B?N2xGYXB4VG5YNmNnVEZhT0k0cnA3UTlKSmczVTVUekNObWZQUnJWb1hDK2VP?=
 =?utf-8?B?VEJGaWZEM0hKandzRDRRUWVNc09qNHlWdkpHMy9JOFpCM2xRU29CU3BqNnlv?=
 =?utf-8?B?dzB2OVZHZitscG9CZnBVZ3lnd2hNa21OdkpGVmw2Vk1Lc3ZJRitYcmxvdDRJ?=
 =?utf-8?Q?KzfCGeoMgjk=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-63b91.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 7722b0e8-45c1-4ac2-d873-08df169a3109
X-MS-Exchange-CrossTenant-AuthSource: MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 22:06:01.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4206



On 19/09/26 3:00 am, Andre Eikmeyer wrote:
> BCM4377 on the affected T2 Macs does not acknowledge HOST_D3_INFORM.
> The current PCIe suspend callback treats this as fatal and aborts system
> suspend.
> 
> On the affected PCI and DMI combinations, mask the mailbox interrupt,
> preserve the bus-down state, and let generic PCI/ACPI suspend proceed. On
> resume the existing recovery path tears down and probes the device again
> instead of relying on a D0 mailbox transaction.
> 
> Tested-on: MacBookAir9,1, MacBookPro15,4, MacBookPro16,3
> Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 55f4d7b..57bbac1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -9,6 +9,7 @@
>  #include <linux/pci.h>
>  #include <linux/vmalloc.h>
>  #include <linux/delay.h>
> +#include <linux/dmi.h>
>  #include <linux/interrupt.h>
>  #include <linux/bcma/bcma.h>
>  #include <linux/sched.h>
> @@ -49,6 +50,40 @@ enum brcmf_pcie_state {
>  	BRCMFMAC_PCIE_STATE_UP
>  };
>  
> +/*
> + * BCM4377 on these T2 Macs never acknowledges HOST_D3_INFORM. The platform
> + * can nevertheless enter and leave system suspend if the PCIe mailbox
> + * interrupt is masked and resume takes the existing cold-reprobe path.
> + */
> +static const struct dmi_system_id brcmf_pcie_no_d3_ack_quirk[] = {
> +	{
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MacBookAir9,1"),
> +		},
> +	},
> +	{
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MacBookPro15,4"),
> +		},
> +	},
> +	{
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,3"),
> +		},
> +	},
> +	{}
> +};
> +

The BCM4377 is Apple exclusive and present only on these three Macs. No other Mac, or PC of some other brand uses this. So the DMI check isn't needed.

