Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762148;
	b=M9kPnlNoqH9LKgIO1QEhr3gW53uYdhHv26WYSOHInK9vH7FDiO9+gxERk5J13zXHXsYx
	 Pcbs5s8uGvF8kWo88BOUeZWaih0IeqSRyoPPXODJNIWeZ4SA4nEexEVMfQdrUdIVhH4SR
	 yG3MqSDz/eMzHLRvRfH2tqGI+SnKF8xYkcZQU2QHGAzthKJV/P51LL77wYMtQReh1fzGh
	 2uLUgVYVO/r4j77gbPfvqpPn0O2i+PVrL77s8yEpImZUCB8hYIvppNBBxTuHweFQgshYz
	 T/raLgsxhFRYs3rjC1Z74toJEjuolIUNIOxpaKF6cSSC/Acj4JqQQZllj2Sonq8caKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762148;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=dvXvM6gi/E2yselhgxqrboFUToKsfbHMCdJebTKtZOw=;
	b=nyGp4JHT0fwNptmIFo8hGkmn9C8jpMnPrmTdnPLojXaiI4l3My7PdvEm/zCKd5KTQzDg
	 R08vH9MtK4bpPgUBrLsE09hUl4rl4KPQZfsfxxkvV6AO41igOH+M3AYjzz2BDUtGGn1Id
	 MPhQRgyJEXvcTNRHeJf3LKdwGN5AAbYyiSaIq73i5YPwlVWxHuj2y7rn4rG+GMa/q0eMh
	 g68w9s5ZU+MvzOyxM26bH+rpWnTj1eF7ew8iPo9VH+RMdDAXFKM7JK5QidecskQo/Y7k9
	 dKN85ZDLwNzPhxXDrFavXJZ9UMxdvVgtbCoc9muq5SvpkqdcJ7WBuvXopej+8fZXyGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=aHpRPLaz;
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEBC606A31A;
	Fri, 23 Oct 2026 13:29:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AEBC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=aHpRPLaz
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 3A5B0FC16;
	Fri, 23 Oct 2026 16:29:00 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=dvXvM6gi/E2yselhgxqr
	boFUToKsfbHMCdJebTKtZOw=; b=aHpRPLazih0fcvF1MJFXQI75k9QpE+N0VE5f
	zhBPahCPoYfuThOdI94mskCWWNfwTbyI6ru6hr8CGjE4mKz7xT3htKUQxzt0ZfXA
	81T6ZPSl0D+2xYE0VoqxoZwserOWYolpVoqDlkDRa23mcp2U03Lmj+SzeVmuc578
	rTdgrMrVfmVADZ3Tr0//VpusH3ylYpuEh4OFqkLR7zyr2esQ0OQkpn6DQVamekXK
	OkXCl11KztY88Xd1qTM9lWBr/Z2KasfVRjGaYIZ04MAAJUiWDS3kafS6sAa1ePCG
	hEMI1HL0nax7vBe/BVLZaMslwlFdRVk7zExjzkOBJq/LHFPUhA==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 0976DFA52;
	Fri, 23 Oct 2026 16:29:00 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 16:28:59 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
CC: Bjorn Andersson <andersson@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>, Konrad Dybcio <konradybcio@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>,
	<ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6 Enterprise
Date: Fri, 23 Oct 2026 16:28:54 +0300
Message-ID: <20261023132854.3641937-1-me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <bd062ae7-74c2-486e-9413-15ca8c943055@oss.qualcomm.com>
References: <cover.1791110510.git.me@andrei-z.com> <ddbc631bb95ae5fcc6498e083b280ba2b736181f.1791110510.git.me@andrei-z.com> <bd062ae7-74c2-486e-9413-15ca8c943055@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

On 10/21/26 3:44 PM, Konrad Dybcio wrote:
> On 10/4/26 1:10 PM, Andrei-Alexandru Bleortu wrote:
>> +		button-reset {
>> +			label = "reset";
>
> Normally we do sentence case here, i.e. "Reset"

Will do in v3.

>> +&blsp1_i2c3 {
>> +	pinctrl-0 = <&i2c_pins>;
>> +	pinctrl-names = "default";
>> +	status = "okay";
>
> Please keep a \n before 'status', file-wide for consistency

Will do, for &blsp1_i2c3, &blsp1_spi1 and &sdhc_1.

>> +&pcie0_port0 {
>> +	reset-gpios = <&tlmm 15 GPIO_ACTIVE_LOW>;
>
> No wake-gpios?

Not that I can find. The vendor device tree gives only PERST# for the
two radios (GPIO15 and GPIO18) and configures nothing on GPIO16, 17 or
19, where a reference-design WAKE# would be. Without a schematic I
can't tell whether WAKE# is routed at all, so I'd rather leave it out
than copy the RDP's GPIO16. Both radios work without it.

>> +	wifi@0,0 {
>> +		compatible = "pci17cb,1104";
>> +		reg = <0x10000 0x0 0x0 0x0 0x0>;
>> +		qcom,calibration-variant = "Ubiquiti-U6-Enterprise-5G";
>
> Does the same calibration work for both radios?

No, they need different board data: the 6 GHz radio below pcie1_port0
has "Ubiquiti-U6-Enterprise-6G". The two QCN9074s are otherwise
indistinguishable to ath11k: both are 17cb:1104 with subsystem
17cb:1104, and both report chip-id 0 and board-id 255 (unprogrammed
OTP). So the variant is the only part of the board name that differs:

  bus=pci,qmi-chip-id=0,qmi-board-id=255,variant=Ubiquiti-U6-Enterprise-5G
  bus=pci,qmi-chip-id=0,qmi-board-id=255,variant=Ubiquiti-U6-Enterprise-6G

The stock firmware also ships a separate board file per band. Both
board files went to the ath11k list under these names.

>> +&prng {
>> +	status = "okay";
>> +};
>
> Please add a preceding patch to enable it in the SoC DTSI, this should
> never really need to be disabled

Will do; v3 drops the status from the dtsi, as ipq5332 and ipq9574
have it, and the board no longer touches &prng.

Thanks for the review!
Andrei

