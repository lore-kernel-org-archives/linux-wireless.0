Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615819;
	b=0UErCLmBQQhzOj/1E/+l01Stc3IdQQI4oB61PX7LNIeBRxD93Clem8sNPAeO8xrkoFtF
	 CzKATUzpTWp/D5Dy2pBM0qg7/gJVp7guT7Y9BChDEaMtR8yZfvFZPOdiRGX0YxjQXPuxa
	 /pWp3j0gjYxZ0vDcToHxRbXUYxVlF7AlcUfCDXRs6eDN2IAen7z2ObNLwX7nUaIXncGf2
	 B5Sc4lnyNVNkgcZuy2QS88PXZI8jOBzt0TYh//Xa638Em7Lx4e/Dk4PcZRQFcASQIUYur
	 3+E8foVdB9gp+CuT1sC3P+Ry+rZfvhbHt94uK4Pvw79gAf8rxoaq/5wfUyAa8KkC72A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615819;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=aR8mKB8M4njSQFiQJBcDGNceeb5I7rYt9NxUcssU3YA=;
	b=jBEnC/dhgqZJW4wGk7bvZNenCLDCOHHWHZbllxjxMTYvzto7W9fM9cdj9pnf6ucdhlbI
	 1IrOw3IcM7r5es+CAolPI0MvWroSltIXY2psYt7nqg099P6306Dcb+6LLx3hO8JakOLw4
	 7GJ/oyeOwuntN6gX0Z3f/3fjCNl3tu6qhk/k8BJYt6YtNBzCZPeWB7jdfTmP/Xjwhidyu
	 NGnBAsw1lfHZr5TWX9IYkgbfLR9RjzDwqoXDrqqHE5YKm07TC53kdmryJIgugBUdANWUh
	 I+69A4Lw/NpYr1iSNewjF2XkliGHAikZnL+BzBe/takLAwBUnIlwd3mcdvWgJVWJi/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hLSNiRsH;
	arc=none smtp.remote-ip=91.218.175.175
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A35606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 20:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3A35606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hLSNiRsH
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=goZeDXML2cVb//QQ7KZZOYitB2T6895CT5ixFt1wh7A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792615816; v=1; x=1793220616;
 b=hLSNiRsHrG+iPIxwNK+AeO6lF7hqLY1PHYlgzkOc6hHVmf3ksA/E8NIlOwWCVY6WeH/Z1HYD
 gLiZQ6F4SuH4lt9ZUMqVvlVpILhqn8k+BeAwFO96R3Y64GPNIkdwrk1Awi58IWVyPjEivLs2waK
 +tqCMASWjbLEyZ0O+Ky8ACgY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c5839db12eed090f;
	Wed, 21 Oct 2026 20:50:15 +0000
X-Mizu-Trace-ID: c5839db12eed090f
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 20:50:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <7ad9e0f356353a3c3c0c3ca4ca0d685ba42983a0@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH rtw-next 5/5] wifi: rtw88: pci: clear CLKREQ/ASPM
 enables when disable_aspm is set
To: "Bob Beckett" <bob.beckett@collabora.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, "Bitterblue Smith"
 <rtl8821cerfe2@gmail.com>, "Timlee" <timlee@realtek.com>,
 matthew.leach@collabora.com, kernel@collabora.com
In-Reply-To: <20261021190529.3893821-6-bob.beckett@collabora.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
 <20261021190529.3893821-1-bob.beckett@collabora.com>
 <20261021190529.3893821-6-bob.beckett@collabora.com>

Hi Bob,

For the SteamOS test build this should do the job. Few notes for upstrami=
ng
though:

On Wed, 21 Oct 2026, Bob Beckett wrote:
> Clear both bits in rtw_pci_link_cfg() when disable_aspm is set, so the
> parameter does what it says from the moment the driver probes.

rtw_pci_link_cfg() runs near the end of probe. By then
rtw_chip_info_setup() has already powered the MAC on, downloaded the
firmware and powered it off again with the old bits still set:

        rtw_pci_probe()
          rtw_chip_info_setup()
            rtw_chip_efuse_info_setup()
              rtw_chip_efuse_enable()
                rtw_mac_power_on()
                rtw_download_firmware()
              rtw_chip_efuse_disable()
          rtw_pci_phy_cfg()
            rtw_pci_link_cfg()

If that power on fails, probe bails out before the bits are cleared.
Should the clear go before rtw_chip_info_setup(), or should the message
say it takes effect once probe reaches rtw_pci_phy_cfg()?

> Assisted-by: Claude:claude-opus-5-5

816d9992d9ed simplified this tag, it now just says LLM instead of the
agent and model. Or you could just drop the tag in whole as that tag
requirement was dropped(will be dropped) in linux 7.4.

[...]
> +static void rtw_pci_link_hw_disable(struct rtw_dev *rtwdev)
> +{
> +     u8 value;
> +     int ret;
> +
> +     ret =3D rtw_dbi_read8(rtwdev, RTK_PCIE_LINK_CFG, &value);

disable_aspm was added in 68aa716b7dd3 for platforms where this very read
fails and the device then drops off the bus, and the FA506II quirk
(b0034a2e4156) reports the same thing. With this patch every disable_aspm
user, and the five rtw_pci_quirks[] machines on every boot, now do the
read at probe.

The reports I found hit it when leaving power save or around suspend, for
example https://bugs.launchpad.net/bugs/1872984 where it fails in
rtw_leave_ips() with the MAC off and BIT_L1_SW_EN set. After a reload
your read runs in that same state. Is it known to be safe there?

If not, clearing the bits in rtw_pci_remove() on loads that set them
would keep disable_aspm users off this register. It would also cover a
reload without disable_aspm, which today starts with L1 still on from
the last rtw_enter_ips().

> +     if (ret) {
> +             rtw_err(rtwdev, "failed to read link config, ret=3D%d", r=
et);

Missing \n, the helpers above have the same problem.

> +             return;
> +     }
> +
> +     value &=3D ~(BIT_CLKREQ_SW_EN | BIT_L1_SW_EN);
> +     rtw_dbi_write8(rtwdev, RTK_PCIE_LINK_CFG, value);
> +}

This is the fourth copy of the same read, mask and write of
RTK_PCIE_LINK_CFG in pci.c, a small helper taking the bits to clear and
set could serve all of them. rtw_pci_link_hw_disable() also reads as if
it turned the link off, a name closer to rtw_pci_clkreq_set() and
rtw_pci_aspm_set() would fit better.

[...]
> +     /* The CLKREQ/ASPM enable bits live in the device and are not res=
et
> +      * by a driver reload, so a previous load may have left them set.
> +      * Clear them explicitly when ASPM is disabled.
> +      */
> +     if (rtw_pci_disable_aspm)
> +             rtw_pci_link_hw_disable(rtwdev);

Block comments should start with /* on its own line, as netdev dropped
that comment style. The last sentence only repeats the if below and can
go, and naming BIT_CLKREQ_SW_EN and BIT_L1_SW_EN says more than "the
CLKREQ/ASPM enable bits".

Best regards,
Luka Gejak
