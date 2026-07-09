Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04D405C21
	for <linux-wireless@vger.kernel.org>; Thu,  9 Jul 2026 10:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593106; cv=none; b=Q4Nh0laUhb9oiHh3hjMBXnDNulpst7QEt+l7nSXhLubPVfxxqOjct/0KHSDJwjIc+PNta4MCwQYcqiFM022rxfwSZad1S4UFggN/rDhX6RQbfkmQSAkC+zK1a4QLZ0ZmkR+tZ1bfe1TmMYQWRWV+fpLA5l/5ErAugDYpdTBCo34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593106; c=relaxed/simple;
	bh=bkGDrjyp7BoAJ8gSCUqiXYy8cBZwW2copI1MI2niZiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vh8xwuXoqSClkAkhnttv7CiPQkVhAQrqe8J88xBZ3EsZLCifEnAYbFEP+XBSd8JzAlSSIiaZPOpphjuTCdfCQJtTCYIkWJP6NyUYD0PnhdWS7ZDhkAhY6pL2lpe/CnMI1118Zs2PJQmEKY1VjWg8jfbKY1YzQ1Rlbc3pzGtLEyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qYa46C/e; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qYa46C/e"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493bab44440so4755365e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2026 03:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783593103; x=1784197903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uiIX7H92MqDl259vct1uhevovCX0Rz9AvH1RwwqdTY8=;
        b=qYa46C/e8WTfCdxbqnPukGd8QhRf2oUkeKLAg/qn0kk3WAHaUjdMCpZAOMnKQv/GJ8
         ad/8+BhbgENZjskDtWT1wnxvqy/zZnr9BT7GvYvt68Naql1OsDikUBzmOXd0gyyv5BDh
         tEdrjbzRjaPpsj7d4fbcP4jL7LwexKC50fz7Q0ucscyzXY4MBdzBEHyPsIGJHx6LKgsv
         cF7XTUksAgPz2B9oKdc0Reuqdf6pbIRmHcOUhYBSFCE/8PsTNaisYbMhhIk2qkMMg3kK
         FStEsWtbiUnLyPFfkSyMn1yopSXybEipmDQongTmXZ0wSfyehEjXF27vYy2g7q41+gqB
         IzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783593103; x=1784197903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uiIX7H92MqDl259vct1uhevovCX0Rz9AvH1RwwqdTY8=;
        b=M4EA604Yi9yWhUUe5jhNaLZ687Wxbjy73LZIxaJjW7wIvOhcakNYIonyRk1rd4/+WE
         X5gVPD1lM5j2ABaAlFYBOypmeaAwFN6SElhTFGjbfTZrGe48bG7SrU8JtofRCQNGm6MS
         13qsVEsbFZw1sPkpvlluxOaVpIczgzOfhpU/ApEI03wvrWWENDMemIDTVg7k1mnKr+zY
         k4xZOvpuDYBBZoNLekI7kJFfv6TtC1mk3DwhSLxKM4AZOg1ChqG4RqlbiDdOs3p3/tXe
         KQkdepmVzUXg4l510FS88bs8A3wYUVx2KUEEZO7/LcucDdAFzjxW8OqvMOciOy02RNip
         fSsw==
X-Gm-Message-State: AOJu0YxE5IfTJCy+qJLq9Ahphm8MbfEQQeNcSE1HBjCz8ssExyXFKNh5
	jWtpCqtKMWREin5NMkRj9xv3Q7KYvR5LLdCeMjtn9buXRgfqan3sidu+aVnREtTN0bs=
X-Gm-Gg: AfdE7clq2xd7gkna0r/oVb+KqJ94bu3PX9at8tJmNRY/28WlFysUqEt1FY6L9PXRDbn
	pmgLlmQJMa8hLGgeQaK2KTt3v9KPv3AJPPtFzX2oWzHlYKkMnhslaysIOTKNcmJCo2lAkLmkIkY
	oTF1yNAZH1ciLXvTauxAt5VHBjayyimlaU7jxrBuWFJpb3dVmYCrMM/6WAYlHW/jrGNZT3ueh1V
	xZpz/LOClcuXUoQaUZef8atfoU9n1CW9jnqEZe1NZIoVcbOw2Ma+IgACbs69+NztVqbEO8i6OAs
	Tr2GUU+IdAxyxEYrWPZ+NDPgUl5hXA7G7qNMTiTdaW/pj4+N2dNfe4v2UHktG3+03l0G9IbOFwA
	j4J1P/aFQu6VSwWEaJitiKIvblwOB8FdbIyVPh3FT+AKJC5ZXkKnzURzvm8KumeUrSKIL4Hi8Pc
	REZlfhlX9ZX07S22fCfq88MTMseAsCh9fD25YV
X-Received: by 2002:a05:600c:c3cb:10b0:490:af63:2cb1 with SMTP id 5b1f17b1804b1-493ec6611abmr16493495e9.7.1783593102637;
        Thu, 09 Jul 2026 03:31:42 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb74b3edsm57297315e9.15.2026.07.09.03.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 03:31:41 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: Re: [PATCH 0/4] wifi: rtw89: advertise WFA-certified EHT capabilities for 8922a
Date: Thu,  9 Jul 2026 12:31:38 +0200
Message-ID: <20260709103138.1269594-1-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <7e092f6cf82c4bb18b59ba5eca40dbb5@realtek.com>
References: <cover.1777832019.git.loukot@gmail.com> <7e092f6cf82c4bb18b59ba5eca40dbb5@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 6 May 2026, Ping-Ke Shih wrote:

> Wi-Fi Component Operating System: Windows
>
> That means hardware is capable, but Linux driver might need more
> implementation, not just declaration. I will ask internal to check them.
>
> But I think it is not necessary to add this link as reference.

Agreed on both points, thanks for the correction. I went back over
each capability with that lens, and it changed the series more than
I expected:

- TTLM (was 3/4): you are right. H2C_FUNC_MLO_TTLM is defined but
  not wired anywhere in the driver, so advertising it would be
  declaration without implementation. Dropped.

- Restricted TWT (was part of 1/4): no in-tree driver advertises
  IEEE80211_EHT_MAC_CAP0_RESTRICTED_TWT for a STA today, and I
  cannot verify what the firmware needs. Dropped.

- Rx 1024/4096-QAM in less-than-242-tone RU (was 2/4): I had
  mischaracterized this bit as generic multi-RU receive support;
  it is specifically about high-order QAM on small RUs, which I
  cannot verify at the PHY level. Dropped.

- EHT OM Control (was 4/4): the drivers that set this for a STA
  (iwlwifi, mt7925) also advertise HE OMI control on the STA
  iftype, which rtw89 sets only for AP. Advertising the EHT
  extension without the HE base looked inconsistent, so I dropped
  it rather than widen the change to the shared HE path.

If your internal check concludes any of these are supportable as-is,
I am happy to bring them back as follow-ups with the right
justification.

> I'd like to know if these patches have explicit improvement to you?
> Or you only test these without regression?

Only the EML capabilities patch has an explicit improvement: in A/B
testing on my RTL8922AU against a TP-Link Deco BE63, ML association
without it came up with a single link, and with it both the 5 GHz
and 6 GHz links are set up (debugfs link-1/link-2, active_links
behaving as expected for EMLSR), stable across 60+ hour soaks. The
other three were no-regression only, which is part of why v2 drops
them.

v2 is therefore that single patch, and follows.

Louis
