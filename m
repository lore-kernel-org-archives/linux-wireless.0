Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE7017B425
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 01:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787879865; cv=none; b=UiqIA1t5BNVq5rSuS3ao/FbNsaZ/TTW3QtfDmbGDj7Za1i5syicCvWDX+Ky01cX1pCXPw+5GlO7h2Wq03kPV3q3lpAXbYqElHjB8O6CIlX44DetLIlYhBAGMdagNvDPI8JnZG4WrgqWvtMRZAyEkUQbCmdARZZBkFe4TPYs5u7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787879865; c=relaxed/simple;
	bh=vkWAAncEPqSCfjPN3H3wr6ysqgrRP13JfyJKI8czm9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeF7mPOwfdPQxMlk4/IC7kYC9Qw/lv9uxb32GYZY4o8qXpmB9bQgFHLqTicJ3xlINwVQD2SD6R0FyR+cLKUt8hHxIctdYD9DlrBGqs13X+/NTE8Lrjm7FQlgnhGbhiarbWRkbaFgJwp+OBYx43CKy3pZRSgkrvcNno/8FMAAJOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=IE7GmnqR; arc=none smtp.client-ip=95.215.58.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="IE7GmnqR"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vkWAAncEPqSCfjPN3H3wr6ysqgrRP13JfyJKI8czm9Q=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787879860; v=1; x=1788484660;
 b=IE7GmnqR+SVgQB5hUB5t+yVdF5gGPZcyaeMFPQYBddrIlc47km0nAQ6A8G9yYNTHCID1Ag1/
 VU/TE4j1kp8uOjyhVQfQj4ONYSocsXlbOKoWruE6WGZBFS7TZG7WXtJCzhbm9fX894GsVukjAQs
 782h7FI/88s8JcwOOuoNqj1BLwZHZ2zHuZ14fjZ+OpWA1GRruQ3VjzZqeHGOyMuait5cRv3zBQV
 g/h4aV4O0660EwBJVAsuy5+3NQGbE0XBkcU85zT2WNgj//8SRpb7Ya+sJh4qhD7bZmVovZVKZqV
 7n8VfqUMimnOTljJg0kvdAVD0zbuWupz2ObjrnKazdccQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4063e950ceabd68a;
	Fri, 28 Aug 2026 01:17:39 +0000
X-Mizu-Trace-ID: 4063e950ceabd68a
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Klara Modin <klarasmodin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	nbd@nbd.name,
	lorenzo@kernel.org,
	regressions@lists.linux.dev
Subject: Re: [PATCH wireless] wifi: mt76: mt792x: fix NULL dereference in ACPI SAR init during probe
Date: Thu, 27 Aug 2026 18:17:37 -0700
Message-ID: <20260828011737.22809-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ao3dyqWJ3nf3rMMW@soda.int.kasm.eu>
References: <20260825181712.28548-1-lucid_duck@justthetip.ca> <ao3dyqWJ3nf3rMMW@soda.int.kasm.eu>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thank you for the Tested-by, and for bisecting it in the first place. The
report arrived with the commit named and a revert confirmed, which is most of
the work already done.

Something odd, since we are on the same laptop. Mine is a Framework 13 that
shipped with an MT7922, and it has no MediaTek power tables at all. I checked
every ACPI table on the machine rather than only the main one, and there is
nothing there for any vendor. So your oops cannot fire here on the same model
with the same card, which is why I had to inject tables to reproduce it.

Which means the difference is somewhere in the firmware, and I can only see my
side of it. Mine is an Intel 11th generation board on BIOS 3.17, dated October
2022. What are you on? Whether these tables came with a later release or only
ever appeared on certain boards decides whether anyone else is about to walk
into this.

While you are in there, does your geo table carry 0xff in the unused slots?
Someone turned up on the list yesterday with an ASUS padded that way, which
the driver takes as roughly -1 dBm and clamps every rate down to it. Whether
that is one vendor's habit or common changes what the right fix looks like.

Devin

On 2026-08-25 11:27:15 +0000, Klara Modin wrote:
> On 2026-08-25 11:17:12 -0700, Devin Wittmayer wrote:
> > Some laptops carry a MediaTek power table in their firmware, and the
> > driver reads it to set a transmit limit for each frequency range. It
> > only fills in the ranges themselves when it registers the device.
> >
> > The startup step that does this existed already, but it never programmed
> > anything. These two commits made it run a regulatory update instead,
> > which sets the limits on the way through, long before registration. So on
> > a machine that has the table the driver reads through an empty pointer
> > and the interface never appears:
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000004
> >   RIP: 0010:mt792x_init_acpi_sar_power
> >   Call Trace:
> >    mt7921_set_tx_sar_pwr
> >    mt7921_mcu_regd_update
> >    mt7921_regd_update
> >    mt7921_run_firmware
> >    mt7921e_mcu_init
> >    mt7921_init_work
> >
> > Skip it when the ranges are missing. They are applied again once the
> > device is up, which is where they came from before.
> >
> > Reported-by: Klara Modin <klarasmodin@gmail.com>
> > Closes: https://lore.kernel.org/linux-wireless/aoyxqHYvSuaBeubf@soda.int.kasm.eu/
> > Fixes: 9b80bd9cab40 ("wifi: mt76: mt7921: add regulatory wiphy self manager support")
> > Fixes: e9f3f1cc133f ("wifi: mt76: mt7925: add regulatory wiphy self manager support")
> > Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> > ---
> >
> > Reproduced on both chips before sending, an MT7922 and an MT7925, and the
> > fix clears both. Neither machine here ships a vendor power table, so I
> > supplied one through an ACPI override in the initrd. It also wants recent
> > firmware. The June builds do not turn on self-managed regulatory and
> > nothing happens; the builds now in linux-firmware do, and then it dies
> > exactly as reported with no interface at all. Patched, both come up and
> > scan normally, and the injected limits still show through in the power
> > table afterwards, so the skip does not lose them.
> >
> > With that table still in place and the fix absent, backing out the mt7921
> > commit on its own also boots clean, so the table is not what causes this.
> >
>
> Thanks for the quick fix!
>
> Regards,
> Tested-by: Klara Modin <klarasmodin@gmail.com>
>
> >  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> > index 946dd7956e4a..b468051fbe68 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> > @@ -323,7 +323,8 @@ int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default)
> >  	const struct cfg80211_sar_capa *capa = phy->mt76->hw->wiphy->sar_capa;
> >  	int i;
> >
> > -	if (!phy->acpisar || !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
> > +	if (!capa || !phy->acpisar ||
> > +	    !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
> >  		return 0;
> >
> >  	/* When ACPI SAR enabled in HW, we should apply rules for .frp
> > --
> > 2.55.0
> >
