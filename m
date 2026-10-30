Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793331294;
	b=eQBIGErRShBz+Paq64XXorAki1eH2IDCVR0DicAUt2xfG44MXWvO7vd+4fTltpVtmlck
	 N1oGGyw5+9fWQPXTSVoXYD0i6tkr3fFBvKqjcS+VSJyhHxRi0FoOxKC4QT1+4dAVYL0Jh
	 aYeR6DWNaM3JwzNZRj8CoM6r6Oh88Zq3bFln0eG9Hgq5lgF1o3UcnSCMIkeOPHWkgN4U8
	 11tAHlL+Rj1fttlS0eduCaOfWgMgMbZK7F/kaFmTHyBVrI48qKXnwal6c/PpQq8Qz+VJz
	 a2hZpp9c+Ob6IhOcFmMp52gwrwpdMO0OI0Qzs/vqAN3OQI5yjz7DgRurHJtBnoF1RxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793331294;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-o365:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:
	 x-ms-exchange-antispam-messagedata-1:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ZXNd+Sd5KRBkAEgkb8mcLEoMPSDpJ3lAb5YbzIFqMmw=;
	b=eHSNGby/4WPfmQ11pcKj8Qg+rQxFukgP5Sjdi0wYr+gF545onwB+I1NbaTcc3eRnb5Ms
	 9ZyWhmbOku6/yJtJA+d+5OwFX5iSf7SgRx6WmCOf+W8vMdz2BH+t+fbuEeskphIDaCdhO
	 lSDOfA0PuvjqK0ERNikN0uLeDLerMnB2LQItc815kXbLwixPiIN0RmvoFSA6fwchTrQkI
	 duOdTN5ku4TXDSC0MbEFxKLDLYPPcN38MCYBpKrNel5rpYUXILTmV3LnlsF7DcVe4ibnl
	 0la6f8KU589l/movcqhgZHLy+MNVm6xVidu7h3rfy0u1ba77Y3CFn9vTndLrRQqi6jg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ntu.edu.sg;
	spf=pass smtp.mailfrom=ntu.edu.sg;
	dkim=pass header.d=ntu.edu.sg header.i=@ntu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=K33fOvWe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.59
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013059.outbound.protection.outlook.com [52.101.127.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CEE606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 03:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35CEE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ntu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=K33fOvWe
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BriSVoNhdUvo1TSVx2PMKnHTbs3+d6F+imhXg6hcnUW75mVVamdUHo8rElMIXMViPAzgTTcwipLAmcUME4/En4RJk0vzmz7g2rm8lnRLOBHyszZQ59W3XWiIhWvsAb/ba6PqvKbDsHCZFVZtCnOn3NAaJ6VxUFz2RrItzhZp1DqZd8Qh5XQcbRGCSqQYfy0T2IOSPncKY9k5j6fW1qGXGWQmwi4qBh68pODC/uZ/+Av+PMW8lfRqH0PKnjeoiNHoFEVFhVVCsu8fMP5/UuXCq2aJBd4Ir8wd2Fa7Uym5E+xfSsg2snEexAtu0jVPHPPt6MxosPq5IXpEu1ll+s4YlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXNd+Sd5KRBkAEgkb8mcLEoMPSDpJ3lAb5YbzIFqMmw=;
 b=Xh2gPZtC3nR0pq5C5HGbQ6F8VPk5Z120SP8kzBTOaIc9y66ZNRJg4cZUuelkbfbsPwReyd/4gUMR5unL3M+uzn6Nw3spnF6rZqd5u+gEfKeDPJbpVpmyAVVFHj5ODuukkPoxSS7j2/nDnerN9ucxEsgkEN5axJsh4FScsB+bL4EzHRnQYZQxaePctWvraEnuw2hIwLTlMPUCsIZ/sF69Eh3ptEHid5T3N84kHOK/mJP3TrMaGIbsgUBh7cjZVVnwHxWv+CnkZtVkzbBMuPA80432hJwM6CC7xcm9SFJ7Ac6UC1ooEYNVQ4vRKcmOrBLYRSUbUUFzlUCze6ZGmnGRjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ntu.edu.sg; dmarc=pass action=none header.from=ntu.edu.sg;
 dkim=pass header.d=ntu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ntu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXNd+Sd5KRBkAEgkb8mcLEoMPSDpJ3lAb5YbzIFqMmw=;
 b=K33fOvWeC2yVhpHhWWc10nWHHEfhlW0+dnRwPNKH3JaVJDF7IBIPbbuqHJawMNRRStpb1WTn5M7vQZaZtMtDmEEsJu3KjPWA2h8+HuOvVtZIlUN0q9hV3t0ibZxsGUZHMdktssjwKT/9G2m8SZ0T6fzN9hXFRcRzCXviF8c60OrCq0LlSgV+HkyFK2YnfGkUpAGIhISCcmgwU7RVFmBN/akbbgi+HOXHEZmps/undrlnA5LQ3QbtuWndeOa/KP6hE5eU7O6UaiP5L7MvWf3i6FbPPxPyvfj0yicZKtrAJvpvVD9AW0uvG79chUL+O4cweYl8ZU17qkiapF7Fhf8kZw==
Received: from SEZPR01MB7338.apcprd01.prod.exchangelabs.com
 (2603:1096:101:2a1::5) by PUZPR01MB5117.apcprd01.prod.exchangelabs.com
 (2603:1096:301:114::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 03:34:48 +0000
Received: from SEZPR01MB7338.apcprd01.prod.exchangelabs.com
 ([fe80::3e12:215:71a1:a76f]) by SEZPR01MB7338.apcprd01.prod.exchangelabs.com
 ([fe80::3e12:215:71a1:a76f%3]) with mapi id 15.21.0569.008; Fri, 30 Oct 2026
 03:34:48 +0000
From: Lang Jianjun <jianjun.lang@ntu.edu.sg>
To: "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jjohnson@kernel.org" <jjohnson@kernel.org>, "baochen.qiang@oss.qualcomm.com"
	<baochen.qiang@oss.qualcomm.com>, "gsh20040816@gmail.com"
	<gsh20040816@gmail.com>
Subject: [RFC PATCH] wifi: ath12k: keep regulatory frequency ranges per radio
Thread-Topic: [RFC PATCH] wifi: ath12k: keep regulatory frequency ranges per
 radio
Thread-Index: AQHdaBph/I9dVq56U0OAJp/j9PcqLw==
Date: Fri, 30 Oct 2026 03:34:48 +0000
Message-ID:
 <SEZPR01MB733849AC81EF5F9EB7B9B6F0A26D2@SEZPR01MB7338.apcprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ntu.edu.sg;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR01MB7338:EE_|PUZPR01MB5117:EE_
x-ms-office365-filtering-correlation-id: 3249c404-dede-4051-3dae-08df3636bfc1
x-o365: NTU-OFF365
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|786006|23010399003|376014|366016|1800799024|38070700021|11063799006|56012099006|261009223027099003|261026121527099003|261026140227099003|261026130827099003|261026135527099003|261028144727099003|261022105027099003|261022113327099003|261021135927099003|261021133027099003|261022075727099003|261021130227099003|261021121427099003|261021123027099003|10067099003|261022115727099003|18002099003|6133799003;
x-microsoft-antispam-message-info:
 3FjDIxhiRZft4BdBif6dDyjDM9Wja1wBszvOmoTmB+7BgZMaNfdR2ej1AD7hD//ZxkLfeGQrW1iBDAUkMiXrm6g/++DsdoSpDWaIjx0Iw7jf1Zg6XYezaIBLXHkd6QTUxr/JW8gatpQmYolW/RS5SWGZhFqwotFarj0Y30kNlhdUMJtVC/RvlZGvUirVXUeS9WOhbLk15TDyawZ6qiF1kRS8rF15Dkno9gP/0DkirwoPqoG1nJrWP0tavGSlkXDpXRGRw55CTcufR/+6jqILfyNnDYC5IL3uZiKuJH8TsKuorqsMVy8T6syVH652CamyCZdqM2nAOLmB4dGJObIJtVNfhwkI4J+SWDfyz6Ma9rrF9pZDCKgu2fSoOWLM70vzTgBY7O3PeDmB2zPEtKxyO4If6sVBfDifp9w1zW0DOM+btxGhOWYInBLapNe0rlgyVQMRNQw+5FME9aG4Bfo6gLH21T8Nl8Rw6XUuyw3afKNA+6aRi/W+OFmNkeNXc9sJ8NMoYcd9M8I7w1hils/2m2VhJNThmZSUzvwWPkn5MhLE0g+ENwwr6x6w9YMG1xae39z0V8SAViyAGu5a7KwxbWY4eHL+K9Pgv0Ba63HM2M76rAdPp/4zPWvbluH5WZFqvgE87LtfpK1UDFshwlEcgE2+xhxxdPuWo84ADHfIxcA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR01MB7338.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(786006)(23010399003)(376014)(366016)(1800799024)(38070700021)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261026140227099003)(261026130827099003)(261026135527099003)(261028144727099003)(261022105027099003)(261022113327099003)(261021135927099003)(261021133027099003)(261022075727099003)(261021130227099003)(261021121427099003)(261021123027099003)(10067099003)(261022115727099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?s7Q09HX+h9T5z56MYOjrsIeM4QJK3criConA/74CFQjkYADWkFVKAWCcme?=
 =?iso-8859-1?Q?AzygrNeLv7qtsgTnV9EbjuxGSYVO9O7Vc9GmWiOG2UpXYOTnsUEg+uLPgy?=
 =?iso-8859-1?Q?rbeTz77f1gLKuxypGVT8IRmn0dVklpoCbzZ3kbn2qpFGytRaRu3AIy3QWT?=
 =?iso-8859-1?Q?tsdGsaYHeDtAhRXCCarZ0/2khYfFQO/BPNkv9QGPACuq2KolCmm9CBteM3?=
 =?iso-8859-1?Q?fa/fnxmjEn8dhp5pfXeWbTihIqHrFdb5nxSG2SwpCDoVa+cRP1cOZ1T5ew?=
 =?iso-8859-1?Q?EvMkeOUppm/76b7KAIVJoLaH2pjz3l4GjQoB6TxubSssM9TtVjm5tUN16v?=
 =?iso-8859-1?Q?tBifvu8jdLStF4YG9NmF8l3gx2rd9beZam6vYYlz+Z/B9wqfGhh1xl6DNK?=
 =?iso-8859-1?Q?KtSo8PMNUGxTV4R8AjJcwfRwjC5Mz9CT8TnmSx2OTeyTRQAx23QKbkhup0?=
 =?iso-8859-1?Q?8BQ4/tHXKiqkSy356gOjIsNjCKFdxisubeuzA4mP8ntAOKJZjYYGuhjSJj?=
 =?iso-8859-1?Q?efpz71RWAilAfnCIaDeMYkNOKyXnJgvqZCweWf118HeRxXteJ5ciDQ/Xsz?=
 =?iso-8859-1?Q?uC4OYh0sRRefM3nwvchhtQXvHYiIi5FuLF+p1JcKFFp0gBL2raQ1a3rEB2?=
 =?iso-8859-1?Q?sQ7fnyZjf1+zlv2mF38NZDwFfrOJ+YephVb8NG+75oSbv/4Uzg/j5j+U5i?=
 =?iso-8859-1?Q?UrS352lzG2kGcAcBTQnPkeD0Sfk7LGT0ee2vRwCK6UL3UuRtHwVLpKk7G2?=
 =?iso-8859-1?Q?ouof4pcJsJf35MUXbDL+XADC9lmofkcMs8V6wbT/4H0vLB+TNQ3PhRb0bM?=
 =?iso-8859-1?Q?4rUvypRFh5BVEoli6xfEO6u8Co05Jm5GmWz+KhhIRdQ+IzRIObtTb+9RIF?=
 =?iso-8859-1?Q?ahSITLej1fklsZv/RiMOt0stL0WShBrWlC4z438wUjRkrW6B0SZHZyF9w3?=
 =?iso-8859-1?Q?KxbfbdrCxiWHzN+/DeqkzNvOSGFDWeANjYkefBEAusXVXE1hBjZMxObwSv?=
 =?iso-8859-1?Q?d0IMYpG0QkdJixUIUMrVJPasQjTCQcEwJT1iyL+KtCsj9M2HCsVf+E6Utc?=
 =?iso-8859-1?Q?HftFhHSNyEoWdNwKbk0d5FvbAvF5zZs2pO1l5P/0agTSYsyw1mhxjavFlV?=
 =?iso-8859-1?Q?U3LHgxzKCHTmfTZa2AfencJfK+U5/tkOuEZjgt9JhzjRpEMxs1vi9TcLrz?=
 =?iso-8859-1?Q?QE9VJvRLqQ/znZySK6OsAEWbCdbgb66ih2QtDhrAWBjvcan048HZsNNM3g?=
 =?iso-8859-1?Q?96vCy6iofKvEraBvf2fOTx4ZzkuaPnPXyF3hwPWphz3m3mffl1t8kJnrdV?=
 =?iso-8859-1?Q?h9IaJeAOU9BKId4iopVcBLuQ1r2XzcnQ8raw6FWwxqBs9VTrdSzysdAeix?=
 =?iso-8859-1?Q?YoPsig3W5Y3rdw2LoENYyLhAjAaTOHu2IsSc48yy51N+VYPsZoY/RThYbu?=
 =?iso-8859-1?Q?DneXhzkdtX8+1tzP00csTDZh64nD6TCrhsG7XsuFubhQHe9yjDG8yThVyM?=
 =?iso-8859-1?Q?wxvoaCnHCBEzXi0CNZFKEgSjNEJzgHoimf5wBhHZ0aCkdIKg6Sg7IQa6Iq?=
 =?iso-8859-1?Q?8EKBhwiZd0mRILycWbpDl2g5J5oU8ScxufG97C4MQZ5mf22fbhsnEZtlPQ?=
 =?iso-8859-1?Q?jhgRVJMMzLoVvRVl/yBM1gCEQi+pASvS73vx77FwhRUj8gHevBV4tgiWI0?=
 =?iso-8859-1?Q?18uB1E1qUwsoh3kiuOcbevNlBTiTc6+VCAQNlTNMGCNeiFhnr4X7WMEViX?=
 =?iso-8859-1?Q?XmokNwD09g3oqcps71wD67s6UfghZDdZ61A6bSL6jqUEqHUs+P6QZxn/r9?=
 =?iso-8859-1?Q?fVK5puPGclDGKRdF0g4tDLsdWapwuMUQOkFnV02hG+6wDTu9MICrJggVRq?=
 =?iso-8859-1?Q?JJ?=
x-ms-exchange-antispam-messagedata-1: UvRiXv+XSDBk1N1a0lVF7Pd0RaRGuIba4y4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: ntu.edu.sg
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR01MB7338.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3249c404-dede-4051-3dae-08df3636bfc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2026 03:34:48.2785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 15ce9348-be2a-462b-8fc0-e1765a9b204a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: carStCuTHwSlnxsEWE7jMXeX6+3HIzqAOLft8iRxAnaCN6qIbNjcxhvYFc5Ac/EuUfNlnlzeNcNLnL24WNbQi6CN4lAcd2I6lY8dlUYLtA1HhRpRKRcjRGO3LJRhuREH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR01MB5117

From: Jianjun Lang <lang.jianjun@ntu.edu.sg>

WCN7850 uses one pdev for multiple bands. When it receives CN rules,
ath12k_regd_update() skips the 5 GHz range because supports_6ghz is set.
There are no 6 GHz rules to extend the remaining 2.4 GHz range, so the
firmware channel list loses every 5 GHz channel.

The ranges also live in ath12k_base. An event for another radio can
replace them before the first radio updates its channel list.

Store the ranges in ath12k_pdev, indexed by nl80211_band. Build each
set locally and publish it together with the regulatory domain under
base_lock. Take a complete snapshot for channel initialization and
regulatory updates. Copy the selected regulatory domain and ranges
under one lock acquisition so a later event cannot mix generations.

Use the presence of a 5 GHz rule range instead of supports_6ghz to
select the 5 GHz update. Use nl80211_band indices for the hardware PHY
lookup and refresh the 5/6 GHz hardware limits for single-pdev devices.
Reject empty hardware/rule intersections before converting MHz to kHz.

This follows the per-radio design proposed during review of the earlier
single-pdev fix. The earlier report and review are linked below.

Fixes: 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update")
Reported-by: Shenghan Gao <gsh20040816@gmail.com>
Link: https://lore.kernel.org/20260715065218.41232-1-gsh20040816@gmail.com/
Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://lore.kernel.org/9dd4e992-5810-429f-bc54-036c4eb276a7@oss.qual=
comm.com/
Assisted-by: LLM
Signed-off-by: Jianjun Lang <lang.jianjun@ntu.edu.sg>
---
RFC notes
---------
This patch follows the earlier discussion linked in the commit message.
Please review the per-radio ownership and snapshot handling.

Testing
-------
Hardware: WCN7850 hw2.0 PCI (17cb:1107, subsystem 105b:e0f7).
Firmware: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3.
Runtime kernel: Kali 7.1.5+kali-amd64, package 7.1.5-1kali1.

The installed driver failed a 5 GHz scan under CN. With the candidate
modules, the device selected CN and three scans returned 5 GHz BSSs,
including channels 36 and 149. Two scans requested cache flushing.

In a separate test under the world domain (00), a saved 5 GHz profile
associated, obtained an IPv4 address, passed 15 gateway pings, fetched
an HTTPS page, and disconnected and reconnected successfully.
These two tests do not establish full connectivity under CN.

An earlier CN association completed its WPA handshake but timed out
while obtaining an IP address. The cause remains undetermined.

Both matching Kali modules and upstream driver objects compiled with
W=3D1 without warnings. Seven userspace range cases passed. A deterministic
userspace test reproduced the old mixed-snapshot result and passed with
this change. These fixtures do not emulate firmware or kernel
concurrency. They are available on request.

No suspend/resume, long-duration, 6 GHz, QCN9274 or QCC2072 hardware test
has been completed. CONFIG_ATH12K_DEBUG is disabled in the running Kali
kernel, so no runtime internal range/channel-count trace was captured.

I would appreciate review of the per-radio ownership and snapshot
handling, and testing on split-pdev devices. In particular, the firmware
may provide a superset of rules for a 6 GHz radio; hardware intersection
must continue to restrict that radio's actual range.

AI tools assisted with the code, tests, and this message.

 drivers/net/wireless/ath/ath12k/core.h |  15 ++-
 drivers/net/wireless/ath/ath12k/mac.c  |  19 ++--
 drivers/net/wireless/ath/ath12k/reg.c  | 149 +++++++++++++------------
 drivers/net/wireless/ath/ath12k/reg.h  |   4 +-
 4 files changed, 100 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/=
ath/ath12k/core.h
index 99d71dab7..193389768 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -850,11 +850,18 @@ struct mlo_timestamp {
        u32 mlo_comp_timer;
 };

+struct ath12k_reg_freq {
+       u32 start_freq;
+       u32 end_freq;
+};
+
 struct ath12k_pdev {
        struct ath12k *ar;
        u32 pdev_id;
        u32 hw_link_id;
        struct ath12k_pdev_cap cap;
+       /* Protected by ath12k_base::base_lock. */
+       struct ath12k_reg_freq reg_freq[NUM_NL80211_BANDS];
        u8 mac_addr[ETH_ALEN];
        struct mlo_timestamp timestamp;
 };
@@ -871,11 +878,6 @@ struct ath12k_board_data {
        size_t len;
 };

-struct ath12k_reg_freq {
-       u32 start_freq;
-       u32 end_freq;
-};
-
 struct ath12k_mlo_memory {
        struct target_mem_chunk chunk[ATH12K_QMI_WLANFW_MAX_NUM_MEM_SEG_V01=
];
        int mlo_mem_size;
@@ -1138,9 +1140,6 @@ struct ath12k_base {
        /* Denote whether MLO is possible within the device */
        bool single_chip_mlo_support;

-       struct ath12k_reg_freq reg_freq_2ghz;
-       struct ath12k_reg_freq reg_freq_5ghz;
-       struct ath12k_reg_freq reg_freq_6ghz;
        const struct ath12k_mem_profile_based_param *profile_param;
        enum ath12k_qmi_mem_mode target_mem_mode;

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/a=
th/ath12k/mac.c
index 01f8c6572..4f1c71388 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -14136,7 +14136,7 @@ EXPORT_SYMBOL(ath12k_mac_op_set_rekey_data);
 void ath12k_mac_update_freq_range(struct ath12k *ar,
                                  u32 freq_low, u32 freq_high)
 {
-       if (!(freq_low && freq_high))
+       if (!freq_low || freq_low >=3D freq_high)
                return;

        if (ar->freq_range.start_freq || ar->freq_range.end_freq) {
@@ -14237,6 +14237,7 @@ static int ath12k_mac_setup_channels_rates(struct a=
th12k *ar,
                                           u32 supported_bands,
                                           struct ieee80211_supported_band =
*bands[])
 {
+       struct ath12k_reg_freq reg_freq[NUM_NL80211_BANDS];
        struct ieee80211_supported_band *band;
        struct ath12k_wmi_hal_reg_capabilities_ext_arg *reg_cap;
        struct ath12k_base *ab =3D ar->ab;
@@ -14250,6 +14251,10 @@ static int ath12k_mac_setup_channels_rates(struct =
ath12k *ar,
                      ARRAY_SIZE(ath12k_6ghz_channels)) !=3D
                     ATH12K_NUM_CHANS);

+       spin_lock_bh(&ab->base_lock);
+       memcpy(reg_freq, ar->pdev->reg_freq, sizeof(reg_freq));
+       spin_unlock_bh(&ab->base_lock);
+
        reg_cap =3D &ab->hal_reg_cap[ar->pdev_idx];

        if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
@@ -14272,9 +14277,9 @@ static int ath12k_mac_setup_channels_rates(struct a=
th12k *ar,
                }

                freq_low =3D max(reg_cap->low_2ghz_chan,
-                              ab->reg_freq_2ghz.start_freq);
+                              reg_freq[NL80211_BAND_2GHZ].start_freq);
                freq_high =3D min(reg_cap->high_2ghz_chan,
-                               ab->reg_freq_2ghz.end_freq);
+                               reg_freq[NL80211_BAND_2GHZ].end_freq);

                ath12k_mac_update_ch_list(ar, band,
                                          reg_cap->low_2ghz_chan,
@@ -14318,9 +14323,9 @@ static int ath12k_mac_setup_channels_rates(struct a=
th12k *ar,
                        band->bitrates =3D ath12k_a_rates;

                        freq_low =3D max(reg_cap->low_5ghz_chan,
-                                      ab->reg_freq_6ghz.start_freq);
+                                      reg_freq[NL80211_BAND_6GHZ].start_fr=
eq);
                        freq_high =3D min(reg_cap->high_5ghz_chan,
-                                       ab->reg_freq_6ghz.end_freq);
+                                       reg_freq[NL80211_BAND_6GHZ].end_fre=
q);

                        ath12k_mac_update_ch_list(ar, band,
                                                  reg_cap->low_5ghz_chan,
@@ -14377,9 +14382,9 @@ static int ath12k_mac_setup_channels_rates(struct a=
th12k *ar,
                        }

                        freq_low =3D max(reg_cap->low_5ghz_chan,
-                                      ab->reg_freq_5ghz.start_freq);
+                                      reg_freq[NL80211_BAND_5GHZ].start_fr=
eq);
                        freq_high =3D min(reg_cap->high_5ghz_chan,
-                                       ab->reg_freq_5ghz.end_freq);
+                                       reg_freq[NL80211_BAND_5GHZ].end_fre=
q);

                        ath12k_mac_update_ch_list(ar, band,
                                                  reg_cap->low_5ghz_chan,
diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/a=
th/ath12k/reg.c
index 7cf3dbc4f..12199f5d6 100644
--- a/drivers/net/wireless/ath/ath12k/reg.c
+++ b/drivers/net/wireless/ath/ath12k/reg.c
@@ -269,11 +269,13 @@ static void ath12k_copy_regd(struct ieee80211_regdoma=
in *regd_orig,
 int ath12k_regd_update(struct ath12k *ar, bool init)
 {
        struct ath12k_wmi_hal_reg_capabilities_ext_arg *reg_cap;
+       struct ath12k_reg_freq reg_freq[NUM_NL80211_BANDS];
        u32 phy_id, freq_low, freq_high, supported_bands;
        struct ath12k_hw *ah =3D ath12k_ar_to_ah(ar);
        struct ieee80211_hw *hw =3D ah->hw;
        struct ieee80211_regdomain *regd, *regd_copy =3D NULL;
        int ret, regd_len, pdev_id;
+       bool update_regd;
        struct ath12k_base *ab;
        long time_left;

@@ -288,69 +290,16 @@ int ath12k_regd_update(struct ath12k *ar, bool init)
                 */
        }

-       supported_bands =3D ar->pdev->cap.supported_bands;
-       reg_cap =3D &ab->hal_reg_cap[ar->pdev_idx];
-
-       /* Possible that due to reg change, current limits for supported
-        * frequency changed. Update it. As a first step, reset the
-        * previous values and then compute and set the new values.
+       /* Only the selected radio publishes the wiphy regulatory domain.
+        * Every radio still needs its own frequency range updated.
         */
-       ar->freq_range.start_freq =3D 0;
-       ar->freq_range.end_freq =3D 0;
-
-       if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
-               if (ab->hw_params->single_pdev_only) {
-                       phy_id =3D ar->pdev->cap.band[WMI_HOST_WLAN_2GHZ_CA=
P].phy_id;
-                       reg_cap =3D &ab->hal_reg_cap[phy_id];
-               }
-
-               freq_low =3D max(reg_cap->low_2ghz_chan, ab->reg_freq_2ghz.=
start_freq);
-               freq_high =3D min(reg_cap->high_2ghz_chan, ab->reg_freq_2gh=
z.end_freq);
-
-               ath12k_mac_update_freq_range(ar, freq_low, freq_high);
-       }
-
-       if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP && !ar->supports_6ghz)=
 {
-               if (ab->hw_params->single_pdev_only) {
-                       phy_id =3D ar->pdev->cap.band[WMI_HOST_WLAN_5GHZ_CA=
P].phy_id;
-                       reg_cap =3D &ab->hal_reg_cap[phy_id];
-               }
-
-               freq_low =3D max(reg_cap->low_5ghz_chan, ab->reg_freq_5ghz.=
start_freq);
-               freq_high =3D min(reg_cap->high_5ghz_chan, ab->reg_freq_5gh=
z.end_freq);
-
-               ath12k_mac_update_freq_range(ar, freq_low, freq_high);
-       }
-
-       if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP && ar->supports_6ghz) =
{
-               freq_low =3D max(reg_cap->low_5ghz_chan, ab->reg_freq_6ghz.=
start_freq);
-               freq_high =3D min(reg_cap->high_5ghz_chan, ab->reg_freq_6gh=
z.end_freq);
-
-               ath12k_mac_update_freq_range(ar, freq_low, freq_high);
-       }
-
-       /* If one of the radios within ah has already updated the regd for
-        * the wiphy, then avoid setting regd again
-        */
-       if (ah->regd_updated)
-               return 0;
-
-       /* firmware provides reg rules which are similar for 2 GHz and 5 GH=
z
-        * pdev but 6 GHz pdev has superset of all rules including rules fo=
r
-        * all bands, we prefer 6 GHz pdev's rules to be used for setup of
-        * the wiphy regd.
-        * If 6 GHz pdev was part of the ath12k_hw, wait for the 6 GHz pdev=
,
-        * else pick the first pdev which calls this function and use its
-        * regd to update global hw regd.
-        * The regd_updated flag set at the end will not allow any further
-        * updates.
-        */
-       if (ah->use_6ghz_regd && !ar->supports_6ghz)
-               return 0;
-
+       update_regd =3D !ah->regd_updated &&
+                     (!ah->use_6ghz_regd || ar->supports_6ghz);
        pdev_id =3D ar->pdev_idx;

        spin_lock_bh(&ab->base_lock);
+       if (!update_regd)
+               goto snapshot;

        if (init) {
                /* Apply the regd received during init through
@@ -382,13 +331,67 @@ int ath12k_regd_update(struct ath12k *ar, bool init)
        if (regd_copy)
                ath12k_copy_regd(regd, regd_copy);

+snapshot:
+       /* Pair the range with the domain from the same published update. *=
/
+       memcpy(reg_freq, ar->pdev->reg_freq, sizeof(reg_freq));
        spin_unlock_bh(&ab->base_lock);

-       if (!regd_copy) {
+       if (update_regd && !regd_copy) {
                ret =3D -ENOMEM;
                goto err;
        }

+       supported_bands =3D ar->pdev->cap.supported_bands;
+       reg_cap =3D &ab->hal_reg_cap[ar->pdev_idx];
+
+       /* Possible that due to reg change, current limits for supported
+        * frequency changed. Update it. As a first step, reset the
+        * previous values and then compute and set the new values.
+        */
+       ar->freq_range.start_freq =3D 0;
+       ar->freq_range.end_freq =3D 0;
+
+       if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
+               if (ab->hw_params->single_pdev_only) {
+                       phy_id =3D ar->pdev->cap.band[NL80211_BAND_2GHZ].ph=
y_id;
+                       reg_cap =3D &ab->hal_reg_cap[phy_id];
+               }
+
+               freq_low =3D max(reg_cap->low_2ghz_chan, reg_freq[NL80211_B=
AND_2GHZ].start_freq);
+               freq_high =3D min(reg_cap->high_2ghz_chan, reg_freq[NL80211=
_BAND_2GHZ].end_freq);
+
+               ath12k_mac_update_freq_range(ar, freq_low, freq_high);
+       }
+
+       if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP &&
+           reg_freq[NL80211_BAND_5GHZ].end_freq) {
+               if (ab->hw_params->single_pdev_only) {
+                       phy_id =3D ar->pdev->cap.band[NL80211_BAND_5GHZ].ph=
y_id;
+                       reg_cap =3D &ab->hal_reg_cap[phy_id];
+               }
+
+               freq_low =3D max(reg_cap->low_5ghz_chan, reg_freq[NL80211_B=
AND_5GHZ].start_freq);
+               freq_high =3D min(reg_cap->high_5ghz_chan, reg_freq[NL80211=
_BAND_5GHZ].end_freq);
+
+               ath12k_mac_update_freq_range(ar, freq_low, freq_high);
+       }
+
+       if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP && ar->supports_6ghz &=
&
+           reg_freq[NL80211_BAND_6GHZ].end_freq) {
+               if (ab->hw_params->single_pdev_only) {
+                       phy_id =3D ar->pdev->cap.band[NL80211_BAND_5GHZ].ph=
y_id;
+                       reg_cap =3D &ab->hal_reg_cap[phy_id];
+               }
+
+               freq_low =3D max(reg_cap->low_5ghz_chan, reg_freq[NL80211_B=
AND_6GHZ].start_freq);
+               freq_high =3D min(reg_cap->high_5ghz_chan, reg_freq[NL80211=
_BAND_6GHZ].end_freq);
+
+               ath12k_mac_update_freq_range(ar, freq_low, freq_high);
+       }
+
+       if (!update_regd)
+               return 0;
+
        ret =3D regulatory_set_wiphy_regd(hw->wiphy, regd_copy);

        kfree(regd_copy);
@@ -643,7 +646,8 @@ struct ieee80211_regdomain *
 ath12k_reg_build_regd(struct ath12k_base *ab,
                      struct ath12k_reg_info *reg_info,
                      enum wmi_vdev_type vdev_type,
-                     enum ieee80211_ap_reg_power power_type)
+                     enum ieee80211_ap_reg_power power_type,
+                     struct ath12k_reg_freq *reg_freq)
 {
        struct ieee80211_regdomain *new_regd =3D NULL;
        struct ath12k_reg_rule *reg_rule, *reg_rule_6ghz;
@@ -711,12 +715,12 @@ ath12k_reg_build_regd(struct ath12k_base *ab,

        /* Reset start and end frequency for each band
         */
-       ab->reg_freq_5ghz.start_freq =3D INT_MAX;
-       ab->reg_freq_5ghz.end_freq =3D 0;
-       ab->reg_freq_2ghz.start_freq =3D INT_MAX;
-       ab->reg_freq_2ghz.end_freq =3D 0;
-       ab->reg_freq_6ghz.start_freq =3D INT_MAX;
-       ab->reg_freq_6ghz.end_freq =3D 0;
+       reg_freq[NL80211_BAND_5GHZ].start_freq =3D INT_MAX;
+       reg_freq[NL80211_BAND_5GHZ].end_freq =3D 0;
+       reg_freq[NL80211_BAND_2GHZ].start_freq =3D INT_MAX;
+       reg_freq[NL80211_BAND_2GHZ].end_freq =3D 0;
+       reg_freq[NL80211_BAND_6GHZ].start_freq =3D INT_MAX;
+       reg_freq[NL80211_BAND_6GHZ].end_freq =3D 0;

        /* Update reg_rules[] below. Firmware is expected to
         * send these rules in order(2G rules first and then 5G)
@@ -728,7 +732,7 @@ ath12k_reg_build_regd(struct ath12k_base *ab,
                        max_bw =3D min_t(u16, reg_rule->max_bw,
                                       reg_info->max_bw_2g);
                        flags =3D ath12k_get_bw_reg_flags(reg_info->max_bw_=
2g);
-                       ath12k_reg_update_freq_range(&ab->reg_freq_2ghz, re=
g_rule);
+                       ath12k_reg_update_freq_range(&reg_freq[NL80211_BAND=
_2GHZ], reg_rule);
                } else if (reg_info->num_5g_reg_rules &&
                           (j < reg_info->num_5g_reg_rules)) {
                        reg_rule =3D reg_info->reg_rules_5g_ptr + j++;
@@ -743,7 +747,7 @@ ath12k_reg_build_regd(struct ath12k_base *ab,
                         */
                        flags =3D NL80211_RRF_AUTO_BW |
                                ath12k_get_bw_reg_flags(reg_info->max_bw_5g=
);
-                       ath12k_reg_update_freq_range(&ab->reg_freq_5ghz, re=
g_rule);
+                       ath12k_reg_update_freq_range(&reg_freq[NL80211_BAND=
_5GHZ], reg_rule);
                } else if (reg_info->is_ext_reg_event && reg_6ghz_number &&
                           (k < reg_6ghz_number)) {
                        reg_rule =3D reg_rule_6ghz + k++;
@@ -752,7 +756,7 @@ ath12k_reg_build_regd(struct ath12k_base *ab,
                                ath12k_get_bw_reg_flags(max_bw_6ghz);
                        if (reg_rule->psd_flag)
                                flags |=3D NL80211_RRF_PSD;
-                       ath12k_reg_update_freq_range(&ab->reg_freq_6ghz, re=
g_rule);
+                       ath12k_reg_update_freq_range(&reg_freq[NL80211_BAND=
_6GHZ], reg_rule);
                } else {
                        break;
                }
@@ -929,15 +933,18 @@ int ath12k_reg_handle_chan_list(struct ath12k_base *a=
b,
                                enum wmi_vdev_type vdev_type,
                                enum ieee80211_ap_reg_power power_type)
 {
+       struct ath12k_reg_freq reg_freq[NUM_NL80211_BANDS] =3D {};
        struct ieee80211_regdomain *regd =3D NULL;
        int pdev_idx =3D reg_info->phy_id;
        struct ath12k *ar;

-       regd =3D ath12k_reg_build_regd(ab, reg_info, vdev_type, power_type)=
;
+       regd =3D ath12k_reg_build_regd(ab, reg_info, vdev_type, power_type,
+                                    reg_freq);
        if (!regd)
                return -EINVAL;

        spin_lock_bh(&ab->base_lock);
+       memcpy(ab->pdevs[pdev_idx].reg_freq, reg_freq, sizeof(reg_freq));
        if (test_bit(ATH12K_FLAG_REGISTERED, &ab->dev_flags)) {
                /* Once mac is registered, ar is valid and all CC events fr=
om
                 * firmware is considered to be received due to user reques=
ts
diff --git a/drivers/net/wireless/ath/ath12k/reg.h b/drivers/net/wireless/a=
th/ath12k/reg.h
index 7c37c0d2a..4d3d7a4f5 100644
--- a/drivers/net/wireless/ath/ath12k/reg.h
+++ b/drivers/net/wireless/ath/ath12k/reg.h
@@ -11,6 +11,7 @@
 #include <net/regulatory.h>

 struct ath12k_base;
+struct ath12k_reg_freq;
 struct ath12k;

 #define ATH12K_REG_UPDATE_TIMEOUT_HZ   (3 * HZ)
@@ -106,7 +107,8 @@ void ath12k_regd_update_work(struct work_struct *work);
 struct ieee80211_regdomain *ath12k_reg_build_regd(struct ath12k_base *ab,
                                                  struct ath12k_reg_info *r=
eg_info,
                                                  enum wmi_vdev_type vdev_t=
ype,
-                                                 enum ieee80211_ap_reg_pow=
er power_type);
+                                                 enum ieee80211_ap_reg_pow=
er power_type,
+                                                 struct ath12k_reg_freq *r=
eg_freq);
 int ath12k_regd_update(struct ath12k *ar, bool init);
 int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait);


base-commit: fab2e70afb13485ea4b198b204af33dd15b8132c
--
2.53.0

________________________________

CONFIDENTIALITY: This email is intended solely for the person(s) named and =
may be confidential and/or privileged. If you are not the intended recipien=
t, please delete it, notify us and do not copy, use, or disclose its conten=
ts.
Towards a sustainable earth: Print only when necessary. Thank you.
