Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08A14EE862
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 22:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375704; cv=none; b=XkGnBC4wnldKKLUWGEikVP7MdpDTCWQWl3gO7u9TcTTH/y913qvVuImXTFr1te7ojo+8B9Ml6Hf5Rwt3V5u6o6dlw34DIQyJclmHLgv3OP/TQOFfOj1a/qoEtJ4WMi7oLC0GZtNPbFpUjBKhdi4e2WlstKvm0osRjmYcNey2D6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375704; c=relaxed/simple;
	bh=NfuJ+ulKb7PoJieV1+7TH+pCz3TxmNiK7fjksCT87fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pP1HCbHRFKi71f2UuTzY/3dsFEDi1nMODcA3OUR1mpruy6A+KAGRqauQubFRFr7vCywyrYvJN8TBIYO1Dd+YlEZJ8fo16LzF8MouRZQaqZwxkYIGq4rJ207oVRt4Jcf9AMmCtc1HnQidlznBYgH6gOaKCJ6pbl9hSXOygab0BXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bxxBFNzA; arc=none smtp.client-ip=74.125.229.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bxxBFNzA"
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-145ab8fd39cso1238153c88.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790375702; x=1790980502; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HnhwV0sMyfX8Q0UH1SywwM5PpJXEsDt0+jjzY6WI5t8=;
        b=bxxBFNzAfDqw0kIavQ6Hz92CcpOfyhWpa6ynCfsmMjt+fQ8u3vygQb/OA4aXxYzbFu
         6bZTN5CG7I9JpWyT2hyqGM3ruZoWECUZzAxYfxc0WhsONAkcuh8p1Kf7jeZb8YtLlJow
         eW6u6OiFSaKqJUTgMMYjcNcJeiJLAUh4IpEfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790375702; x=1790980502;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HnhwV0sMyfX8Q0UH1SywwM5PpJXEsDt0+jjzY6WI5t8=;
        b=xe6kbdOxo/lJIue1377Ng0iR0FvPeKxJWdGTg5yvDgqByadGOLCHags07kSQQoPlIF
         wrQaBAoJ3lau/L1ovPs90JlOCvgBhG5DtG2QsCD0B/6CB60saTT35DoVqi2tWhYLwZRK
         q0yfTFly9tYL4MP+ZIGAtWLJgp06dlFwA7VFqwqD3XJlZqfbotUR6BsJ4PuHwKXGNw/E
         9AHPd0UZYhCH7vSSVQkwbMMfPBXnpnvAxch6DrhEMCKQU2pn7u5Yk09Tzq28ga7IS6Dr
         ZhH63Oku3n8tIB09c2FfdzAyrOVT6t8RDbaKDH54C+CL3iDvcfjvxvcTd3+UlLivj929
         C7JQ==
X-Forwarded-Encrypted: i=1; AKwUvBxX3Vuln0FiRFRAbfTWwzWoPO0T5JPTdrej36ZNVzZEw/khLfHCNedYR17nuhwuep8C7NDnxR9R/9aP6NJwzA==@vger.kernel.org
X-Gm-Message-State: AFuF++kuPd9wQBXbrYIGVbaIXwofJUWEY9ITM52pY+sfgEzSXCpZOR7o
	Ykf6gi7rlNMQMuLUNUcX8lk3LcujJbZ0SVcMOpZnzMfOCi6dhvXl1cbWwzVatmNyt+wmSifRZZs
	szKg=
X-Gm-Gg: AYBFou0+K7zg7z2HizAGjZGAk1SzXTMlrGl+yX+L2RKjC0FUllK4dx4FAmOa4Sd3LxR
	XRYSZ8DocqY7SooFRxOvvVLURP11SGiD2OgQtsUq1K5+6ONgVpe6bSGpneKe2cD5CE0RN6av9DU
	RjXTIdBt7EbS8aBfiQiVf9y2zEx0RHMXxQtaeiWnRxEI5GX6p+voOtJFAXfksd5OQoMGN/XXBcA
	3xVu5ktMEAhdJC7volcKii5o+MHD1Y7QeMjgw4vB33FLvZECTLjzEmSYhl9pQz+8AHmxPSPjZYe
	MxbkPgia+nizKpwn2WRpQtmt/NeL2DAkp4MYTOJxcHbEBdOOO8n5KJlA+7ITgxXQfVAC05VBoz6
	lBJ9SC0OFOelLtmJHx3TSAy+N/0QH9uATxW1lOYEBsyMDMtXd40p2FGtVQpYKJ9LpSqvxmwhn4z
	q133sPPXfkRmza4AK1RBV5sOeY/r97SuKLP3BT4nqhFp3MY4u25/WGh0Afwmp5xJyIMAX4g2Fu2
	U9nwc5fRQcY9cQHibwxaIxXw/NGf74FZNEYwQ==
X-Received: by 2002:a05:701b:20de:20b0:145:5c7:71bc with SMTP id a92af1059eb24-146cddbcfddmr1428825c88.5.1790375701802;
        Fri, 25 Sep 2026 15:35:01 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:41fb:1648:4395:5cc4])
        by smtp.gmail.com with UTF8SMTPSA id a92af1059eb24-145ac67c505sm7608861c88.5.2026.09.25.15.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 15:35:01 -0700 (PDT)
Date: Fri, 25 Sep 2026 15:34:59 -0700
From: Brian Norris <briannorris@chromium.org>
To: Tianchu Chen <tianchu.chen@linux.dev>
Cc: francesco@dolcini.it, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: bound SDIO fw dump count by memory table
 size
Message-ID: <arb3E_cVtzMC5eKj@google.com>
References: <7d886d74276c05eeb1b1698e31b72a5aed98612a@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d886d74276c05eeb1b1698e31b72a5aed98612a@linux.dev>

On Fri, Sep 04, 2026 at 12:57:55PM +0000, Tianchu Chen wrote:
> From: Tianchu Chen <flynnnchen@tencent.com>
> 
> mwifiex_sdio_fw_dump() reads the number of memory regions (dump_num) from 
> a device register and uses it to index the static 15-entry
> mem_type_mapping_tbl[] without any bounds check. A bogus device can
> report a dump_num larger than the table, making each loop iteration
> store a vmalloc pointer and a device-controlled size past the end
> of the table into adjacent .data (up to ~5.7KB when dump_num is 255).
> 
> The dump path runs after command timeouts or firmware crashes, so a
> bogus device can first force an error to trigger the dump and
> then report a bogus dump_num.
> 
> Aborting the dump only loses the firmware snapshot; the card reset 
> that follows is unaffected, so error recovery still completes.
> 
> Discovered by Atuin - Automated Vulnerability Discovery Engine.
> 
> Fixes: 54881c6b37c8d ("mwifiex: add firmware dump feature for SDIO")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>

I'm not sure if we're in the business of distrusting SDIO registers, but
sure?

Acked-by: Brian Norris <briannorris@chromium.org>

We also read this same register a bit later and use it for computing
potentially-enormous buffers to allocate and fill. Dunno if we consider
OOM a potential vulnerability (or infinite loop / DoS, or ...).
