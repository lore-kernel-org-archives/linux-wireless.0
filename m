Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D30133A71A
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228422; cv=none; b=R9FwAhNF4PSxVSLJQz3TB0kYnIQ+I25/lzY2L5dmzZygSeB9Gcsh43BggddlN8bVamahGJh0iUfIzvUefx/6Rc7jzH/86Y4b49wDER4rgmY/nDN8qZaC5Fy2ZAYdyfulakXhEWpY0a+7Bvha2SpJh+Mtc6neTdwdde26c3dStQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228422; c=relaxed/simple;
	bh=rNfpXctYlmvNaplmhY2FuAjrYfZBZpsvr2kplLP4X4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QChQJD6NhX8ANrSDbuvK/ck47OpviYGq3rEL8lNCizDIRCRpN1rtUeIA72kiCWQbhL1geDh1E49C7BvsXyY6y33nwWdLKOj4YIojM0cQBQ1BtIEOevOQI0ih9wlnmx6kbp0uDwk8E56biD54e1IyMxdr8yZXAxDQgu1WuPbOdvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmJa6fOl; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmJa6fOl"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49e6bbf77e8so1240325e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 08:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789228419; x=1789833219; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l1EiVuUnkZLCw+oyWuYK9Ns90XQNUjgp3rWGW2uzObE=;
        b=UmJa6fOlpfnYF2eR/bBoxQ8TuVoAA6j7dg0HIpZBIO+YL5AZ0da6vLkZR8CZf+ly+s
         qlVMH0UynK/dDHTRlsf32WlLLvfa6rQNbOgO463b1c097pfhGGIdVWOoHYdK4vkRtFM7
         ew6TASqY40CkGtufb3jhR1GAkXT0e4BDCNakQCQsBJiiSPl7CivLvs6L3tNxniPZIFxL
         r6t/37uYhxSSwQeIfqmq2P103TuWoYHrEQIeIeDL5Gd+u83o5xpJkNd61joefuojV4Ue
         GQbcPZ7EfyDdEYXabvGR+NAclMYPpVv8VXf2MIxWBcKcwVc3F9F5NO/0jnCzBLkorW3j
         2h8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789228419; x=1789833219;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l1EiVuUnkZLCw+oyWuYK9Ns90XQNUjgp3rWGW2uzObE=;
        b=rZ2AsDHc+Bg5W2hUAcUZODUW2TtAstpy4eFbeW4Bhlu82Roda/zO88gK752rdabNaA
         Ojiyc/kkMyBdDoPLESsMXZcZwuCZWWpIqPL6crLT6bFPrBmXm5kW2X8zXLpmwELimx81
         tfZfFxAU0NGq2dInEbYgLLi7z6v2KrepKpfWcVtUbLxLS0Empmi6ybBY9gkP55oN2TXy
         T6C6/+pUkpkSERM1iw6gm8gtaRxjRl4Lb/B9+Bav9FDir/Z1FK+6FOlAa64y1ihpw7Xy
         wt6oe+QK5EYNpER1uHoEG753IvvRsqctKMkuEcpyRQdINjC36P3O9aYKSeB1NirSyUfa
         Fbrw==
X-Gm-Message-State: AFuF++lP79mrhLJiairE5FtoEO+vk0+RELar8TYXI3vR0dONgrfC3Gt6
	eo0lBqWh2MkkI5hVdRliVTBwj7CQvL3hHiOUFquh4ZEHSyDBwwf4qeG27BwrUmtOAgdGpg==
X-Gm-Gg: AYBFou2T7aHyyoy9EEX1Gz/JZAHIuHFicpUxUiA5Tdhv4a66twlT0ftLruLg55zzW5B
	8Veerrpk0mi/Zl8Si3ewpIPrj07Yq81l0D+N5rrdnxr9diD+0OQ3pp1mV525miHohCaOEBZm5Ex
	TLtuiCRIZEwGLoh852uxobLWxXrCCOql/8MkiJLzm8qcvBdrJz8ilzHONXxhOqjIDBQ114+c0lk
	dC3ivcWhPGGampTHfi3ry43OUb0nQCO7ALb+QtULMQSV7sAvrbfWggFUr7CQQaTwYHK5TcLgtAi
	G2/lLz8UI/Ti9qYseRpoFALYk5XsGIOfqrlQxOx+crUaJOEWKkSUDsJgT6b+2JS+dct4dBekMPM
	YbFd0DXbCotOjoS6LPOT3ys8OwLhiXG/Nv2lwqp21+96UmbVvY64NW6+1f75e6D3iqn5Ykm+WAu
	Kh1FFjSldTsozitIetCwRJmRsBAB6X9F5we1fK5VS73kpXSt5wbMQGFXfJoKE25Mqwf1wmBxnm+
	MIVpgTOk/SfyVWd+Ncy5qQUtFqX1buADuoLAZ013XWj9XokIkHWBb+U
X-Received: by 2002:a05:600c:b99:b0:49c:dca4:94c with SMTP id 5b1f17b1804b1-49e619b9d57mr205474485e9.13.1789228419097;
        Sat, 12 Sep 2026 08:53:39 -0700 (PDT)
Received: from fedora.fritz.box (dynamic-adsl-84-220-246-20.clienti.tiscali.it. [84.220.246.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6af095d7sm75829165e9.0.2026.09.12.08.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 08:53:38 -0700 (PDT)
Date: Sat, 12 Sep 2026 17:53:30 +0200
From: moosager <moosager90@gmail.com>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: mt7921e: failure to reset causes network drop
Message-ID: <aqVwl7fe5zHVYXT9@fedora.fritz.box>
References: <anG46qbvCqCHGF-f@fedora.fritz.box>
 <20260910055018.29328-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910055018.29328-1-lucid_duck@justthetip.ca>

Hi Devin,

> On debugging further, I had the same ownership handshake fail on a mini PC 
> here. What that ruled out, so you can skip them: in-tree against out-of-tree 
> builds, a PCI bus reset, remove and rescan, and a cold boot. The Bluetooth 
> half of the same chip kept working throughout, so the silicon was alive and 
> only the WiFi side was stuck.

I can confirm these are the things I've had to rule out with my testing as well.
I can also attest to the fact that the Bluetooth half of the chip works 
regardless of the Wi-Fi's state (I should've mentioned that earlier): I've used 
my laptop for a while with mt7921e unloaded, all the while Bluetooth was working 
the whole time.

> There is a patch for it that the maintainer has taken

Good, though I don't see which tree it has been merged in, I'm sure I'll see it 
soon in a future release.

> It sits downstream of your bad read though, so it will not stop the
> register going wrong in the first place.

True, I will stress that the root cause has not been found yet and this chip is 
still unusable for me (and others).

Sorry for the late reply, I'll test the output of lspci as well when I get the 
chance to debug this further.
