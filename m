Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazolkn19010007.outbound.protection.outlook.com [52.103.2.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6421E5B68
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.2.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772397; cv=fail; b=ZnfWJJ+gqYkDmdSgQdNHexQZJaOymJRHj4DXEfOk6x1mj1yhZyAL5ONwXwA4hOIhiSWJq4uatSuo3r4NX41ZVqoDRpefRfXNqDLXj8KNBNcFc4rVFgnYLCS85lGQA7bduvuwXxxa0073R7G2wcmgY3Rfe8IKsqGVxYlGXOoKiek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772397; c=relaxed/simple;
	bh=ibaDt4/vLPgi0HA9UZfGtoX97U4ucL3G3c+L7Wpo1l0=;
	h=References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:MIME-Version; b=LgPyLxNiwHUNj9FccQKSD6CTPFXA1C10DKpZ4NXc0gvS/PSCfuCw86B5JwbApU+ZyTwiILzOzFE8YwhpZd1+6tbqK7QtbEwt3hMJ64At0Mf4sQ2G2YhtKt4kVzEzPbUS8KiFl4ZpdguxyTLC5m8V60WbNgw1kppMtCg343TygLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=J+cpccut; arc=fail smtp.client-ip=52.103.2.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="J+cpccut"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iX8dOVY+A+4CKLG2Qfu+MZmAlsT0li4Vt+kem2XAXznXQy239LNpM4nPOLmMyVYPDDU7MyS1OmhU7yf24NkQMvDa80trH/4wdy87m/fpSjgxZCGIRFUZNKf2IMVX8qwOLdER7iLUImafcnm0y6CvLsDvGys1pi1u2eNEzqsYyCHk7WjVvovYVqzCBaXQCchm5OmfltW/sTmLYMuDabKTg25ve3cVIQnprRFnTistNB9VugbEoiUT8ooAW3lA92aNM+k87jS+xEZBiqgVUTWeONba3GWAlXeuKz+JMiFG8ZY66rhSGKr6O4sUefafZlfBW8TKtwIU/2JxKWkb/13qsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibaDt4/vLPgi0HA9UZfGtoX97U4ucL3G3c+L7Wpo1l0=;
 b=CJ8Jlzs6QDMDnMgKqa9FQNCYPi3hBq4LKLzii0+FISIfC+hsVvFiAkdthLJImoFxtkbIQBV+pgQp9busXGD3GNJap93tjzFDBNjRHktZBXISLylTyabaSMAknntIVpBAtbRprXI91aDndjDSxNuLQBIvERjQBNlT0Xmiid8yGpOX75Q+B62+gRCpW6UuT2U5BivYruPQUfOIYD8M+ratI8LDGDQ67JjO2mWn9Pg+rVA6VlM0A1xl/+RamJe+/+uXKI71F5WTsEbGFn3n+yT5qTu6FlCxiXDauSzf/EPy9As4lgJW5gZoJJ+aQd/ifuZyJ1SrEN9j3J4WVJv4R/h1mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibaDt4/vLPgi0HA9UZfGtoX97U4ucL3G3c+L7Wpo1l0=;
 b=J+cpccutV79Ucz8ysWptoIq6U0SFrD05SIRSlRL76jwLJObTjcqlRU1HMfjQdkQ8GW5viEsb9bp2PvMWpyFUo2C8EI3+vwMSLO4Eyz3U9lMxcM9gBZRPvbpsJfqbumVynGA7r5TBowPu4Rbum5NBtCDdAJ815u/L3tQGkpuURqLym2OWsA5haDrKVqHJwqUCZo0W0VJfwtnApoBih4nt7ZGHxP4qLH2Rx7eecIzVMdtDlTXfdq1V5bFJAaDIGWRP7WlytFzAO6cJU0x30i8iWO0DOmjHOyVDbb06rEVhRxPkS82AN1g4oKwGL/vOx91kia5pNH5zXtxTkO3qOHkAzA==
Received: from CH3PR15MB6020.namprd15.prod.outlook.com (2603:10b6:610:156::20)
 by CH6PR15MB174990.namprd15.prod.outlook.com (2603:10b6:610:303::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sat, 15 Aug
 2026 05:39:54 +0000
Received: from CH3PR15MB6020.namprd15.prod.outlook.com
 ([fe80::a655:4b65:19a2:85c1]) by CH3PR15MB6020.namprd15.prod.outlook.com
 ([fe80::a655:4b65:19a2:85c1%6]) with mapi id 15.21.0315.014; Sat, 15 Aug 2026
 05:39:54 +0000
X-Forwarded-Encrypted: i=1; AHgh+RqKXbA+h74AZnDrC3WA4Gd3Muj7hfj+y+37Ek9qcBormv3gHGlMk6z1ZztbzW+daL7h8t2mNilipbv7/sZG0w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhi2po3d4azV0R/+DxjmZ/ejkiGGGz83iz/MlZ2YOIRPMzA+Zy
	9JM81VHtQi+r811Yzozk2dsp2VZy1AY4XBBVf3f7IWpVagc1P8oWcjwQjVUTQyikaP/nz2Rs5tb
	uY8Z+U/DFTg/o55X8YluQFVK5kecp5mE=
X-Received: by 2002:a05:690e:43c5:b0:665:992:8a85 with SMTP id
 956f58d0204a3-66c73ee747emr3118835d50.23.1786771934646; Fri, 14 Aug 2026
 22:32:14 -0700 (PDT)
References: <20260715044431.1207-2-mbc07@live.com> <CAGsSZgFqeNpPXS8q9VYGGqE_ONVCD-V18vf0+R6tZTS2PeKv9Q@mail.gmail.com>
 <CH3PR15MB6020E8912A56105D447332BEC8C82@CH3PR15MB6020.namprd15.prod.outlook.com>
 <a7681525-b5fd-4a34-8ba5-99e79d77a694@nbd.name>
In-Reply-To: <a7681525-b5fd-4a34-8ba5-99e79d77a694@nbd.name>
From: "Mateus B. Cassiano" <mbc07@live.com>
Date: Sat, 15 Aug 2026 01:32:02 -0400
X-Gmail-Original-Message-ID: <CAGsSZgFetjvj69w6MELzMcXyMjD76SQJRey3_UW=SpvR3arSCQ@mail.gmail.com>
X-Gm-Features: AUfX_mwiRcWtFHy4UNYuF5CGkdG_gbNWdnFr8HDgGlno6xciFeW1F9QIWIkDAVw
Message-ID:
 <CH3PR15MB6020C5614F7BDE2B7DF67E23C8D92@CH3PR15MB6020.namprd15.prod.outlook.com>
Subject: Re: [PATCH] wifi: mt76: pass LED define via ccflags-y in driver submodules
To: Felix Fietkau <nbd@nbd.name>
Cc: lorenzo@kernel.org, ryder.lee@mediatek.com, shayne.chen@mediatek.com, 
	sean.wang@mediatek.com, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SA0PR11CA0075.namprd11.prod.outlook.com
 (2603:10b6:806:d2::20) To CH3PR15MB6020.namprd15.prod.outlook.com
 (2603:10b6:610:156::20)
X-Microsoft-Original-Message-ID:
 <CAGsSZgFetjvj69w6MELzMcXyMjD76SQJRey3_UW=SpvR3arSCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR15MB6020:EE_|CH6PR15MB174990:EE_
X-MS-Office365-Filtering-Correlation-Id: dedd55d9-f88d-4f9a-672f-08defa8fa1e6
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|24021099003|15080799012|8060799015|19110799012|51005399006|6090799003|5072599009|25010399006|40105399003|2607281247196008|18061999006|3412199025|440099028|19061999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGFZb3lrNEVaUEhmUDNibmVhTUZzdHlsYVRYV0dramsySUlQUU1uY2E0NDIz?=
 =?utf-8?B?bUhUQ0hIb0VMTTZSYXdTUXRYcUhjdjBTVTMwMXJtWExrVndJRllKNStKTWxO?=
 =?utf-8?B?ZVN0eE84RjVQeldZTEs2cElRUUNuUnZhSDZwVlY2UWlNeXpOcjNSK3lpRitO?=
 =?utf-8?B?V2l0VWFpVHJMNi8vZEx2Y2x6VEIySDBFOFpuejZsdXROMGx1K0U2ZkswUzlC?=
 =?utf-8?B?QXdkK2poZFVZajJydEFNT296NTFSMEpDWExmQjZVV0o3RU9PTUJIakh5ckhE?=
 =?utf-8?B?blJtNVdmSlduUFRkZFZkaEpsVnh6bzhJZ3dNRVRMeHhoY281MS84dGFJRXVO?=
 =?utf-8?B?elgyaVB6MGN5cXZjZ0RDNXFGZGtvNUZVV2U2eGI4YytrTjVPSFFjTkxMcXc5?=
 =?utf-8?B?S3NwNHNsblJDQnFWN3NFRHVpOW1aR29SSjBZWkxFWnJRWTdmOVhRVXdCTHQx?=
 =?utf-8?B?anJRc0ZMa1dmWEZrSlNQU043ZDBIckZyVEtpNUVvR2pYcCtNbnBMamx6QmZi?=
 =?utf-8?B?bEJQMmtIT0M1TENyQ3lERCtkZnpkN0xQTjBCYUx0cmdkdkc0Zm5xNjFZUTAr?=
 =?utf-8?B?dkNZZzBCZ2hXWlAwSHV4NnJ3ck5VS2NISXRoKzFNN0RWU2pWMUhGLzF0dy95?=
 =?utf-8?B?bXp5ZUJOQVdGc3ZJWHNGamNSdElrcnBqanEveWZHTnRPUFlqQkpaZ1d5ZUwx?=
 =?utf-8?B?VEhUa3BOc0FRbDNJTkc1bDdmaTA3cWJUZXAxRUFveFhUOE9Db3BsNjduUVJP?=
 =?utf-8?B?ZnVyQ3dWSlFLcCtpVzVVNGZ0dTUxZzNtQjhQU0l6YlQxbVVXWTd6Vy9HSUs5?=
 =?utf-8?B?Q3pHUHRaSmcxOGVxLytHRU82WVVpRFQ2SWFXeTdjSUdjVXh1REhCZy84UmpI?=
 =?utf-8?B?cmp1VDdkWnozVmJGSjR1UnlsVXVvZmR3MGNDTVZzQmFxQ1BkQ2hJVkxKaVJU?=
 =?utf-8?B?Y1Nma1E4NzdpYXRlc3d5T3Nib2lzc1JHVitlUHRMK01mbkdHNzcvbGVOK3Yz?=
 =?utf-8?B?TGtKUzJYNUlnL1BMQmlLRTNwOS9KdnVTbHVMOEYrdXlZLzhRbDNRcXA2L2hT?=
 =?utf-8?B?SVdrUGdwdUszbXkyM3E5VWRISlZRV2RPT1F5dTl5MW5xd3JiaWtBbllGc0g5?=
 =?utf-8?B?cEhiK0x3MnBPSlBteTNyZmpWR0wwQXprOTRGcXRTc2w3OEJLSzdkVE5wbEha?=
 =?utf-8?B?U1lYRk1Pa0gwaUdaNDVXSEI2WnYwTXpNVDFuVkk3Y1hQUG1TWk9kQ29oNnFt?=
 =?utf-8?B?ckhMNlhVUEgzZ1ZhaUJ6UjVVVTd4WUJXbnVmMHlQeWs1WFJOTkwrM3pjc2tI?=
 =?utf-8?B?a2Z4b3FHd2dJT2g4RDllc1JHT3FqdHcrajNXVVBsTkcvZHpoLzBtR0lheEhU?=
 =?utf-8?Q?ECPUpI0MapQbsU25dcy+ihyn3to9c/Vg=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFNRaUpFcHpLdWp5ZkpudUpJT0FoN3JNQ0dTbTBiVVc0YmNmbFdPR3hpOXNQ?=
 =?utf-8?B?d1g3SUE0RWVTdlc0QnRrc04yUG56UEtCVmZ0eGlNQ1BCV0dDVDlCZmMzaU8r?=
 =?utf-8?B?bGUzTERGY3J1UkoramJtWEgyUFI4MUZzSWRqZXQxd1EvalB5SEQyN3lWbk02?=
 =?utf-8?B?RVBmbjdvTTJhTk5nbXF2QVlkUElVVkd3YzJsMDZXMm02djd6cnUvV204MkJR?=
 =?utf-8?B?ZFF0Z2V2ZlhrVkhObFhTbnNReHBZMTdiQmNvQXBzSHY5R0NyYVF1VlhmQlQr?=
 =?utf-8?B?aGpoR2NWWHRuVU5vSGE4NzE4RzJ0QTZ6LzFwWjR4TmtXZmRZRGNOMVdDUHVw?=
 =?utf-8?B?QXhCMGRNQktMcGd4YkxiTUY4eVVNM09naHVKTmgxWGhmV2ordXI5eHNNZENN?=
 =?utf-8?B?V1NJTjliRHF5ZmJobWp2VS9BNW1weTRFMWdxdHp6aFp0MG5TSWM2RFV4VllB?=
 =?utf-8?B?RGFsV0poNzh2YzE2dUQ5RGRndUo0TjlKRmZmL1dmSnA3a3Z5a3JUckViNW8w?=
 =?utf-8?B?eE1SdXp2eVpJSmhkMytGZXJYQUlma240eDk4eGtjRGtMeFR5aldwUCt4cEpM?=
 =?utf-8?B?cXozSU8zREROU1ZuYU1KNXU3N2NLcEJJdHpTRGxYYjNaNXpLdHAzWTNSMmJT?=
 =?utf-8?B?VWhZaE9TK1dQcHp3OW9FU1ZXUnFteGI5bXYyK1psNm5jcGZiblhYd2dhWnZ4?=
 =?utf-8?B?d0FiRDJZN2JCQ3RmNUJUUnNjYm5KcXc2NVp6MExsa2RDYjUzWmxDUFFUeEU5?=
 =?utf-8?B?bEdWMnZaK3RQdjRzeDRTeWZpQnZoRGVNdkVueEt1S3B6VTlmbHN2YWNTbkoy?=
 =?utf-8?B?eVJQUmk5Q0FOYUhSTWViRkJUUnVyK05vYW5wN3NLMGRTVi8zNFMvdEZGSkdm?=
 =?utf-8?B?Tlc2Rmdna0swSDFoZjI1V1lkYXExbllsUHhDRms5TUg3WXdmRklMVEJSVjBZ?=
 =?utf-8?B?QVZLZ2dlQWlMb2tuNlo5Lzgza2oxMzR1TmxLbDhiS09VYkRRSVVVdVBUS3FD?=
 =?utf-8?B?TnJVMXNVZDVvRmtKd0JsQ0NyUzd0SzAzU1A0WHBaWGF1UWFsbWVhVThUSENJ?=
 =?utf-8?B?Y1ZLUDBlUFd2N3JUSmdFY3V3OWNiRUlINjgyd2xNYXRCRFFLQnFwVVo2Z1RC?=
 =?utf-8?B?QitHNlNKUzQxQi93RTFMaFBkNEtkNWJidzRsOHZuYUdwWW5FdllFd3ZsNEwz?=
 =?utf-8?B?R1M0OU9jNXN6TlY1L1pvUzlyWUJLOWVPYWpGVXJrM2tvVU5vTnM0ZFpFM0Fj?=
 =?utf-8?B?Y3pEZVBSdjFDWGpUQjhzZVN3aGFXVHNHZ3hIaWVSTzNZQVhqWmgrTy9KQUtL?=
 =?utf-8?B?d3NmcHpkb01aZTJpYnVtcTVlakFuVDJ4UzgyeGJDZENSRlJSbWNreWhRYXha?=
 =?utf-8?B?aCtjZ0x1OG52VnNDSmFXcytqNlRlUnRDTFhHSUZramlGNmV5QXR4MUpQVlhL?=
 =?utf-8?B?NDFVWDFlRlFScnNleGRjbU5Oby9qcWluaEkvWHp2ZGdxME9hYWhyMGtnc0U5?=
 =?utf-8?B?Yk1nUXgvMFJxRU5ObzdJb0RDYjVZZmI5YnBwQ00wcm5MeGM2OU9JdVRheGZz?=
 =?utf-8?B?ZU1hQkdhc21TQWo2bm90SGhOY1oxNit5OHR1VG9RSUdSWHZiUDVWd0tmSWRw?=
 =?utf-8?B?VFgvTWkvRkd5eENEU3dwbXN2Ukl1Z0hZWjBqakNXYmxzcXQ2R1g5WDBJenJX?=
 =?utf-8?B?eWFQTmg2RE5lQ1lNdWd5VTNkbzg3ZkpQeTVSZHVxVnJRWHZoR1JlcWtTNmFT?=
 =?utf-8?B?Q1hMUG5DSFlRZE9SVm9XQXkrTWZtSjhQWU5aQVplSjdkZ2Nlc3VJWVpGNlBH?=
 =?utf-8?Q?eILvNNgPTNW5D+p9bFgwZ2xKFh3mjigeVWHps=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-d4257.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: dedd55d9-f88d-4f9a-672f-08defa8fa1e6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR15MB6020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2026 05:39:54.3008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH6PR15MB174990

Hi Felix,

> I will apply this to the correct tree later.

May I ask when is later?

This has been broken for about three months now. The fix is a trivial
compile-flag change, has been tested on hardware, has had an upstream
GitHub PR (#1090) open on openwrt/mt76 for two months, and a
downstream GitHub PR (#24333) open on openwrt/openwrt for a month
already.

I have to say, at this point it feels like this isn't going anywhere.
The bottleneck clearly isn't the patch, so what exactly are we waiting
for?

Thanks,
Mateus

Em sex., 31 de jul. de 2026 =C3=A0s 04:13, Felix Fietkau <nbd@nbd.name> esc=
reveu:
>
> On 31.07.26 07:43, Mateus B. Cassiano wrote:
> > Hi,
> >
> > Gentle ping on this patch.
> >
> > The mt7615 change was tested by me, and the mt7996 hunk was also
> > independently confirmed on hardware in the follow-up above.Please don't=
 send mt76 repo patches to the linux-wireless list. This
> belongs purely in the openwrt/mt76 repository, since it is out of tree.
> I will apply this to the correct tree later.
>
> - Felix



--=20
Mateus B. Cassiano
Eng. Computa=C3=A7=C3=A3o - UFMS
