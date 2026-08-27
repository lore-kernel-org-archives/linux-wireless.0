Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164F2331ED1
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787853762; cv=pass; b=YklFPp2LNsFK0Q3LkmT8DNcwEM5+IjaEiCjNCIU0WjumZj52XZG5oY2Ag7pPBQBc8xZUNF7Li2O91J+cFZXpZjQHGbSoYiXXuZp780o0qAv6F4m0pvCD34Ei/yKhLPC0XQQPf44iqX7RnMIzgKn/CydTDlq9dJLrXtACE2ozajE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787853762; c=relaxed/simple;
	bh=do51Gl5dKXox8vJq4RVAbo30sgZsNyHF3P929jzrUc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EuyvND4VbrqntYQo2DkRf3sfl2TF8xmqOUpztTC7hWeg41IQv9MNCA8U756wdGivOizeGV3N4LwAgTQ/F2dlkzQSzicn6ipoL94hub+tc8VlWfCRmMtH3z2p3po/PW/8e9Nczqb9tBu+xGlPc/dqbUK5xC/Ep2vPkEBSfrw0QVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n2eTbU+c; arc=pass smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n2eTbU+c"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39c74c469e8so878771fa.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 11:02:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787853759; cv=none;
        d=google.com; s=arc-20260327;
        b=CUDrYqs8Mk4Onf5CVoODndeErnvDwAHJrOj3BcFN3wdJZYTEbi/gnCD/Tw8pm3jvY6
         qRfEQ9sTL5BJ7JK4Wp8cWraMX79f9OfXKdr0xFy3H7a/D4/+7j7CESuM0i/oM7AUt7Op
         wRtwI3iTNraN5uElcMZgVoLG3CeLMULwGx8bCEBcYE4O6miA5sEk9nQmCtUuD4uOTxCp
         +gAlKxorc/KYkKhCFN2bS1smET1emsmOu/Wmmyw3YLJmNcI8EAdyboTw0TIDY2ghCo5Q
         Yz+dcSlsUaeIyvRo4e4XuFA+H2Au8YWlUnOPgkkJ+n/tgNgz+gTYWv9CX0hemTh0Dahs
         z2tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=do51Gl5dKXox8vJq4RVAbo30sgZsNyHF3P929jzrUc0=;
        fh=4jm5qFA+MFjbABh/kKXB+V6a1fn+oQyhzNDoX6kxWPk=;
        b=Ub2hev8U1ATD1HARQYXC3LmoYEoJ2ndZSIQxZUZ1t4nju0irg88daJpbQRvNbedV3F
         /nfNWjJvLayYoTCgwl/EdxTKZx4TLDmvTHJtQGVoCxMW4SSX8WbK+x97TfmMt9GIt5ZN
         6r/SO6pf3j6lmvtaI7w630QLZ3ZfoU7g3JD5I11oLHYZzvatTGi+hMa9m1dzyzA3Agkd
         wMsXR7jwEEwhX4jFkVRpERCssmdrNxMAToMcBRMn/V8tPMomApDfQWDzCWoYC7FHT01z
         i5wxFvouYPsJjLEJltZ1AwOv5HlSODCJy1meMg8uQyvCxQfEVNOJhSyvc9+oCoSRPOSQ
         vcfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787853759; x=1788458559; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=do51Gl5dKXox8vJq4RVAbo30sgZsNyHF3P929jzrUc0=;
        b=n2eTbU+cbSbMUPkABPoMoo/sPQBVCvk2x42AjW51PvgBG2QdJkfraFvAANsPASidPf
         hgKh55SR4U04ozjiNmctMMYi6DdS84DpFDoN2Dda88qInvjcUzOuiq8AaHJ1LjNrqYXd
         BAhTk8QE74rczrC8g2Jh+81993ycn/H9sglMjaRAEGLj3kDriJsfUGVhQPTBVWlfrmnM
         zQ9Wp/bpAoBBunLQ0c8S2qR+05WXHrFYD+5DAGN29/41yzzqdH/t6mpiJ4Kq+Ua+S6s2
         Miiilzi23ZCYmU1UCM3d56SBR7xCR6syP3wZvuI3HC5AgIaTtILZRsvwzhUPpXXaXyxW
         S6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787853759; x=1788458559;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=do51Gl5dKXox8vJq4RVAbo30sgZsNyHF3P929jzrUc0=;
        b=iulFN5Ad2tHJzrE/+Mg7p+0h8lVdi6qMldvn6O6geRmLjMu/idnQwCDcHnKnYqvKqZ
         qmJuywKHxccvfbcZee7r74MrXmdv2aOPfuHTKAMwgXQPfZaRlXRozsT+BMPnmg56isoJ
         JL3rmv/Fo/5Jaxhj1G4hPAsG4OAguhxz4FtQMz5yK7HZvHhxcgLv30/ltG89LoeqFPRe
         F8Je+pNtCZV8QPu1R5nxSeT5/JpyWXctey0X5XrloYj4m4Y7feoHCSPte6PrjCxhuUbN
         c/EqhbOlUbzNf6ePaA+S19wEHr2ZLQOyAxqymhAceFSlTHVcBYYmfmarCj2YYs8zUyJj
         fePg==
X-Forwarded-Encrypted: i=1; AHgh+RquYWoKiucu6jWPrPAg+yqOj+ffdExwvQboH3/Yw5y7At4ww6D1W31ydgcRfKlHieH3vHtXjWTyxKGhISo8tQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lX/Ml83wVpj9vVbB5Np4XI94Xm3gl+cERvxG8YohkLb9E+DQzM
	QeqTnyidSVghg7Yz2dbt+XgXVCKpMHD1Tiv4d6IZNfgjhnK/JLXCnc2TFCfPq4yhzmWrMMV8dZ8
	V/jFZlH0IooL7KGzZU4WnxDphytFuYEQ=
X-Gm-Gg: AR+sD11zsem6+TlrXNIHoixWnt54tPCe+RXc6eaQTxKeQnDX/Ang37TQjYKd/daJE+a
	VKP2P2PF/8EUrZTLaR4/lllzfNGwAV+0lpQdCyHyLnZ7QDUbqSGNKKkPVisKG1+5sNLXq1k7Val
	UEahzhsUmacuX20Srnv7w7oyHi06vPB50g3T23ssfww3FKON347cQz6wjqJSd9IwkYkoFidwDnu
	W9FRppQOxpcWk5Sy7Z7aPN6gXBiiRH3Sa+nWhoyMo3OO+lWmB4VOiSY2fKIwjGB9G3KrXb3xxnP
	Vx7z5rmm2aChYuWINtHxzqE11Ijl0EXyOMk28YuVZ7cJ8L2v7b0G7SQJpIFzTudwbrkeM9RS2Yc
	voev//hWOLVAUb6/s0Ys/zt57dg==
X-Received: by 2002:a05:651c:a11b:10b0:39c:9241:af65 with SMTP id
 38308e7fff4ca-3a301ac1f3amr415741fa.11.1787853758715; Thu, 27 Aug 2026
 11:02:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827171937.28878-1-gvalkov@gmail.com> <20260827171937.28878-3-gvalkov@gmail.com>
 <15F55ACD-E206-4B79-9E8D-1ED24427BB19@dolcini.it>
In-Reply-To: <15F55ACD-E206-4B79-9E8D-1ED24427BB19@dolcini.it>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 27 Aug 2026 21:02:27 +0300
X-Gm-Features: AcwNN1WhcJL-nGDx-lqXbkS4JNH0Ob2Z7Us1EwrenTLfU7VSU-Ti3TpW8tZnfmw
Message-ID: <CADOrJmae24XCgxFwtHssdoWc4rv1Q743hfgjG=kUrVPgf6urmw@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] ARM: dts: armada: WRT3200ACM: add marvell,invalid-reg-hint-in-rom
To: Francesco Dolcini <francesco@dolcini.it>
Cc: briannorris@chromium.org, johannes@sipsolutions.net, andrew@lunn.ch, 
	krzk+dt@kernel.org, johannes.berg@intel.com, kees@kernel.org, 
	miriam.rachel.korenblit@intel.com, rongqianfeng@vivo.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, arend.vanspriel@broadcom.com, 
	peddolla.reddy@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Aug 2026 at 20:40, Francesco Dolcini <francesco@dolcini.it> wrote:
>
>
>
> On 27 August 2026 19:19:37 CEST, Georgi Valkov <gvalkov@gmail.com> wrote:
> >WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> >from the mwifiex ROM, which conflicts with the platform regulatory
> >configuration on units sold outside the US market. For example:
> >- phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> >- phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> >- phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
> >
> >When the system boots, it detects a conflict between the user selected
> >region and the radios, e.g. BG FR US, and applies extreme restrictions,
> >preventing phy0 from starting on any DFS channel. phy2 works.
> >
> >Add node wifi@1 with a flag marvell,invalid-reg-hint-in-rom to the
> >WRT3200ACM device-tree, which signals mwifiex that its regulatory
> >hint from ROM conflicts with the platform and should be ignored, so the
> >platform regulatory domain can be used. This does not allow the user to
> >change the regulatory config of any radio. It only allows phy0 to start
> >and operate according to its certified configuration. All radios in
> >WRT3200ACM/WRT32x are locked to the hard-coded configuration for which
> >they are certified.
> >
> >On WRT3200ACM, the platform configuration is stored on the devinfo mtd3
> >partition, which is read-only: cert_region=EU modelNumber=WRT3200ACM-EU
> >
> >The Linux kernel sources do not have support for WRT32x. An equivalent
> >patch for these routers has to be sent to OpenWrt.
> >
> >[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
> >[2] https://github.com/openwrt/openwrt/issues/9956
> >
> >Cc: stable@vger.kernel.org
>
> This whole series is not material for stable. Please drop thia tag from all the patches.

Dropped CC: stable from all patches, and sent v9:
https://lore.kernel.org/linux-wireless/20260827175850.89395-1-gvalkov@gmail.com/T/#t

Thank you!
Georgi Valkov
