Received: from sonic.asd.mail.yahoo.com (sonic-asso1-0020.asd.mail.yahoo.com [34.2.90.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E19F448BAF
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 10:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.2.90.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792145005; cv=none; b=km9RtirU/mq/IO6PpXkk2LV7XUOLtFzOVhZWn30x+Gh7NJcGmucFTBxhNcO7eSgkyG79BQSoEUkK64E8Jvrg3KSodPrfeFmHkaWDk9+JjBa0gRHumoXJLe8ifeiRoDSlnvhaSuF19aO5XwgQ42jaUkhtXjq6mHoNlUIFXqphLm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792145005; c=relaxed/simple;
	bh=syy4GVVFQ2FJugD5bmnWBPsTt9J+l7F8sLeb7gveoTU=;
	h=Date:From:To:Message-ID:References:Subject:MIME-Version:
	 Content-Type; b=Ur5n1WKqVuOz4icnHsW9xDTAoksbwFfVWkSpI/sDMO0eEa2nLaqyrJmTvlpCD4HqDwRw1iSViWvmu3KYNGnP7NbIX0aTyB+XENPYkbksUCBjX9V2LoTo6xvCFBo7aPcSlhflZUbjaZhnvELd1sKuYF21kB7N4BY9B7e2ukFEjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=mXyhGmLH; arc=none smtp.client-ip=34.2.90.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="mXyhGmLH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792144999; bh=syy4GVVFQ2FJugD5bmnWBPsTt9J+l7F8sLeb7gveoTU=; h=Date:From:To:References:Subject:From:Subject:Reply-To; b=mXyhGmLHuAG1tBzoPi6P2P8Z3/dACuktbTlm+BvfCP4cDRgsKPieUyTgFy6+iTTEFFtdpXahzrJafA4BXpo7/G8SOrg8WD+NWnWcn8Ga3knvtBsaATyOq6JNSlzMRkdQwj1jvSKYeDDQYsarkI2HmK3b/jYNdSOxhLAacF1Hxr6TlPQs123GeegUWxMBSugjOR5bILW5rvyfeurVA14vls1G/5ZgccB4/EKZzaB5P1YvD7v9i/mrImUy932OtQE0herJ6+nRauottRvi6E2YRr8vXHDQXDoFu+csYy7MUsat7J0ZIIammoXomdKWR+WfJAFSo2M6bECP2tbwZ2AEHg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792144999; bh=onPa/cu4fjfnB0geqwGUo7s+EaF4IfivG6gijiZGytK=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=VC+v5jBl9g8I2vLeqXgVDExBSJvRBSZj1fSpkvLM/d0V8nFNVi9RSZ3LtfkD9HC5DwK+69CPxhmSt8kQCBtH3aAssAiBMfww7rPm/QoqhiMEzC7BOX7ePANxVlC1omCaeWEbfT8LyK4wpp9Ywr8LVN7J8Pbr80T80KlQ64RaayzlfYSMFnZTkLH9jg6d7Ap6bxm/9tdyT50SrtsMRdDhu8FiKx0AQlU+hSO6pD8QlOMxVIkjdOBMgJud+XeTtWaPN03oMfQrF+nSDnoHtK01eNlyoEXs6BI02xHotUwONaKKkmGp/fUwivrdHmReqL5ZXZ/eUYWOIghEyX8eRiByag==
X-YMail-OSG: 6T5lPB0VM1lPNbqsem94vFbn8q.pqWXmIsFk6JnSMO_RXoDQcfY4mzPSHwJNQ54
 73YCbKMqma82wEx2oZCR_MfGvalvGKEiXy5KxpVo0viu0U3xIwzOaTeO96RaBcM0hAQqpydxlHP0
 uRD1DZCXtt.vs99NEBfGzP0Iq5vXHGxLtqm_oLksouh1NMOyyEY7nP68.HpamfQz9yMWCCaArye2
 NljtaiGLC0exHzzxmOGPb72rDsUCxZ5XGBKUeBuDY68e6zNMSBFlo_BXBBfkhVkkseb.QnhqXTru
 0agmhewbaTci0dybA4GJcdKZiULPwhvDVkSpqWXbi4kWzJHOveImwl0uldZmkf3Lo8PUA2mIwfQL
 KmSOnNE1DbjkUq9mvtlYRDATnjiMO0TCXhacPKO3sP2mENjuVlzT67ThhEHSV2RNgeAsmxF4HGTF
 XAEg8s8Nna1uTmr2QDWvP7a6I42dWwcHn1nFlk33Yw5flJd4ftLOIkAUvbyKn2KBguestQOZlGoI
 etFE7kmsYcslYgsF_R3mxDwrefDpn5kU0pxfowoUJsEojuxrA_cUOxoKc4WpPu2.ZfgkjhqEN3a6
 yR4.mgZw4cE_wgPVGJuLDHyDt6rwsZNa83bqtkd8OPEble9b9UxsBPlpKqqhI18_A9f9x3gSuRA7
 rOVRHmXcApwewHCJMgsaz8CEkY0txl8TZKbzSfFKosV8LFbxVDJehydAXWBsohztrTEnVypJXSAe
 8YyxbMQ2xU5W211DMrxHtLV9WFYaqDyFS3vCKqsDCIf1ip1hvjEOMSdnnpz7DxrDBIi.EemDtbXS
 WT0uBoz0XRj3DnfQCO9Cf64R43ulEeXml4Wdb9Z7S5amccJ6N.pGdVN3ktkE7h_Kl0OYLQwCUrXb
 pTTBDWliNrPtdND10pzA7e91SnJzeX.vVDZ6TKBIoQF0sf4muNCAxtg45R7DHxZ3R1mAf34H_sZa
 m8MPsZjx1.4n16m81ChyC0y36HK2IvyPpa.SBbSHnrUEhs6ZXtfDy5ZpDWqUM7oNK4KaNi0ecfgA
 qVJGSMaIQV14lvXib.BkUetuvJpIUxQUeMEJ7HziG3BhCl3.Ea3C1uD84bVn3yOIgwXk5mu2ZsTT
 GdtwQ32DNaWKueVsZhiKs2WrnRbulLWGp0_VYazPgtfVn.Q0e_mzJmmHkEXVaPgL3qUrJc7laL_h
 lfelq578FIhZRqWGNiZE6dX3WiIxxuZvN3dSXPNr9EGfJoIGDeJHiEOufmmaNaS1DMQLWdSAPwLG
 kG8nGz6.VBvzCnu2OYYyOBjqS8DmOLLiLEDwBmlEU_ShBg2ApzX74r92spb1RMBxL2HXtjS4Bo5r
 DCkwK0Cg3oz3HSbY2PPTG3CCNb2WXnwLYLiETLUkYksGFwnxGnrv2sdno4QcQ_tCHcpNgoBGBztw
 SKrKBUcbsw8JcLaa6jEHwrAAk1W84krMlL7atoKY5tgvuXTTcWc5Z6TYUsg5wVOCQ0ONRkzcWOjx
 LQGfA7LIAb75NaME9V2wu4V8pX1p4W6pCrzYt.ZI4eMX9jpkCZ9VUpgm9aU.jFrz3c2CEFqeh2im
 dP.CE0CzbAs7mFK2XIEFKkfm2p34878N7w5JGyO_vPdYZCbW7foBXfz0qTXGeCMTObKq0BK1ffHL
 cBALRhW0BBYE4M6DHXY3utZc5RLFPXzRgibTn4KGPtTJ_BMvbJkgCztIf7FVQ7JVP6wzQOqeRw64
 rcmZKn_.I5yJ6VXGYAN_jiDtz_WOyi7Vmr15Ic6PwplgvqfPYjWerezMthbOErzrRg0Tiif_c1vU
 tgIABuBEUEnh.vnmPBq.e5_OCuEqJ7n9DFMYtnTBR38d.hIHstX80x67bE95qJLKhEwt_UReYcGQ
 td7kz0y3r7mEFT85P.2ppM3UQaYQkXG0AAVbElNb0bLpizeWOw82u56HjwQrL4pJTSM42iKQ76cV
 r3KQbac1d7QXoyiSEyxb.h6hqCr8C46J1ir1SEyQO7ooa3waJ1kSDIPRo_OnB6CjhqHy9SizyJPL
 gl9oFUFF3tQK2pLRr1aOI2Pr41SfHb4cnn.8l89Yhq1vs7xVJlPQnlHhRZZ9JyhVjRDPRkvVZ9xq
 ygWxS.v.aO6EBUo4kDhggRVG4rwYWgIvcgWBnpw--
X-Sonic-MF: <jewel_boss_m@yahoo.com>
X-Sonic-ID: b2602b22-2aeb-434b-85ce-db14e340acc1
Received: from sonic.gate.mail.ne1.yahoo.com by mail-asdoutdeli-p-cin-asso1-prod-sonicconsumer-svc-102 with HTTP; Fri, 16 Oct 2026 10:03:19 +0000
Date: Fri, 16 Oct 2026 10:03:11 +0000 (UTC)
From: blackbird <jewel_boss_m@yahoo.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
	"wireless-regdb@lists.infradead.org" <wireless-regdb@lists.infradead.org>
Message-ID: <1844356607.822318.1792144991919@mail.yahoo.com>
References: <1844356607.822318.1792144991919.ref@mail.yahoo.com>
Subject: [PATCH] wireless-regdb: update regulatory rules for Bangladesh (BD)
 to allow 6 GHz (UNII-5)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.26740 YMailCLDNovation

Dear Maintainers,


The Bangladesh Telecommunication Regulatory Commission (BTRC) has officiall=
y approved the lower portion of the 6 GHz frequency band (5925=E2=80=936425=
 MHz) for shared, unlicensed use including Wi-Fi 6E/7, IoT, and Wireless LA=
N (WLAN) devices.=20


Please update the database rules for Bangladesh (BD) to permit indoor trans=
missions on the UNII-5 band up to a 160 MHz channel width.


Official Regulatory References and Direct Circular Evidence:
- Official Announcement Notice Page:=20
https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d
- Direct Source Regulatory PDF Document:=20
https://objectstorage.ap-dcc-gazipur-1.oraclecloud15.com/n/axvjbnqprylg/b/V=
2Ministry/o/office-btrc/2024/12/18337854ab6c487fa749464c7672c8a8.pdf


Proposed database block update for db.txt:


country BD: DFS-FCC
(2402 - 2482 @ 40), (20)
(5170 - 5250 @ 80), (23)
(5735 - 5835 @ 80), (30)
# 6 GHz band (UNII-5) approved by BTRC circular on Sept 15, 2024
# Shared unlicensed indoor use for Wi-Fi, IoT, and WLAN
(5925 - 6425 @ 160), (23), NO-OUTDOOR


Signed-off-by: Syed Mubashir <jewel_boss_m@yahoo.com>

