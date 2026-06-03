Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195D12BD00C
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514954; cv=none; b=gM3poRceqKjLFVCt2P5CVGWdRZeyYD8Wz5qNUfUc44MpCi2zl7A3Wgos43DBAmRSVVg+rWL0ShOxI/mxjVbNT82UEgvpJGOD3cFS4saWceYBBQS2k6vOfI+7CIxfJDTNKmXTR9pEqU6HjYZlv9/K4vTHzKta2Fl36eZxy5qRj5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514954; c=relaxed/simple;
	bh=b8s9MyaKyI5INLezHk1dcLXoNWO2SNHVAIksnvEGv/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZZk7eSPKUvTvmXJQCFZSQUAk5vRE9I+Qhyh61bpQ1dgRbEGEuNV2jRgMK4pHiJH//ATGWJz7gyhCDbTUC0mAM3VM9end8y30y95lN9MFWYI6RU5lue93Zcd1S/WGxnGu2Flzp4Y7uW6HScOevQIVsFvPAe8AwHFGUjrc9F+l0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=xGDSb7IA; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="xGDSb7IA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1780514950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nCFhc3WlhCwhpl8dws8Ce7awF49P1ZMA2kRsFwUbIGY=;
	b=xGDSb7IAxVdsiMyjxK4e1pZc9dHod6ApsA4llroP3m2qA0W5+vPBdzxhRlffuGIel2Et2d
	TRykfQYzwmWE4vpfmxdtVIVKUKWBl5NZEMXJ/+Am7403siaCSEKqb2v5QZI39JDjmVnxcL
	T3vzNTBqV1NllsDvxQduB+gWJ2vniY7TjUC8qB/mekFRCXHV0UULZJNrqMk9TGsTZgBU1P
	5JsERu6r1lvS4TN4VUZoS5sWC2mvcPtm8jbXX7hnUdvoKgcEm5Cis9IiRJyBRDnVXV6NF/
	q3zcU8gE1Ac/vkBh/bdmv4pgVyw2bJoGyOzBxozbpGnH6S0vCgC9eyva2B4JOg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-kernel@vger.kernel.org,
	Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>,
	fjhhz1997@gmail.com,
	Brite <brite.airgeddon@gmail.com>
Subject: [PATCH v5 0/1] wifi: mac80211: fix monitor mode frame capture for real chanctx drivers
Date: Wed,  3 Jun 2026 12:28:53 -0700
Message-ID: <cover.1780513445.git.lucid_duck@justthetip.ca>
In-Reply-To: <20260519235713.49109-1-lucid_duck@justthetip.ca>
References: <20260519235713.49109-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v4 [1] used list_first_or_null_rcu() plus an rcu_access_pointer() check
on the sole entry's list.next to confirm it was the only chanctx. As
Johannes pointed out [2], list.next is not an __rcu pointer, so that
check trips a sparse warning, and his original loop is cleaner. v5 walks
chanctx_list with list_for_each_entry_rcu() and takes the sole entry
instead, which builds clean.

v5 also switches the stable tag to the noautosel opt-out, since the fix
can crash older drivers and should not be auto-backported.

No functional change from v4, so the v3 Tested-by carries. I rebuilt v5
and reran the monitor injection test on mt7921e here, no crash.

[1] https://lore.kernel.org/linux-wireless/20260519235713.49109-1-lucid_duck@justthetip.ca/
[2] https://lore.kernel.org/linux-wireless/978c9a11cf836680b1fd9365f3b90f028ddf5372.camel@sipsolutions.net/

傅继晗 (1):
  wifi: mac80211: fix monitor mode frame capture for real chanctx
    drivers

 net/mac80211/tx.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.54.0

