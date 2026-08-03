Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F301DFFB;
	Mon,  3 Aug 2026 07:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785741666; cv=none; b=c+SvVzyDS1SEDXd8TmkN4nvACIQuBUKKEOFWOkYStYrrLegJ5P+2oPLTXSyG/LaY7TksC+1aVD7SQ6QQIReSDLXnaG/stcVW1bSpz4LR99Dcm84c0YlEfpgyeH/BW5C12g3GhgymgX4nL/7OQi3vKXPS+pUeeDsBnRKsyrFa7jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785741666; c=relaxed/simple;
	bh=xbdyUyEMaXUhcEO75ISnJxi7QZvew55I9kstKypjAhQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qhoPxNXLHAQa+NwORprQLuI8Re9q8y8sQgDhRJkGdha2zh5JZrqVUce4Bv6v4ezChfvxx8n2mUW8MlVP5RsFbnMujxHD9+2XSzF9rq5HA+uzqYw2DqPQaJmX2sz4YftYr4RZ0dl2eVQVHwbUiow00SuuqUV+FTN+VT2BGxg0CzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=F4cbUbqd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="F4cbUbqd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zmDV+RuIoaCg3zpDOuu8aEUxqmTGjTH0WU9pE5ZeVG8=;
	t=1785741663; x=1786951263; b=F4cbUbqdx3ktkZNLy6lKbzWDeskN+pZgsSJwsswmlGqTCZ+
	ChE3pDz3//KMjspWv1nlVkYsXMFjDC52nMBG+zUlJEyYW/+bJJyVMUUAGzZhC4T5PaFSyAwwlr4G4
	aYgs0qIdFi7I9Ykf1TKYMEJWLS+Kv9n3dVpIlhM/kHL4ND0LDEIlwymu1PdXXIipHb3hOn2Q9iRPK
	Tb93UtifZvH1z6BBzSeZVulFHs8rica7XG1jPqrEMyTzaCnQcl38TPas0IJvfAzIpbmvk5BEKNhdT
	ZhGcCkt7b6715I9/OQ2DmSEMGVpKbg31iXx6IbM4fRi8xYiyWpUTjX4ck02P8wGA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqmym-00000004BNm-42wM;
	Mon, 03 Aug 2026 09:20:57 +0200
Message-ID: <5811c9927b0fd5dd2287101a2c98a4eac3b6c5ca.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/2] wifi: brcmfmac: validate msgbuf flowring IDs
From: Johannes Berg <johannes@sipsolutions.net>
To: Can Peng <pengcan@kylinos.cn>, arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
Date: Mon, 03 Aug 2026 09:20:56 +0200
In-Reply-To: <20260803071259.546631-1-pengcan@kylinos.cn>
References: <20260803071259.546631-1-pengcan@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-08-03 at 15:12 +0800, Can Peng wrote:
> Clean up the excess blank lines in msgbuf.c first, then validate
> firmware supplied msgbuf flowring IDs before converting them to internal
> flow IDs and using them as bit and array indexes.
>=20
> Changes in v2:
> - Add a preparatory cleanup to use a single blank line between functions
>   and declarations in msgbuf.c.
> - Rebase the flowring ID validation change on top of the cleanup.

Too late, I applied the other changes yesterday, and while I can rebase,
I'm not going to do that now for just some whitespace. Feel free to send
a cleanup on top of current wireless-next.

johannes
