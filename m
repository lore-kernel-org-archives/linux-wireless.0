Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729564;
	b=U3F9e9LVM2GHbclm8y9QbI+Y0KOnpJG++1q5qZ02fr1UGHnOPunJKrVCWX/t87pkAL/4
	 JoMQtTQJVwES+HDiPUJGMzOkF+SPyWvs1L+gnK63n819eBEUV9cbzR4qn745qqWNUk2t5
	 fTEoiyz2EZxHCKXBXsGU66rxLScGiGB6KAETPi2IHw5GTTQusobIl7d2UDb3JrTcJtMJ+
	 qTd7KvNdmHbd4EG1mK9RvmRJyYFIBqIdimtf/Wp/X9z06R9GxYeZMmiLy5Cb+UEtSj6sp
	 hpcq46kB5cLGb37zlELhQjptPE6tW+tBdGfsSgk6+iJsxZvhgEK1uTGwG9gDaOTxhGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Content-Transfer-Encoding:Message-Id:References:To:X-Mailer;
	bh=307AF/jEOxbdpPS8rhJxDrUHxY2uVxJwujwuyFVAf7c=;
	b=ptXcp9tvMjDUF2FUL/TPvWSwc2Y6AaPnm8riA7czuoj0fSuoivM5uE/g81fvAEE21d/W
	 8kTCKRErz+fuq31VaYfndhKG7XJJ+ONoIy64OKQSzfHv2wKnhBImhBiyt7xEJbGEAtbTR
	 /J8I9jnM0kk+4vUX6GqpUiaMfgUJFiWMuMDSILyeRdG1Li4AaEW47QtydLNx8pkih60/v
	 OS8UgAYcyK+GXskK5qGn9lz/thhr3jNvoLVplfExjgpv5XvYNE4CJWkZbJousoIhYAxzw
	 uSlwyaY87NlkdP5TNllWBO42fXEanxJLNVVgT/srokZGvfFrYgHzBQE3ddjEZkZkAVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lPmTlVuZ;
	arc=none smtp.remote-ip=74.125.224.54
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1406E606A31B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 18:12:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1406E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lPmTlVuZ
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-6798c43a3d6so3179127d50.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 10:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793729563; x=1794334363; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=307AF/jEOxbdpPS8rhJxDrUHxY2uVxJwujwuyFVAf7c=;
        b=lPmTlVuZaie32YitYcw8ewUSq1a0d5xY4pNB8Y3Pz5yp3/hWitDKu64bl/LLBmrf7w
         hSeaZG2OJG7madkDL+zxENL7mILzkP3UvMtKfNoW/kkIOHOcg1gNAQwWyddeQ+A5Wpkj
         eWglqiezygYtyxdqEE4Ki389kL0/lABwgrWlLDLDxqaSSJPDXjbmozMRGgpRDr9mXF/M
         oweJ1MyQVfy6xKlLxBwVyWgaXMTXdeEPsYYZ8rPlL4XJY3+YC+maiJQWAk1wrLUdXAcZ
         8q/6N18sh4DKXQpTvUSFgmMo7uQ1KUQninBUa2vShbox5x4rTYI8oALkIqnf1FtUcYSv
         KkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793729563; x=1794334363;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=307AF/jEOxbdpPS8rhJxDrUHxY2uVxJwujwuyFVAf7c=;
        b=cHhbbkwMSlyl2mpMA+jwu8Na1PaAchBQd70OPMmFeQrD4Kn6gOr8XqhKe3oMyBerB+
         Bm8gnfKIKJbOqfgOIgx7IimCYY0b9P13EaNbAjWbLemcT6Ko/gFDrrLLgNpHVUQh5kDX
         wEQybSZh6gGts2az8zT59b/k77DHsJ0HHZTLJdlFQ2GVye2+jm5Iae4n5s0dPVOwhlRb
         /gLHUdAIzbuSzxlzsQfZQfHWwdH7cPMI66LHGyavwaKNYSShYV2O5IlyU8zRrAF/wKMx
         7NJBtP31eDdMEAA7XAFSHEvSYrH3WqHEu9JJRbsSqnQf6rUfIKH9A/stLaB9eLfyeEHj
         yRDg==
X-Forwarded-Encrypted: i=1; AKwUvBw8gIVV0+e/c4+Bvhw1NDRQ6T4uxNitHhR+CwfggDYVE1izhuOLFtXTMMeSSFb07XCBKfsQEktjiXX0a3As0g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/zsCV719mXe9sHTC4OnA2LUP9K+eaONPjMzfflp5JkHa+VNFqs
	C+pvN9zukQJ6NGBRg5lP/iCTyF3TOilRfsx13hetsDMXfUB1PQ8wZQ+0
X-Gm-Gg: AYBFou2qeZRDLg5LtbaqSbycAoLdzGGUQSU65ncrYBS7wvCzSRBZth69Ak+jy/ZvMX8
	7aT4hnv8HfJ/CvZwBRUEgenq+xQfczfkEPyeyHHasTktFOs737uIVEXkjUyIMKjZ7OyjKbAUqXG
	J3YGCpgfUo5YLfiMShci+vyEacsAOJs2h7UifxRYNCoUg6eMJ2j/MNALSAVaAi+nwZJuziV7hxR
	2NQtBgJPUwjg0Rqo+Vu6C7uRSAvmD0jACow5gqe8kCxgWoArj5ARYffzwkSACQyufUse43x+vJh
	il83KvVeALPoV/jthQfOgfw37hYribsP35Rj2ivUZEXXh4cxhy1sxB8Pz1hUoGvmpI6Pi3ir7tc
	w7HzbjyWmbTle6927mvfkFXznWL6JeueMbFFGe7X0+d5qKspjSpQ5gVURe2WKDHpbrkRo2iQjY+
	iZ8C1sA/B20p9GZ/5YOro6iQ4JL1BcsP5Jfv0GzdYhIkeDX0phuI13sVpugKrMmzfalJMqjhUgC
	fCihNnuwvDMjr9KFGIaR+LilcWtUzSt6hj+pj9jDI5vo1Be6O7hQfu/AB6pxEh6XW0q5Fu3/DQK
	Q7Y2rAtfLVNF4lxT+853Tz/ay16miFNU0puu6tMT2uLGNoizVnjWayK1QfWX7x7bTvQvnwZfofm
	Y6WUf88NyeQ==
X-Received: by 2002:a05:690e:dcb:b0:67a:2ca2:8a3d with SMTP id 956f58d0204a3-67ba4c8842dmr7196675d50.17.1793729563101;
        Tue, 03 Nov 2026 10:12:43 -0800 (PST)
Received: from smtpclient.apple (1433037-static.lxtnkya4.metronetinc.net. [162.221.218.20])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3098c3122sm2112597b3.14.2026.11.03.10.12.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:12:42 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH wireless-next v3] wifi: brcmfmac: pcie: restore FEM
 control pin mode on Apple BCM43602
From: BJ Hinkle <bjhinkle@gmail.com>
In-Reply-To: <20261101172011.1591620-1-dolph-in@yandex.ru>
Date: Tue, 3 Nov 2026 13:12:32 -0500
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
 linux-wireless@vger.kernel.org,
 brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com,
 Angel Lindo <angellindo@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <908B5B94-5092-40DD-92D9-B19E9E68D52A@gmail.com>
References: <20261101172011.1591620-1-dolph-in@yandex.ru>
To: Sergey Armodin <dolph-in@yandex.ru>
X-Mailer: Apple Mail (2.3901.200.71.1.16)

Tested on a MacBookPro14,2 (BCM43602, subsystem 106b:0157) with this =
patch applied to Omarchy's 7.2.15 kernel.

This machine unloads brcmfmac before suspend and loads it again after =
resume. For the test, the sleep hook that normally sets bit 4 only read =
chipcontrol, with the driver unbound. After each of two deep suspends on =
battery, about 4 minutes each, it read 0x00000000. The driver then =
logged "chipcontrol 0x00000000, setting discrete FEM control mode", and =
5 GHz reconnected within 5 seconds with no status_code=3D16 rejects.

Tested-by: BJ Hinkle <bjhinkle@gmail.com> # MacBookPro14,2=
