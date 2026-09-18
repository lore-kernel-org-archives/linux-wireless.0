Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E043F0BB;
	Fri, 18 Sep 2026 06:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712817; cv=pass; b=oE0sDVIuHDEhNgVciz3NUi0klUIhLnTJdv8RGkDjqaGqTnRe5UgjZIjoIFTAcV3AriRjUpZdr/GZ4ss2wL/TGLXqAVPenIKdHT2Bw/5jIToav5q11QtL3zG/nyx5Yw6SMuH0iaKWU3OriY25pF+62OAP5Nxj9N+5A4X5T9LAows=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712817; c=relaxed/simple;
	bh=LP0IIN7pY003UkA/8lpEQmNYH2LWWi0j/4H3NIKqHkw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=NrIx3DwiAMhkzSwwgGT39UAgxbdyAoWEKjq2TurHM1TK0oeqIPqMrB6nINAn+gILkk1xtoOyxdcxZRTjY6vlfS77S7teBj5kfIbH6TY0umTQ+dLRvFF0S17Nz0yBFbXmgCbrq1mgpbLbKtKAVIKCBZd0FL+jPSbhg+7/WYBTLFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=ZelSeWhd; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="ZelSeWhd"
Received: from fauth-c1-smtp.messagingengine.com (fauth-c1-smtp.messagingengine.com [204.75.18.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hmN2132JqzyPw;
	Fri, 18 Sep 2026 09:26:49 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789712810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbGB/4hNeZUFNX6/pPlJdv0sQED8O6qK3gQGbfLFPKo=;
	b=ZelSeWhdkkJbsJZGCulL70M+A5qJyphNVIA5wP2bvlPiONmSSdzV70jNOtZC0594CPo0uy
	bjj2YN4SzZJXIKpZc/xw60HnqUH1TIGUvSFodadJmTXqF+uCIaTP4llaM8v05B0HBxzl/Y
	eauMnKoQBVXpeGLdK8OVQ2TvHJNO+fE=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789712810;
	b=X/vZFSjrGrD4zi1Iehh9JcwzP7ShOgJaTJ+m46AEDIk7PrQTLSZwYOZ2sGfWqj8LKnWwys
	HOTS0Wo1HTIL/DgQO83Z5cOkgPRwpFDWcna+gD8m9nODHQUcVb1fWU8RZLAug8yOKXqVwE
	CjmdWbKmioaayWolTXmTHZg8Tlw/v5Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789712810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbGB/4hNeZUFNX6/pPlJdv0sQED8O6qK3gQGbfLFPKo=;
	b=DBCGS4RJanCH7LrL3tEJ9fajPm+zU/bDdFeI8z2OUibz9gS5RshxU+ZfOUuWtEkSHKq5uy
	BufbEnc8yDJ78Cn/d0bYDG2B/CxTgBKkWsTOOgfXPdg6LkceAolIAZz63I72trRwGw3KbJ
	ndjubc0Y2tZs/4fx9Fit49VhVrnLSco=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id A31C8198003A;
	Fri, 18 Sep 2026 02:26:48 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Fri, 18 Sep 2026 02:26:48 -0400
X-ME-Sender: <xms:pdmsahWJdmupBtcwACxHjr-e6uQgIh0-Y1wyAfksKZ9598zNAXIBNg>
    <xme:pdmsasYPjLGqkqre6F3h7PTmk-EbE80w96uH9LdwxMxHsyrwf1Fslrwcko9NVzGGM
    65-ryFnEKAvA5Qfh09EKW0FXBF8a3P_UJjxHPjAYVJrG5rm7Ndh-QYY>
X-ME-Proxy-Cause: dmFkZTFbGgTFyzr43rklC79WMROH2XMGgfTXx9kUipHZMopomzGpZPM3/OWscnMHveFvKL
    R8IddKqeOBIwxn0zXVt54zj/dE2h59NlPXjdcnHs2T+QA09up05hhLzn0p7k7DjFiwq6v2
    S4C6lWzDYrJwwEV+5FajmR712RM88E7UrJ2ngdpLy6/Ac0ILSZ2wPcHLjYu6fWPoxmqK8h
    qTgqrFmNiE+6lolgVqLAnT2zoQXC8Fh28XdzDCavOGyyBIxZs8J362URMiHzLJ7PBBrCbj
    jf7CH7mf1GC/LwtdV7wIhFFD9eYj/ek58uMz5AE6h9xyIG7K5yyLcbM/PfNoIqndAaSyWG
    97SsgZhI60ri6+0JjxG8OBtIVUbYwYxsw+xIvwe0yzsvrLbqWYZqiT9tgwyuibxFu+NM/A
    nLDyJspmmXH4Pf1YdKI6JLfm573MrZNG18zUftSBURUOkA+RDYtdJvLJyVOOVjBL34jwc4
    wm4ij2gtDgrh6izFrPXvb78JHXf3PF2rkfZbJCeXYv9ULfeVxQxk33NKu4/ohXsq2luPRi
    XpHUmfy3Z+Eec2DxMrDWIAptwq0MepuU/rzsVzICnw+FxZrgO4WqP6ZHMYXiLPgsrgLS0e
    XeZtpn7w7qxnCK0E4fu4jpdHMxacuMOdCIVRqB6YtPU8JxKDUx+qmLnh7ytQ
X-ME-Proxy: <xmx:qNmsaiL2T51LXhbS8udNAUIs5Rlw4Kk7jfadcPhQ_oUfZXl8anQjkQ>
    <xmx:qNmsarxfT0uT2HLBEq52irqQsqKrqtfIxAcooXUgIyeM_buikAnVeA>
    <xmx:qNmsamyQ4BBP29gNNi-pzXRYS5GOxQLdbyqX1ZI2J0ZfTv_ppyCnPQ>
    <xmx:qNmsat0sAIPIw_XWTdcaXQjsI42lXUd4LBWgcSiJXgfZ-IGf_C6UOw>
    <xmx:qNmsaoVEGL9yWvRgP115kx1g9TnPAY1y3CBsL-KtqO7h2dWL3OLoQAmX>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 73B87F80091; Fri, 18 Sep 2026 02:26:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A2KHHV_FOEKJ
Date: Fri, 18 Sep 2026 09:26:24 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
 "Manivannan Sadhasivam" <mani@kernel.org>,
 "Jeff Johnson" <jjohnson@kernel.org>
Cc: "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>,
 "Eric Dumazet" <edumazet@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>, "Paolo Abeni" <pabeni@redhat.com>,
 "Willem de Bruijn" <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, "Jakub Kicinski" <kuba@kernel.org>,
 "Simon Horman" <horms@kernel.org>, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 "Mihai Moldovan" <ionic@ionic.de>, "Denis Kenzior" <denkenz@gmail.com>
Message-Id: <98cc01fd-0df0-46ee-b27f-2556a577a5a5@app.fastmail.com>
In-Reply-To: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
References: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
Subject: Re: [PATCH v4 00/12] ath1{1,2}k: support multiple PCI devices in one system
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Sep 15, 2026, at 10:41, Juha-Matti Tilli wrote:
> Hello,
> 
> As you may well know, multiple identical ath11k and ath12k devices are
> not supported in a single Linux host because they use conflicting QRTR
> node IDs. Fortunately, Denis Kenzior created a patchset to support
> multiple QRTR endpoints with identical node IDs, and Mihai Moldovan
> refined it, after which I took over the patchset and refined it more.
> 
> Mihai Moldovan also created a patchset for actually adding the support
> for this QRTR multi-endpoint feature to ath11k and ath12k drivers.
> Unfortunately, the code of Mihai was not merge-quality, since it leaked
> memory if you ran rmmod and modprobe inside a loop. Mihai mentioned this
> drawback, without providing an API for deleting endpoints or usage of
> such API in code that's responsible for freeing resources. Also Mihai's
> patchset had a race condition.

Hello,

Some positive news. There will be no next version, as Qualcomm is going
to provide a superior patchset that I tested. It's easier to backport,
cleaner design, fewer lines changed, has 1 author as opposed to 3, and
most importantly, it worked just fine on my 2x card setup. 

Thus, I'm going to abandon this patchset.

BR, Juha-Matti
