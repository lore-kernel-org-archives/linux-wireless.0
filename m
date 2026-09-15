Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D663B3C18;
	Tue, 15 Sep 2026 12:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475561; cv=pass; b=cfz7A7DFxGKuCt+3eylCKdazGrIIDvApDM675TQ9L2IV+7Y8+bYoValJZCTyWuIwN8D0ucdqCe6prhYQwigRsvw66mFTMWBKzEj3gYhtVXGWqeDb8N2yiXjsRMvw4doZE2+odcFzYa+igr6WZDnEiszF7Q3e/ccP5kHh5cAn/kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475561; c=relaxed/simple;
	bh=NYx6mzzZPmldI53NSxGpwwRPncOdBwkbPbQ66RgsM7A=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=F8V3f9o0sZ4Ri2d8I/uzSEnQC4qH5ExLbdG9DLAcUN6g2e/Fo+NQ2WH3bEVbxirrl2NcG7prqieboeZlTrUIvdRVM2fsKI8BcfvFcftHrMwjnmeyWSLisroeELROtq+xLg3ZxU4NkwpTcHEMtl+tVNPOvmiK0GdM0zJUihFYK80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=U/p6Iq0t; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="U/p6Iq0t"
Received: from fauth-c2-smtp.messagingengine.com (fauth-c2-smtp.messagingengine.com [204.75.18.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkhHM70QVz10gQ;
	Tue, 15 Sep 2026 15:32:31 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789475552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lulhfXdBZ8IlWRG8McqTlzoi9Lws1M12SFhrapzdGsk=;
	b=U/p6Iq0t7lwWgfXglk4q/W1iTerf4NV8JWGIACjjP7iZciHiHJrNvCfPmesv3B7nxiGYGj
	C/Vk34LHNe04OpSdFRx1+55880SM9DHeE/gz+lyK10J1nMG8LV1aSQl1Zs5+g0y4X5h9Zc
	xBKsPCXm38ka6pX8OIRaQAc/qqBWH2M=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789475552;
	b=K6d+i8phejjQKVrcLEMHnXs/cCVtN4aBOxtMDN/J0jbUEsrJLmsdplk2R8V5TAVDfKBf4M
	0lmKX7yw+wN8YEmQiLNSAL3lgM1vag0LQHjsWEjjyZ9iPJs8Igfs4hFBocH75nLKRRgxtJ
	wU1sYlc1Bp8P0ls9oPWvy/wIQHh/sHk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789475552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lulhfXdBZ8IlWRG8McqTlzoi9Lws1M12SFhrapzdGsk=;
	b=E4aoBWj3Dy1SorXjWqpdMDWwONblq3rQiu+YIH5mw1wNHg3iEQMqzRRHB3ZNqA0cFTSWe0
	7FIuTEbM15CzU/PqaczitDwmQNmajDLV4Qe67DcXnYw4/XgvLykj+ye3EaDpJ4rXD6hAE1
	H6o+h2WjmfQBghRZXu3OebL+z8tNn/8=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 78E24198003A;
	Tue, 15 Sep 2026 08:32:30 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Tue, 15 Sep 2026 08:32:30 -0400
X-ME-Sender: <xms:2jqpak0bJ0YRiWQiNx_2y0ZIftizHOz3eY2-gSxBctN2xImZgQhApQ>
    <xme:2jqpap6huM2Q017AzlPLLoZRbJhikx6bUeMaJUZYNcaXA3XmKkiaoYCPNU_M7rhMQ
    1urF-vkH2lw4lgvr3sdCSleFNK_8FLKRMUWKGeUraFr1y1Ssl7F6eEf>
X-ME-Proxy-Cause: dmFkZTEFymrOVPWK+MQ4UXejtvxyh+l6dc5IFIgY4jnDXoWEvKpMjB051KQpVtX+K4gQ75
    kUfcjqqxEf3p9FzEJAN0QsyR1bZY+KS7rL4N8A4Zr61S146jEPyD/UHZtYNPbKCo7DWY+p
    s4x6/sThfkRdNZV+RL7rVbK4RWJVMo2nLKKITqNAjCmiDkIBD7hROe4coNhKbitLSzCJy1
    mAo4Jiq8udQVkdUsueh/WGbRTj3wyUMHAM3AzJ4Zsl37M2RLv7LzWwPXgdFKPs7S2lGFUB
    N55+wUYvrw9L20LzbwhmmQ7s+ErG8LKT9ccLLa7hDRnuwVBbqSX0SoHf9niz2A/OvVcQJu
    zDSpJNLDB8FGblXKsvXis1Iw1zZnBPxoRM36BrN+C9kLGA7xPSnQPINWIPv5mdN8QIiI1p
    1iyL1odL+MY43Qw8n7/v7B8fAy3L/Dnaw3ErMoe4s/6ijKtZI8gtjJEkd569lumsEghzaT
    xB8Wx+Kk4MdnciVvLwlRy44HQ9mbyqsiV/AveldrPTVxiFmtJj9ulds+wF+AJlupbeBwak
    QmCAv9s8K7PnZb5Mw0JBxK1rc/jvSSeP9q5oBJEr2Caq5N7nZf5//LLecDHggeeOaN+vYl
    hY/IZcs+h5CYej7CR3MDuymC1gvQK29r7cFct0XF6k70BPzNFzNyvXG+x8GQ
X-ME-Proxy: <xmx:3jqpapE5fuSSiL3vJPkxhThkglAA33DNJI7cVgIdZx9U3P7PmmA3OA>
    <xmx:3jqpana-kdrjVns9y24LBC4N2xbFW-ZwkIsAaoDLmvBLmFQaijy9gA>
    <xmx:3jqpakN5YO46-r3Ba2vQcOGTsvQnwzBrs90AEfYwOB_WSFerGW50eA>
    <xmx:3jqpaq1SrDBlqOKwSL1iW3o-i2bcCkjKY_QDXzxej4a5un8rmL6zyw>
    <xmx:3jqpaomo-h_ZFFWWaFEAnIyOOr5e18WpSkI8FBLX4AagS7DwrKIqXFR_>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1540AF80089; Tue, 15 Sep 2026 08:32:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AfrYmASNsTfZ
Date: Tue, 15 Sep 2026 15:30:26 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Arthur Crepin Leblond" <arthur@marmottus.net>
Cc: "Manivannan Sadhasivam" <mani@kernel.org>, linux-arm-msm@vger.kernel.org,
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>,
 "Jeff Johnson" <jjohnson@kernel.org>,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>,
 "Eric Dumazet" <edumazet@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>, "Paolo Abeni" <pabeni@redhat.com>,
 "Willem de Bruijn" <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, "Jakub Kicinski" <kuba@kernel.org>,
 "Simon Horman" <horms@kernel.org>, "Mihai Moldovan" <ionic@ionic.de>,
 "Denis Kenzior" <denkenz@gmail.com>, "Marcel Holtmann" <marcel@holtmann.org>,
 "Andy Gross" <agross@kernel.org>, linux-kernel@vger.kernel.org,
 mhi@lists.linux.dev, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 netdev@vger.kernel.org
Message-Id: <c4a033ee-b71f-4548-8be9-0a43f31c8d42@app.fastmail.com>
In-Reply-To: <20260915071131.GA30612@marmottus.net>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915054207.2513877-13-juha-matti.tilli@iki.fi>
 <20260915071131.GA30612@marmottus.net>
Subject: Re: [PATCH v7 12/15] net: qrtr: mhi: Report endpoint id in sysfs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Sep 15, 2026, at 10:11, Arthur Crepin Leblond wrote:
> On Tue, Sep 15, 2026 at 08:42:04AM +0300, Juha-Matti Tilli wrote:
> >+static ssize_t endpoint_show(struct device *dev,
> >+      struct device_attribute *attr, char *buf)
> >+{
> >+ struct qrtr_mhi_dev *qdev = dev_get_drvdata(dev);
> >+
> >+ return sprintf(buf, "%u\n", qdev->ep.id);
> >+}
> >+
> >+static DEVICE_ATTR_RO(endpoint);
> 
> I think you could use sysfs_emit instead of sprintf.

Thank you for the commentary. I tested sysfs_emit and it compiles and:

cat /sys/devices/platform/soc/*.pcie/pci*/*/*/mhi0/*/endpoint

...prints 2, as it should, so it seems to work too.

The next patchset version will use sysfs_emit here.

BR, Juha-Matti
