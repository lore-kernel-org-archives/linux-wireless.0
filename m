Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EB9470122
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 22:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375777; cv=none; b=UWL3qEPsRj4mJpQcLWWclFUYewEwDIRFwG1rmqG/iOJL/JN660lWqWXDv0ovO5XIfQxpdfN+4r9W62Ez9+FEy0rwYV3Eyct0TDUq0zvyFDfIRS9BEiFN45IhwLd2OsJrRPdYLAG+s2EakUsHvRUuZdC1jwHzqswcA/tXZPeV5K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375777; c=relaxed/simple;
	bh=R0pasx4rUDrTRnTIqVfyTz3shRNkybxi+9Y9dZyInBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=koVhZz1tCFaVmp+jWPbwQnMoA76y/7hwmw2/pQTjw58R3GfPZZ1+DpJuZBd+A6ALxrBMJxTig9Zf5HiuGpVajIUbh4WxJ03ZwPPNhNDw13wft53NcrBCZlpturu7G3wHQPZGE/3o4UceeQs81jsUcCnOqBFt17rO8ueURYLGiSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=SzFIaWNG; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SzFIaWNG"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3428f70d7e7so372111eec.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790375775; x=1790980575; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0z8m6GhqWG2S45oUhvOdavPteC1wXhqLqgxa71TJWLw=;
        b=SzFIaWNGjVGIaXDgS6ZFF/7lOeiet6Sfhs9m99G8RRTUtCWhKyUvN+XDk9aiR6OA2u
         bNvNf2hy87qhNa83zzEEUuwTuVlLqNqnJ5ZdbM6gUiMbjqMv1J+dYkjaH0Rt3P0ZuA1y
         Z+efj97w3/fB9sKIJLSO6UHWH9owhagwXwlZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790375775; x=1790980575;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0z8m6GhqWG2S45oUhvOdavPteC1wXhqLqgxa71TJWLw=;
        b=T+LgG/p91UJ4ZNaD6dz8caaZ9MSj25iz+ldgGtoHuPM53LZKRfX6S3rIZYA67T1CKb
         sZ5vrKEJ2TXdJ+sUJQqYFFtTxK+3LgF6bWcTdClPca/oqeRVWmEKMTsbFsnXOuJLOGqC
         UH9/y6QJUAXm3b/vLKTs9yFw847MlqZ/YFGxsLgIu9LtWmNiOCZtOykakAnLOvHW1nRF
         LXAQL5fPn7ECecloC2/fNU080+9HX7odVJRKb45RLTLvdNw5GqWtIEX/kRdS76f8X0fv
         YKPW29aEPuRjPhIZrEzT31tKxjUF3W+IbwsViDmcHQVNW10Fozd/NiR0TPNq3dJc4jXa
         XGRQ==
X-Gm-Message-State: AFuF++l7LrZoq+SUvpOnDkJVhCxbLk0L2DGxnGl77n/fW8T1tPmhOC9M
	gvF/fjFnwurszao7PO0W9qhhnulji9UVUVI5CUjHUmSP2lBcG9EL3n3vPduEel+07A==
X-Gm-Gg: AYBFou0UwMNxijnGyKDYXlz50VRqfbbEUunBeHWdGXkhlDZPYDMg9gHSxa7tzHUxsOU
	D9gjYCow82aYggcikoXxKnW4dF6wiFQ6hAt9AXVrXho6El6Lk9iAabkoJg04pqt2X3ix54/UYBM
	7UbBenLAODqDs5TnDCqY6WF2jfrjVsXAbpWhf5mOZ5Fcs66EuMQ13BBZ+KbHMyLb7yx2QSZ/Oag
	16cvEMfUZIxGuQZbI8YusLMU50xibv/YWes0ksO6NU6L4Q+giJTZD+7LnQ/YbIf5ajmOyGBPPIN
	pUZL9Irx/7lAz9TPbjgASm9uB/vJw59IKZVupDzJ3+471cfHn4QwHLukTY1KekIMTiE3SPmxtb3
	9nQNK//cVirhumv2zq8J3t/9pSwCDOf9XiFPjknIhIjNBvM+zuGsynK0wF0hdFI66Xy5T5WRG5a
	V6kakbKuZDerwgVHL3C7JFxaV2wOXepyuoNACbjWmdWiQhd+cILlIyhzOpgpjivJY1yU5ZrAHqY
	w1dC5Q4iLlx0hM2k3X1lSJN/rDYHuJBwmd9Qg==
X-Received: by 2002:a05:7301:a2d:b0:33c:e74:4625 with SMTP id 5a478bee46e88-34272b4a95emr1244017eec.28.1790375774652;
        Fri, 25 Sep 2026 15:36:14 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:41fb:1648:4395:5cc4])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-34141d2fe4bsm9134465eec.4.2026.09.25.15.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 15:36:14 -0700 (PDT)
Date: Fri, 25 Sep 2026 15:36:12 -0700
From: Brian Norris <briannorris@chromium.org>
To: Tianchu Chen <tianchu.chen@linux.dev>
Cc: linux-wireless@vger.kernel.org, francesco@dolcini.it
Subject: Re: [PATCH v2] wifi: mwifiex: bound SDIO fw dump count by memory
 table size
Message-ID: <arb3XMIIxzrGeGae@google.com>
References: <33a45fd59b5569cbce79142d2e012e191989ec26@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33a45fd59b5569cbce79142d2e012e191989ec26@linux.dev>

On Wed, Sep 23, 2026 at 02:43:51PM +0000, Tianchu Chen wrote:
> From: Tianchu Chen <flynnnchen@tencent.com>
> 
> mwifiex_sdio_fw_dump() reads the number of memory regions (dump_num)
> from a device register and uses it to index the static 15-entry
> mem_type_mapping_tbl[] without any bounds check.  A bogus device can
> report a dump_num larger than the table; each out-of-table loop
> iteration then reads entry->mem_name and entry->done_flag and stores
> a vmalloc pointer and a device-controlled size past the end of the
> table, into adjacent .data (up to ~5.6KiB when dump_num is 255).
> 
> The dump path runs after command timeouts or firmware crashes, so a
> bogus device can first force an error to trigger the dump and then
> report a bogus dump_num.
> 
> Limit dump_num to the table size instead of aborting the dump. This
> is not expected to change the behavior on normal devices.
> 
> Discovered by Atuin - Automated Vulnerability Discovery Engine.
> 
> Fixes: 54881c6b37c8d ("mwifiex: add firmware dump feature for SDIO")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
> ---
> v2: clamp dump_num to the table size and continue when bogus dump_num
> detected.

Oops, didn't notice v2 when reviewing v1. This is a valid choice too;
probably a better one.

Acked-by: Brian Norris <briannorris@chromium.org>
