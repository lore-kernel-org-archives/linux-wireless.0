Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714372;
	b=od62B7IuCWEnkHuAib/bIJrbfURb9iSgC+TWFLgnaf/t+KTqOgNcPQ7jM6NfN3lLbxc9
	 PiRZdeKmEnyryIazrDsspVPxANVBjmn1oEXxBDbWjqOfTbW+GUSyxeJVlxq+4zV9RRzFk
	 goRggnMHUBSs5sKcJymhn1vMUIxWNmc/oRZNHVXVD+qIIPnT0r+h/OAjJCeIWzmvgRG8o
	 afZD6IRWyO0ez85Dckc5sYYSmplqw7zPAP2SzC+N1D2XLldMrq5cALCeGVXzBtYb5b6yJ
	 oKoy+JcuZqYLphptadVQ0xUoaDNJaNGtGGqXJ6gHJK+AVQQqUZVsc5w9PcIpXvOIpvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714372;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=Qngkg57Ni1YhWMlAtKTzwfofY3KWH3EsG38ilqqk6Gk=;
	b=vAvK+oQjAKW5dVQcNxSn5MBRpyGBEnCVZSjD9zwq4uablqsOjckPV7ss9652INuMvhlp
	 q1vMty9O6Af6zGGxLsz32KQiZEObotr7Y5aaUSON6T9I1xUHPxSHf2Cqh5pn1xO35wxn4
	 5ctqrZZS7pnlxPbWwgs6eEnyeAuAJW2VYGZVAw/MBkXtBAarSy+XC9wZg5C8FvytNEg1p
	 iXlaWB3BhndvLmJKUnFwyVoDwHwzjZn3jPFXNkPUxKZeLcewmFGyGWxYwUkfPypXrE+Rb
	 iZjAq0DlHxZDYNoTeWzCZfnfMWCFyrgrlHpzTwidz6/CvOvnnXbdK1BLh9c2fqLR6Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RAZNGhku;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3543606A326
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3543606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RAZNGhku
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso1911982a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714371; x=1794319171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qngkg57Ni1YhWMlAtKTzwfofY3KWH3EsG38ilqqk6Gk=;
        b=Jsj3hNkMAZMf2v/KW0qs9/rsGCLPP+NyJYb1LW6SuzyC2DBdY6iwj7VEc7zywjymp+
         R5cWdYHFXh3MZRYNopQyVEYpn2HkknabZQEGLreLuCTmwkbNk/sYJuHto7WaNRwsimOi
         LEY6YgMDAGNuyvOg41kGxgyhYZYRAnVZu37zJ+d9bU/C7pxUqkvhDNgxZt/i5Ic2jX1T
         2XYMYzKLaaRTVRUlNMXunAQwftrhu9ZFR9sGm1YDFcHPyWAFzBriGq2Sm9TUH1YllEj3
         8ASanERbjocPVY+5hIGNBG30VBdBslGrgBqdN6WgTR3vQ3lppuwnJA9W5NuLLFEZIbae
         6y4Q==
X-Forwarded-Encrypted: i=1; AKwUvBw39n2I1dDtVENg6HeFWeNdt1lFtqRci+wy/olGNzHBHM8snHUPW8ljnIteT5FQtESTXyRdpy9NHxihXIAPuA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8QXVtktmYgWCeJ2gnI2zlclB+re3vrMrHV+O7iY4tAI3CkRQ5A
	Nm/evq1h6mQ+tLDXG6482KskKGCbZdd+Zjnue3u1zWGKZ4Z7smEOEK10S1iS1Ig31ncgwSrgBzR
	GXAWGUVjqJrj35IkgdJ/28YNO5YY7CnOR4m/6w4sodZwhMMZ5XtYAsoR21ttD8k/vaFTecCpsQb
	Q2LsEFHJLzdnC2Oql3iAfSvYCvXYOF+u4T4tsSxUUd6J95CWSMIH1pWgm+W3uYhctdtWC2621Ew
	yc4/HbeXnHZdTJ5KNGuHZYSSZ9g
X-Gm-Gg: AYBFou28bki4gpTaWd7t8Y97taLOTGGxV2hL0l38U3RKyNrGiPWo0mIdNbLhwkBAlyq
	V4OI6PoLiwQL5SUTG4dWEKK7+AnzmIKRhhH/z4MRn+3ZBu8WbeQfT7oMk5Neke5fChhf0pt9/0/
	uU7QAfzqY9pcxqLa7g6jdpIS4SC5yb8lTUSfMIA/mSjM+sNouvUE3PPHPOoUXC7jsWBCCGOhCI+
	BUaZ2b4K31SXrx9Fz2dOP1/Bhc07IQg97DtD0sIiRMaWNf17e1GdgnROkoNmxaypV7dRaSdsRIn
	UUvxwC+B+vrAxlGWJgrVkX1VnpdYYQAgiTVUaaqUfQBSrDwRNT1wfGw/clK8Mf5Q2qOdSIAgzRg
	8625LkFz/tK99Mzj88URGRzCSk9ipypmQipdJkRBEBIAjLG5eNc6nwjQAPk68TwxI6KtEvHY4vl
	z2asWgRc1C/ouy3ryek+j41raiTfvpWb3jxPgJzoA=
X-Received: by 2002:a17:90b:4483:b0:3ac:9259:1234 with SMTP id 98e67ed59e1d1-3ae8979ba8emr10772810a91.39.1793714370956;
        Tue, 03 Nov 2026 05:59:30 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07ca36545sm1865102a91.5.2026.11.03.05.59.30
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:30 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1a5005fd0f8so3930708c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714369; x=1794319169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qngkg57Ni1YhWMlAtKTzwfofY3KWH3EsG38ilqqk6Gk=;
        b=RAZNGhkubzobtBl4XQ6QFZ+ZtDKkdhhSh6Cx9T8qqPrlLIpp2UDEVY6JmFOwtgrnMM
         TCmFIzXB8qTb8c2uqPPWKqn7c3x0f0JV2S81PvfAt+vtQYo1AMDSgKqQOh8fw2b44F3T
         uctOB0YWbGBqphDVaGgiwxPG/yYuj9s+Er5kU=
X-Forwarded-Encrypted: i=1; AKwUvBw9IS49MDB9E51lPocSC6ebjna9YMRVbzCAnvbErYdw8jcNci9KQXrBk/LrSBb1uoQWNG0ULN2MTKmMDXLa4g==@vger.kernel.org
X-Received: by 2002:a05:7022:ec85:b0:15a:2b63:a0cb with SMTP id a92af1059eb24-1ac59dd081cmr26545027c88.13.1793714368800;
        Tue, 03 Nov 2026 05:59:28 -0800 (PST)
X-Received: by 2002:a05:7022:ec85:b0:15a:2b63:a0cb with SMTP id a92af1059eb24-1ac59dd081cmr26544986c88.13.1793714368146;
        Tue, 03 Nov 2026 05:59:28 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:27 -0800 (PST)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Michael Reeves <michael.reeves077@gmail.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
	Mathy Vanhoef <vanhoefm@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	asahi@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Daniel Berlin <dberlin@dberlin.org>,
	Janne Grunau <j@jannau.net>,
	linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-hardening@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 09/13] wifi: brcmfmac: Accept newer BSS information versions
Date: Tue,  3 Nov 2026 14:58:49 +0100
Message-ID: <20261103135856.3676311-6-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-9-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-9-b5cbc2cde2fb@gmail.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 25 Sep 2026 23:43:44 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Hector Martin <marcan@marcan.st>
>
> The driver accepts only BSS information version 109, rejecting scan
> results with newer versions even though the common fields used for
> reporting remain compatible.
>
> Accept versions 109 through 112 when reporting scan results.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   | 5 +++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h | 3 ++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
