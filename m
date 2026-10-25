Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792963815;
	b=RuHikL1oFFmPsHYzhKv+R0kr3E1547TYvP8ipg89eRfAJIrebOWyvuFUFDm/sVmRXdf9
	 KO5HoFX7uhjwwbrAFbxoW7Y5x6kQIeXPaCumZXsv8YUHhLGvQ+U+tBlZEK7KmNzFuALv6
	 rTddfbODxl65V2llj3g3mETzBV7veqj/88yfaP48NvFNHqhPaMtSMpXT4QYg6q5dhBZEO
	 O9uG5wxiaIK6NwNeR5le8wOOGoRXxmFAYkWKWSXNMPhIpZrQuIyWL1eg++mkJQ63TOwH3
	 XRXQbxkYFbLnH39VCUHatJ2umab7dMVP2dJUUSz06EetGgXaP2kGYefNC2QfG+8/B1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792963815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/2eFiE3bQ464FmO2JJo4VW5PfHFjibC+F4cl51xjGiE=;
	b=4MZW4woURBEzrm+EOgfvX8OT+sGVf2JhpXb8F3PUhGp/nTssllELLzTQUc4gL+fs5ANs
	 ac4YpBExKf5Yi5FTxO75EOJFXpavqbaTuuvGhDlrAh5lbc8johUXElTAbpVCtq/DPdXGZ
	 c/FA0hxAtl/zr+m35D+pfEPFBu9m74w7yYHjxlzeBg2+sdgU/tK1XoLGkgPqFlBXuymqz
	 EV4JyQTHsbSO7n+aM/LJqjXPT5b5EIOn239don61pYXokg/CZyraiS1TOb5Fx0GfEKWGY
	 T3Y/HQ6lKD0IRdwXMgRfXhtMnj/bFL7pMnj+R4e5iQ/CxMAfOZEZ+vQhdXYWP+z25DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fhCKYdsQ;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599C2606A31E
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 21:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 599C2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fhCKYdsQ
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2afa22e1dcso308871166b.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792963814; x=1793568614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/2eFiE3bQ464FmO2JJo4VW5PfHFjibC+F4cl51xjGiE=;
        b=fhCKYdsQ0OyMh6sfuOIAo3sWCrsg/U2CMwUsTWVoLNM6E4aIJSXdw6bxDKSvR4csCW
         E4HpFqoTo0lvGnx1G2acQkNs6fhk5ruW1hDejUFGLm/TqlCu/enFwrL79TAfmZmSSH8j
         zzQZoj3e2m+cedl/uDnFRFSNCGHFWaiD4lIuD58F4vO16fJxYTg2B0HGqUyWspn5902d
         KdN4e1YsyNdxzlA++oNeas/rKymOFsim22w8eVLmRbTZT46V22WHFoKCr67WKaR+WKEP
         XXKtSYgRO18cnwiUBo/5DC07QHztJNJBxPJHoq5vBif5AHhNVWGxWjP79WyCtd+90yMz
         4S0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792963814; x=1793568614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/2eFiE3bQ464FmO2JJo4VW5PfHFjibC+F4cl51xjGiE=;
        b=MnQtW43aoqP8YxTNxEHXLiEsMjtcJSEOZ8zzt/wCg6y4fL8Rp1hLaoofRDNMjsMlYj
         7V68xdJJ/z/TirjCtqJrIyihKdkeDfcKQ0EirgCaBZifMQO4UJq3RH/tQrstHFfQNU5e
         +a/rEJ+Omycd7RLat43J1Ql090/SWDhgutmSaDSQaEsApUUXytXJ4XmRW5Vc3VahJEeQ
         Cmx9XWkz0JY+TleuA17L6a4rxjaldjrpwX5Z0m6+Fb7y6KaqqsAmKhSdINz6QxhqU0J2
         jwd3STzFRFSfLE0KRNIcpmRRb0pCKrX+WGXwUHT1idZtL5344Cywu/PGPQD34cc5HF/t
         EelA==
X-Forwarded-Encrypted: i=1; AKwUvBzaHcXtDHU7wle8cELWfUyL7WRJ+vIllZjrPjPC7kxHxB9DxuDujUNGKrmbu+JdNKHEFhdb6JSEiGpAijFBSA==@vger.kernel.org
X-Gm-Message-State: AFq9FYINTXWntZH1AeIgTfpmX/KCq2veOOye49GTbZ15DC1gpqzyIF8R
	EnB8LQ5pglEDr+9AACHboSpmh5EoHDUeyaAoc+Izytl3QD8I9dCgO+fL
X-Gm-Gg: AYBFou0htjA2GC6fbT0xM56/rcA+JUS0mu+tIlkIc7iAObSTQcAuCFtxh2QWlW9BLRr
	ZSBn69FoSADN+FrTthCZ35t1f2XzztXbb//3nlbG4v+d77Kv37tu4tvFyDaR/vZVoDxjCTsFyr2
	eCSgkb8Tt6szLc5GeOt8xx/m0OGRgRHsmbiP4fATasDgH5o91WgJpcJ7L/WEf8/j2qU65MtBTJ7
	cmR6GzEI1xAwDdigMjzAN1DmLX4z8VyUaZjcmbBNKZIo41dDH9oNRXA6ZPNNOhut+B6ul+KpaRa
	cOKV0H+oeIsA3bUPpQ49f8Hr8A/o760oGsqCt82xVJ02vXC2hzSgKP5gFcuMg+DLw1zbOIIdUHO
	OZ1NVGuZ+4tKC/ZUvL1XynYjevy9Seljvd0Nv8bvRImaCG66gH2FHHFGcvq547R1gCePuqxmvSq
	FhfN2ys4YDz9T4gaFUvGWYlJgst0BZpboRUoFmyL5VuUCJ6ZQ+ZYHGk7kTJf/uRmcy4gTs+veUP
	1FHHZHy0BzPgN9GcWFM9zAagpwbvmR6IfzW2zrKixg/bTy1fzODTXXX8v51jpw=
X-Received: by 2002:a17:906:dc95:b0:c34:83c0:b92b with SMTP id a640c23a62f3a-c46bde24eebmr627862566b.23.1792963813604;
        Sun, 25 Oct 2026 14:30:13 -0700 (PDT)
Received: from nb-xps.ts.zxczxc.org ([78.56.243.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd66e51fsm243556666b.64.2026.10.25.14.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 14:30:13 -0700 (PDT)
From: Nikolay Bryskin <nbryskin@gmail.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Hans de Goede <hansg@kernel.org>,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/4] driver core: add device_schedule_reprobe()
Date: Sun, 25 Oct 2026 23:29:48 +0200
Message-ID: <20261025212948.11474-1-nbryskin@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <4ffa0608d32b6a68e064b41b17b6d35096b9a7fc.1792203271.git.daniel@makrotopia.org>
References: <cover.1792203271.git.daniel@makrotopia.org> <4ffa0608d32b6a68e064b41b17b6d35096b9a7fc.1792203271.git.daniel@makrotopia.org>
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

On Sat, Oct 17, 2026 at 08:56:27AM +0000, Daniel Golle wrote:
> driver core: add device_schedule_reprobe()

Tested on a Dell XPS 13 9310 with 7.2.11, called from the .restore
callback of hci_qca (QCA6390 on serdev) to download the firmware again
after hibernation: the reprobe ran after restore and Bluetooth came
back, and s2idle suspend did not trigger it.

Tested-by: Nikolay Bryskin <nbryskin@gmail.com>
