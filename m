Received: from GVZP280CU018.outbound.protection.outlook.com (mail-swedencentralazolkn19012066.outbound.protection.outlook.com [52.103.35.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C1C44C502
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 11:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.35.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786016017; cv=fail; b=FawQjyNzw6GN9UQ4xkNGR+Y9MPse8qQRAQqY3Xd3pPuffo6kADgWZJNgV2XguNtODIkPHVYMxdl6zTZqABypfzMPPoNdffbh4aA/O62gAIC9T9QjZrmxgcGwvSOyebm8bhRfL5NcPYa7m6Iu9prUDg+gbXnqXnKY/W1LE8lHgkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786016017; c=relaxed/simple;
	bh=C4rkRhyjgB+WhF8/rnGK9vg1YTlPrhrEeRlcXtFopUo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vx+M5zhTUeXWh7yafAJepHiy0mpRiY/UqqduglgWj3vbHWTQICTTv9w6aNhk8WlBxzLM5WsiZ4IbXoLo3rDzvexl9X/NG6K6BEaFwfvxKOF3mwNAyx6XFF3oT0VUM4OTK4N1E+X1Fy75LOlLDPbtlsoKrpHBlH9QFAd7OjhGYBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=S3dLSN+f; arc=fail smtp.client-ip=52.103.35.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="S3dLSN+f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boTBJc4WlYX4Fc6NxPqH+XxSnfXtFAQlV4B3yw8aejUwh69YfmMlNyG7n/BUnG3+DZqK/cqSPymbt7ZtzIWo5rey4/uT0K5EKxPcQ/t7wL/mkoPqpYwSJ+RTgFAminnJ095ACE9ENlPypS+TJtVHiuV+ieOEUBI1wx96WxLGVrb4xeF7U2JFYzrsDCxfH6mf79ReDJUo/lIYvKkT/zRbTntiubGq1daxMcg/1BZY99v8suYNdUNEjC3TSdkdQxHMR+Hj1CAjM8u8iD8fNx8kHA+E1/1SX8CSoulf3ubKIjXIlzzVDQRvu7SWhdD5btMQqPVlKRX/KA+2yq2/SRiueQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AdojZHDmMd3uj+FmunouK/levQ8CA45KQv5vK9vMLI=;
 b=tDF2ckmVQtJTghLXEFpunJ0U/RQmvt0N/qg5ZkqjHulNeUzGs58cZOj+1Ey/5pWWTYx6/JERoS3w6ed7k61eaKt64aSe2f3n2Fuq+HgK2AHhrKRbzTBPhbFDiVKIgn4R49j0LshJiqmRh8LJRzzXR5Y+w786GgM2YnI5tzelC1PsIGq0kfGGENfrx2bn8zaxACc9m1V6ONN/z758VFTKMBpTlH2NzSspRRinNOuF8u+MIBsAx7172prSqvJEfufu9/HeC/BISNMqIbf5mQ4OvZtWelhhVGerOvvw8kBXx/KeJsgHLt7YatQw6ErkbDy12CnhV+Gw3qv3MPOuB5PLeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AdojZHDmMd3uj+FmunouK/levQ8CA45KQv5vK9vMLI=;
 b=S3dLSN+fSIrCf/aU3umwD4wo+4nBl3sy5eypJ8QmGuw429QIXKaF2iTb6KFYgotV3A3Du7KbhvgDgEh6L1nWmYE5eV2BeoVS67mDc7k2UuWkcLF6FXriKXBlXJUfyjHZ56Tu63v0CtBkCM8Yfd9QqO6Ytsm4Kj5YwyXhZPZOBpVB9zBjsXUDFuDEJMhTp3X9RL34KvL+rBiKizV0Eflx7iCmV6nTMKOmSPgQQ5m3y0StNGFtE7/T/2pJ7aVWFf+kubgD1ol1tkrfkJ2NBplWLxv0n2bvTfLxJn1lTZfZHCDsqQOSNlrIvLTMWdSOwot6aYsHScw/p+2+SHG3fBVHBQ==
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:eb::13)
 by GV5P280MB2187.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Thu, 6 Aug
 2026 11:33:32 +0000
Received: from GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a]) by GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
 ([fe80::fd2d:3517:f39d:926a%3]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 11:33:32 +0000
From: Stephen C Goodman <Stephen.C.Goodman2@outlook.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211@lists.linux.dev" <brcm80211@lists.linux.dev>,
	"arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
	"brcm80211-dev-list.pdl@broadcom.com" <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: brcmfmac: multi-BSS fails with arbitrary per-BSS MAC addresses
Thread-Topic: brcmfmac: multi-BSS fails with arbitrary per-BSS MAC addresses
Thread-Index: AQHdI21MToUzxZi3FUai5UCQnAbZJLaQ5zV1
Date: Thu, 6 Aug 2026 11:33:32 +0000
Message-ID:
 <GVYP280MB10568E8371572689D15B728C9DD22@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
References:
 <GVYP280MB1056B22F060395735F23C20C9DD52@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
In-Reply-To:
 <GVYP280MB1056B22F060395735F23C20C9DD52@GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVYP280MB1056:EE_|GV5P280MB2187:EE_
x-ms-office365-filtering-correlation-id: b54656c4-5408-4aa6-d8ba-08def3ae8b89
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|15080799012|6012599012|19101099003|8062599012|8060799015|19110799012|25010399006|51005399006|15030799006|41001999006|40105399003|2607281247196008|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?lCuAIEvNtEFLto+qcQ3LGzbeDjqSUSmS637OXHityA9bfCOdevhdApiQSS?=
 =?iso-8859-1?Q?hS3f61kS2swP9TSvFZ13KcuzhYAkARrCIzCFlCruDF2Bt1VhUnQ0w5avy3?=
 =?iso-8859-1?Q?ljzc6YI0C0eaMyby/QuUQOnyO7TN3fv4SOqBDZGy44OhX+CPjkZKSEwbvl?=
 =?iso-8859-1?Q?fqzaHL7sAqmcFaK7P1iRITwO6ell4dVLMDKFqUTzS9P1logYoz3yn4coTA?=
 =?iso-8859-1?Q?FHTfdvfDOyRvF15z7757cblj3ScNlozUZNIZsZrY1M8T+MT7rq4ff1lOyQ?=
 =?iso-8859-1?Q?OvV/3OnW/0hI9V1GhrNxMnaGg41ELuO2Jt0mmcR0KTOmS1at0DXV6hvTsA?=
 =?iso-8859-1?Q?4uQXawNqf8eFhbcXPTTZGEFiUfzt3v+1i5nq3MQoGCzvtDm7ESsOYCnXeQ?=
 =?iso-8859-1?Q?KvufVuH5iGEQMlCnWyo6MAdGtqeM+yzY7nOXhnNyAP2s6b1Z/2Y4LUpNr9?=
 =?iso-8859-1?Q?AkFqfTDX0fwj7ev1DodeOxKZ9H3BfArKodsesupmD7DfGVwnysA1drZsPU?=
 =?iso-8859-1?Q?lAjyHCvwG0pFm7KPmpQxPz48sz1U5/yqNwxgR4Mp7rZW544nwW3Qxpyixb?=
 =?iso-8859-1?Q?fIw9KgCZ8cfsUl3I36lKJT+CRmzhuhn5qtjgxzOa48jHpzy5mRc6nDO/6d?=
 =?iso-8859-1?Q?GbmRwAnQTUoH/pRfh5rALpEE+fAfmNJTzGwjSnl2rvACO49oJ45u04Ecwg?=
 =?iso-8859-1?Q?vyABsNqJnrXgA4OghXzhP8lcW31m39/sDv57W1M2hkOkh8XNpUYaswFOvF?=
 =?iso-8859-1?Q?x9UAdXAxyi1VOtQFHfetdu1dVMgFjX9DJstEClJLYVn088KWviXZvNvx72?=
 =?iso-8859-1?Q?hR6H/rpnuVZuAKBSPuuy+9anLYnUqz60I1xUZQKaiS9/5aeboB8vXMpK57?=
 =?iso-8859-1?Q?TjSEduQYuikiHtcoHw61zBv5wa9emD8fsC5/N4MhfLfMNbZxPuayaC4EwB?=
 =?iso-8859-1?Q?TdjqB/b4V2Weih0iO1ONhhxUTOcYcKZH7DK123TpYCnW/K8h09WTYISqO9?=
 =?iso-8859-1?Q?ziT7tGLn0KSbaEROqcdZaalCVinlPUHRE8zc3oCaLH6/51tLPP363aFKrE?=
 =?iso-8859-1?Q?oOZdt26cvNSIdvDKXrCJqYY=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?EOGdtPkKLYvjUc2auPlZxy6astCYu9SW8IO7QNP1Ku2ALyNuTrmN4q9tPq?=
 =?iso-8859-1?Q?TWEHIfiuzqrqkcvcN2tywz8SFb+hcHCEYp9gMcO5q2EFH3Fgn0QrTv/mEd?=
 =?iso-8859-1?Q?9gzCjHuegErRXPNuMyWG+lSgGVPn1U8TcmBxxdpw8NIvX7ey3znxyqA3nF?=
 =?iso-8859-1?Q?BCNtdyvLbj7y2gsdOOGQcRV8luvssm/e8HCbam9VoOFFPB5ymK3VrL37mO?=
 =?iso-8859-1?Q?GYfA5DBn3BXqtM35yH45xl7rrbXdKHd4kINtk/rjlsC4TTk5Y2NWLBqjYu?=
 =?iso-8859-1?Q?vDDRRjmpAsdw7Z5NhbzVifg5/kJoXBeeN/FxlTRI8+VAoQM6EJjinMC/6M?=
 =?iso-8859-1?Q?NhEZpDaxTms7I3kwbJ0d/d4QFnwzpxHYh2aSrTm4PsW1vH2tYxO5n62AVD?=
 =?iso-8859-1?Q?fqdd4rzoDVcrSHLpGn5cqTC4i6tiliM+WYFgL37FSE8iHvUm4sM8RCWAKK?=
 =?iso-8859-1?Q?CiF/NobmDWff4wwmQwJJeVH8MfywhZUuyO1nx66lgVwWbwvVEMQ52njQGW?=
 =?iso-8859-1?Q?G5j4BHM6Ooe6sFGQkJQmZqimyZEN5v/9Wd3DoMtLIoEJzRCC/WFW9CcwGM?=
 =?iso-8859-1?Q?9gGePHij44al1kcHBW8c3SV++5NFBmMxeApBNXzNtzD9zWBpbNytPYaFBV?=
 =?iso-8859-1?Q?SN6p8MCL3AKINulfqzY8Y0HZZ9jLFYv/Mkl+c/myOCQpY32bZ1XrAbMjIR?=
 =?iso-8859-1?Q?S4qc2VReoVmXXWXeakuguwZGkRKgxS9nt8jxtNCw5jiPTrhlrzZja6t9Im?=
 =?iso-8859-1?Q?IpstaX6UBgXeu34aGn+fQiBF8R8e1Lvu1boAJ6GIJaeMSqc6WZ1Kvpcsm1?=
 =?iso-8859-1?Q?l4Sd5Ufozn17BoEhs/5fmuopc0tdKzNHlL6PULT0M1qhOr5Yayi5tbuZ8S?=
 =?iso-8859-1?Q?OzOTKobdBZtSR2r28N+tuiMCxK0yytp7PKcyW7SOYZHTJW/ckekLvWZluc?=
 =?iso-8859-1?Q?F6YJ47+964ksf5zJ56TcbMGXxhTKOgW9Q40jQFXAEVx5VtNAUxe9zhQMtS?=
 =?iso-8859-1?Q?weGXViBMvjhS7Pi+UriGOJ2t7MRfl+/8zZLxTB5pdcT/1H34fId5wkxLSQ?=
 =?iso-8859-1?Q?masa4Pv31PDRrquqAcvgYvf9OISU0roxXbefoiqIjrDFQ5mouaewJfsofz?=
 =?iso-8859-1?Q?Otx72KgLf5p238xvEsOos8lsz1Lj81hfg03hUB2j2tyJm9+Mpzlg7PY4tp?=
 =?iso-8859-1?Q?hlrmdyccJ+tmv1Js0IpNCUeaA1kUqYSBlBcc65V8KhevusjzNoXIR/Yy2Z?=
 =?iso-8859-1?Q?HWDGBoFESG+NOwbXnj7gAs3LI5X7RtGaH2HFSDtHNZAqULHTbMSsFcQBTh?=
 =?iso-8859-1?Q?/Rhmliic9P+dQfP1/IegMwe+8gxDn+1wnNvWT4dlceZIn1xCb2uSx3VEeI?=
 =?iso-8859-1?Q?Y4tEc8TpbdVoq1NKDQmWxN2T5cRKWKkhUfQ26n16Kp1OBkuAL4LyMasjTT?=
 =?iso-8859-1?Q?eqgI9mCLR7p4wTc+UkiD6U18Elz5VahQN5yL2Q=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVYP280MB1056.SWEP280.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b54656c4-5408-4aa6-d8ba-08def3ae8b89
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2026 11:33:32.3547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV5P280MB2187

Hi,=0A=
=0A=
I have obtained additional reproducible results concerning brcmfmac=0A=
MAC-address handling with multiple AP interfaces.=0A=
=0A=
=0A=
## Summary=0A=
=0A=
Runtime MAC reassignment using "ip link" succeeds only on phy1-ap0,=0A=
which appears to be the primary firmware BSS.=0A=
=0A=
The identical operation fails on every secondary AP interface:=0A=
phy1-ap1, phy1-ap2, and phy1-ap3.=0A=
=0A=
The failure is not caused by unrelated randomized addresses or by an=0A=
invalid address pattern. I tested four valid locally administered=0A=
unicast addresses which:=0A=
=0A=
* have the same first five octets;=0A=
* differ only in the final octet; and=0A=
* follow the same sequential pattern with which the four APs can=0A=
  otherwise operate concurrently.=0A=
=0A=
## Test=0A=
=0A=
The requested address set was:=0A=
=0A=
phy1-ap0  aa:bb:cc:dd:ee:01=0A=
phy1-ap1  aa:bb:cc:dd:ee:02=0A=
phy1-ap2  aa:bb:cc:dd:ee:03=0A=
phy1-ap3  aa:bb:cc:dd:ee:04=0A=
=0A=
The first octet, 0xaa, identifies a valid locally administered unicast=0A=
address.=0A=
=0A=
I performed the following operations:=0A=
=0A=
ip link set dev phy1-ap0 down=0A=
ip link set dev phy1-ap0 address aa:bb:cc:dd:ee:01=0A=
ip link set dev phy1-ap0 up=0A=
=0A=
ip link set dev phy1-ap1 down=0A=
ip link set dev phy1-ap1 address aa:bb:cc:dd:ee:02=0A=
ip link set dev phy1-ap1 up=0A=
=0A=
ip link set dev phy1-ap2 down=0A=
ip link set dev phy1-ap2 address aa:bb:cc:dd:ee:03=0A=
ip link set dev phy1-ap2 up=0A=
=0A=
ip link set dev phy1-ap3 down=0A=
ip link set dev phy1-ap3 address aa:bb:cc:dd:ee:04=0A=
ip link set dev phy1-ap3 up=0A=
=0A=
The phy1-ap0 address operation succeeds.=0A=
=0A=
The address operation on each secondary AP fails with:=0A=
=0A=
ip: SIOCSIFHWADDR: No error information=0A=
=0A=
The interfaces were explicitly brought back up after each failed=0A=
address operation.=0A=
=0A=
## Kernel log=0A=
=0A=
The corresponding kernel error is:=0A=
=0A=
ieee80211 phy1: brcmf_c_set_cur_etheraddr:=0A=
Setting cur_etheraddr failed, -52=0A=
=0A=
Example log excerpt:=0A=
=0A=
brcmfmac 0001:01:00.0 phy1-ap2: left promiscuous mode=0A=
br-lan: port 8(phy1-ap2) entered disabled state=0A=
ieee80211 phy1: brcmf_c_set_cur_etheraddr:=0A=
Setting cur_etheraddr failed, -52=0A=
br-lan: port 8(phy1-ap2) entered blocking state=0A=
br-lan: port 8(phy1-ap2) entered disabled state=0A=
brcmfmac 0001:01:00.0 phy1-ap2: entered allmulticast mode=0A=
brcmfmac 0001:01:00.0 phy1-ap2: entered promiscuous mode=0A=
=0A=
brcmfmac 0001:01:00.0 phy1-ap3: left allmulticast mode=0A=
brcmfmac 0001:01:00.0 phy1-ap3: left promiscuous mode=0A=
br-lan: port 9(phy1-ap3) entered disabled state=0A=
ieee80211 phy1: brcmf_c_set_cur_etheraddr:=0A=
Setting cur_etheraddr failed, -52=0A=
brcmfmac 0001:01:00.0 phy1-ap3: entered allmulticast mode=0A=
brcmfmac 0001:01:00.0 phy1-ap3: entered promiscuous mode=0A=
br-lan: port 9(phy1-ap3) entered forwarding state=0A=
=0A=
phy1-ap1 produces the same brcmf_c_set_cur_etheraddr failure; its line=0A=
was immediately above the displayed tail of the log.=0A=
=0A=
The bridge state transitions are expected because I explicitly brought=0A=
each interface down and up. This test did not produce the previous=0A=
brcmf_cfg80211_add_iface error or an interface-creation retry loop.=0A=
=0A=
## Interpretation=0A=
=0A=
All AP netdevices expose the same ndo_set_mac_address operation.=0A=
=0A=
brcmf_netdev_set_mac_address() calls:=0A=
=0A=
brcmf_c_set_cur_etheraddr(ifp, address)=0A=
=0A=
which sends the ordinary "cur_etheraddr" IOVAR using:=0A=
=0A=
brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", ...)=0A=
=0A=
The same operation succeeds on the primary AP but returns -52 on every=0A=
secondary AP. The failure therefore correlates with the interface being=0A=
a secondary BSSCFG, rather than with the requested address format.=0A=
=0A=
This does not by itself establish whether:=0A=
=0A=
1. the firmware does not permit changing a secondary BSSID after=0A=
   creation; or=0A=
=0A=
2. brcmfmac needs to use a BSSCFG-indexed "cur_etheraddr" operation for=0A=
   secondary AP interfaces.=0A=
=0A=
There may also be a relevant creation-path issue. In=0A=
brcmf_apsta_add_vif(), params->macaddr is supplied when requesting a=0A=
station interface, but the AP path calls brcmf_cfg80211_request_ap_if()=0A=
without passing the requested AP address.=0A=
=0A=
If a secondary AP address can only be assigned during firmware=0A=
interface/BSS creation, the current AP creation path does not appear to=0A=
provide userspace's requested address.=0A=
=0A=
## Expected behavior=0A=
=0A=
A valid MAC address supplied for an AP interface should either:=0A=
=0A=
1. be applied to the correct firmware BSSCFG; or=0A=
=0A=
2. be rejected with an explicit unsupported-operation error if the=0A=
   firmware does not permit changing that interface's address.=0A=
=0A=
The driver should not expose apparently identical runtime MAC-change=0A=
support on all AP netdevices while the operation succeeds only on the=0A=
primary AP.=0A=
=0A=
## Questions=0A=
=0A=
1. Is the ordinary "cur_etheraddr" IOVAR expected to operate on=0A=
   secondary AP interfaces?=0A=
=0A=
2. Should brcmf_netdev_set_mac_address() use=0A=
   brcmf_fil_bsscfg_data_set() for an interface whose bsscfgidx is not=0A=
   the primary BSS?=0A=
=0A=
3. If secondary AP addresses are immutable after creation, should=0A=
   brcmf_cfg80211_request_ap_if() accept and pass params->macaddr when=0A=
   creating the firmware interface?=0A=
=0A=
4. If the firmware imposes a BSSID address mask or address pool, should=0A=
   brcmfmac advertise that restriction through wiphy->addr_mask or=0A=
   reject incompatible requests before disrupting an active interface?=0A=
=0A=
=0A=
Best regards,=0A=
=0A=
