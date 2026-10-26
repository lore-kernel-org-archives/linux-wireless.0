Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041793;
	b=elBxQmhFQDbHihRdJ/ASn3BUMX7+gOmV0nQN3nz6ngQAAWO60W/Z/r7Ooseisu2/8ubr
	 NuTQC2lKeL+OyS2XBpeNkOK9iQ82bbzF4g2mo7iTOqtQX//gEFrGQCr1hpuhJGX13Jjhj
	 OZCkGGBca7ypDNLCxXy13HV6V30rFCEmd2JxAkgRF2afqApzD/evHcGKiD9c1Z3MO8dpS
	 g+YGChsX30lpNPQjrS3/FMv7zDoSIcDMQ2+OWmyCtrl4BJ45NIte4c8a/CgCUoBLA8zS+
	 9ZzIuJZhlJ69l6him0z/Ff1TmSTytGJ+EVETf+VEwGV0zGKV8LlDr7oAuwa5q2lU5og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041793;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Message-ID:In-Reply-To:
	 References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Correlation-ID;
	bh=d0/9qWWid7eSh4s2p7uR1bCkkdTfC4hPw3dFG/jWyRI=;
	b=S8oTQUqq77d+8+wXnoiw5JYCAaJQcMN8poytazEWHn15jmsZTt/an75DPwOC5FnFdZz2
	 htd8aOVxGlA/vSf5uLMvATolwcfB7KKe2VzWeBJ1wviVnZSG9/23S0jXMZ7PVTxTyZa/v
	 J/I5VU7r4LvQnMg19FYJnDvEU7bVgH/LcmDw0zefpYT5BYvVqsWvqjJtb0zysYqz1Podg
	 kXBuq43J2IvINuSAUbQnbOYA8jAFXP9DLzr9SBvbZ7PnP2lF6CFNj4+tfepFqQx7Rn+LQ
	 owx4+GOywpIf4+0R6wiWVMWv7bx+4pziFm3GMY1VoXQ27X2RYL2IShBQ8FgzJPmfJ4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.150
Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F4B606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 19:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49F4B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=d0/9qWWid7eSh4s2p7uR1bCkkdTfC4hPw3dFG/jWyRI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793041779; v=1; x=1793646579;
 b=mOxdfz/JW9dk9ctPky4ltgnXSJBfYxEIh3TexWocXMVW3Hc3jSnw09yIzM/GGnD1xHlX5DAg
 ITBRa4QJyPHgL0rPtaZum/1QofKAcyWOjHlOh3z+6pizSvWNjMPoPDipJD69rs9abO+1VAu53KN
 qVHaSK0sp3dQRyTYevOfXAp8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 600b06249a500df1;
	Mon, 26 Oct 2026 19:09:39 +0000
X-Mizu-Trace-ID: 600b06249a500df1
X-Migadu-Flow: FLOW_OUT
Date: Mon, 26 Oct 2026 20:09:34 +0100
From: Denis Benato <denis.benato@linux.dev>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
	linux-wireless@vger.kernel.org, miriam.rachel.korenblit@intel.com,
	emmanuel.grumbach@intel.com, linux-kernel@vger.kernel.org,
	kernel@lists.opengamingcollective.org
Message-ID: <76481816-6b21-4f45-8949-144342faf39e@linux.dev>
In-Reply-To: <20261026184813.GA342157@bhelgaas>
References: <20261026184813.GA342157@bhelgaas>
Subject: Re: [PATCH 1/1] PCI: Disable D3cold for Killer BE200-family WiFi on
 MSI Claw A1M
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <76481816-6b21-4f45-8949-144342faf39e@linux.dev>

26 ott 2026 19:48:16 Bjorn Helgaas <helgaas@kernel.org>:

> On Sun, Oct 25, 2026 at 11:18:13PM +0000, Denis Benato wrote:
>> During s2idle the platform removes power from the WiFi slot (D3cold).
>> The Killer BE1750 (Intel BE200, 8086:272b) installed in the MSI Claw A1M
>> fails to resume from that state: the PCIe link does not retrain
>> ("pcieport 0000:00:1c.0: Data Link Layer Link Active not set in
>> 100 msec") and every device register reads back as 0xffffffff, so the
>> card disappears from the bus and the machine must be power-cycled.
>>
>> Keeping the device in D3hot with the link in L1.2 during system sleep
>> makes suspend and resume work reliably: the package still reaches >99%
>> S0ix residency and the card survives every cycle (verified over multiple
>> suspend/resume tests with an RTC-timed wake).
>>
>> Disable D3cold for the BE200-family device on this board. This mirrors
>> the udev-level workaround distributions already ship for the AX200/AX210
>> (8086:2725), which suffers from the same class of problem, and moves it
>> into the kernel where it belongs.
>
> If 2725 has the same problem, should we make the quirk apply to it
> also?
>

Hi Bjorn,

Probably yes, but I don't own that hardware, only saw gaming distros are sh=
ipping an udev rule to do just that.

> I suppose this is a firmware problem with whatever is supposed to turn
> the power back on?=C2=A0 Are there any firmware updates available?
>

Not that I know of. I have updated my bios (only update available) but the =
issue is still there.

>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D220223
>> Signed-off-by: Denis Benato <denis.benato@linux.dev>
>> ---
>> drivers/pci/quirks.c | 21 +++++++++++++++++++++
>> 1 file changed, 21 insertions(+)
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 7572b358b50f..60156e6c3e49 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -6593,3 +6593,24 @@ static void pci_mask_replay_timer_timeout(struct =
pci_dev *pdev)
>> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9750, pci_mask_replay_timer=
_timeout);
>> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9755, pci_mask_replay_timer=
_timeout);
>> #endif
>> +
>> +/*
>> + * MSI Claw A1M: during s2idle the platform removes power from the WiFi=
 slot
>> + * (D3cold). The Killer BE1750 (Intel BE200, 8086:272b) fails to resume=
 from
>> + * that state: the PCIe link does not retrain ("Data Link Layer Link Ac=
tive
>> + * not set in 100 msec") and every device register reads back as 0xffff=
ffff,
>> + * so the card disappears from the bus and the machine must be power-cy=
cled.
>> + *
>> + * Keeping the device in D3hot with the link in L1.2 during system slee=
p makes
>> + * suspend and resume work reliably: the package still reaches >99% S0i=
x
>> + * residency and the card survives.
>
> From just this patch, I don't think we can assert the L1.2 link state,
> can we?=C2=A0 AFAICS, this patch just prevents the use of D3cold.

From this patch no, but that is the description of what happens on my msi c=
law when I enter sleep with this patch, checked via s0ixselftest tool.

This is surely better than the previous work around of detaching the driver=
 and re-attaching it leaving the device in d0.

>
>> + */
>> +static void quirk_msi_claw_be200_d3cold(struct pci_dev *pdev)
>> +{
>> +=C2=A0=C2=A0 if (!dmi_match(DMI_BOARD_NAME, "MS-1T41"))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> +
>> +=C2=A0=C2=A0 pci_d3cold_disable(pdev);
>> +=C2=A0=C2=A0 pci_info(pdev, "disabling D3cold: slot power removal durin=
g s2idle prevents resume on this system");
>> +}
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x272b, quirk_msi_claw_be2=
00_d3cold);
>> --
>> 2.55.0
>>

